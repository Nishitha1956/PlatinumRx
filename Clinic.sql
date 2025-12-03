DROP DATABASE IF EXISTS clinic_management;
CREATE DATABASE clinic_management;
USE clinic_management; 

-- Clinics table
CREATE TABLE clinics (
    cid VARCHAR(20) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Customer table
CREATE TABLE customer (
    uid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(20)
);

-- Clinic Sales table
CREATE TABLE clinic_sales (
    oid VARCHAR(20) PRIMARY KEY,
    uid VARCHAR(20),
    cid VARCHAR(20),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Expenses table
CREATE TABLE expenses (
    eid VARCHAR(20) PRIMARY KEY,
    cid VARCHAR(20),
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);
SET SQL_SAFE_UPDATES = 0;


-- 1. Clinics
-- --------------------------
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'XYZ Clinic', 'Lorem', 'Ipsum', 'Dolor'),
('cnc-0100002', 'ABC Clinic', 'Sit', 'Amet', 'Consectetur'),
('cnc-0100003', 'PQR Clinic', 'Dolor', 'Ipsum', 'Sit'),
('cnc-0100004', 'LMN Clinic', 'Amet', 'Dolor', 'Ipsum'),
('cnc-0100005', 'OPQ Clinic', 'Sit', 'Ipsum', 'Dolor'),
('cnc-0100006', 'RST Clinic', 'Lorem', 'Amet', 'Consectetur'),
('cnc-0100007', 'UVW Clinic', 'Dolor', 'Consectetur', 'Sit'),
('cnc-0100008', 'DEF Clinic', 'Amet', 'Ipsum', 'Dolor'),
('cnc-0100009', 'GHI Clinic', 'Sit', 'Dolor', 'Ipsum'),
('cnc-0100010', 'JKL Clinic', 'Lorem', 'Ipsum', 'Consectetur');

-- --------------------------
-- 2. Customers
-- --------------------------
INSERT INTO customer (uid, name, mobile) VALUES
('bk-09f3e-95hj', 'Jon Doe', '9712345678'),
('bk-09f3e-95hk', 'Jane Smith', '9723456789'),
('bk-09f3e-95hl', 'Alice Brown', '9734567890'),
('bk-09f3e-95hm', 'Bob Johnson', '9745678901'),
('bk-09f3e-95hn', 'Charlie Lee', '9756789012'),
('bk-09f3e-95ho', 'David Kim', '9767890123'),
('bk-09f3e-95hp', 'Emma Davis', '9778901234'),
('bk-09f3e-95hq', 'Frank Miller', '9789012345'),
('bk-09f3e-95hr', 'Grace Wilson', '9790123456'),
('bk-09f3e-95hs', 'Hannah Moore', '9701234567');

-- --------------------------
-- 3. Clinic Sales
-- --------------------------
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-00100-00100','bk-09f3e-95hj','cnc-0100001',24999,'2021-09-23 12:03:22','Online'),
('ord-00100-00101','bk-09f3e-95hk','cnc-0100002',15000,'2021-09-15 10:20:00','Walk-in'),
('ord-00100-00102','bk-09f3e-95hl','cnc-0100003',18000,'2021-09-20 14:45:30','Online'),
('ord-00100-00103','bk-09f3e-95hm','cnc-0100004',22000,'2021-09-25 16:10:12','Referral'),
('ord-00100-00104','bk-09f3e-95hn','cnc-0100005',17000,'2021-09-18 09:05:00','Online'),
('ord-00100-00105','bk-09f3e-95ho','cnc-0100006',20000,'2021-09-22 11:30:45','Walk-in'),
('ord-00100-00106','bk-09f3e-95hp','cnc-0100007',19000,'2021-09-19 15:25:00','Referral'),
('ord-00100-00107','bk-09f3e-95hq','cnc-0100008',21000,'2021-09-21 13:45:30','Online'),
('ord-00100-00108','bk-09f3e-95hr','cnc-0100009',23000,'2021-09-17 12:15:20','Walk-in'),
('ord-00100-00109','bk-09f3e-95hs','cnc-0100010',25000,'2021-09-24 10:50:10','Online');

-- --------------------------
-- 4. Expenses
-- --------------------------
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-0100-00100','cnc-0100001','First-aid supplies',557,'2021-09-23 07:36:48'),
('exp-0100-00101','cnc-0100002','Equipment maintenance',1200,'2021-09-15 09:00:00'),
('exp-0100-00102','cnc-0100003','Staff salaries',5000,'2021-09-20 08:30:00'),
('exp-0100-00103','cnc-0100004','Utilities',800,'2021-09-25 07:45:12'),
('exp-0100-00104','cnc-0100005','Medical supplies',950,'2021-09-18 08:15:00'),
('exp-0100-00105','cnc-0100006','Rent',1500,'2021-09-22 07:50:45'),
('exp-0100-00106','cnc-0100007','Insurance',700,'2021-09-19 09:20:00'),
('exp-0100-00107','cnc-0100008','Maintenance',650,'2021-09-21 08:10:30'),
('exp-0100-00108','cnc-0100009','Staff salaries',4800,'2021-09-17 07:55:20'),
('exp-0100-00109','cnc-0100010','Medical supplies',900,'2021-09-24 08:05:10');



-- QUERIES SOLVING 

-- 1. Find the revenue we got from each sales channel in a given year 
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel
ORDER BY total_revenue DESC;
 
 
 -- 2. Find top 10 the most valuable customers for a given year
 SELECT 
    c.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM customer c
JOIN clinic_sales cs ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY c.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;

-- 3. Find month wise revenue, expense, profit , status (profitable / not-profitable) for a given Year 
SELECT 
    MONTH(cs.datetime) AS month,
    COALESCE(SUM(cs.amount), 0) AS revenue,
    COALESCE(SUM(e.amount), 0) AS expense,
    COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) AS profit,
    CASE 
        WHEN COALESCE(SUM(cs.amount), 0) - COALESCE(SUM(e.amount), 0) > 0 
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END AS status
FROM clinic_sales cs
LEFT JOIN expenses e 
    ON cs.cid = e.cid 
    AND YEAR(e.datetime) = 2021 
    AND MONTH(e.datetime) = MONTH(cs.datetime)
