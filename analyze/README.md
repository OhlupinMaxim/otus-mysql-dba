### HOMEWORK-30 Оптимизация производительности. Профилирование. Мониторинг

Для примера используем учебную БД взятую с [MySQLTUTORIAL](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/)
В данной базе по умолчанию отсутвуют индексы за исключением первичных ключей.

Рассмотрим запрос который выводит кол-во проданных моделей за один год и
выводом наименования модели, статуса заказа и адрес офиса в котором продали товар.
(Например нам нужно понять кто и сколько каких машин продал)

```sql
WITH product_list AS (
    SELECT 
        p.productCode as productCode, p.productName as productName,
        p.productLine as productLine, od.orderNumber as orderNumber,
        SUM(od.quantityOrdered) as quantityOrdered
    FROM 
        products as p
    INNER JOIN 
        orderdetails as od ON od.productCode = p.productCode
    GROUP BY od.orderNumber, p.productCode
) SELECT
    ofi.city, pl.productName, pl.productLine,
    YEAR(o.orderDate), SUM(pl.quantityOrdered) as quantityOrdered
FROM product_list as pl
INNER JOIN 
    orders as o ON pl.orderNumber = o.orderNumber
INNER JOIN
    customers as c ON c.customerNumber = o.customerNumber
INNER JOIN
    employees as e ON e.employeeNumber = c.salesRepEmployeeNumber
INNER JOIN
    offices as ofi ON ofi.officeCode = e.officeCode
WHERE 
    YEAR(o.orderDate) = 2004 AND o.status = 'Shipped'
GROUP BY o.orderNumber, pl.productCode, ofi.officeCode;
```

Запрос вывод 1353 записи распредленных по городам и моделям проданных машин.
Рассмотрим EXPLAIN запроса.
В запросе большое кол-во операций JOIN. Построение дополнительных индексов
не даст никакого улучшения так как в нашем случае выборка проводится по первичным ключам, которые являются индексами.

```
mysql: [Warning] World-writable config file '/etc/mysql/conf.d/my.cnf' is ignored.
mysql: [Warning] Using a password on the command line interface can be insecure.
EXPLAIN
-> Sort: ofi.officeCode  (actual time=7.025..7.123 rows=1353 loops=1)
    -> Table scan on <temporary>  (actual time=0.000..0.100 rows=1353 loops=1)
        -> Aggregate using temporary table  (actual time=6.701..6.844 rows=1353 loops=1)
            -> Nested loop inner join  (actual time=5.425..6.026 rows=1353 loops=1)
                -> Nested loop inner join  (cost=67.58 rows=33) (actual time=0.077..0.388 rows=145 loops=1)
                    -> Nested loop inner join  (cost=56.17 rows=33) (actual time=0.074..0.315 rows=145 loops=1)
                        -> Nested loop inner join  (cost=44.76 rows=33) (actual time=0.071..0.243 rows=145 loops=1)
                            -> Filter: ((o.`status` = 'Shipped') and (year(o.orderDate) = 2004))  (cost=33.35 rows=33) (actual time=0.062..0.122 rows=145 loops=1)
                                -> Table scan on o  (cost=33.35 rows=326) (actual time=0.027..0.082 rows=326 loops=1)
                            -> Filter: (c.salesRepEmployeeNumber is not null)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=145)
                                -> Single-row index lookup on c using PRIMARY (customerNumber=o.customerNumber)  (cost=0.25 rows=1) (actual time=0.001..0.001 rows=1 loops=145)
                        -> Single-row index lookup on e using PRIMARY (employeeNumber=c.salesRepEmployeeNumber)  (cost=0.25 rows=1) (actual time=0.000..0.000 rows=1 loops=145)
                    -> Single-row index lookup on ofi using PRIMARY (officeCode=e.officeCode)  (cost=0.25 rows=1) (actual time=0.000..0.000 rows=1 loops=145)
                -> Index lookup on pl using <auto_key0> (orderNumber=o.orderNumber)  (actual time=0.000..0.001 rows=9 loops=145)
                    -> Materialize CTE product_list  (actual time=0.037..0.038 rows=9 loops=145)
                        -> Table scan on <temporary>  (actual time=0.001..0.204 rows=2996 loops=1)
                            -> Aggregate using temporary table  (actual time=3.870..4.188 rows=2996 loops=1)
                                -> Nested loop inner join  (cost=1070.22 rows=3023) (actual time=0.051..2.568 rows=2996 loops=1)
                                    -> Table scan on p  (cost=12.00 rows=110) (actual time=0.014..0.039 rows=110 loops=1)
                                    -> Index lookup on od using productCode (productCode=p.productCode)  (cost=6.90 rows=27) (actual time=0.020..0.022 rows=27 loops=110)

mysql: [Warning] World-writable config file '/etc/mysql/conf.d/my.cnf' is ignored.
mysql: [Warning] Using a password on the command line interface can be insecure.
id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
1	PRIMARY	o	NULL	ALL	PRIMARY,customerNumber	NULL	NULL	NULL	326	10.00	Using where; Using temporary; Using filesort
1	PRIMARY	c	NULL	eq_ref	PRIMARY,salesRepEmployeeNumber	PRIMARY	4	classicmodels.o.customerNumber	1	100.00	Using where
1	PRIMARY	e	NULL	eq_ref	PRIMARY,officeCode	PRIMARY	4	classicmodels.c.salesRepEmployeeNumber	1	100.00	NULL
1	PRIMARY	ofi	NULL	eq_ref	PRIMARY	PRIMARY	42	classicmodels.e.officeCode	1	100.00	NULL
1	PRIMARY	<derived2>	NULL	ref	<auto_key0>	<auto_key0>	4	classicmodels.o.orderNumber	10	100.00	NULL
2	DERIVED	p	NULL	ALL	PRIMARY	NULL	NULL	NULL	110	100.00	Using temporary
2	DERIVED	od	NULL	ref	productCode	productCode	62	classicmodels.p.productCode	27	100.00	NULL
mysql: [Warning] World-writable config file '/etc/mysql/conf.d/my.cnf' is ignored.
mysql: [Warning] Using a password on the command line interface can be insecure.


EXPLAIN
-> Sort: ofi.officeCode
    -> Table scan on <temporary>
        -> Aggregate using temporary table
            -> Nested loop inner join
                -> Nested loop inner join  (cost=67.58 rows=33)
                    -> Nested loop inner join  (cost=56.17 rows=33)
                        -> Nested loop inner join  (cost=44.76 rows=33)
                            -> Filter: ((o.`status` = 'Shipped') and (year(o.orderDate) = 2004))  (cost=33.35 rows=33)
                                -> Table scan on o  (cost=33.35 rows=326)
                            -> Filter: (c.salesRepEmployeeNumber is not null)  (cost=0.25 rows=1)
                                -> Single-row index lookup on c using PRIMARY (customerNumber=o.customerNumber)  (cost=0.25 rows=1)
                        -> Single-row index lookup on e using PRIMARY (employeeNumber=c.salesRepEmployeeNumber)  (cost=0.25 rows=1)
                    -> Single-row index lookup on ofi using PRIMARY (officeCode=e.officeCode)  (cost=0.25 rows=1)
                -> Index lookup on pl using <auto_key0> (orderNumber=o.orderNumber)
                    -> Materialize CTE product_list
                        -> Table scan on <temporary>
                            -> Aggregate using temporary table
                                -> Nested loop inner join  (cost=1070.22 rows=3023)
                                    -> Table scan on p  (cost=12.00 rows=110)
                                    -> Index lookup on od using productCode (productCode=p.productCode)  (cost=6.90 rows=27)


```