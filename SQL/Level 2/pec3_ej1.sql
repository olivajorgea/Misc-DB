------------------------------------------------------------------------------------------------
--
-- Pregunta a) 
--
------------------------------------------------------------------------------------------------
ALTER TABLE clinical.tb_patient
ALTER COLUMN birth_dt SET NOT NULL;


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta b) 
--
------------------------------------------------------------------------------------------------

ALTER TABLE clinical.tb_encounter 
ADD CONSTRAINT check_data_discharge CHECK (discharge_dt IS NULL OR  discharge_dt >= arrival_dt);
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta c) 
--
------------------------------------------------------------------------------------------------
REVOKE UPDATE(created_dt) ON clinical.tb_orders  FROM PUBLIC;

// GRANT UPDATE ON dbo.Person (FirstName, LastName) TO SampleRole;
//DENY UPDATE ON dbo.Person (Age, Salary) TO SampleRole;
// GRANT SELECT,INSERT,UPDATE,DELETE ON clinical.tb_medical_services TO rw_clinical
Hola Sergio,

//¿La sentencia empieza por ALTER TABLE...? Si es sí, ya tienes la solución. Sinó hará falta un trigger.
------------------------------------------------------------------------------------------------