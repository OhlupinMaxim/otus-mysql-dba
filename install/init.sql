CREATE database otus;
CREATE USER 'otus_db_user'@'localhost' IDENTIFIED BY '12345maxim';
GRANT ALL PRIVILEGES ON otus.* TO 'otus_db_user'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON otus.* TO 'root'@'localhost' WITH GRANT OPTION;

USE otus;

CREATE TABLE misc_table (data int);
INSERT INTO misc_table (1);
INSERT INTO misc_table (2);
INSERT INTO misc_table (3);
INSERT INTO misc_table (4);