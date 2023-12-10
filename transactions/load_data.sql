LOAD DATA LOCAL INFILE "/load_data_local/Product.csv"
INTO TABLE Product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
(id, name, article, manufacturer);

LOAD DATA LOCAL INFILE "/load_data_local/Shop_Point.csv"
INTO TABLE Shop_Point
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
(id, name, address);

LOAD DATA LOCAL INFILE "/load_data_local/Shop_Point_Product.csv"
INTO TABLE Shop_Point_Product
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY "\r\n"
(fk_product, fk_shop_point, count_products);


SET NAMES utf8 COLLATE utf8_unicode_ci;
SELECT * FROM Product WHERE manufacturer LIKE '%Luc%' LIMIT 5 OFFSET 100;
SELECT * FROM Shop_Point WHERE id = 100 OR id = 200;
SELECT * FROM Shop_Point_Product WHERE fk_shop_point = 100 OR fk_shop_point = 200;