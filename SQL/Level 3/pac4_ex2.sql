EXERCICE 2.a
============

SET search_path TO clinical;

CREATE TABLE tb_location (
	location_id INT NOT NULL, 
	name CHARACTER VARYING(50),
	description CHARACTER VARYING(50),
	type CHARACTER VARYING(50),
	CONSTRAINT PK_tb_location PRIMARY KEY(location_id)
);

ALTER TABLE tb_orders ADD COLUMN location_id INT DEFAULT NULL, ADD COLUMN location_dt TIMESTAMP DEFAULT NULL,
	ADD CONSTRAINT FK_orders_location FOREIGN KEY (location_id) REFERENCES tb_location(location_id);

INSERT INTO tb_location VALUES(1,'Sala1','Sala general 1','General'), (2,'Sala2','Sala general 2','General'), (3,'Sala3','Sala general 3','General');


