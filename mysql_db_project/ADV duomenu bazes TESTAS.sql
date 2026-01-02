/*AdventureWorks2019 Test
1. Klientų lojalumo analizė.
Scenarijus: Įmonės rinkodaros komanda 2014 m. birželio 30 d.siekia įvertinti klientų
lojalumą. Jūsų užduotis skirta įvertinti klientų elgseną laike. Reikia nustatyti, kurie klientai
pirmą kartą užsakė 2013 metais ir kiek vidutiniškai išleido tais metais, ir ar jie užsakė dar
kartą ir kiekvieno užsakymo sumą 2014 metais.
Naudojamos lentelės: sales_salesorderheader, sales_customer, person_person.
Naudojamos window function: DENSE_RANK().
Laukiamas rezultatas:
+-------+---------+----------+------------------------+-------------+----------------+--------+---------+
| id | vardas | pavarde | uzsakymo_vidurkis_2013 | uzsakymoID | uzsakymo_data | suma | ranking |
+-------+---------+----------+------------------------+-------------+----------------+--------+---------+
| 11012 | Lauren | Walker | 82.85 | 68413 | 2014-03-16 | 6.94 | 1 |
| 11013 | Ian | Jenkins | 43.07 | 74908 | 2014-06-22 | 82.85 | 1 |
| 11014 | Sydney | Bennett | 76.49 | NULL | NULL | NULL | 1 |
+-------+---------+----------+------------------------+-------------+----------------+--------+---------+
9486 rows */

WITH all_orders AS (
    -- 1) Pasiimame VISUS užsakymus ir priskiriame "pirmumo reitingą" pagal užsakymo datą kiekvienam klientui
    SELECT
        soh.CustomerID,
        soh.SalesOrderID,
        soh.OrderDate,
        soh.TotalDue,
        DENSE_RANK() OVER (
            PARTITION BY soh.CustomerID
            ORDER BY soh.OrderDate, soh.SalesOrderID
        ) AS first_order_rank
    FROM sales_salesorderheader AS soh
),

first_2013_customers AS (
    -- 2) Paimame tik tuos klientus, kurių PATS PIRMAS užsakymas (rank=1) buvo 2013 metais
    SELECT DISTINCT
        ao.CustomerID
    FROM all_orders AS ao
    WHERE ao.first_order_rank = 1
      AND YEAR(ao.OrderDate) = 2013
),

avg_2013 AS (
    -- 3) Suskaičiuojame tų klientų 2013 m. užsakymų vidurkį
    SELECT
        soh.CustomerID,
        ROUND(AVG(soh.TotalDue), 2) AS uzsakymo_vidurkis_2013
    FROM sales_salesorderheader AS soh
    JOIN first_2013_customers AS f
        ON f.CustomerID = soh.CustomerID
    WHERE YEAR(soh.OrderDate) = 2013
    GROUP BY
        soh.CustomerID
),

orders_2014 AS (
    -- 4) Paimame 2014 m. užsakymus ir su DENSE_RANK suranguojame kiekvieno kliento 2014 m. užsakymus
    SELECT
        soh.CustomerID,
        soh.SalesOrderID,
        soh.OrderDate,
        ROUND(soh.TotalDue, 2) AS suma,
        DENSE_RANK() OVER (
            PARTITION BY soh.CustomerID
            ORDER BY soh.OrderDate, soh.SalesOrderID
        ) AS ranking
    FROM sales_salesorderheader AS soh
    WHERE YEAR(soh.OrderDate) = 2014
)

-- 5) Galutinis rezultatas: klientas + 2013 vidurkis + 2014 užsakymai (arba NULL, jei jų nėra)
SELECT
    sc.CustomerID AS id,
    pp.FirstName  AS vardas,
    pp.LastName   AS pavarde,
    a.uzsakymo_vidurkis_2013,
    o.SalesOrderID AS uzsakymoID,
    o.OrderDate    AS uzsakymo_data,
    o.suma,
    o.ranking
FROM first_2013_customers AS f
JOIN sales_customer AS sc
    ON sc.CustomerID = f.CustomerID
JOIN person_person AS pp
    ON pp.BusinessEntityID = sc.PersonID
JOIN avg_2013 AS a
    ON a.CustomerID = sc.CustomerID
LEFT JOIN orders_2014 AS o
    ON o.CustomerID = sc.CustomerID
ORDER BY
    sc.CustomerID,
    o.ranking,
    o.OrderDate,
    o.SalesOrderID;


/*2. Produktų pardavimų analizė pagal prekių kategorijas ir regionus
Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą produktų pardavimų sumą pagal prekių
kategorijas ir rodo rezultatus pagal regionus. Užklausoje turi būti šie stulpeliai:
• Prekės kategorija (iš ProductCategory)
• Regionas (iš SalesTerritory)
• Bendros pardavimų sumos
Užuomina: Susijunkite SalesOrderDetail su Product ir ProductCategory, tada susijunkite
SalesOrderHeader su SalesTerritory naudojant atitinkamus Foreign Keys. Filtruokite
rezultatus pagal 2013 metų pardavimus.
Tikėtinas rezultatas:
• Prekės kategorija
• Regionas
• Bendros pardavimų sumos
Tikėtini rezultatai:
# kategorija, regionas, suma'Bikes', 'Australia', '3951062.89'
40 rows */

