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



