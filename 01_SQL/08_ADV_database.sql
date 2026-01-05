-- 1. Išveskite visų klientų vardus ir pavardes iš person_person.

SELECT
FirstName,
LastName
FROM
person_person;

-- 2.Suskaičiuokite kiek įrašų yra lentelėje person_person.
SELECT
	COUNT(*)
FROM
	person_person;
    
    
    -- 3. Išveskite visus miestus iš person_address, nesikartojančius
    
SELECT DISTINCT city FROM person_address;

-- 4. Raskite kiek žmonių turi el. paštą (naudokite emailaddress).
 
 SELECT 
 COUNT(*)
 FROM
	person_emailaddress;
    
    -- 5 Išveskite pirmus 10 produktų iš production_product
    
 select ProductID, name 

from production_product

order by ReorderPoint desc

limit 10;
 
 -- 6. Raskite visus produktus, kurių svoris yra didesnis nei 100.
 
SELECT
	Name
    , Weight
FROM production_product
WHERE 
	Weight > 100;
        
-- 7. Raskite visas šalis, kurios prasideda raide 'C', naudokite LIKE.

SELECT * FROM person_countryregion 
WHERE name LIKE'C%';
-- 8 Išveskite dabartinę datą naudodami CURRENT_DATE()
SELECT
	DATE(MIN(OrderDate))
    , DATE(MAX(OrderDate))
FROM sales_salesorderheader;
-- 9 Raskite, kiek produktų neturi nurodyto svorio (weight IS NULL)
SELECT
	Name
    , Weight
FROM production_product
WHERE 
	Weight IS NULL;
    -- 10  Suskaičiuokite, kiek darbuotojų yra lentelėje humanresources_employee.
    SELECT

    COUNT(BusinessEntityID)
FROM humanresources_employee;
 
    -- 11. Raskite visus darbuotojus, kurių gimimo data po 1980 metų.
    
SELECT
	BusinessEntityID
    , BirthDate
FROM humanresources_employee
WHERE YEAR(BirthDate) >1980;

-- 12
-- 12.	Raskite visus produktus, kurių pavadinime yra žodis "Helmet".
select productid, name, ROUND(listprice,2) AS KAINA from production_product 
where name like '%helmet%';
 
 
	-- 13 Rūšiuokite produktus pagal kainą mažėjančia tvarka.

SELECT 
    productid,
    name,
    listprice
FROM 
    production_product
ORDER BY 
    listprice DESC; 
    
    -- 14 Apskaičiuokite vidutinę produkto kainą
SELECT 
    ROUND(AVG(listprice), 2) AS vidutine_kaina
FROM 
    production_product;

-- 15. Konvertuokite produkto pavadinimą į didžiąsias raides.
 
SELECT name,
	ROUND(AVG(ListPrice),2) AS Vidutine_kaina
FROM production_product
GROUP BY name
HAVING Vidutine_kaina > 0;
SELECT
	UPPER(Name)
    , listprice
FROM production_product
ORDER BY listprice DESC;

-- 16. Raskite miestus, kurių pavadinimas ilgesnis nei 10 simbolių.
 
SELECT DISTINCT
    city
FROM 
    person_address
WHERE 
    LENGTH(city) > 10;
    
-- 17 Apskaičiuokite kiek žmonių gyvena kiekviename mieste
SELECT 
    pa.city,
    COUNT(DISTINCT pp.BusinessEntityID) AS gyventojai
FROM person_person pp
JOIN person_businessentityaddress bea 
    ON pp.BusinessEntityID = bea.BusinessEntityID
JOIN person_address pa 
    ON bea.AddressID = pa.AddressID
GROUP BY 
    pa.city
ORDER BY 
    gyventojai DESC;
    
    -- 18. Raskite visus darbuotojus, kurių pavardė baigiasi 'son'.
    
    SELECT 
    pp.businessentityid,
    pp.firstname,
    pp.lastname,
    e.jobtitle
FROM 
    person_person pp
JOIN 
    humanresources_employee e 
        ON pp.BusinessEntityID = e.BusinessEntityID