SELECT
    pc.Name AS kategorija,
    st.Name AS regionas,
    ROUND(SUM(sod.LineTotal), 2) AS bendra_pardavimu_suma
FROM sales_salesorderdetail AS sod
JOIN sales_salesorderheader AS soh
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product AS p
    ON p.ProductID = sod.ProductID
LEFT JOIN production_productsubcategory AS psc
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN production_productcategory AS pc
    ON pc.ProductCategoryID = psc.ProductCategoryID
LEFT JOIN sales_salesterritory AS st
    ON st.TerritoryID = soh.TerritoryID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY
    pc.Name,
    st.Name
ORDER BY
    pc.Name,
    st.Name;

/*3. Pardavimų departamento darbuotojų našumas
Užduotis: Vadovybė nori įvertinti pardavimų darbuotojų efektyvumą pagal jų priskirtus
departamentus. Naudojant duomenis iš lentelių SalesOrderHeader, Person,
EmployeeDepartmentHistory ir Department, reikia apskaičiuoti bendrą kiekvieno darbuotojo
pardavimų sumą, nustatyti, kuriam departamentui jis priklauso, ir palyginti darbuotojo
rezultatus su to departamento vidurkiu. Skaičiavimui naudojama window function AVG(...)
OVER (PARTITION BY DepartmentID), kuri leidžia gauti departamento vidutinę pardavimų sumą.
Palyginimui reikia pridėti stulpelį, rodantį darbuotojo santykinį našumą procentais, ir tekstinį
įvertinimą (ar darbuotojo rezultatas viršija, atitinka ar nesiekia vidurkio), naudojant CASE.
Tikėtini rezultatai:
+-----+---------+----------+-------------+------------------------+-----------------------------+-------------------
-----+--------------------+
| id | vardas | pavarde | departamentas | darbuotojo_pardavimai | departamento_pard_vidurkis
| santykinis_nasumas_proc | vertinimas |
+-----+---------+----------+-------------+------------------------+-----------------------------+-------------------
-----+--------------------+
| 276 | Linda | Mitchell | Sales | 11695019.06 | 5339732.18 | 219.0 |
Viršija vidurkį |
| 277 | Jillian | Carson | Sales | 11342385.90 | 5339732.18 | 212.4 |
Viršija vidurkį |
| 275 | Michael | Blythe | Sales | 10475367.08 | 5339732.18 | 196.2 |
Viršija vidurkį |
+-----+---------+----------+-------------+------------------------+-----------------------------+-------------------
-----+--------------------+
17 rows */

WITH employee_sales AS (
    SELECT
        soh.SalesPersonID AS BusinessEntityID,
        ROUND(SUM(soh.TotalDue), 2) AS darbuotojo_pardavimai
    FROM sales_salesorderheader AS soh
    WHERE soh.SalesPersonID IS NOT NULL
    GROUP BY soh.SalesPersonID
),
current_dept AS (
    SELECT
        edh.BusinessEntityID,
        edh.DepartmentID,
        ROW_NUMBER() OVER (
            PARTITION BY edh.BusinessEntityID
            ORDER BY
                CASE WHEN edh.EndDate IS NULL THEN 0 ELSE 1 END,
                edh.StartDate DESC
        ) AS rn
    FROM humanresources_employeedepartmenthistory AS edh
),
base AS (
    SELECT
        es.BusinessEntityID AS id,
        p.FirstName AS vardas,
        p.LastName  AS pavarde,
        d.Name      AS departamentas,
        es.darbuotojo_pardavimai,
        cd.DepartmentID
    FROM employee_sales AS es
    JOIN person_person AS p
        ON p.BusinessEntityID = es.BusinessEntityID
    LEFT JOIN current_dept AS cd
        ON cd.BusinessEntityID = es.BusinessEntityID
       AND cd.rn = 1
    LEFT JOIN humanresources_department AS d
        ON d.DepartmentID = cd.DepartmentID
)
SELECT
    id,
    vardas,
    pavarde,
    departamentas,
    darbuotojo_pardavimai,
    ROUND(
        AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID),
        2
    ) AS departamento_pard_vidurkis,
    ROUND(
        (darbuotojo_pardavimai /
         NULLIF(AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID), 0)
        ) * 100,
        1
    ) AS santykinis_nasumas_proc,
    CASE
        WHEN darbuotojo_pardavimai >
             AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID)
            THEN 'Viršija vidurkį'
        WHEN darbuotojo_pardavimai =
             AVG(darbuotojo_pardavimai) OVER (PARTITION BY DepartmentID)
            THEN 'Atitinka vidurkį'
        ELSE 'Nesiekia vidurkio'
    END AS vertinimas
