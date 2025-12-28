/*ADV_Practice_Intermediate
Užduotys praktikai*/

/*1. LEFT JOIN kartojimas
Išvesti produkto pavadinimą ir užsakymo numerį (SalesOrderID) visiems produktams.
Naudojamos lentelės:
Production_Product AS p
LEFT JOIN Sales_SalesOrderDetail AS sod*/
SELECT
	p.Name,
	sod.SalesOrderID
FROM 
	production_product AS p
    LEFT JOIN sales_salesorderdetail sod ON sod.ProductID = p.ProductID;

/*2. RIGHT JOIN kartojimas
Išvesti teritorijos pavadinimą ir BusinessEntityID. Rezultate turi būti visi pardavėjai, nesvarbu, ar
jie dirba toje teritorijoje.
Naudojamos lentelės:
Sales_SalesTerritory
Sales_SalesPerson*/

SELECT 
	st.Name AS teritorijos_pavadinimas,
    sp.BusinessEntityID
FROM
	sales_salesperson AS sp
    RIGHT JOIN sales_salesterritory st ON st.TerritoryID = sp.TerritoryID;
    
    SELECT 
    st.Name AS teritorijos_pavadinimas,
    sp.BusinessEntityID
FROM sales_salesterritory st
RIGHT JOIN sales_salesperson sp
    ON st.TerritoryID = sp.TerritoryID;
    
/*3. JOIN kartojimas
Išvesti kontaktus, kurie nėra iš US ir gyvena miestuose, kurių pavadinimas prasideda „Pa“.
Išvesti stulpelius: AddressLine1, AddressLine2, City, PostalCode, CountryRegionCode.
Naudojamos lentelės:
Person_Address AS a
Person_StateProvince AS s*/

SELECT
    a.AddressLine1,
    a.AddressLine2,
    a.City,
    a.PostalCode,
    s.CountryRegionCode
FROM person_address AS a
JOIN person_stateprovince AS s
    ON s.StateProvinceID = a.StateProvinceID
WHERE a.City LIKE 'Pa%'
  AND s.CountryRegionCode <> 'US';
  
/*4. JOIN kartojimas su subquery arba CTE
Išvesti darbuotojų vardą ir pavardę (kartu) ir jų gyvenamą miestą.
Naudojamos lentelės:
Person_Person
HumanResources_Employee
Person_Address
Person_BusinessEntityAddress*/

WITH addr AS (
    SELECT
        bea.BusinessEntityID,
        a.City,
        ROW_NUMBER() OVER (
            PARTITION BY bea.BusinessEntityID
            ORDER BY a.AddressID DESC
        ) AS rn
    FROM person_businessentityaddress bea
    JOIN person_address a
        ON a.AddressID = bea.AddressID
)
SELECT
    CONCAT(p.FirstName, ' ', p.LastName) AS vardas_pavarde,
    addr.City
FROM humanresources_employee e
JOIN person_person p
    ON p.BusinessEntityID = e.BusinessEntityID
LEFT JOIN addr
    ON addr.BusinessEntityID = e.BusinessEntityID
   AND addr.rn = 1;

/*5. UNION ALL kartojimas
Parašyti SQL užklausą, kuri pateiktų visų raudonos arba mėlynos spalvos produktų sąrašą.
Išvesti: pavadinimą, spalvą ir katalogo kainą (ListPrice).
Rūšiuoti pagal ListPrice.
Naudojama lentelė:
Production_Product*/

SELECT
    Name,
    Color,
    ListPrice
FROM production_product
WHERE Color = 'Red'

UNION ALL

SELECT
    Name,
    Color,
    ListPrice
FROM production_product
WHERE Color = 'Blue'

ORDER BY ListPrice;

/*6. CTE kartojimas
Rasti, kiek užsakymų per metus įvykdo kiekvienas pardavėjas.
Naudojamos lentelės:
Sales_SalesOrderHeader
Sales_SalesPerson*/


