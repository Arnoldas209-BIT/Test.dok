/*Verslo problema
Įmonė gamina produkciją (partijomis), laiko ją sandėlyje ir vykdo klientų užsakymus. 
Reikia:
matyti ką pagaminom (partijom),
kiek turim sandėlyje (likučiai pagal partiją),
ką užsakė klientai ir už kokią sumą,
turėti galimybę greitai daryti ataskaitas (TOP klientai, mėnesio apyvarta, likučiai, užsakymų kiekiai).*/


-- Kurie mūsų klientai generuoja didžiausią apyvartą ir sudaro pagrindinę pardavimų dalį?

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

-- Kuriuos produktus klientai perka dažniausiai ir kurių pardavimo apimtys yra didžiausios?

SELECT
    p.display_name AS produktas,
    SUM(oi.quantity_kg) AS parduota_kg
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.display_name
ORDER BY parduota_kg DESC;

-- Kiek šiuo metu turime kiekvieno produkto sandėlyje ir ar esami likučiai pakankami vykdomiems užsakymams?

SELECT
    p.display_name AS produktas,
    SUM(i.quantity_kg) AS likutis_kg
FROM inventory i
JOIN batches b ON i.batch_id = b.batch_id
JOIN products p ON b.product_id = p.product_id
GROUP BY p.display_name
ORDER BY likutis_kg DESC;

-- Kaip kinta klientų užsakymų srautas skirtingomis dienomis ir kada turime didžiausią apkrovą?

SELECT
    order_date,
    COUNT(order_id) AS uzsakymu_sk
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- Kokia yra vidutinė kiekvieno produkto pardavimo kaina ir kaip ji skiriasi tarp skirtingų užsakymų?

SELECT
    p.display_name AS produktas,
    ROUND(AVG(oi.price_per_kg), 2) AS vidutine_kaina_eur
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.display_name
ORDER BY vidutine_kaina_eur DESC;


