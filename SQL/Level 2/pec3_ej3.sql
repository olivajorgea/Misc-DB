------------------------------------------------------------------------------------------------
--
-- Pregunta a) 
--
------------------------------------------------------------------------------------------------
CREATE or REPLACE FUNCTION order_status_check()
RETURNS trigger AS $$
BEGIN
	IF (OLD.status='Cancelada'  and NEW.status='Realizada') or  
	   (OLD.status='Realizada'  and NEW.status='Cancelada')  then 
		NEW.status:= OLD.status;
	END IF ;
RETURN NEW;
END;
$$LANGUAGE plpgsql;

CREATE TRIGGER auditoria_order_status
BEFORE UPDATE OF status ON clinical.tb_orders
FOR EACH ROW EXECUTE PROCEDURE order_status_check();


-- Unit test realizado 
UPDATE clinical.tb_orders 
SET status = 'Realizada'
WHERE order_id = 357;
select * from clinical.tb_orders WHERE order_id = 357;


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta b) 
--
------------------------------------------------------------------------------------------------
CREATE TABLE 	clinical.tb_orders_status_changelog
(
	order_id      INTEGER NOT NULL,
	old_status 	  VARCHAR(50)NOT NULL,
	new_status 	  VARCHAR(50)NOT NULL,
	changelog_dt  TIMESTAMP NOT NULL, 
	FOREIGN KEY(order_id) REFERENCES clinical.tb_orders (order_id)
);

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta c) 
--
------------------------------------------------------------------------------------------------
CREATE or REPLACE FUNCTION order_log()
RETURNS trigger AS $$
BEGIN
	INSERT INTO clinical.tb_orders_status_changelog VALUES
	(OLD.order_id,OLD.status,NEW.status, NOW());
RETURN NULL;
END;
$$LANGUAGE plpgsql;


CREATE TRIGGER auditoria_order
AFTER UPDATE OF status ON clinical.tb_orders
FOR EACH ROW EXECUTE PROCEDURE order_log();


UPDATE clinical.tb_orders 
SET status = 'Cancelada'
WHERE order_id = 100;
select * from clinical.tb_orders WHERE order_id >=100;
