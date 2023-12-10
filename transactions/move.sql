set autocommit = 0;

START TRANSACTION;

-- Предположим нам нужно перевезти часть товара с одного из магазинов в другой

SET @count_movable = 5;
SET @from_shop_id = 100;
SET @to_shop_id = 200;
SET @movable_product_id = 1010;


UPDATE Shop_Point_Product 
SET 
    count_products=count_products - @count_movable 
WHERE 
    fk_product=@movable_product_id AND fk_shop_point=@from_shop_id;

UPDATE Shop_Point_Product 
SET 
    count_products=count_products + @count_movable 
WHERE 
    fk_product=@movable_product_id AND fk_shop_point=@to_shop_id;

COMMIT;

SELECT
    sp.name as shop_point_name,
    p.name as product_name,
    spp.count_products
FROM
    Shop_Point_Product as spp
    INNER JOIN Shop_Point as sp
    INNER JOIN Product as p
WHERE
    spp.fk_product = p.id
    AND spp.fk_shop_point = sp.id
    AND (sp.id = @from_shop_id OR sp.id = @to_shop_id)
    AND p.id = @movable_product_id;
