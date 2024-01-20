CREATE USER IF NOT EXISTS 'client'@'localhost' IDENTIFIED BY '12345maxim';
CREATE USER IF NOT EXISTS 'manager'@'localhost' IDENTIFIED BY '12345maxim';

GRANT SELECT ON classicmodels.* TO 'client'@'localhost';
GRANT SELECT ON classicmodels.* TO 'manager'@'localhost';

DELIMITER $$
DROP PROCEDURE IF EXISTS classicmodels.products_by_filters$$
DROP PROCEDURE IF EXISTS classicmodels.get_orders$$

CREATE PROCEDURE classicmodels.products_by_filters (
    price INTEGER,
    productLine VARCHAR(128),
    sort_by VARCHAR(64),
    sort_type VARCHAR(4),
    limit_val SMALLINT,
    offset_val SMALLINT
)
BEGIN
    SET limit_val = IFNULL(limit_val, 10);
    SET offset_val = IFNULL(offset_val, 0);
    SET sort_by = IFNULL(sort_by, 'buyPrice');
    SET sort_type = IFNULL(sort_type, 'DESC');

    SET @sqlraw = CONCAT(
        'SELECT productName, productLine FROM products WHERE buyPrice >= ', price, ' AND productLine = "',
        productLine,'" ORDER BY "', sort_by, '" ', sort_type, ' LIMIT ', limit_val, ' OFFSET ', offset_val, ';'
    );

    PREPARE sqlraw_run FROM @sqlraw;
    EXECUTE sqlraw_run;
    DEALLOCATE PREPARE sqlraw_run;
END $$

CREATE PROCEDURE classicmodels.get_orders (
    exprassion_of_time varchar(128),
    group_by_value varchar(128)
)
BEGIN
    SET @sqlraw = CONCAT(
        'WITH orders_by_date AS ( '
        'SELECT c.customerName as customerName, o.orderDate as orderDate, o.status as status, o.orderNumber as orderNumber ',
        'FROM orders as o ',
        'INNER JOIN customers as c ON c.customerNumber = o.customerNumber ',
        'INNER JOIN orderdetails as od ON od.orderNumber = o.orderNumber ',
        'INNER JOIN products as p ON p.productCode = od.productCode ',
        'WHERE DATE(o.orderDate) BETWEEN DATE_SUB(CURDATE(), INTERVAL ', exprassion_of_time,') AND CURDATE()',
        ') SELECT customerName, orderDate, status, COUNT(orderNumber) as count_orders FROM orders_by_date ',
        'GROUP BY ', group_by_value, ';'
    );

    set session sql_mode='';
    PREPARE sqlraw_run FROM @sqlraw;
    EXECUTE sqlraw_run;
    DEALLOCATE PREPARE sqlraw_run;
END $$

DELIMITER ;

GRANT ALL ON PROCEDURE classicmodels.products_by_filters TO 'client'@'localhost';
GRANT ALL ON PROCEDURE classicmodels.get_orders TO 'manager'@'localhost';


