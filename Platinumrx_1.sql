
DROP DATABASE IF EXISTS platinumrxdb;
-- step 1
CREATE DATABASE platinumrxdb;
-- step 2
USE platinumrxdb;

-- Step 3: Create tables
-- --------------------------

CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255),
    phone_number VARCHAR(20),
    mail_id VARCHAR(255),
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no VARCHAR(50),
    user_id VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(255),
    item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
    id VARCHAR(50) PRIMARY KEY,
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATETIME,
    item_id VARCHAR(50),
    item_quantity DECIMAL(10,3),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id) REFERENCES items(item_id)
);

-- Step 4: Insert sample data
-- --------------------------

-- Users
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('USR001','John Doe','9712345678','john.doe@example.com','XX, Street Y, ABC City'),
('USR002','Jane Smith','9723456789','jane.smith@example.com','YY, Street Z, DEF City'),
('USR003','Alice Brown','9734567890','alice.brown@example.com','ZZ, Street X, GHI City'),
('USR004','Bob Johnson','9745678901','bob.johnson@example.com','AA, Street W, JKL City'),
('USR005','Charlie Lee','9756789012','charlie.lee@example.com','BB, Street V, MNO City'),
('USR006','David Kim','9767890123','david.kim@example.com','CC, Street U, PQR City'),
('USR007','Emma Davis','9778901234','emma.davis@example.com','DD, Street T, STU City'),
('USR008','Frank Miller','9789012345','frank.miller@example.com','EE, Street S, VWX City'),
('USR009','Grace Wilson','9790123456','grace.wilson@example.com','FF, Street R, YZA City'),
('USR010','Hannah Moore','9701234567','hannah.moore@example.com','GG, Street Q, BCD City');

-- Bookings
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('BKG001','2021-09-23 07:36:48','RM101','USR001'),
('BKG002','2021-10-05 12:03:22','RM102','USR002'),
('BKG003','2021-10-15 09:15:00','RM103','USR003'),
('BKG004','2021-11-01 18:20:00','RM104','USR004'),
('BKG005','2021-11-05 14:55:00','RM105','USR005'),
('BKG006','2021-11-12 11:10:00','RM106','USR006'),
('BKG007','2021-11-18 16:40:00','RM107','USR007'),
('BKG008','2021-12-02 19:30:00','RM108','USR008'),
('BKG009','2021-12-15 08:50:00','RM109','USR009'),
('BKG010','2021-12-20 20:15:00','RM110','USR010');

-- Items
INSERT INTO items (item_id, item_name, item_rate) VALUES
('ITM001','Tawa Paratha',18.00),
('ITM002','Mix Veg',89.00),
('ITM003','Paneer Butter Masala',150.00),
('ITM004','Dal Makhani',120.00),
('ITM005','Fried Rice',100.00),
('ITM006','Chicken Curry',200.00),
('ITM007','Mutton Biryani',250.00),
('ITM008','Masala Dosa',50.00),
('ITM009','Idli Sambhar',40.00),
('ITM010','Pasta',180.00);

-- Booking Commercials
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
('BC001','BKG001','BL001','2021-09-23 12:03:22','ITM001',3),
('BC002','BKG001','BL001','2021-09-23 12:03:22','ITM002',2),
('BC003','BKG002','BL002','2021-10-05 14:00:00','ITM003',1),
('BC004','BKG002','BL002','2021-10-05 14:00:00','ITM004',2),
('BC005','BKG003','BL003','2021-10-15 10:30:00','ITM005',1),
('BC006','BKG003','BL003','2021-10-15 10:30:00','ITM006',1),
('BC007','BKG004','BL004','2021-11-01 19:00:00','ITM007',1),
('BC008','BKG005','BL005','2021-11-05 11:30:00','ITM008',4),
('BC009','BKG005','BL005','2021-11-05 11:30:00','ITM009',6),
('BC010','BKG006','BL006','2021-11-12 10:00:00','ITM010',2); 



-- 1. For every user in the system, get the user_id and last booked room_no 
SELECT 
    u.user_id,
    b.room_no
FROM users u
JOIN bookings b ON u.user_id = b.user_id
WHERE (b.user_id, b.booking_date) IN (
    SELECT user_id, MAX(booking_date)
    FROM bookings
    GROUP BY user_id
);

-- 2. Get booking_id and total billing amount of every booking created in November, 2021 
 
 SELECT 
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate) AS total_amount
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

-- 3. Get bill_id and bill amount of all the bills raised in October, 2021 having bill amount >1000
SELECT 
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;


-- 4. Determine the most ordered and least ordered item of each month of year 2021 

SELECT month, 
       item_name, 
       total_quantity,
       CASE WHEN rn_asc = 1 THEN 'Least Ordered'
            WHEN rn_desc = 1 THEN 'Most Ordered' END AS status
FROM (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) ASC) AS rn_asc,
        ROW_NUMBER() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity) DESC) AS rn_desc
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
) t
WHERE rn_asc = 1 OR rn_desc = 1
ORDER BY month;

-- 5. Find the customers with the second highest bill value of each month of year 2021 

SELECT month, user_id, total_bill
FROM (
    SELECT 
        u.user_id,
        MONTH(bc.bill_date) AS month,
        SUM(bc.item_quantity * i.item_rate) AS total_bill,
        DENSE_RANK() OVER (PARTITION BY MONTH(bc.bill_date) ORDER BY SUM(bc.item_quantity * i.item_rate) DESC) AS rank_bill
    FROM users u
    JOIN bookings b ON u.user_id = b.user_id
    JOIN booking_commercials bc ON b.booking_id = bc.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY u.user_id, MONTH(bc.bill_date)
) t
WHERE rank_bill = 2
ORDER BY month;
