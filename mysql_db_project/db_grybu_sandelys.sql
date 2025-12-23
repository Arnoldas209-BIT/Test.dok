CREATE DATABASE IF NOT EXISTS grybu_sandelio_valdymas;
USE grybu_sandelio_valdymas;

/*Verslo problema
Įmonė gamina produkciją, laiko ją sandėlyje ir vykdo klientų užsakymus. 
Reikia:
matyti ką pagaminom (partijom),
kiek turim sandėlyje (likučiai pagal partiją),
ką užsakė klientai ir už kokią sumą,
turėti galimybę greitai daryti ataskaitas (TOP klientai, mėnesio apyvarta, likučiai, užsakymų kiekiai).*/

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory;		-- senus duomenys pasalinau 
DROP TABLE IF EXISTS batches;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  city VARCHAR(60),
  country VARCHAR(50) DEFAULT 'LT',
  network VARCHAR(30) 
);

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  species VARCHAR(60) NOT NULL,         
  champignon_class VARCHAR(10),         
  display_name VARCHAR(120) NOT NULL,   
  unit VARCHAR(20) DEFAULT 'kg',
  default_price DECIMAL(10,2) NOT NULL  
);

CREATE TABLE batches (
  batch_id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  harvest_date DATE NOT NULL,
  shelf_life_days INT,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE inventory (
  inventory_id INT AUTO_INCREMENT PRIMARY KEY,
  batch_id INT NOT NULL,
  location VARCHAR(50),
  quantity_kg DECIMAL(10,2) NOT NULL,
  last_movement_date DATE,
  FOREIGN KEY (batch_id) REFERENCES batches(batch_id)
);

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  order_date DATE NOT NULL,
  status VARCHAR(20) DEFAULT 'Confirmed',
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity_kg DECIMAL(10,2) NOT NULL,
  price_per_kg DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE inventory;		-- senus duomenis pasalinau 
TRUNCATE TABLE batches;
TRUNCATE TABLE products;
TRUNCATE TABLE customers;

INSERT INTO customers (name, city, network) VALUES
('NORFA - Vilnius (Ukmergės g.)', 'Vilnius', 'Norfa'),
('NORFA - Kaunas (Savanorių pr.)', 'Kaunas', 'Norfa'),
('NORFA - Klaipėda (Taikos pr.)', 'Klaipėda', 'Norfa'),
('NORFA - Šiauliai (Tilžės g.)', 'Šiauliai', 'Norfa'),
('NORFA - Panevėžys (J. Basanavičiaus g.)', 'Panevėžys', 'Norfa'),

('AIBĖ - Panevėžys (centras)', 'Panevėžys', 'Aibė'),
('AIBĖ - Kaunas (Šilainiai)', 'Kaunas', 'Aibė'),
('AIBĖ - Vilnius (Pilaitė)', 'Vilnius', 'Aibė'),
('AIBĖ - Klaipėda (Pietinis)', 'Klaipėda', 'Aibė'),

('HoReCa klientas', 'Kaunas', 'Kita');

INSERT INTO customers (name, city, network) VALUES
('IKI - Vilnius (Ozo g.)', 'Vilnius', 'IKI'),
('IKI - Kaunas (Savanorių pr.)', 'Kaunas', 'IKI'),
('IKI - Panevėžys (centras)', 'Panevėžys', 'IKI'),

('Maxima - Vilnius (Akropolis)', 'Vilnius', 'Maxima'),
('Maxima - Kaunas (Mega)', 'Kaunas', 'Maxima'),
('Maxima - Klaipėda (Akropolis)', 'Klaipėda', 'Maxima'),
('Maxima - Panevėžys (centras)', 'Panevėžys', 'Maxima');

INSERT INTO products (species, champignon_class, display_name, unit, default_price) VALUES
-- Balti šampinjonai (4 klasės)
('Balti šampinjonai', 'Extra', 'Balti šampinjonai - Extra klasė', 'kg', 2.80),
('Balti šampinjonai', 'I',     'Balti šampinjonai - I klasė',     'kg', 2.40),
('Balti šampinjonai', 'II',    'Balti šampinjonai - II klasė',    'kg', 2.00),
('Balti šampinjonai', 'III',   'Balti šampinjonai - III klasė',   'kg', 1.60),

-- Rudi šampinjonai (4 klasės)
('Rudi šampinjonai', 'Extra', 'Rudi šampinjonai - Extra klasė', 'kg', 3.20),
('Rudi šampinjonai', 'I',     'Rudi šampinjonai - I klasė',     'kg', 2.80),
('Rudi šampinjonai', 'II',    'Rudi šampinjonai - II klasė',    'kg', 2.40),
('Rudi šampinjonai', 'III',   'Rudi šampinjonai - III klasė',   'kg', 2.00),

-- Portobello (pagal save)
('Portobello', NULL, 'Portobello', 'kg', 4.50),

-- Kiti grybai (pagal tavo kainas)
('Eryngii (stepių baravykai)', NULL, 'Eryngii (stepių baravykai)', 'kg', 15.00),
('Šiitake', NULL, 'Šiitake', 'kg', 12.00),
('Kreivabudės', NULL, 'Kreivabudės', 'kg', 10.00);

INSERT INTO batches (product_id, harvest_date, shelf_life_days) VALUES
(1, '2025-12-16', 7),  
(2, '2025-12-16', 7), 
(5, '2025-12-16', 7),  
(9, '2025-12-16', 6),  
(10,'2025-12-16', 5),  
(11,'2025-12-16', 6), 
(12,'2025-12-16', 6);  

INSERT INTO inventory (batch_id, location, quantity_kg, last_movement_date) VALUES
(1, 'S1-R1', 600.00, '2025-12-17'),
(2, 'S1-R2', 500.00, '2025-12-17'),
(3, 'S1-R3', 250.00, '2025-12-17'),
(4, 'S2-R1', 180.00, '2025-12-17'),
(5, 'S3-R1', 90.00,  '2025-12-17'),
(6, 'S3-R2', 110.00, '2025-12-17'),
(7, 'S3-R3', 95.00,  '2025-12-17');

INSERT INTO orders (customer_id, order_date, status) VALUES
(5, '2025-12-17', 'Confirmed'),  
(6, '2025-12-17', 'Confirmed'),  
(2, '2025-12-17', 'Confirmed'),  
(10,'2025-12-17', 'Confirmed');  

INSERT INTO orders (customer_id, order_date, status) VALUES
(1,  '2025-12-15', 'Confirmed'),
(6,  '2025-12-15', 'Confirmed'),
(11, '2025-12-16', 'Confirmed'),
(14, '2025-12-16', 'Confirmed'),
(12, '2025-12-17', 'Confirmed'),
(15, '2025-12-18', 'Confirmed');

INSERT INTO order_items (order_id, product_id, quantity_kg, price_per_kg) VALUES
-- order 1: Norfa Panevėžys
(1, 2, 220, 2.40),  
(1, 9,  40, 4.50),   

-- order 2: Aibė Panevėžys
(2, 4,  120, 1.60),  
(2, 6,  80,  2.80),  

-- order 3: Norfa Kaunas
(3, 1,  180, 2.80),  
(3, 5,  70,  3.20), 

-- order 4: HoReCa
(4, 10, 20, 15.00), 
(4, 11, 25, 12.00),  
(4, 12, 15, 10.00);

INSERT INTO order_items (order_id, product_id, quantity_kg, price_per_kg) VALUES
(5,  2, 180, 2.40),
(5,  9,  25, 4.50),

(6,  4, 120, 1.60),
(6, 11,  10, 12.00),

(7,  1, 200, 2.80),
(7, 10,  12, 15.00),

(8,  6,  90, 2.80),
(8, 12,  15, 10.00),

(9,  5,  60, 3.20),
(9,  9,  20, 4.50),

(10, 2, 140, 2.40),
(10, 11, 18, 12.00);

CREATE TABLE suppliers (
  supplier_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  country VARCHAR(50) NOT NULL DEFAULT 'PL',
  contact_email VARCHAR(120),
  is_active TINYINT NOT NULL DEFAULT 1,
  UNIQUE (name, country)
);

CREATE TABLE batch_sources (
  batch_id INT PRIMARY KEY,
  source_type VARCHAR(10) NOT NULL,   -- 'Internal' arba 'Supplier'
  supplier_id INT NULL,
  purchase_ref VARCHAR(50),           -- pvz. PO numeris / sąskaita / krovinio nr.
  FOREIGN KEY (batch_id) REFERENCES batches(batch_id),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE batch_quality_actions (
  action_id INT AUTO_INCREMENT PRIMARY KEY,
  batch_id INT NOT NULL,
  action_date DATE NOT NULL,
  issue VARCHAR(120) NOT NULL,        
  decision VARCHAR(12) NOT NULL,     
  downgraded_to_product_id INT NULL,  -- į kokį produktą perkelta (pvz. Extra -> I)
  discount_percent DECIMAL(5,2) NULL, -- pvz. 10.00
  final_price_per_kg DECIMAL(10,2) NULL,
  rejected_qty_kg DECIMAL(10,2) NULL,
  notes VARCHAR(255),

  FOREIGN KEY (batch_id) REFERENCES batches(batch_id),
  FOREIGN KEY (downgraded_to_product_id) REFERENCES products(product_id)
);

INSERT INTO suppliers (name, country, contact_email, is_active) VALUES
('PL Mushrooms Sp. z o.o.', 'PL', 'sales@plmushrooms.pl', 1),
('Mazovia Fresh Export',     'PL', 'export@mazoviafresh.pl', 1),
('Wroclaw Agro Trade',       'PL', 'info@wat.pl', 1),
('Baltic Import Partner',    'LT', 'pirkimai@balticimport.lt', 1),
('Silesia Farms',            'PL', 'quality@silesiafarms.pl', 1);

INSERT INTO batch_sources (batch_id, source_type, supplier_id, purchase_ref) VALUES
(1, 'Internal', NULL, NULL),
(2, 'Internal', NULL, NULL),
(3, 'Supplier', 1, 'PO-2025-12-1601'),
(4, 'Internal', NULL, NULL),
(5, 'Supplier', 2, 'PO-2025-12-1602'),
(6, 'Supplier', 5, 'PO-2025-12-1603'),
(7, 'Internal', NULL, NULL);

INSERT INTO batch_quality_actions
(batch_id, action_date, issue, decision, downgraded_to_product_id, discount_percent, final_price_per_kg, rejected_qty_kg, notes)
VALUES
-- 1) Sava gamyba: viskas ok
(1, '2025-12-17', 'Standartinė kokybė', 'Accepted', NULL, NULL, NULL, NULL, 'Priimta be pastabų'),

-- 2) Sava gamyba: Extra nurūšiuota į I klasę (pvz. dėl dydžio/defektų)
(2, '2025-12-17', 'Netolygus dydis, dalis pažeidimų', 'Downgraded', 2, NULL, NULL, NULL, 'Nurūšiuota į Balti I'),