WHERE 
    pp.lastname LIKE '%son';
    
   --  19. Sujunkite person_person ir emailaddress, kad gautumėte žmogų su jo el. paštu.
 
    
    SELECT 
    pp.BusinessEntityID,
    pp.FirstName,
    pp.LastName,
    ea.EmailAddress
FROM 
    person_person pp
JOIN 
    person_emailaddress ea 
        ON pp.BusinessEntityID = ea.BusinessEntityID;
        
    --     20. Suskirstykite produktus į grupes pagal productsubcategoryid ir suskaičiuokite, kiek jų kiekvienoje.
    
    SELECT 
    productsubcategoryid,
    COUNT(*) AS produktu_kiekis
FROM 
    production_product
GROUP BY 
    productsubcategoryid
ORDER BY 
    produktu_kiekis DESC;
 
 
 SELECT 
psc.ProductSubCategoryID,
psc.name,
COUNT(pp.ProductID) AS Kiekis
FROM production_product pp
JOIN production_productsubcategory psc 
	ON pp.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN production_productcategory pc 
	ON pc.ProductCategoryID = psc.ProductCategoryID
GROUP BY psc.ProductCategoryID, psc.name
ORDER BY Kiekis DESC;

/* INFO:
 
LEFT JOIN - duoda 38 atsakymas
JOIN - duoda 37 atsakymus
Vadinasi, YRA ir GALI BUTI produktai, kurie neturi subkategoriju.
RIGHT JOIN - duoda 29 atsakymus
JOIN - douda 37 atsakymus
Vadinasi, YRA ir GALI BUTI subkategorijos, kurios nepriskirtos jokiems produktams.
LEFT JOIN - duoda 37 atsakymas
JOIN - duoda 37 atsakymus
Vadinasi, NERA produktu, kurie neturi subkategoriju.
Ar GALI BUTI produktai, kurie neturi subkategoriju - neaisku, reikia ziureti DB schema.
RIGHT JOIN - duoda 37 atsakymas
JOIN - duoda 37 atsakymus
Vadinasi, NERA subkategoriju, kurios nepriskirtos jokiems produktams.
Ar GALI BUTI produktai, kurios nepriskirtos jokiems produktams - neaisku, reikia ziureti DB schema */ 
 

 -- 21. Naudodami JOIN, parodykite klientų vardus ir miestus.
 
 SELECT 
    pp.FirstName,
    pp.LastName,
    pa.City
FROM person_person pp
JOIN person_businessentityaddress bea 
    ON pp.BusinessEntityID = bea.BusinessEntityID
JOIN person_address pa
    ON bea.AddressID = pa.AddressID;
 
-- 22. Sujunkite produktų ir jų kategorijų lenteles, parodykite produktų pavadinimus ir
-- kategorijų pavadinimus.

SELECT
    pp.Name,
    pc.Name
FROM 
	production_product pp
JOIN production_productsubcategory psc ON psc.ProductSubcategoryID = pp.ProductSubcategoryID
JOIN production_productcategory pc ON pc.ProductCategoryID = psc.ProductCategoryID;
    
-- 23. Raskite 5 brangiausius produktus.

SELECT
	ProductID,
    Name,
    ListPrice
FROM
	production_product
ORDER BY listprice DESC
LIMIT 5;

-- 24. Naudokite CASE, kad pažymėtumėte produktus kaip 'Lengvas', 'Vidutinis', 'Sunkus'
-- pagal svorį.

SELECT
	Name,
    Weight,
CASE
	WHEN Weight BETWEEN 0 AND 150 THEN 'Lengvas'
	WHEN Weight BETWEEN 151 AND 350 THEN 'Vidutinis'
	WHEN Weight BETWEEN 351 AND 1050 THEN 'Sunkus'
	ELSE 'Nera'
END svorio_grupe
FROM 
	production_product;
    
    SELECT
    Name,
    Weight,
    CASE
        WHEN Weight < 151 THEN 'Lengvas'
        WHEN Weight < 351 THEN 'Vidutinis'
        WHEN Weight <= 1050 THEN 'Sunkus'
        ELSE 'Nėra'
    END AS svorio_grupe