SELECT 
	COUNT(soh.SalesOrderID) AS uzsakymai,
    sp.BusinessEntityID AS pardavejas
FROM
	sales_salesorderheader soh
    JOIN sales_salesperson sp ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY pardavejas;

SELECT 
    YEAR(soh.OrderDate) AS metai,
    sp.BusinessEntityID AS pardavejas,
    COUNT(soh.SalesOrderID) AS uzsakymai
FROM sales_salesorderheader soh
JOIN sales_salesperson sp 
    ON sp.BusinessEntityID = soh.SalesPersonID
GROUP BY 
    YEAR(soh.OrderDate),
    sp.BusinessEntityID
ORDER BY 
    metai,
    pardavejas;
    
    WITH orders_per_year AS (
    SELECT
        YEAR(soh.OrderDate) AS metai,
        soh.SalesPersonID AS pardavejas_id,
        COUNT(*) AS uzsakymai
    FROM sales_salesorderheader AS soh
    WHERE soh.SalesPersonID IS NOT NULL
    GROUP BY
        YEAR(soh.OrderDate),
        soh.SalesPersonID
)
SELECT
    opy.metai,
    sp.BusinessEntityID AS pardavejas,
    opy.uzsakymai
FROM orders_per_year AS opy
JOIN sales_salesperson AS sp
    ON sp.BusinessEntityID = opy.pardavejas_id
ORDER BY
    opy.metai,
    sp.BusinessEntityID;
    
/* 7. Aritmetiniai skaičiavimai
Apskaičiuoti bendros metų pardavimų sumos (SalesYTD) padalijimą iš komisinių procentinės
dalies (CommissionPCT).
Išvesti SalesYTD, CommissionPCT ir apskaičiuotą reikšmę, suapvalintą iki artimiausio sveikojo
skaičiaus.Naudojama lentelė:
Sales_SalesPerson*/

SELECT
    SalesYTD,
    CommissionPCT,
    ROUND(SalesYTD / NULLIF(CommissionPCT, 0)) AS skaiciuota_reiksme
FROM sales_salesperson;

SELECT
    SalesYTD,
    CommissionPCT,
    ROUND(SalesYTD / CommissionPCT) AS skaiciuota_reiksme
FROM sales_salesperson
WHERE CommissionPCT IS NOT NULL
  AND CommissionPCT <> 0;

/*8. STRING duomenų tipo manipuliavimas
Išvesti produktų pavadinimus, kurių kainos yra tarp 1000 ir 1220.
Pavadinimus išvesti trimis būdais: naudojant LOWER(), UPPER() ir LOWER(UPPER()).
Naudojama lentelė:
Production_Product*/

SELECT
    Name AS originalus_pavadinimas,
    LOWER(Name) AS pavadinimas_lower,
    UPPER(Name) AS pavadinimas_upper,
    LOWER(UPPER(Name)) AS pavadinimas_lower_upper
FROM production_product
WHERE ListPrice BETWEEN 1000 AND 1220;

/*9. Wildcards kartojimas
Iš Production_Product išrinkti ProductID ir pavadinimą produktų, kurių pavadinimas prasideda
„Lock %“.*/

SELECT
    ProductID,
    Name
FROM production_product
WHERE Name LIKE 'Lock %';

/*10. CASE ir loginės sąlygos
Iš lentelės HumanResources_Employee parašyti SQL užklausą, kuri grąžintų darbuotojų ID ir
reikšmę, ar darbuotojas gauna pastovų atlyginimą (SalariedFlag) kaip TRUE arba FALSE.
Rezultatus surikiuoti taip:
– pirmiausia darbuotojai su pastoviu atlyginimu, mažėjančia ID tvarka;
– po jų kiti darbuotojai, didėjančia ID tvarka.
Naudoti CASE tiek stulpelio konvertavimui, tiek rikiavimui.*/

