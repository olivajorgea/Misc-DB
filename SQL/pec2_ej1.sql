/* Se supone que la BD ya está creada, en caso contrario lo podéis hacer con:
	CREATE DATABASE TEST1_DB_DW2;*/
	
	CREATE SCHEMA clinical;
	SET search_path TO clinical, "$user", public;

CREATE TABLE 	clinical.tb_medical_services 
(
	med_service_id INTEGER NOT NULL,
	description VARCHAR(50) NOT NULL,
	surgical  CHAR(1)NOT NULL,
	short_code CHAR(3)NOT NULL,
	PRIMARY KEY(med_service_id));
CREATE TABLE 	clinical.tb_users  
(
	user_id INTEGER NOT NULL,
	user_name CHAR(10) NOT NULL,
	user_type CHAR(10) NOT NULL,
	full_name VARCHAR(50)NOT NULL,
	register_dt  TIMESTAMP NOT NULL DEFAULT CURRENT_DATE, 
	medical_license_nbr CHAR(10),
	med_service_id INTEGER , 
	PRIMARY KEY(user_id),
	FOREIGN KEY(med_service_id) REFERENCES tb_medical_services (med_service_id));
CREATE TABLE 	clinical.tb_patient  
(
	patient_id INTEGER NOT NULL,
	ehr_number INTEGER,
	name VARCHAR(50) NOT NULL,
	sex CHAR (1),
	birth_dt DATE,
	residence VARCHAR(100),
	insurance VARCHAR(50),
	PRIMARY KEY (patient_id));
CREATE TABLE 	clinical.tb_encounter
(
	encounter_id INTEGER NOT NULL,
	patient_id INTEGER NOT NULL,
	encounter_type VARCHAR(50) NOT NULL,
	arrival_dt TIMESTAMP NOT NULL DEFAULT CURRENT_DATE	,
	discharge_dt TIMESTAMP, 
	med_service_id INTEGER NOT NULL,
	PRIMARY KEY (encounter_id),
	FOREIGN KEY(patient_id) REFERENCES tb_patient (patient_id),
	FOREIGN KEY(med_service_id) REFERENCES tb_medical_services (med_service_id));

CREATE TABLE 	clinical.tb_orders_catalog
(
	order_code INTEGER NOT NULL,
	category VARCHAR(50) NOT NULL,
	subcategory  VARCHAR(50) NOT NULL,
	order_desc  VARCHAR(50) NOT NULL,
	cost REAL NOT NULL,
	PRIMARY KEY (order_code));


CREATE TABLE 	clinical.tb_orders
(
	order_id INTEGER NOT NULL,
	order_code INTEGER NOT NULL,
	encounter_id INTEGER NOT NULL,
	status VARCHAR(50) NOT NULL,
	created_dt TIMESTAMP NOT NULL DEFAULT CURRENT_DATE	,
	status_dt TIMESTAMP  DEFAULT CURRENT_DATE	,
	created_by_user INTEGER NOT NULL,
	PRIMARY KEY (order_id),
	FOREIGN KEY(order_code) REFERENCES tb_orders_catalog (order_code),
	FOREIGN KEY(encounter_id) REFERENCES tb_encounter (encounter_id),
	FOREIGN KEY(created_by_user) REFERENCES tb_users (user_id));