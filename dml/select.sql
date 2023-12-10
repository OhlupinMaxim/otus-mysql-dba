SET NAMES utf8 COLLATE utf8_unicode_ci;

-- Ищем все корма
SELECT * FROM Product WHERE name LIKE 'Корм%';

-- Ищем все торговые точки в Москве
SELECT * FROM Shop_Point WHERE address LIKE '%Москва%';


-- Пример использования LEFT JOIN и INNER JOIN. 
-- В контексте данной БД ответ будет одинаковый так как в таблице shop_point_product всегда есть совпадения по идентификаторам.
-- По задумке в каждой точке должнен быть обозначен каждый товар, даже если его кол-во равно нулю
SELECT 
    sp.name AS shop_point_name,
    p.name AS product_name,
    spp.count_products AS count_products
FROM 
    Shop_Point_Product AS spp 
LEFT JOIN Shop_Point AS sp
    ON spp.fk_shop_point=sp.id
LEFT JOIN Product AS p
    ON spp.fk_product=p.id;


-- Ищем все корма в москве кол-во которых меньше 10 (для пополнения складов в Москве)
SELECT 
    sp.name AS shop_point_name,
    p.name AS product_name,
    spp.count_products AS count_products
FROM 
    Shop_Point_Product AS spp 
INNER JOIN Shop_Point AS sp
    ON spp.fk_shop_point=sp.id
INNER JOIN Product AS p
    ON spp.fk_product=p.id
WHERE 
    spp.fk_product IN ( SELECT id FROM Product WHERE NAME LIKE 'Корм%' ) 
    AND spp.fk_shop_point in (SELECT id FROM Shop_Point WHERE address LIKE '%Москва%' )
    AND spp.count_products < 20;
