use sb_crm;

DROP TABLE IF EXISTS Amount_Product;
DROP TABLE IF EXISTS Product_Unit;
DROP TABLE IF EXISTS Work_Shift;
DROP TABLE IF EXISTS Shop_Point_Product;
DROP TABLE IF EXISTS Shop_Point;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Staff;


CREATE TABLE Staff(
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL CHECK (username != ''),
    password VARCHAR(64) NOT NULL CHECK (password != ''),
	staff_full_name VARCHAR(64) NOT NULL CHECK (staff_full_name != ''),
	staff_person_data JSON DEFAULT NULL,
    is_master_staff BOOLEAN NOT NULL
);

CREATE TABLE Product(
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(64) NOT NULL CHECK (name != ''),
    article INT NOT NULL UNIQUE CHECK (article > 0),
	manufacturer varchar(256),
	product_properties JSON DEFAULT NULL
);

CREATE TABLE Product_Unit(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fk_product INT NOT NULL,
	unit VARCHAR(8) NOT NULL CHECK (unit != ''),
	price_per_unit REAL NOT NULL CHECK (price_per_unit > 0)
);

CREATE TABLE Shop_Point(
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(64) NOT NULL UNIQUE CHECK (name != ''),
	address VARCHAR(64) NOT NULL UNIQUE CHECK (address != '')
);

CREATE TABLE Shop_Point_Product(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fk_product INT NOT NULL,
	fk_shop_point INT NOT NULL,
	FOREIGN KEY (fk_product) REFERENCES Product(id),
	FOREIGN KEY (fk_shop_point) REFERENCES Shop_Point(id),
	count_products REAL
);

CREATE TABLE Work_Shift(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fk_staff INT NOT NULL,
	fk_shop_point INT NOT NULL,
	date_shift DATETIME DEFAULT CURRENT_TIMESTAMP,
	is_close BOOLEAN DEFAULT False,
	profit REAL DEFAULT 0.0 CHECK (profit >= 0),
	expenses REAL DEFAULT 0.0 CHECK (expenses >= 0),
	FOREIGN KEY (fk_staff) REFERENCES Staff(id),
	FOREIGN KEY (fk_shop_point) REFERENCES Shop_Point(id)
);

CREATE TABLE Amount_Product (
	id INT PRIMARY KEY AUTO_INCREMENT,
	fk_work_shift INT NOT NULL,
	fk_product INT NOT NULL,
	fk_product_unit INT NOT NULL,
	number_of_sold INT CHECK (number_of_sold > 0),
	FOREIGN KEY (fk_work_shift) REFERENCES Work_Shift(id),
	FOREIGN KEY (fk_product_unit) REFERENCES Product_Unit(id)
);