-- 3) Pirkta: derybos dėl kainos (nuolaida) – priimta su korekcija
(3, '2025-12-17', 'Per didelė drėgmė, trumpesnis galiojimas', 'Accepted', NULL, 8.00, 2.30, NULL, 'Suderėta 8% nuolaida'),

-- 4) Sava gamyba: dalinis atmetimas (pvz. brokas)
(4, '2025-12-17', 'Mechaniniai pažeidimai', 'Rejected', NULL, NULL, NULL, 40.00, '40 kg atmesta, likusi dalis tinkama'),

-- 5) Pirkta: nurūšiavimas + kainos korekcija
(5, '2025-12-17', 'Pažeista pakuotė, vizualiniai defektai', 'Downgraded', 8, 12.00, 2.10, NULL, 'Nurūšiuota į Rudi III, 12% nuolaida'),

-- 6) Pirkta: atmetimas didesnės dalies
(6, '2025-12-17', 'Kvapas / fermentacijos požymiai', 'Rejected', NULL, NULL, NULL, 70.00, '70 kg atmesta, informuotas tiekėjas'),

-- 7) Sava gamyba: priimta, bet su pastaba (be kainos korekcijos)
(7, '2025-12-17', 'Smulkesnė frakcija', 'Accepted', NULL, NULL, NULL, NULL, 'Priimta, rekomenduota greitesnė realizacija');

