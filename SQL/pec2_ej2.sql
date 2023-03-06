/* EJERCICIO 2a Entendemo que solo nos interesa los registros de las peticiones (status ="Solicitada )" */
SELECT order_id identificador, encounter_id episodio, status estado ,created_dt fecha
FROM clinical.tb_orders
WHERE status= 'Solicitada' and
	  created_dt between '01/01/2019 23:59:59' and NOW()
ORDER BY created_dt  ASC


/* EJERCICIO 2b Entendemo que solo nos interesa los registros con el estado actual ="Cancelada" */
SELECT 	p.name paciente, c.category categoria, c.order_desc descripcion, o.order_id identificador,
		o.encounter_id episodio,e.encounter_type tipo,o.status estado , o.status_dt fecha
FROM	clinical.tb_patient p,clinical.tb_encounter e, clinical.tb_orders_catalog c,
		clinical.tb_orders o
WHERE	o.order_code=c.order_code  and o.encounter_id= e.encounter_id and
		e.patient_id=p.patient_id and o.created_dt<'01/01/2015 00:00:00' and
		(c.category='Laboratorio' or c.category='M.Interna') and
		o.status='Cancelada'

	

/* EJERCICIO 2c El primer intento fue  con subcategory="Laboratorio" , el segundo con subcategory="Pruebas"  
pero analizando los datos conclui que las dos subcategory podrian ser pruebas */
select 	u.full_name doctor, s.description especialidad,COUNT(o.order_id)pruebas , 
		SUM(c.cost)*COUNT(o.order_id) importe , 
		COUNT(DISTINCT e.patient_id) pacientes
from 	clinical.tb_users u , clinical.tb_medical_services s, clinical.tb_orders o,
		clinical.tb_orders_catalog c, clinical.tb_encounter e
where 	u.medical_license_nbr!='null' and 
		u.med_service_id=s.med_service_id and 
		u.user_id=o.created_by_user and
		o.order_code = c.order_code  and
		o.encounter_id= e.encounter_id and
		(c.subcategory='Laboratorio' or c.subcategory='Pruebas')
GROUP BY u.full_name,s.description
ORDER BY  importe DESC
LIMIT 3;



/*EJERCICIO 2d */ 
SELECT 	DISTINCT p.patient_id paciente,p.ehr_number ehr,p."name" nombre,p.sex sexo,
		p.birth_dt fecha_nacimiento,p.residence direccion,p.insurance aseguradora
FROM	clinical.tb_patient p, clinical.tb_encounter e
WHERE 	p.insurance='Mapfre' and
		e.encounter_type <>'Urgencia'

/*EJERCICIO 2e No se especifica en el ejercicio pero he ordenado descendentemente por que considero que el objetivo 
de esta consulta es ver las personal que mas atenciones tienen  */ 
SELECT 	p.ehr_number historial ,p."name" nombre, date_part('year',age(p.birth_dt)) edad,
		COUNT(e.patient_id) atenciones
FROM	clinical.tb_patient p, clinical.tb_encounter e
WHERE 	p.patient_id =  e.patient_id
GROUP BY p.ehr_number,p."name",p.birth_dt 
HAVING COUNT(e.patient_id) > 8
ORDER BY atenciones DESC
