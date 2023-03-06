------------------------------------------------------------------------------------------------
--
-- Pregunta a) 
--
------------------------------------------------------------------------------------------------
CREATE FUNCTION catalog_yearly_orders(year_cat INTEGER, order_cat INTEGER)
RETURNS INTEGER AS $$
DECLARE
	prestaciones INTEGER;
BEGIN
	SELECT count(*) into prestaciones
	FROM clinical.tb_orders o
	WHERE  date_part('year',o.created_dt)= year_cat 
	   AND o.order_code=order_cat;
RETURN prestaciones;
END;
$$LANGUAGE plpgsql;

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta b) 
--
------------------------------------------------------------------------------------------------
CREATE FUNCTION yearly_orders(year_cat INTEGER)
RETURNS INTEGER AS $$
DECLARE
	prestaciones INTEGER;
BEGIN
	SELECT count(*) into prestaciones
	FROM clinical.tb_orders o
	WHERE  date_part('year',o.created_dt)= year_cat;
RETURN prestaciones;
END;
$$LANGUAGE plpgsql;



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--
-- Pregunta c) 
--
------------------------------------------------------------------------------------------------
DROP  FUNCTION summary_orders();
DROP TYPE tipo_datos_report;
CREATE TYPE tipo_datos_report AS (
	year_cat INTEGER,
	order_cat INTEGER,
	percentage FLOAT);

CREATE or REPLACE FUNCTION summary_orders() 
RETURNS SETOF tipo_datos_report AS $$
DECLARE
	datos_clientes tipo_datos_report;
	prestaciones_year INTEGER;
	prestaciones_cat_year INTEGER;
BEGIN
	FOR datos_clientes IN  SELECT date_part('year',o.created_dt)  year_cat, order_code,0
							FROM clinical.tb_orders o
							GROUP  BY year_cat, order_code 
							ORDER BY year_cat, order_code ASC LOOP
		prestaciones_cat_year := (SELECT catalog_yearly_orders(datos_clientes.year_cat,datos_clientes.order_cat)); 
		prestaciones_year := (SELECT yearly_orders(datos_clientes.year_cat));
		datos_clientes.percentage :=  ROUND(prestaciones_cat_year * 100.0 / prestaciones_year, 1);
		
		RETURN NEXT datos_clientes;
	END LOOP;
	RETURN ;
END;
$$LANGUAGE plpgsql;
