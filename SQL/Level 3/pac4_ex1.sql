EXERCICE 1.1.a)
===============
ALTER TABLE clinical.tb_orders_catalog ADD COLUMN parent_code INT DEFAULT NULL;


EXERCICE 1.1.b)
===============
CREATE SEQUENCE clinical.seq_orders_catalog INCREMENT BY 1 START WITH 1 NO CYCLE;


EXERCICE 1.1.c) 
===============
WITH orders AS (
	SELECT DISTINCT category FROM clinical.tb_orders_catalog
)
INSERT INTO clinical.tb_orders_catalog (order_code, category, subcategory, order_desc, cost, parent_code)
SELECT nextval('clinical.seq_orders_catalog'), '','',category, 0, null FROM orders;

WITH orders AS (
	SELECT DISTINCT c1.subcategory, c2.order_code
	FROM clinical.tb_orders_catalog c1
	JOIN clinical.tb_orders_catalog c2 ON c2.order_desc=c1.category AND c2.parent_code IS NULL
)
INSERT INTO clinical.tb_orders_catalog (order_code, category, subcategory, order_desc, cost, parent_code)
SELECT nextval('clinical.seq_orders_catalog'), '','',subcategory, 0, order_code FROM orders;

WITH orders AS (
	SELECT o.order_code, subcat.order_code subcat_code
	FROM clinical.tb_orders_catalog o
	JOIN clinical.tb_orders_catalog cat ON cat.order_desc=o.category AND cat.parent_code IS NULL
	JOIN clinical.tb_orders_catalog subcat ON subcat.order_desc=o.subcategory AND subcat.parent_code=cat.order_code
)
UPDATE clinical.tb_orders_catalog c
SET parent_code=o.subcat_code
FROM orders o
WHERE c.order_code=o.order_code;


EXERCICE 1.1.d)
=============
ALTER TABLE clinical.tb_orders_catalog DROP COLUMN category, DROP COLUMN subcategory;


EXERCICE 1.2
============
WITH RECURSIVE catalog AS (
  SELECT 
	order_code,
	CAST(order_desc AS TEXT) AS parent_list,
	CAST('     ' AS TEXT) AS padding,
	CAST(order_desc AS TEXT) AS menu
  FROM 
     clinical.tb_orders_catalog
  WHERE 
	parent_code IS NULL
  UNION
  SELECT 
    c.order_code,
    CAST(p.parent_list || ' -> ' || c.order_desc AS TEXT) AS parent_list,
	CAST(p.padding || '     ' AS TEXT) AS padding,
	CAST(p.padding || '--->' || c.order_desc AS TEXT) AS menu
  FROM 
     clinical.tb_orders_catalog c INNER JOIN catalog p
	   ON (c.parent_code = p.order_code)
)
SELECT menu FROM catalog
ORDER BY parent_list;


EXERCICE 1.3
============
WITH patients AS (
	SELECT p.ehr_number, p.name,e.arrival_dt,sum(c.cost) AS cost
	FROM clinical.tb_patient p
	NATURAL JOIN clinical.tb_encounter e
	NATURAL LEFT JOIN clinical.tb_orders o
	NATURAL LEFT JOIN clinical.tb_orders_catalog c
	GROUP BY p.ehr_number, p.name, e.arrival_dt
	ORDER BY p.ehr_number, p.name,e.arrival_dt
)
SELECT ehr_number, name, 
	ROW_NUMBER() OVER (PARTITION BY ehr_number,name ORDER BY arrival_dt) AS position,
	cost,
	SUM(cost) OVER (PARTITION BY ehr_number,name ORDER BY arrival_dt RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sum
FROM patients;