CREATE TABLE quality_issues (
  issue_id INT AUTO_INCREMENT PRIMARY KEY,
  issue_name VARCHAR(80) NOT NULL UNIQUE
);

INSERT INTO quality_issues (issue_name) VALUES
('Per lengvi grybai'),
('Per sunkūs grybai'),
('Pažeisti'),
('Užkrėsti'),
('Juoduojantys'),
('Atsivėrę'),
('Silpni grybai');

ALTER TABLE batch_quality_actions
  ADD COLUMN issue_id INT NULL,
  ADD CONSTRAINT fk_bqa_issue
    FOREIGN KEY (issue_id) REFERENCES quality_issues(issue_id);
    
    CREATE TABLE employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(120) UNIQUE,
  hire_date DATE NOT NULL,
  is_active TINYINT NOT NULL DEFAULT 1
);

INSERT INTO employees (first_name, last_name, phone, email, hire_date) VALUES
('Jonas', 'Petrauskas', '+37060000001', 'jonas@company.lt', '2022-01-10'),
('Marius', 'Kazlauskas', '+37060000002', 'marius@company.lt', '2021-06-05'),
('Tomas', 'Jankauskas', '+37060000003', 'tomas@company.lt', '2023-02-01'),
('Darius', 'Vaitkus', '+37060000004', 'darius@company.lt', '2020-09-15'),
('Andrius', 'Mockus', '+37060000005', 'andrius@company.lt', '2019-11-20');

