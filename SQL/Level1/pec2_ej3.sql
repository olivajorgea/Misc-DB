/*Ejercicio 3a */
/*Insertar nueva especialidad */
INSERT INTO clinical.tb_medical_services(med_service_id, description, surgical, short_code) 
VALUES		(6,'Digestología','S','DIG');
/*Actualizar medico responsable*/
UPDATE 	clinical.tb_users
SET		med_service_id = 6
WHERE   user_id = 13;
/*Insertar nueva prueba*/
INSERT INTO clinical.tb_orders_catalog(order_code, category, subcategory, order_desc, cost) 
VALUES (9001, 'M.Interna', 'Endoscopia', 'Colonoscopia', 600.00);


/*Ejercicioi 3b*/
ALTER TABLE	clinical.tb_encounter 
	ALTER COLUMN discharge_dt DROP NOT NULL,
	ADD CONSTRAINT chec_date CHECK (discharge_dt>=arrival_dt);

/*Ejercicio 3c*/
CREATE VIEW clinical.top_six_cost_doctors ( doctor, especialidad, pruebas ,importe ,numero_de_pacientes) 
AS
 (select 	u.full_name doctor, s.description especialidad,COUNT(o.order_id)pruebas , 
		SUM(c.cost)*COUNT(o.order_id) importe , 
		COUNT(DISTINCT e.patient_id) pacientes
from 	clinical.tb_users u , clinical.tb_medical_services s, clinical.tb_orders o,
		clinical.tb_orders_catalog c, clinical.tb_encounter e
where 	u.medical_license_nbr!='null' and u.med_service_id=s.med_service_id and u.user_id=o.created_by_user and
		o.order_code = c.order_code  and o.encounter_id= e.encounter_id and
		(c.subcategory='Laboratorio' or c.subcategory='Pruebas')
GROUP BY u.full_name,s.description
ORDER BY  importe DESC
LIMIT 6);

	
/*Ejercicioi 3d*/
ALTER TABLE clinical.tb_users
	ADD COLUMN mail_address VARCHAR(100) UNIQUE DEFAULT NULL;

/*Ejercicio 3E*/
CREATE USER rw_clinica2 WITH ENCRYPTED PASSWORD 'rw_clinical_upc';
GRANT SELECT , INSERT , UPDATE,  DELETE  ON ALL TABLES IN SCHEMA clinical TO rw_clinica;