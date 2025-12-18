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