CREATE TABLE departments (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO departments (name) VALUES
('Komercija'),
('Gamyba'),
('Sandėlis'),
('Plovykla'),
('Logistika');

CREATE TABLE employee_departments (
  employee_id INT NOT NULL,
  department_id INT NOT NULL,
  role VARCHAR(50) NOT NULL,
  PRIMARY KEY (employee_id, department_id),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employee_departments VALUES
(1, 1, 'Meistras'),
(1, 3, 'Meistras'),
(2, 2, 'Meistras'),
(3, 3, 'Komplektuotojas'),
(4, 4, 'Plovyklos operatorius'),
(5, 5, 'Logistikos koordinatorius');

CREATE TABLE employee_addresses (
  address_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  city VARCHAR(50),
  street VARCHAR(100),
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO employee_addresses (employee_id, city, street) VALUES
(1, 'Panevėžys', 'Vilniaus g. 10'),
(2, 'Panevėžys', 'Parko g. 5'),
(3, 'Panevėžys', 'Sodų g. 22'),
(4, 'Panevėžys', 'Laisvės a. 3'),
(5, 'Panevėžys', 'Statybininkų g. 8');

CREATE TABLE kpi_types (
  kpi_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  unit VARCHAR(20)
);

INSERT INTO kpi_types (name, unit) VALUES
('Sukomplektuotas kiekis', 'kg'),
('Broko kiekis', 'kg'),
('Laiku įvykdyti užsakymai', '%'),
('Pamainos našumas', 'kg/h');

CREATE TABLE employee_kpi_results (
  result_id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  kpi_id INT NOT NULL,
  period_month DATE NOT NULL,
  value DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
  FOREIGN KEY (kpi_id) REFERENCES kpi_types(kpi_id)
);

INSERT INTO employee_kpi_results
(employee_id, kpi_id, period_month, value) VALUES
(1, 1, '2025-12-01', 42000),
(1, 3, '2025-12-01', 98),
(2, 1, '2025-12-01', 38000),
(2, 2, '2025-12-01', 520),
(3, 1, '2025-12-01', 30000),
(4, 2, '2025-12-01', 150),
(5, 4, '2025-12-01', 820);

INSERT INTO employee_departments VALUES
(2, 2, 'Gamybos operatorius'),
(3, 2, 'Gamybos operatorius');

INSERT INTO employee_departments VALUES
(3, 3, 'Sandėlio operatorius'),
(4, 3, 'Sandėlio operatorius');

INSERT INTO employee_departments VALUES
(5, 2, 'Fasavimo operatorius');

INSERT INTO employee_departments VALUES
(1, 1, 'Plant Manager');

UPDATE employee_departments
SET role = 'Plant Manager'
WHERE employee_id = 1 AND department_id = 1;

INSERT INTO employees (first_name, last_name, phone, email, hire_date) VALUES
('Rasa', 'Kairytė', '+37060000006', 'rasa@company.lt', '2022-05-10'),
('Paulius', 'Šimkus', '+37060000007', 'paulius@company.lt', '2021-10-01'),
('Inga', 'Petkevičienė', '+37060000008', 'inga@company.lt', '2023-03-15'),
('Mindaugas', 'Brazaitis', '+37060000009', 'mindaugas@company.lt', '2020-02-20'),
('Eglė', 'Stonienė', '+37060000010', 'egle@company.lt', '2024-01-08'),
('Saulius', 'Rimkus', '+37060000011', 'saulius@company.lt', '2022-11-12'),
('Giedrė', 'Vaitkevičiūtė', '+37060000012', 'giedre@company.lt', '2021-04-18'),
('Vytautas', 'Gricius', '+37060000013', 'vytautas@company.lt', '2019-07-01'),
('Karolis', 'Jasaitis', '+37060000014', 'karolis@company.lt', '2023-09-05'),
('Monika', 'Bielskė', '+37060000015', 'monika@company.lt', '2022-08-22');

INSERT INTO employee_departments (employee_id, department_id, role)
SELECT e.employee_id, d.department_id, x.role
FROM (
  SELECT 'Rasa' first_name, 'Kairytė' last_name, 'Gamybos operatorius' role, 'Gamyba' dept UNION ALL
  SELECT 'Paulius', 'Šimkus', 'Sandėlio operatorius', 'Sandėlis' UNION ALL
  SELECT 'Inga', 'Petkevičienė', 'Kokybės kontrolierė', 'Gamyba' UNION ALL
  SELECT 'Mindaugas', 'Brazaitis', 'Komplektuotojas', 'Sandėlis' UNION ALL
  SELECT 'Eglė', 'Stonienė', 'Plovyklos operatorė', 'Plovykla' UNION ALL
  SELECT 'Saulius', 'Rimkus', 'Fasavimo operatorius', 'Gamyba' UNION ALL
  SELECT 'Giedrė', 'Vaitkevičiūtė', 'Logistikos koordinatorė', 'Logistika' UNION ALL
  SELECT 'Vytautas', 'Gricius', 'Sandėlio operatorius', 'Sandėlis' UNION ALL
  SELECT 'Karolis', 'Jasaitis', 'Gamybos operatorius', 'Gamyba' UNION ALL
  SELECT 'Monika', 'Bielskė', 'Komercijos operatorė', 'Komercija'
) x
JOIN employees e ON e.first_name = x.first_name AND e.last_name = x.last_name
JOIN departments d ON d.name = x.dept;

INSERT INTO employee_addresses (employee_id, city, street)
SELECT e.employee_id, 'Panevėžys', x.street
FROM (
  SELECT 'Rasa' first_name, 'Kairytė' last_name, 'Alyvų g. 7' street UNION ALL
  SELECT 'Paulius','Šimkus','Žemaičių g. 14' UNION ALL
  SELECT 'Inga','Petkevičienė','Nemuno g. 3' UNION ALL
  SELECT 'Mindaugas','Brazaitis','S. Kerbedžio g. 21' UNION ALL
  SELECT 'Eglė','Stonienė','Ramygalos g. 9' UNION ALL
  SELECT 'Saulius','Rimkus','Pušaloto g. 5' UNION ALL
  SELECT 'Giedrė','Vaitkevičiūtė','Dariaus ir Girėno g. 18' UNION ALL
  SELECT 'Vytautas','Gricius','Parko g. 11' UNION ALL
  SELECT 'Karolis','Jasaitis','Tulpių g. 2' UNION ALL
  SELECT 'Monika','Bielskė','Smėlynės g. 30'
) x
JOIN employees e ON e.first_name=x.first_name AND e.last_name=x.last_name;

INSERT INTO employee_kpi_results (employee_id, kpi_id, period_month, value)
SELECT e.employee_id, k.kpi_id, '2025-12-01', x.val
FROM (
  SELECT 'Paulius' first_name, 'Šimkus' last_name, 'Sukomplektuotas kiekis' kpi, 34000 val UNION ALL
  SELECT 'Mindaugas','Brazaitis','Sukomplektuotas kiekis', 36000 UNION ALL
  SELECT 'Inga','Petkevičienė','Broko kiekis', 210 UNION ALL
  SELECT 'Saulius','Rimkus','Pamainos našumas', 900 UNION ALL
  SELECT 'Vytautas','Gricius','Sukomplektuotas kiekis', 31000
) x
JOIN employees e ON e.first_name=x.first_name AND e.last_name=x.last_name
JOIN kpi_types k ON k.name=x.kpi;

INSERT INTO batches (product_id, harvest_date, shelf_life_days)
SELECT p.product_id, x.harvest_date, x.shelf_life
FROM (
  SELECT 'Balti šampinjonai - Extra klasė' display_name, '2025-12-18' harvest_date, 7 shelf_life UNION ALL
  SELECT 'Balti šampinjonai - I klasė',     '2025-12-18', 7 UNION ALL
  SELECT 'Balti šampinjonai - II klasė',    '2025-12-18', 7 UNION ALL
  SELECT 'Rudi šampinjonai - Extra klasė',  '2025-12-18', 7 UNION ALL
  SELECT 'Rudi šampinjonai - I klasė',      '2025-12-19', 7 UNION ALL
  SELECT 'Portobello',                      '2025-12-19', 6 UNION ALL
  SELECT 'Eryngii (stepių baravykai)',      '2025-12-19', 5 UNION ALL
  SELECT 'Šiitake',                         '2025-12-19', 6 UNION ALL
  SELECT 'Kreivabudės',                     '2025-12-19', 6 UNION ALL
  SELECT 'Balti šampinjonai - III klasė',   '2025-12-19', 7
) x
JOIN products p ON p.display_name = x.display_name;

INSERT INTO inventory (batch_id, location, quantity_kg, last_movement_date)
SELECT b.batch_id, x.location, x.qty, x.mov_date
FROM (
  SELECT 'Balti šampinjonai - Extra klasė' display_name, '2025-12-18' harvest_date, 'S1-R4' location, 650.00 qty, '2025-12-19' mov_date UNION ALL
  SELECT 'Balti šampinjonai - I klasė',     '2025-12-18', 'S1-R5', 540.00, '2025-12-19' UNION ALL
  SELECT 'Balti šampinjonai - II klasė',    '2025-12-18', 'S1-R6', 420.00, '2025-12-19' UNION ALL
  SELECT 'Rudi šampinjonai - Extra klasė',  '2025-12-18', 'S2-R2', 260.00, '2025-12-19' UNION ALL
  SELECT 'Rudi šampinjonai - I klasė',      '2025-12-19', 'S2-R3', 220.00, '2025-12-19' UNION ALL
  SELECT 'Portobello',                      '2025-12-19', 'S2-R4', 160.00, '2025-12-19' UNION ALL
  SELECT 'Eryngii (stepių baravykai)',      '2025-12-19', 'S3-R4', 80.00,  '2025-12-19' UNION ALL
  SELECT 'Šiitake',                         '2025-12-19', 'S3-R5', 95.00,  '2025-12-19' UNION ALL
  SELECT 'Kreivabudės',                     '2025-12-19', 'S3-R6', 70.00,  '2025-12-19' UNION ALL
  SELECT 'Balti šampinjonai - III klasė',   '2025-12-19', 'S1-R7', 300.00, '2025-12-19'
) x
JOIN products p ON p.display_name = x.display_name
JOIN batches b ON b.product_id = p.product_id AND b.harvest_date = x.harvest_date;

INSERT INTO orders (customer_id, order_date, status)
SELECT c.customer_id, x.order_date, x.status
FROM (
  SELECT 'NORFA - Vilnius (Ukmergės g.)' cust, '2025-12-19' order_date, 'Confirmed' status UNION ALL
  SELECT 'NORFA - Klaipėda (Taikos pr.)',      '2025-12-19', 'Confirmed' UNION ALL
  SELECT 'AIBĖ - Vilnius (Pilaitė)',           '2025-12-19', 'Confirmed' UNION ALL
  SELECT 'IKI - Vilnius (Ozo g.)',             '2025-12-20', 'Confirmed' UNION ALL
  SELECT 'IKI - Kaunas (Savanorių pr.)',       '2025-12-20', 'Confirmed' UNION ALL
  SELECT 'Maxima - Vilnius (Akropolis)',       '2025-12-20', 'Confirmed' UNION ALL
  SELECT 'Maxima - Kaunas (Mega)',             '2025-12-20', 'Confirmed' UNION ALL
  SELECT 'NORFA - Šiauliai (Tilžės g.)',       '2025-12-21', 'Confirmed' UNION ALL
  SELECT 'AIBĖ - Kaunas (Šilainiai)',          '2025-12-21', 'Confirmed' UNION ALL
  SELECT 'IKI - Panevėžys (centras)',          '2025-12-21', 'Confirmed' UNION ALL
  SELECT 'Maxima - Panevėžys (centras)',       '2025-12-21', 'Confirmed' UNION ALL
  SELECT 'HoReCa klientas',                    '2025-12-21', 'Confirmed'
) x
JOIN customers c ON c.name = x.cust;

INSERT INTO order_items (order_id, product_id, quantity_kg, price_per_kg)
SELECT o.order_id, p.product_id, x.qty, x.price
FROM (
  SELECT 'NORFA - Vilnius (Ukmergės g.)' cust, '2025-12-19' d, 'Balti šampinjonai - I klasė' prod, 260 qty, 2.40 price UNION ALL
  SELECT 'NORFA - Vilnius (Ukmergės g.)',      '2025-12-19', 'Portobello', 35, 4.50 UNION ALL

  SELECT 'NORFA - Klaipėda (Taikos pr.)',      '2025-12-19', 'Balti šampinjonai - Extra klasė', 220, 2.80 UNION ALL
  SELECT 'NORFA - Klaipėda (Taikos pr.)',      '2025-12-19', 'Rudi šampinjonai - I klasė', 90, 2.80 UNION ALL

  SELECT 'AIBĖ - Vilnius (Pilaitė)',           '2025-12-19', 'Balti šampinjonai - III klasė', 180, 1.60 UNION ALL
  SELECT 'AIBĖ - Vilnius (Pilaitė)',           '2025-12-19', 'Kreivabudės', 12, 10.00 UNION ALL

  SELECT 'IKI - Vilnius (Ozo g.)',             '2025-12-20', 'Balti šampinjonai - II klasė', 240, 2.00 UNION ALL
  SELECT 'IKI - Vilnius (Ozo g.)',             '2025-12-20', 'Šiitake', 10, 12.00 UNION ALL

  SELECT 'IKI - Kaunas (Savanorių pr.)',       '2025-12-20', 'Rudi šampinjonai - Extra klasė', 120, 3.20 UNION ALL
  SELECT 'IKI - Kaunas (Savanorių pr.)',       '2025-12-20', 'Portobello', 25, 4.50 UNION ALL

  SELECT 'Maxima - Vilnius (Akropolis)',       '2025-12-20', 'Balti šampinjonai - I klasė', 300, 2.35 UNION ALL
  SELECT 'Maxima - Vilnius (Akropolis)',       '2025-12-20', 'Rudi šampinjonai - II klasė', 110, 2.40 UNION ALL

  SELECT 'Maxima - Kaunas (Mega)',             '2025-12-20', 'Balti šampinjonai - Extra klasė', 260, 2.75 UNION ALL
  SELECT 'Maxima - Kaunas (Mega)',             '2025-12-20', 'Eryngii (stepių baravykai)', 8, 15.00 UNION ALL

  SELECT 'NORFA - Šiauliai (Tilžės g.)',       '2025-12-21', 'Balti šampinjonai - II klasė', 280, 2.00 UNION ALL
  SELECT 'NORFA - Šiauliai (Tilžės g.)',       '2025-12-21', 'Rudi šampinjonai - III klasė', 140, 2.00 UNION ALL

  SELECT 'AIBĖ - Kaunas (Šilainiai)',          '2025-12-21', 'Balti šampinjonai - III klasė', 200, 1.60 UNION ALL
  SELECT 'AIBĖ - Kaunas (Šilainiai)',          '2025-12-21', 'Šiitake', 6, 12.00 UNION ALL

  SELECT 'IKI - Panevėžys (centras)',          '2025-12-21', 'Balti šampinjonai - I klasė', 240, 2.40 UNION ALL
  SELECT 'IKI - Panevėžys (centras)',          '2025-12-21', 'Portobello', 30, 4.50 UNION ALL

  SELECT 'Maxima - Panevėžys (centras)',       '2025-12-21', 'Rudi šampinjonai - I klasė', 130, 2.80 UNION ALL
  SELECT 'Maxima - Panevėžys (centras)',       '2025-12-21', 'Kreivabudės', 10, 10.00 UNION ALL

  SELECT 'HoReCa klientas',                    '2025-12-21', 'Eryngii (stepių baravykai)', 15, 15.00 UNION ALL
  SELECT 'HoReCa klientas',                    '2025-12-21', 'Šiitake', 18, 12.00
) x
JOIN customers c ON c.name = x.cust
JOIN orders o ON o.customer_id = c.customer_id AND o.order_date = x.d
JOIN products p ON p.display_name = x.prod;

INSERT INTO batch_sources (batch_id, source_type, supplier_id, purchase_ref)
SELECT b.batch_id,
       x.source_type,
       s.supplier_id,
       x.purchase_ref
FROM (
  SELECT 'Eryngii (stepių baravykai)' prod, '2025-12-19' d, 'Supplier' source_type, 'PL Mushrooms Sp. z o.o.' supp, 'PO-2025-12-1901' purchase_ref UNION ALL
  SELECT 'Šiitake',                  '2025-12-19', 'Supplier', 'Mazovia Fresh Export', 'PO-2025-12-1902' UNION ALL
  SELECT 'Kreivabudės',              '2025-12-19', 'Supplier', 'Silesia Farms', 'PO-2025-12-1903' UNION ALL
  SELECT 'Portobello',               '2025-12-19', 'Internal', NULL, NULL UNION ALL
  SELECT 'Balti šampinjonai - Extra klasė','2025-12-18','Internal', NULL, NULL
) x
JOIN products p ON p.display_name = x.prod
JOIN batches b ON b.product_id = p.product_id AND b.harvest_date = x.d
LEFT JOIN suppliers s ON s.name = x.supp;

INSERT INTO batch_quality_actions
(batch_id, action_date, issue, decision, downgraded_to_product_id, discount_percent, final_price_per_kg, rejected_qty_kg, notes, issue_id)
SELECT b.batch_id, x.action_date, x.issue_text, x.decision,
       p2.product_id, x.discount, x.final_price, x.rej_qty, x.notes, qi.issue_id
FROM (
  -- Eryngii: per lengvi -> derybos (nuolaida)
  SELECT 'Eryngii (stepių baravykai)' prod, '2025-12-19' d, '2025-12-20' action_date,
         'Per lengvi grybai' issue_name, 'Accepted' decision,
         NULL downgrade_to, 7.00 discount, 13.95 final_price, NULL rej_qty,
         'Suderėta nuolaida dėl svorio' notes,
         'Per lengvi grybai' issue_text
  UNION ALL
  -- Balti Extra: pažeisti -> nurūšiuoti į I klasę
  SELECT 'Balti šampinjonai - Extra klasė', '2025-12-18', '2025-12-19',
         'Pažeisti', 'Downgraded', 'Balti šampinjonai - I klasė', NULL, NULL, NULL,
         'Nurūšiuota į I klasę', 'Pažeisti'
  UNION ALL
  -- Šiitake: užkrėsti -> atmesta dalis
  SELECT 'Šiitake', '2025-12-19', '2025-12-20',
         'Užkrėsti', 'Rejected', NULL, NULL, NULL, 12.00,
         'Dalinis atmetimas, informuotas tiekėjas', 'Užkrėsti'
) x
JOIN products p ON p.display_name = x.prod
JOIN batches b ON b.product_id = p.product_id AND b.harvest_date = x.d
LEFT JOIN products p2 ON p2.display_name = x.downgrade_to
LEFT JOIN quality_issues qi ON qi.issue_name = x.issue_name;

