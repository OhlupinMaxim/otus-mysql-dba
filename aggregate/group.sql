set session sql_mode='';

-- Список товаров с их колличеством, заказы по которым уже закрыты (Статус: Отправлено)

SELECT
 COUNT(p.productCode) as count_shipped, o.orderDate, o.shippedDate, p.productName
FROM orders as o
INNER JOIN orderdetails as od
    ON od.orderNumber = o.orderNumber
INNER JOIN products as p
    ON p.productCode = od.productCode
WHERE 
    o.status = 'Shipped'
AND 
    YEAR(o.orderDate) = 2005
GROUP BY p.productCode
ORDER BY count_shipped DESC;


-- Список товаров распределнных на типы которые могут закончиться на складе

WITH productByLine AS (
    SELECT 
        productLine, SUM(quantityInStock) as count_product_by_line
    FROM 
        products
    GROUP BY productLine
    HAVING count_product_by_line < 50000
)
SELECT 
    productLine, count_product_by_line,
    CASE
        WHEN count_product_by_line >= 100000
            THEN 'Много товара'
        WHEN count_product_by_line < 100000 AND count_product_by_line >= 50000
            THEN 'Есть в наличии'
        WHEN count_product_by_line < 50000 AND count_product_by_line >= 10000
            THEN 'Товар заканчивается'
        ELSE 'Мало товара'
    END AS count_in_stock
FROM
    productByLine;


-- Самый дорогой и самый дешевый товар в каждой категории
SELECT
    productName, productLine, MAX(buyPrice) as max_price
FROM products
GROUP BY productLine;

SELECT
    productName, productLine, MIN(buyPrice) as min_price
FROM products
GROUP BY productLine;

SELECT 
    productLine, COUNT(*) as count_models
FROM products
GROUP BY productLine WITH ROLLUP;

-- Кол-во заказов каждого покупателя за все года где кол-во заказов больше 2 (WITH ROLLUP)
SELECT 
    c.customerName, YEAR(o.orderDate), COUNT(c.customerNumber) as count_orders
FROM customers as c
INNER JOIN 
    orders as o ON o.customerNumber = c.customerNumber
GROUP BY YEAR(o.orderDate), c.customerName WITH ROLLUP
HAVING count_orders > 2