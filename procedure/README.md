### HOMEWORK-29 Хранимые процедуры и триггеры


Для примера используем учебную БД взятую с [MySQLTUTORIAL](https://www.mysqltutorial.org/getting-started-with-mysql/mysql-sample-database/)

Создадим двух пользователей и процедуры для них

- Пользователь - __client__  <-> Процедура - __products_by_filters__
- Пользователь - __manager__  <-> Процедура - __get_orders__

Скрипт процедур в файле [procedures.sql](./procedures.sql)
Для запуска выполните скрипты [init.sh](./init.sh) и [run.sh](./run.sh)