FROM production_product;

SELECT
    Name,
    Weight,
    CASE
        WHEN Weight IS NULL THEN 'Nežinomas'
        WHEN Weight <= 150 THEN 'Lengvas'
        WHEN Weight <= 350 THEN 'Vidutinis'
        ELSE 'Sunkus'
    END AS svorio_grupe
FROM production_product;
    
SELECT * FROM production_product;


-- 25. Naudokite IF() funkciją produkto kainos analizei – ar viršija 500.

SELECT
    Name,
    ListPrice,
    IF(ListPrice > 500, 'Viršija 500', 'Neviršija 500') AS kainos_ivertinimas
FROM production_product;

-- 26. Raskite klientus, kurie turi daugiau nei vieną adresą (naudokite GROUP BY ir
-- HAVING).

SELECT
    bea.BusinessEntityID,
    COUNT(bea.AddressID) AS adresu_kiekis
FROM person_businessentityaddress bea
GROUP BY bea.BusinessEntityID
HAVING COUNT(bea.AddressID) > 1;

SELECT * FROM sales_customer;

-- 27. Sukurkite CTE, kuris grąžina visus produktus, kurių kaina viršija vidurkį.

WITH vidurkis AS (
    SELECT
        AVG(ListPrice) AS avg_price
    FROM production_product
)
SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM production_product p
JOIN vidurkis v
    ON p.ListPrice > v.avg_price;

-- 28. Naudokite subquery, kad rastumėte produktus brangesnius už visų produktų
-- medianą.

SELECT
    ProductID,
    Name,
    ListPrice
FROM production_product
WHERE ListPrice >
(
    SELECT AVG(ListPrice)
    FROM production_product
);

-- 29. Raskite šalis, kuriose gyvena daugiau nei 5 žmonės (pagal adresus).

SELECT
    cr.Name AS salis,
    COUNT(*) AS adresu_kiekis
FROM person_address a
JOIN person_stateprovince sp
    ON sp.StateProvinceID = a.StateProvinceID
JOIN person_countryregion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
GROUP BY
    cr.Name
HAVING
    COUNT(*) > 5
ORDER BY
    adresu_kiekis DESC;
    
    SELECT
    cr.Name AS salis,
    COUNT(DISTINCT p.BusinessEntityID) AS zmoniu_kiekis
FROM person_person p
JOIN person_businessentityaddress bea
    ON bea.BusinessEntityID = p.BusinessEntityID
JOIN person_address a
    ON a.AddressID = bea.AddressID
JOIN person_stateprovince sp
    ON sp.StateProvinceID = a.StateProvinceID
JOIN person_countryregion cr
    ON cr.CountryRegionCode = sp.CountryRegionCode
GROUP BY
    cr.Name
HAVING
    COUNT(DISTINCT p.BusinessEntityID) > 5
ORDER BY
    zmoniu_kiekis DESC;
    
-- 30. Apskaičiuokite bendrą visų užsakymų pardavimo sumą iš sales_salesorderheader.

SELECT
    SUM(TotalDue) AS pardavimo_suma
FROM
	sales_salesorderheader;

-- 31. Raskite kiek klientų pateikė bent vieną užsakymą.

SELECT
    CustomerID,
    COUNT(SalesOrderID) AS uzsakimu_sk
FROM
	sales_salesorderheader
GROUP BY 
	CustomerID;

SELECT
    COUNT(DISTINCT CustomerID) AS klientu_skaicius
FROM sales_salesorderheader;

-- 32. Raskite kiekvieno kliento visų užsakymų sumą (vardas, pavardė, suma).

SELECT
	pp.FirstName,
	pp.LastName,
    pp.BusinessEntityID,
	ROUND(SUM(ss.TotalDue),2) AS bendra_suma
FROM
	person_person pp
    JOIN sales_customer sc ON sc.CustomerID = pp.BusinessEntityID				-- klaida padaryta sujungti bandziau per customer_id o turejo buti person_id 
    JOIN sales_salesorderheader ss ON ss.CustomerID = sc.CustomerID
