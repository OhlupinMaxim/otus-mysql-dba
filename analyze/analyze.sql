set session sql_mode='';

EXPLAIN FORMAT=JSON
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
    YEAR(o.orderDate) as year_sale, SUM(pl.quantityOrdered) as quantityOrdered
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
GROUP BY o.orderNumber, pl.productCode, ofi.officeCode ORDER BY ofi.officeCode;