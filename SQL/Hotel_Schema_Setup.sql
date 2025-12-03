import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="your_password",
    database="hotel_db"
)
cursor = conn.cursor()

# Insert sample user
cursor.execute("""
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address)
VALUES ('21wrcxuy-67erfn', 'John Doe', '97XXXXXXXX', 'john.doe@example.com', 'XX, Street Y, ABC City')
""")

# Insert sample booking
cursor.execute("""
INSERT INTO bookings (booking_id, booking_date, room_no, user_id)
VALUES ('bk-09f3e-95hj','2021-09-23 07:36:48','rm-bhf9-aerjn','21wrcxuy-67erfn')
""")

# Insert sample items
cursor.execute("""
INSERT INTO items (item_id, item_name, item_rate)
VALUES ('itm-a9e8-q8fu','Tawa Paratha',18)
""")

# Insert booking commercials
cursor.execute("""
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity)
VALUES ('q34r-3q4o8-q34u','bk-09f3e-95hj','bl-0a87y-q340','2021-09-23 12:03:22','itm-a9e8-q8fu',3)
""")

conn.commit()
print("Sample data inserted successfully!")

cursor.close()
conn.close()
