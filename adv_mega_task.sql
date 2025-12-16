-- Užduotis 3: Produktų kategorijų pelningumo analizė per laiką, teritorijose ir pardavimo
-- kanaluose
-- Naudok Production_Product, Production_ProductSubcategory, Production_ProductCategory,
-- Sales_SalesOrderDetail, Sales_SalesTerritory ir Sales_SalesOrderHeader lenteles.

-- 1. Susiek produktus su jų subkategorijomis, kategorijomis, teritorijomis ir pardavimo
-- kanalais.
SELECT
	pp.ProductID,
	pp.Name AS produktas,
    ps.ProductSubcategoryID,
    ps.Name AS sub_kategorija,
    pc.ProductCategoryID,
	pc.Name AS kategorija,
	st.Name AS teritorija,
    ss.SalesOrderID,
    soh.Status,
    soh.OnlineOrderFlag
FROM 
	production_product pp
	JOIN production_productsubcategory ps ON ps.ProductSubcategoryID = pp.ProductSubcategoryID
	JOIN production_productcategory pc ON ps.ProductCategoryID = pc.ProductCategoryID
    JOIN sales_salesorderdetail ss ON pp.ProductID = ss.ProductID
    JOIN sales_salesorderheader soh ON ss.SalesOrderID = soh.SalesOrderID
    JOIN sales_salesterritory st ON st.TerritoryID = soh.TerritoryID;
    
-- 2. Apskaičiuok bendras pajamas bei runningtotal kiekvienai kategorijai pagal metus ir
-- ketvirčius.

-- 3. Naudok CASE, kad kategorijas suskirstytum į „High Profit“ ir „Low Profit“.

-- 4. Naudok procentinį skaičiavimą, kad parodytum, kiek kiekviena kategorija sudaro bendrų
-- pajamų.

-- 5. Panaudok RANK ir DENSE_RANK funkciją, kad išreitinguotum kategorijas pagal
-- pelningumą teritorijose ir kanaluose. Įtrauk tendencijų analizę, ar kategorijos pajamos
-- auga, mažėja ar lieka stabilios laikui bėgant.