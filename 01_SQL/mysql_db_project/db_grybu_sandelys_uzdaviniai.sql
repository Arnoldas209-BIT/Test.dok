/*Verslo problema
Įmonė gamina produkciją (partijomis), laiko ją sandėlyje ir vykdo klientų užsakymus. 
Reikia:
matyti ką pagaminom (partijom),
kiek turim sandėlyje (likučiai pagal partiją),
ką užsakė klientai ir už kokią sumą,
turėti galimybę greitai daryti ataskaitas (TOP klientai, mėnesio apyvarta, likučiai, užsakymų kiekiai).*/


-- 1.Kurie mūsų klientai generuoja didžiausią apyvartą ir sudaro pagrindinę pardavimų dalį?

SELECT
    c.network AS tinklas,
    c.name AS klientas,
    SUM(oi.quantity_kg * oi.price_per_kg) AS apyvarta_eur
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.network, c.name
ORDER BY apyvarta_eur DESC;

SELECT
    c.network AS tinklas,
    c.name AS klientas,
    COALESCE(SUM(oi.quantity_kg * oi.price_per_kg), 0) AS apyvarta_eur
FROM customers c
LEFT JOIN orders o 
    ON o.customer_id = c.customer_id
LEFT JOIN order_items oi 
    ON oi.order_id = o.order_id
GROUP BY c.network, c.name
ORDER BY apyvarta_eur DESC, c.network, c.name;

SELECT
  c.network AS tinklas,
  ROUND(COALESCE(SUM(oi.quantity_kg * oi.price_per_kg), 0), 2) AS apyvarta_eur
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.network
ORDER BY apyvarta_eur DESC, c.network;

-- 2.Kuriuos produktus klientai perka dažniausiai ir kurių pardavimo apimtys yra didžiausios?

SELECT
    p.display_name AS produktas,
    SUM(oi.quantity_kg) AS parduota_kg
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.display_name
ORDER BY parduota_kg DESC;

-- 3.Kiek šiuo metu turime kiekvieno produkto sandėlyje ir ar esami likučiai pakankami vykdomiems užsakymams?

SELECT
    p.display_name AS produktas,
    SUM(i.quantity_kg) AS likutis_kg
FROM inventory i
JOIN batches b ON i.batch_id = b.batch_id
JOIN products p ON b.product_id = p.product_id
GROUP BY p.display_name
ORDER BY likutis_kg DESC;

-- 4.Kaip kinta klientų užsakymų srautas skirtingomis dienomis ir kada turime didžiausią apkrovą?

SELECT
    order_date,
    COUNT(order_id) AS uzsakymu_sk
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- 5.Kokia yra vidutinė kiekvieno produkto pardavimo kaina ir kaip ji skiriasi tarp skirtingų užsakymų?

SELECT
    p.display_name AS produktas,
    ROUND(AVG(oi.price_per_kg), 2) AS vidutine_kaina_eur
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.display_name
ORDER BY vidutine_kaina_eur DESC;

SELECT
  p.display_name AS produktas,
  ROUND(MIN(oi.price_per_kg), 2) AS min_kaina,
  ROUND(AVG(oi.price_per_kg), 2) AS vidutine_kaina,
  ROUND(MAX(oi.price_per_kg), 2) AS max_kaina
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.display_name
ORDER BY p.display_name;

SELECT
  o.order_id,
  o.order_date,
  p.display_name AS produktas,
  oi.price_per_kg
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN products p ON p.product_id = oi.product_id
ORDER BY p.display_name, o.order_date;

-- 6.Kiek apyvartos sugeneruoja kiekvienas tinklas (Norfa/Aibė/IKI/Maxima) per dieną?

SELECT
  c.network,
  o.order_date,
  ROUND(SUM(oi.quantity_kg * oi.price_per_kg), 2) AS apyvarta_eur
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY c.network, o.order_date
ORDER BY o.order_date, apyvarta_eur DESC;

SELECT
  c.network,
  ROUND(SUM(oi.quantity_kg * oi.price_per_kg), 2) AS apyvarta_eur
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_date BETWEEN '2025-12-01' AND '2025-12-31'
GROUP BY c.network
ORDER BY apyvarta_eur DESC;

-- 7. Kurie klientai perka egzotinius grybus (Eryngii/Šiitake/Kreivabudės) ir kiek?

SELECT
  c.name AS klientas,
  p.display_name AS produktas,
  SUM(oi.quantity_kg) AS kiekis_kg
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
WHERE p.species NOT IN ('Balti šampinjonai', 'Rudi šampinjonai')
GROUP BY c.name, p.display_name
ORDER BY kiekis_kg DESC;

  -- bendras kiekis: egzotiniai + portobello
SELECT
  c.network,

  SUM(CASE WHEN p.species = 'Eryngii (stepių baravykai)' THEN oi.quantity_kg ELSE 0 END) AS eryngii_kg,
  SUM(CASE WHEN p.species = 'Šiitake' THEN oi.quantity_kg ELSE 0 END) AS shiitake_kg,
  SUM(CASE WHEN p.species = 'Kreivabudės' THEN oi.quantity_kg ELSE 0 END) AS kreivabudes_kg,
  SUM(CASE WHEN p.species = 'Portobello' THEN oi.quantity_kg ELSE 0 END) AS portobello_kg,

  SUM(oi.quantity_kg) AS total_ne_sampinjonai_kg

FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id

WHERE p.species NOT IN ('Balti šampinjonai', 'Rudi šampinjonai')

GROUP BY c.network
ORDER BY total_ne_sampinjonai_kg DESC;

-- 8.Kokios partijos artėja prie galiojimo pabaigos (per 2 dienas) ir kiek jų dar turime?“
-- (labai opi problema maisto pramoneje tokie grybu ismetimui = dideli pinigu praradimai) Ka galime padaryti padidinti pardavimus/paleisti akcijas tirti rinka ar poreikis krenta ar dideja pritaikyti auginimo poreiki ir tt..

SELECT
  b.batch_id,
  p.display_name AS produktas,
  b.harvest_date,
  b.shelf_life_days,
  DATE_ADD(b.harvest_date, INTERVAL b.shelf_life_days DAY) AS galioja_iki,
  SUM(i.quantity_kg) AS likutis_kg
FROM batches b
JOIN products p ON p.product_id = b.product_id
JOIN inventory i ON i.batch_id = b.batch_id
WHERE DATE_ADD(b.harvest_date, INTERVAL b.shelf_life_days DAY) <= DATE_ADD(CURDATE(), INTERVAL 2 DAY)
GROUP BY b.batch_id, p.display_name, b.harvest_date, b.shelf_life_days
ORDER BY galioja_iki ASC;

SELECT
  p.display_name AS produktas,
  ROUND(SUM(i.quantity_kg), 2) AS likutis_kg,
  ROUND(SUM(i.quantity_kg * p.default_price), 2) AS potencialus_praradimas_eur
FROM batches b
JOIN products p  ON p.product_id = b.product_id
JOIN inventory i ON i.batch_id = b.batch_id
WHERE DATE_ADD(b.harvest_date, INTERVAL b.shelf_life_days DAY) <= DATE_ADD(CURDATE(), INTERVAL 2 DAY)
GROUP BY p.display_name
ORDER BY potencialus_praradimas_eur DESC;

SELECT
  ROUND(SUM(i.quantity_kg * p.default_price), 2) AS prarastas_revenue_eur
FROM batches b
JOIN products p  ON p.product_id = b.product_id
JOIN inventory i ON i.batch_id = b.batch_id
WHERE DATE_ADD(b.harvest_date, INTERVAL b.shelf_life_days DAY)
      <= DATE_ADD(CURDATE(), INTERVAL 2 DAY);

-- 9.Kokie tiekėjai atveža daugiausiai probleminių partijų (nurūšiavimai/atmetimai)?“

SELECT
  s.name AS tiekejas,
  COUNT(*) AS probleminiu_partiju_sk,
  SUM(CASE WHEN bqa.decision = 'Rejected' THEN 1 ELSE 0 END) AS atmestu_sk,
  SUM(COALESCE(bqa.rejected_qty_kg, 0)) AS atmesta_kg,
  AVG(COALESCE(bqa.discount_percent, 0)) AS vid_nuolaida_proc
FROM batch_sources bs
JOIN suppliers s ON s.supplier_id = bs.supplier_id
JOIN batch_quality_actions bqa ON bqa.batch_id = bs.batch_id
WHERE bs.source_type = 'Supplier'
  AND bqa.decision IN ('Downgraded', 'Rejected')
GROUP BY s.name
ORDER BY atmestu_sk DESC, probleminiu_partiju_sk DESC;

-- 10. Kiek nuostolio per mėnesį sudaro atmestos partijos (kg) ir kiek dažnai tai kartojasi?

SELECT
  DATE_FORMAT(action_date, '%Y-%m') AS menuo,
  COUNT(*) AS incidentu_sk,
  SUM(COALESCE(rejected_qty_kg, 0)) AS atmesta_kg
FROM batch_quality_actions
WHERE decision = 'Rejected'
GROUP BY DATE_FORMAT(action_date, '%Y-%m')
ORDER BY menuo;

-- 11. Kokie darbuotojai per mėnesį sugeneruoja didžiausią naudą sandėlio ir gamybos procesuose pagal pagrindinius KPI?

SELECT
    e.first_name,
    e.last_name,
    d.name AS skyrius,
    k.name AS kpi_pavadinimas,
    ek.period_month,
    SUM(ek.value) AS kpi_rezultatas,
    k.unit
FROM employee_kpi_results ek
JOIN employees e ON e.employee_id = ek.employee_id
JOIN kpi_types k ON k.kpi_id = ek.kpi_id
JOIN employee_departments ed ON ed.employee_id = e.employee_id
JOIN departments d ON d.department_id = ed.department_id
WHERE ek.period_month = '2025-12-01'
GROUP BY
    e.first_name, e.last_name, d.name, k.name, ek.period_month, k.unit
ORDER BY
    kpi_rezultatas DESC;
    
    SELECT
    e.first_name,
    e.last_name,
    d.name AS skyrius,
    k.name AS kpi_pavadinimas,
    ek.period_month,
    ek.value,
    k.unit
FROM employees e
LEFT JOIN employee_kpi_results ek 
    ON ek.employee_id = e.employee_id
    AND ek.period_month = '2025-12-01'
LEFT JOIN kpi_types k 
    ON k.kpi_id = ek.kpi_id
LEFT JOIN employee_departments ed 
    ON ed.employee_id = e.employee_id
LEFT JOIN departments d 
    ON d.department_id = ed.department_id
ORDER BY e.last_name;