SELECT
    BusinessEntityID AS darbuotojo_id,
    CASE 
        WHEN SalariedFlag = 1 THEN 'TRUE'
        ELSE 'FALSE'
    END AS ar_pastovus_atlyginimas
FROM humanresources_employee
ORDER BY
    CASE WHEN SalariedFlag = 1 THEN 0 ELSE 1 END,              
    CASE WHEN SalariedFlag = 1 THEN BusinessEntityID END DESC, 
    CASE WHEN SalariedFlag = 0 THEN BusinessEntityID END ASC;

/*11. Window Functions kartojimas
Naudojamos lentelės: Sales_SalesPerson, Person_Person, Person_Address.
Parašyti SQL užklausą, kuri atrinktų asmenis, gyvenančius teritorijoje ir kurių SalesYTD ≠ 0.
Grąžinti: vardą, pavardę, eilučių numeraciją (Row Number), reitingą (Rank), glaustą reitingą
(Dense Rank), kvartilį (Quartile), SalesYTD ir PostalCode.
Rikiuoti pagal PostalCode.
Naudoti ROW_NUMBER(), RANK(), DENSE_RANK(), NTILE().*/

WITH one_address AS (
    SELECT
        bea.BusinessEntityID,
        a.PostalCode,
        ROW_NUMBER() OVER (
            PARTITION BY bea.BusinessEntityID
            ORDER BY a.AddressID
        ) AS rn
    FROM person_businessentityaddress bea
    JOIN person_address a
        ON a.AddressID = bea.AddressID
)
SELECT
    p.FirstName,
    p.LastName,

    -- Window funkcijos (skaičiuojamos "per visą rezultatų rinkinį")
    ROW_NUMBER() OVER (ORDER BY oa.PostalCode) AS row_num,
    RANK()       OVER (ORDER BY sp.SalesYTD DESC) AS rank_by_sales,
    DENSE_RANK() OVER (ORDER BY sp.SalesYTD DESC) AS dense_rank_by_sales,
    NTILE(4)     OVER (ORDER BY sp.SalesYTD DESC) AS quartile,

    sp.SalesYTD,
    oa.PostalCode
FROM sales_salesperson sp
JOIN person_person p
    ON p.BusinessEntityID = sp.BusinessEntityID
JOIN one_address oa
    ON oa.BusinessEntityID = sp.BusinessEntityID
   AND oa.rn = 1
WHERE sp.TerritoryID IS NOT NULL      -- "gyvena teritorijoje" (turi priskirtą teritoriją)
  AND sp.SalesYTD <> 0                -- SalesYTD ≠ 0
ORDER BY oa.PostalCode;

/*12. Agregacijų kartojimas su Window Functions
Iš lentelės Sales_SalesOrderDetail apskaičiuoti suminį kiekį, vidurkį, užsakymų skaičių,
mažiausią ir didžiausią OrderQty kiekvienam SalesOrderID.
Atrinkti tik SalesOrderID: 43659 ir 43664.
Grąžinti: SalesOrderID, ProductID, OrderQty, suminį kiekį, vidurkį, užsakymų skaičių, minimalų
ir maksimalų kiekį.
Naudoti SUM(), AVG(), COUNT(), MIN(), MAX() su OVER (PARTITION BY SalesOrderID).*/

SELECT
    SalesOrderID,
    ProductID,
    OrderQty,

    SUM(OrderQty) OVER (PARTITION BY SalesOrderID) AS sum_kiekis,
    AVG(OrderQty) OVER (PARTITION BY SalesOrderID) AS avg_kiekis,
    COUNT(*)      OVER (PARTITION BY SalesOrderID) AS eiluciu_skaicius,
    MIN(OrderQty) OVER (PARTITION BY SalesOrderID) AS min_kiekis,
    MAX(OrderQty) OVER (PARTITION BY SalesOrderID) AS max_kiekis

FROM sales_salesorderdetail
WHERE SalesOrderID IN (43659, 43664)
ORDER BY SalesOrderID, ProductID;