WHERE YEAR(cs.datetime) = 2021
GROUP BY MONTH(cs.datetime)
ORDER BY month;

 -- 4. For each city find the most profitable clinic for a given month 
WITH clinic_profit AS (
    SELECT 
        cl.cid,
        cl.clinic_name,
        cl.city,
        SUM(cs.amount) AS revenue,
        COALESCE(SUM(e.amount),0) AS expense,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs 
        ON cl.cid = cs.cid AND YEAR(cs.datetime) = 2021 AND MONTH(cs.datetime) = 9
    LEFT JOIN expenses e 
        ON cl.cid = e.cid AND YEAR(e.datetime) = 2021 AND MONTH(e.datetime) = 9
    GROUP BY cl.cid, cl.clinic_name, cl.city
)
SELECT city, clinic_name, profit
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY city ORDER BY profit DESC) AS rn
    FROM clinic_profit
) t
WHERE rn = 1;


-- 5. For each state find the second least profitable clinic for a given month 
WITH clinic_profit AS (
    SELECT 
        cl.cid,
        cl.clinic_name,
        cl.state,
        SUM(cs.amount) AS revenue,
        COALESCE(SUM(e.amount),0) AS expense,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinics cl
    LEFT JOIN clinic_sales cs 
        ON cl.cid = cs.cid AND YEAR(cs.datetime) = 2021 AND MONTH(cs.datetime) = 9
    LEFT JOIN expenses e 
        ON cl.cid = e.cid AND YEAR(e.datetime) = 2021 AND MONTH(e.datetime) = 9
    GROUP BY cl.cid, cl.clinic_name, cl.state
)
SELECT state, clinic_name, profit
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY profit ASC) AS rn
    FROM clinic_profit
) t
WHERE rn = 2;
