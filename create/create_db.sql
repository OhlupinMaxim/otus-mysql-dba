CREATE DATABASE IF NOT EXISTS sb_crm;
CREATE USER IF NOT EXISTS 'sb_crm_user'@'localhost' IDENTIFIED BY '12345maxim';
GRANT ALL ON sb_crm.* TO 'sb_crm_user'@'localhost';
GRANT REFERENCES ON sb_crm.* TO 'sb_crm_user'@'localhost';
ALTER DATABASE sb_crm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
