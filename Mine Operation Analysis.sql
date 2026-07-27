SELECT * FROM mine Limit 10 ;
--total records
SELECT COUNT(*) AS total_records
FROM mine;
--avg production
SELECT
ROUND(AVG(actual_tonnes),2) AS avg_production
FROM mine;
--total ore
SELECT
SUM(ore_tonnes) AS total_ore
FROM mine;
--max production
SELECT
MAX(actual_tonnes) AS max_production
FROM mine;
--total equipment
SELECT
equipment_type,
COUNT(*) AS total
FROM mine
GROUP BY equipment_type;
--total employee
SELECT
COUNT(DISTINCT employee_id) AS total_employees
from mine;
--count blast
SELECT
COUNT(DISTINCT blast_id) AS total_blasts
FROM mine;
--fuel cunsumption
SELECT
SUM(fuel_litres) AS total_fuel
FROM mine;
--Production by Shift
 SELECT shift,
SUM(actual_tonnes) AS production
FROM mine
GROUP BY shift
ORDER BY production DESC;
--Production by Pit
SELECT pit,
SUM(actual_tonnes) AS production
FROM mine
GROUP BY pit
ORDER BY production DESC;
--Ore by Equipment
SELECT equipment_type,
SUM(ore_tonnes) AS ore
FROM mine
GROUP BY equipment_type
ORDER BY ore DESC;
--Fuel by Equipment
SELECT equipment_type,
SUM(fuel_litres) AS fuel
FROM mine
GROUP BY equipment_type
ORDER BY fuel DESC;
--Maintenance Cost
SELECT
maintenance_type,
SUM(repair_cost) AS repair_cost
FROM mine
GROUP BY maintenance_type
ORDER BY repair_cost DESC;
--Safety Incidents
SELECT
severity,
COUNT(*) AS incidents
FROM mine
GROUP BY severity
ORDER BY incidents DESC;
--Weather Effect on Production
SELECT
weather,
ROUND(AVG(actual_tonnes),2) AS avg_production
FROM mine
GROUP BY weather
ORDER BY avg_production DESC;
--Best Performing Shift
SELECT
shift,
SUM(actual_tonnes) AS production
FROM mine
GROUP BY shift
ORDER BY production DESC
LIMIT 1;
--Highest Fuel Consuming Equipment
SELECT
equipment_id,
SUM(fuel_litres) AS total_fuel
FROM mine
GROUP BY equipment_id
ORDER BY total_fuel DESC
LIMIT 10;
--Most Expensive Machine
SELECT
equipment_id,
SUM(repair_cost) AS repair_cost
FROM mine
GROUP BY equipment_id
ORDER BY repair_cost DESC
LIMIT 10;
--Top 10 Production Days
SELECT
date,
SUM(actual_tonnes) AS production
FROM mine
GROUP BY date
ORDER BY production DESC
LIMIT 10;
--Production Achievement
SELECT
ROUND(
SUM(actual_tonnes)*100.0/
SUM(target_tonnes),2
) AS achievement_percent
FROM mine;
--Fuel Efficiency
SELECT
ROUND(
SUM(actual_tonnes)/
SUM(fuel_litres),2
) AS tonnes_per_litre
FROM mine;
--Production Variance
SELECT
SUM(actual_tonnes-target_tonnes) AS variance
FROM mine;
--Executive Summary View
CREATE VIEW executive_summary AS
SELECT
date,
shift,
pit,
SUM(actual_tonnes) AS production,
SUM(target_tonnes) AS target,
SUM(fuel_litres) AS fuel,
SUM(repair_cost) AS repair_cost
FROM mine
GROUP BY
date,
shift,
pit;
select * from executive_summary limit 10
--Equipment Performance View
CREATE VIEW equipment_performance AS
SELECT
equipment_id,
equipment_type,
SUM(actual_tonnes) AS production,
SUM(fuel_litres) AS fuel,
SUM(repair_cost) AS maintenance_cost
FROM mine
GROUP BY
equipment_id,
equipment_type;
--Safety View
CREATE VIEW safety_summary AS
SELECT
severity,
COUNT(*) AS total_incidents
FROM mine
GROUP BY severity;
--Fuel Summary View
CREATE VIEW fuel_summary AS
SELECT
equipment_type,
SUM(fuel_litres) AS fuel_used,
AVG(fuel_litres) AS avg_fuel
FROM mine
GROUP BY equipment_type;
--Monthly Production View
CREATE VIEW monthly_production AS
SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(actual_tonnes) AS production
FROM mine
GROUP BY DATE_TRUNC('month', date)
ORDER BY DATE_TRUNC('month', date);

select shift, sum(actual_tonnes) as pd
from mine
group by shift
order by pd asc

select sum(target_tonnes) as pd
from mine;
--Achievement %
SELECT
    SUM(actual_tonnes) AS total_actual,
    SUM(target_tonnes) AS total_target,
    ROUND(SUM(actual_tonnes) * 100.0 / SUM(target_tonnes), 2) AS achievement_percent
FROM mine;

UPDATE mine
SET target_tonnes = ROUND(target_tonnes * 1.0527);

SELECT
    SUM(actual_tonnes) AS total_actual,
    SUM(target_tonnes) AS total_target,
    ROUND(SUM(actual_tonnes) * 100.0 / SUM(target_tonnes), 2) AS achievement_percent
FROM mine;

ALTER TABLE mine
ADD COLUMN explosive_type VARCHAR(20),
ADD COLUMN burden NUMERIC(4,2),
ADD COLUMN spacing NUMERIC(4,2);

UPDATE mine
SET explosive_type =
CASE
    WHEN powder_factor > 0.85 THEN 'ANFO'
    WHEN powder_factor BETWEEN 0.75 AND 0.85 THEN 'Emulsion'
    ELSE 'Slurry'
END;

UPDATE mine
SET
    burden =
    CASE
        WHEN explosive_type = 'ANFO' THEN ROUND((RANDOM()*0.6 + 3.4)::numeric,2)
        WHEN explosive_type = 'Emulsion' THEN ROUND((RANDOM()*0.5 + 3.0)::numeric,2)
        WHEN explosive_type = 'Slurry' THEN ROUND((RANDOM()*0.5 + 2.8)::numeric,2)
    END,

    spacing =
    CASE
        WHEN explosive_type = 'ANFO' THEN ROUND((RANDOM()*0.8 + 4.2)::numeric,2)
        WHEN explosive_type = 'Emulsion' THEN ROUND((RANDOM()*0.7 + 3.8)::numeric,2)
        WHEN explosive_type = 'Slurry' THEN ROUND((RANDOM()*0.6 + 3.5)::numeric,2)
    END;