GROUP BY 
	pp.BusinessEntityID,
	pp.FirstName, 
    pp.LastName;

SELECT
    pp.BusinessEntityID,
    pp.FirstName,
    pp.LastName,
    ROUND(SUM(ss.TotalDue), 2) AS bendra_suma
FROM person_person pp
JOIN sales_customer sc 
    ON sc.PersonID = pp.BusinessEntityID
JOIN sales_salesorderheader ss 
    ON ss.CustomerID = sc.CustomerID
GROUP BY 
    pp.BusinessEntityID,
    pp.FirstName,
    pp.LastName;

-- 33. Apskaičiuokite kiek užsakymų buvo pateikta kiekvieną mėnesį.

SELECT
	month(ModifiedDate) AS menuo,
    COUNT(SalesOrderID) AS uzsakymu_sk			-- ir vel panaudojau ne ta lentele, plius menuo be metu labai didele klaida analitikoje turi buti metai kad visko nesudetu is visu metu!!! 
FROM
	sales_salesorderdetail
    GROUP BY menuo
    ORDER BY menuo ASC;

SELECT
    YEAR(OrderDate) AS metai,
    MONTH(OrderDate) AS menuo,
    COUNT(SalesOrderID) AS uzsakymu_sk					-- geras sprendimas 			
FROM sales_salesorderheader
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    metai,
    menuo;

-- 34. Išveskite 10 dažniausiai parduodamų produktų pagal kiekį.

SELECT
	pp.ProductID,
	pp.Name,
	SUM(soh.SalesOrderID) AS kiekis
FROM
	production_product pp
    JOIN Sales.SalesOrderDetail sod ON sod.ProductID = pp.ProductID
    JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID 			-- mano sprendimas neveikia... nes skaiciavau uzsakimu nr o ne pacius uzsakimus 
GROUP BY 
	pp.ProductID, 
    pp.Name
ORDER BY COUNT(ss.SalesOrderID) DESC;

SELECT
    pp.ProductID,
    pp.Name,
    SUM(sod.OrderQty) AS kiekis
FROM production_product pp
JOIN sales_salesorderdetail sod
    ON sod.ProductID = pp.ProductID
GROUP BY
    pp.ProductID,
    pp.Name
ORDER BY
    kiekis DESC
LIMIT 10;

-- 35. Raskite visus klientus, kurių pirkimo suma viršija vidutinę visų klientų sumą. (su
-- subquery)

SELECT
    pp.FirstName,
    pp.LastName,
    SUM(sod.LineTotal) AS pirkimo_suma
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN sales_customer sc
    ON sc.CustomerID = soh.CustomerID
JOIN person_person pp
    ON pp.BusinessEntityID = sc.PersonID			-- nemokejau isprest.... 
GROUP BY
    pp.FirstName,
    pp.LastName,
    soh.CustomerID
HAVING
    SUM(sod.LineTotal) >
    (
        SELECT AVG(kliento_suma)
        FROM (
            SELECT
                soh2.CustomerID,
                SUM(sod2.LineTotal) AS kliento_suma
            FROM sales_salesorderheader soh2
            JOIN sales_salesorderdetail sod2
                ON sod2.SalesOrderID = soh2.SalesOrderID
            GROUP BY soh2.CustomerID
        ) avg_table
    );

-- 36. Parodykite kiekvieno produkto pavadinimą ir jo bendrą pardavimų sumą (naudoti
-- JOIN su sales_salesorderdetail).

SELECT
    pp.ProductID,
    pp.Name AS produktas,
    ROUND(SUM(sod.LineTotal), 2) AS bendra_pardavimu_suma
FROM production_product pp
JOIN sales_salesorderdetail sod
    ON sod.ProductID = pp.ProductID
GROUP BY
    pp.ProductID,
    pp.Name
ORDER BY
    bendra_pardavimu_suma DESC;
    
-- 37. Naudokite CASE, kad parodytumėte, ar produktas yra 'Pigus', 'Vidutinės kainos', ar
-- 'Brangus' (pagal listprice).

