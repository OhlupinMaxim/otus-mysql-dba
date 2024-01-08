-- Создадим процедуру для создания\удаления индексов (для упрощения)

DELIMITER $$
DROP PROCEDURE IF EXISTS sb_crm.OperateIndexByExist$$

CREATE PROCEDURE sb_crm.OperateIndexByExist (
    input_table_name varchar(64),
    input_index_name varchar(64),
    input_index_type varchar(64),
    columns varchar(128),
    to_create boolean
)
BEGIN

    DECLARE IndexExist INTEGER;

    SELECT COUNT(1) INTO IndexExist FROM
        INFORMATION_SCHEMA.STATISTICS
    WHERE
        table_schema=DATABASE() AND
        table_name=input_table_name AND
        index_type=input_index_type AND
        index_name=input_index_name;

    select IndexExist as exist;
    
    IF (IndexExist = 0) THEN
        IF (to_create) THEN
            IF (input_index_type = 'BTREE') THEN
                SET @sqlraw = CONCAT('CREATE INDEX ', input_index_name, ' ON ', input_table_name, ' (',columns,');');
            ELSE
                SET @sqlraw = CONCAT('CREATE ', input_index_type ,' INDEX ', input_index_name, ' ON ', input_table_name, ' (',columns,');');
            END IF;
            PREPARE sqlraw_run FROM @sqlraw;
            EXECUTE sqlraw_run;
            DEALLOCATE PREPARE sqlraw_run;
        ELSE
            SET @sqlraw = CONCAT('DROP INDEX ', input_index_name, ' ON ', input_table_name);
            PREPARE sqlraw_run FROM @sqlraw;
            EXECUTE sqlraw_run;
            DEALLOCATE PREPARE sqlraw_run;
        END IF;
    ELSE
        SELECT CONCAT('Index -- ', input_index_name, ' -- Already exists') IndexAlreadyExists;
    END IF;
END $$

DELIMITER ;

SET NAMES utf8 COLLATE utf8_unicode_ci;
ANALYZE table Product, Shop_Point_Product, Shop_Point;

CALL sb_crm.OperateIndexByExist('Amount_Product', 'idx_amount_products_fK_work_shift_fk_product_fk_product_unit','BTREE','fk_work_shift, fk_product, fk_product_unit', FALSE);
CALL sb_crm.OperateIndexByExist('Work_Shift', 'idx_work_shift_fk_staff_fk_shop_point','BTREE','fk_staff, fk_shop_point', FALSE);
CALL sb_crm.OperateIndexByExist('Product', 'fulltext_idx_product_name', 'FULLTEXT', 'name', FALSE);

EXPLAIN ANALYZE 
select id,name FROM Product WHERE name LIKE '%Корм%';
-- select id, name, MATCH (name) AGAINST ('Корм') AS score FROM Product HAVING score > 0;

EXPLAIN ANALYZE
SELECT p.name, sp.name FROM Shop_Point_Product AS spp
INNER JOIN Shop_Point AS sp
    ON spp.fk_shop_point=sp.id
INNER JOIN Product AS p
    ON spp.fk_product=p.id
WHERE spp.count_products < 18;

EXPLAIN ANALYZE
select st.username, ws.date_shift, sp.name
FROM Work_Shift as ws
INNER JOIN Staff as st
	ON ws.fk_staff=st.id
INNER JOIN Shop_Point as sp
	ON sp.id=ws.fk_shop_point;


-- Создаем составной индекс в сущности Amount_Products по полям fk_work_shift, fk_product, fk_product_unit
CALL sb_crm.OperateIndexByExist('Amount_Product', 'idx_amount_products_fK_work_shift_fk_product_fk_product_unit','BTREE','fk_work_shift, fk_product, fk_product_unit', TRUE);
-- Создаем составной индекс в сущности Work_Shift по полям (fk_staff, fk_shop_point)
CALL sb_crm.OperateIndexByExist('Work_Shift', 'idx_work_shift_fk_staff_fk_shop_point','BTREE','fk_staff, fk_shop_point', TRUE);
-- Создаем индекс полнотекстового поиска по полю name в таблице Product
CALL sb_crm.OperateIndexByExist('Product', 'fulltext_idx_product_name', 'FULLTEXT', 'name', TRUE);

EXPLAIN ANALYZE
select id, name, MATCH (name) AGAINST ('Корм') AS score FROM Product HAVING score > 0;

EXPLAIN ANALYZE
SELECT p.name, sp.name FROM Shop_Point_Product AS spp
INNER JOIN Shop_Point AS sp
    ON spp.fk_shop_point=sp.id
INNER JOIN Product AS p
    ON spp.fk_product=p.id
WHERE spp.count_products < 18;

EXPLAIN ANALYZE
select st.username, ws.date_shift, sp.name
FROM Work_Shift as ws
INNER JOIN Staff as st
	ON ws.fk_staff=st.id
INNER JOIN Shop_Point as sp
	ON sp.id=ws.fk_shop_point;

DROP PROCEDURE sb_crm.OperateIndexByExist;