FROM base
ORDER BY
    departamentas,
    darbuotojo_pardavimai DESC;


/*4. Pardavimų analize pagal laikotarpį ir produktų grupes
Užduotis: Parašykite užklausą, kuri apskaičiuoja bendrą pardavimų sumą per metus (2013)
pagal produktų grupes ir pateikia šiuos duomenis:
• Prekės grupė (iš ProductSubcategory)• Bendros pardavimų sumos
• Pardavimų kiekis
• Vidutinė pardavimo kaina
Užuomina: Susijunkite SalesOrderDetail su Product ir ProductSubcategory. Filtruokite pagal
2013 metų pardavimus ir apskaičiuokite bendrą pardavimų sumą, kiekį ir vidutinę pardavimo
kainą (rikiuojant desc)..
Tikėtinas rezultatas:
# prekes_grupe, kiekis, pardavimu_suma, vidutine_pardavimo_kaina
'Mountain Bikes', '11741', '13046301.82', '1111.17'
35 rows */

SELECT
    psc.Name AS prekes_grupe,
    SUM(sod.OrderQty) AS kiekis,
    ROUND(SUM(sod.LineTotal), 2) AS pardavimu_suma,
    ROUND(SUM(sod.LineTotal) / NULLIF(SUM(sod.OrderQty), 0), 2) AS vidutine_pardavimo_kaina
FROM sales_salesorderdetail AS sod
JOIN sales_salesorderheader AS soh
    ON soh.SalesOrderID = sod.SalesOrderID
JOIN production_product AS p
    ON p.ProductID = sod.ProductID
LEFT JOIN production_productsubcategory AS psc
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY
    psc.Name
ORDER BY
    pardavimu_suma DESC;

/*5. Gamybos ir tiekimo grandinės efektyvumo analizė
Užduotis: Parašykite užklausą, kuri apskaičiuoja prekių tiekimo laiką pagal gamintoją.
Pateikite šiuos duomenis:
• Tiekimo grandinės tiekėjo pavadinimas (iš Supplier)
• Prekės pavadinimas (iš Product)
• Laikas nuo užsakymo iki pristatymo (laiko skirtumas tarp OrderDate ir ShipDate)
Užuomina: Susijunkite Product su ProductSupplier, o ProductSupplier su Supplier.
Apskaičiuokite vidutinį tiekimo laiką pagal tiekėją. Išrūšiuokite pagal tiekėją ir produktą.
Tikėtinas rezultatas:
# tiekejas, produktas, vid_pristatymo_laikas
'Advanced Bicycles', 'Thin-Jam Hex Nut 1', '10'
'Advanced Bicycles', 'Thin-Jam Hex Nut 10', '10'
'Advanced Bicycles', 'Thin-Jam Hex Nut 11', '10'
460 rows. */

SELECT
    v.Name AS tiekejas,
    p.Name AS produktas,
    ROUND(AVG(DATEDIFF(poh.ShipDate, poh.OrderDate)), 0) AS vid_pristatymo_laikas
FROM purchasing_purchaseorderheader AS poh
JOIN purchasing_purchaseorderdetail AS pod
    ON pod.PurchaseOrderID = poh.PurchaseOrderID
JOIN production_product AS p
    ON p.ProductID = pod.ProductID
JOIN purchasing_vendor AS v
    ON v.BusinessEntityID = poh.VendorID
WHERE poh.ShipDate IS NOT NULL
GROUP BY
    v.Name,
    p.Name
ORDER BY
    v.Name,
    p.Name;

/*6. Pardavimų sezoniškumo analizė
Užduotis: Parašykite užklausą, kuri apskaičiuoja mėnesio pardavimus 2013 metais,
naudodamiesi SalesOrderHeader duomenimis. Užklausoje turi būti:• Mėnuo (iš OrderDate)
• Bendros pardavimų sumos
• Pardavimų kiekis
Užuomina: Filtruokite pagal 2023 metus, naudokite MONTH() funkciją, kad išgautumėte
mėnesio reikšmę ir MONTHNAME() mėnesio pavadinimui, ir apskaičiuokite bendrą pardavimų
sumą bei kiekį kiekvienam mėnesiui.
# menuo, menuo_pavadinimas, pardavimu_kiekis, pardavimu_suma
'1', 'January', '407', '2354903.68'
12 rows.*/

SELECT
    MONTH(soh.OrderDate) AS menuo,
    MONTHNAME(soh.OrderDate) AS menuo_pavadinimas,
    COUNT(soh.SalesOrderID) AS pardavimu_kiekis,
    ROUND(SUM(soh.TotalDue), 2) AS pardavimu_suma
FROM sales_salesorderheader AS soh
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY
    MONTH(soh.OrderDate),
    MONTHNAME(soh.OrderDate)
ORDER BY
    MONTH(soh.OrderDate);

