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

--5. Find the customers with the second highest bill value of each month of year 2021 

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