SELECT
    pp.Name AS produktas,
    pp.ListPrice,
    CASE
        WHEN pp.ListPrice < 100 THEN 'Pigus'
        WHEN pp.ListPrice BETWEEN 100 AND 500 THEN 'Vidutinės kainos'
        ELSE 'Brangus'
    END AS kainos_kategorija
FROM production_product pp
ORDER BY
    pp.ListPrice ASC;

-- 38. Išveskite užsakymus, kurių pristatymo kaina didesnė nei 10 % nuo visos užsakymo
-- sumos (CASE ar IF su skaičiavimu).

SELECT
    soh.SalesOrderID,
    soh.TotalDue,
    soh.Freight,
    CASE
        WHEN soh.Freight > 0.10 * soh.TotalDue
            THEN 'Pristatymas > 10%'
        ELSE 'Pristatymas ≤ 10%'
    END AS pristatymo_ivertinimas
FROM sales_salesorderheader soh
WHERE
    soh.Freight > 0.10 * soh.TotalDue;

SELECT
    soh.SalesOrderID,
    soh.TotalDue,
    soh.Freight,
    IF(
        soh.Freight > 0.10 * soh.TotalDue,
        'Pristatymas > 10%',
        'Pristatymas ≤ 10%'
    ) AS pristatymo_ivertinimas
FROM sales_salesorderheader soh
WHERE
    soh.Freight > 0.10 * soh.TotalDue;

-- 39. Raskite klientus, kurie pateikė daugiau nei 5 užsakymus.

SELECT
    soh.CustomerID,
    COUNT(soh.SalesOrderID) AS uzsakymu_sk
FROM sales_salesorderheader soh
GROUP BY
    soh.CustomerID
HAVING
    COUNT(soh.SalesOrderID) > 5;

-- 40. Parodykite visų produktų sąrašą ir pažymėkite, ar jie kada nors buvo parduoti (CASE
-- WHEN EXISTS (...) THEN 'Taip' ELSE 'Ne').

SELECT
    pp.ProductID,
    pp.Name AS produktas,
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM sales_salesorderdetail sod
            WHERE sod.ProductID = pp.ProductID
        )
        THEN 'Taip'
        ELSE 'Ne'
    END AS ar_buvo_parduotas
FROM production_product pp
ORDER BY
    pp.Name;

-- 41. Apskaičiuokite pelną kiekvienam produktui (kaina - standarto kaina), parodykite tik
-- tuos, kurių pelnas > 0.

SELECT
    pp.ProductID,
    pp.Name AS produktas,
    pp.ListPrice,
    pp.StandardCost,
    (pp.ListPrice - pp.StandardCost) AS pelnas
FROM production_product pp
WHERE
    (pp.ListPrice - pp.StandardCost) > 0
ORDER BY
    pelnas DESC;

-- 42. Parodykite klientus, kurie pirko prekes už daugiau nei 1000.

SELECT
    soh.CustomerID,
    SUM(sod.LineTotal) AS bendra_pirkimu_suma
FROM sales_salesorderheader soh
JOIN sales_salesorderdetail sod
    ON sod.SalesOrderID = soh.SalesOrderID
GROUP BY
    soh.CustomerID
HAVING
    SUM(sod.LineTotal) > 1000;

-- 43. Parodykite produktus, kurie yra brangesni nei bet kuris "Helmet" tipo produktas. (su
-- ANY ar subquery)


-- 44. Parodykite kiekvienos produktų subkategorijos pardavimo sumą.


-- 45. Parodykite tik tuos produktus, kurių buvo parduota daugiau nei 100 vienetų.


-- 46. Apskaičiuokite kiek produktų yra kiekvienoje kainos kategorijoje: <100, 100–500,
-- >500.


-- 47. Parodykite darbuotojus, kurie dirba daugiau nei metus, 5 metus ir daugiau nei 10
-- metų (skaičiuoti su DATEDIFF()).


-- 48. Raskite, kurie produktai generavo didžiausią pardavimų pajamų sumą.

