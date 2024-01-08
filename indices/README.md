# HOMEWORK-26

### __Индексы__
- составной индекс в сущности Amount_Products по полям (fk_work_shift, fk_product, fk_product_unit). idx_amount_products_fK_work_shift_fk_product_fk_product_unit
  Данный запрос имеет высокую кардинальность, так по каждой точке еждневно будут идти запросы в БД. (Как со стороны Предпринимателя так и со стороны сотрудника)
- составной индекс в сущности Work_Shift по полям (fk_user, fk_shop_point). idx_work_shift_fk_user_fk_shop_point
  Данный запрос в имеет высокую координальность, так как его выполнение неободимо составления статистики и последующего анализа.

### __Полнотекстовый индекс__
- Полнотекстовый индекс по именам товаров. Индекс имеет высокую координальность так как по нему будут выполняться различные поисковые запросы.
 

 ### __EXPLAIN__
__До индекса (Полнотекстовый)__
```
 -> Filter: (Product.`name` like '%Корм%')  (cost=1.05 rows=1) (actual time=0.016..0.017 rows=3 loops=1)
 -> Table scan on Product  (cost=1.05 rows=8) (actual time=0.011..0.012 rows=8 loops=1)
```

__После индекса (Полнотекстовый)__
```
 -> Filter: (score > 0)  (actual time=0.007..0.009 rows=3 loops=1)
 -> Table scan on Product  (cost=1.05 rows=8) (actual time=0.004..0.007 rows=8 loops=1)
```

Как видим, использование индекса сократило время исполнения запроса на несколько милисекунд на 8 строчках в таблице


__До индекса (BTREE составной)__
```
 -> Nested loop inner join  (cost=1.92 rows=2) (actual time=0.020..0.028 rows=5 loops=1)
 -> Nested loop inner join  (cost=1.33 rows=2) (actual time=0.018..0.022 rows=5 loops=1)
 -> Filter: (spp.count_products < 18)  (cost=0.75 rows=2) (actual time=0.012..0.013 rows=5 loops=1)
 -> Table scan on spp  (cost=0.75 rows=5) (actual time=0.011..0.012 rows=5 loops=1)
 -> Single-row index lookup on sp using PRIMARY (id=spp.fk_shop_point)  (cost=0.31 rows=1) (actual time=0.001..0.001 rows=1 loops=5)
 -> Single-row index lookup on p using PRIMARY (id=spp.fk_product)  (cost=0.31 rows=1) (actual time=0.001..0.001 rows=1 loops=5)
```

__После индекса (BTREE составной)__
```
 -> Nested loop inner join  (cost=1.92 rows=2) (actual time=0.014..0.022 rows=5 loops=1)
 -> Nested loop inner join  (cost=1.33 rows=2) (actual time=0.011..0.016 rows=5 loops=1)
 -> Filter: (spp.count_products < 18)  (cost=0.75 rows=2) (actual time=0.007..0.009 rows=5 loops=1)
 -> Table scan on spp  (cost=0.75 rows=5) (actual time=0.006..0.008 rows=5 loops=1)
 -> Single-row index lookup on sp using PRIMARY (id=spp.fk_shop_point)  (cost=0.31 rows=1) (actual time=0.001..0.001 rows=1 loops=5)
 -> Single-row index lookup on p using PRIMARY (id=spp.fk_product)  (cost=0.31 rows=1) (actual time=0.001..0.001 rows=1 loops=5)

```

Как видим, использование индекса сократило время исполнения запроса на несколько милисекунд на 5 строчках в таблице

__До индекса (BTREE составной)__
```
 -> Nested loop inner join  (cost=1.05 rows=1) (actual time=0.013..0.013 rows=0 loops=1)
 -> Nested loop inner join  (cost=0.70 rows=1) (actual time=0.012..0.012 rows=0 loops=1)
 -> Table scan on ws  (cost=0.35 rows=1) (actual time=0.012..0.012 rows=0 loops=1)
 -> Single-row index lookup on sp using PRIMARY (id=ws.fk_shop_point)  (cost=0.35 rows=1)
 -> Single-row index lookup on st using PRIMARY (id=ws.fk_staff)  (cost=0.35 rows=1)
```

__После индекса (BTREE составной)__
```
 -> Nested loop inner join  (cost=1.05 rows=1) (actual time=0.005..0.005 rows=0 loops=1)
 -> Nested loop inner join  (cost=0.70 rows=1) (actual time=0.005..0.005 rows=0 loops=1)
 -> Table scan on ws  (cost=0.35 rows=1) (actual time=0.004..0.004 rows=0 loops=1)
 -> Single-row index lookup on sp using PRIMARY (id=ws.fk_shop_point)  (cost=0.35 rows=1) (never executed)
 -> Single-row index lookup on st using PRIMARY (id=ws.fk_staff)  (cost=0.35 rows=1) (never executed)
```

Как видим, использование индекса сократило время исполнения запроса на несколько милисекунд

