
---correct order to run files:
--      1 create_software_ecommerce_database.sql; create tables
--      2 insert.sql; insert records (this file)
--      3 features.sql; add features 
--      4 testFormal.sql; tests everything and outputs to DBMS_OUTPUT

--      the file drop.sql was included to delete everything made for our project

--Customer table inserts
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('john.doe@example.com', 'hash1', 'John Doe', '555-0101', TO_DATE('1980-05-15', 'YYYY-MM-DD'), '123 Main St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('jane.smith@example.com', 'hash2', 'Jane Smith', '555-0102', TO_DATE('1992-08-22', 'YYYY-MM-DD'), '456 Oak St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('alex.brown@example.com', 'hash3', 'Alex Brown', '555-0103', TO_DATE('1985-01-30', 'YYYY-MM-DD'), '789 Pine St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('emily.johnson@example.com', 'hash4', 'Emily Johnson', '555-0104', TO_DATE('1990-11-05', 'YYYY-MM-DD'), '123 Maple St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('michael.lee@example.com', 'hash5', 'Michael Lee', '555-0105', TO_DATE('1978-03-25', 'YYYY-MM-DD'), '234 Birch St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('susan.white@example.com', 'hash6', 'Susan White', '555-0106', TO_DATE('1983-07-12', 'YYYY-MM-DD'), '345 Cedar St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('daniel.green@example.com', 'hash7', 'Daniel Green', '555-0107', TO_DATE('1995-09-18', 'YYYY-MM-DD'), '456 Fir St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('natalie.adams@example.com', 'hash8', 'Natalie Adams', '555-0108', TO_DATE('1988-02-02', 'YYYY-MM-DD'), '567 Ash St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('william.martin@example.com', 'hash9', 'William Martin', '555-0109', TO_DATE('1975-06-15', 'YYYY-MM-DD'), '678 Elm St, City, Country');
INSERT INTO Customer (email, password_hash, full_name, phone_number, birthday, billing_address) 
    VALUES ('laura.walker@example.com', 'hash10', 'Laura Walker', '555-0110', TO_DATE('1981-12-20', 'YYYY-MM-DD'), '789 Redwood St, City, Country');

--ProductCategory inserts
INSERT INTO ProductCategory (name) VALUES ('Software Development');
INSERT INTO ProductCategory (name) VALUES ('Data Analytics');
INSERT INTO ProductCategory (name) VALUES ('Design Tools');
INSERT INTO ProductCategory (name) VALUES ('Gaming');
INSERT INTO ProductCategory (name) VALUES ('Security');
INSERT INTO ProductCategory (name) VALUES ('Productivity');
INSERT INTO ProductCategory (name) VALUES ('Database Management');
INSERT INTO ProductCategory (name) VALUES ('Cloud Services');
INSERT INTO ProductCategory (name) VALUES ('Business Tools');
INSERT INTO ProductCategory (name) VALUES ('Utilities');

--Product insert
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (1, 'Visual Studio', 150.00, 'An integrated development environment', 500, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (2, 'Power BI', 200.00, 'A data analytics tool for business intelligence', 300, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (3, 'Adobe Photoshop', 250.00, 'A graphics design software', 120, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (4, 'Cyberpunk 2077', 60.00, 'An open-world role-playing game', 70000, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (5, 'Norton Security', 50.00, 'Antivirus and internet security software', 10, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (6, 'Microsoft Office', 120.00, 'A suite of productivity applications', 10, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (7, 'MySQL Workbench', 65.00, 'Database management software', 50, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (8, 'AWS Cloud Storage', 50.00, 'Cloud storage service from AWS', 40, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (9, 'Trello', 10.00, 'Project management software', 50, 1);
INSERT INTO Product (category_id, name, price, description, file_size, min_age)
    VALUES (10, 'WinRAR', 30.00, 'File compression software', 50, 1);

--Cart inserts    
INSERT INTO Cart (customer_id) VALUES(1);
INSERT INTO Cart (customer_id) VALUES(2);
INSERT INTO Cart (customer_id) VALUES(3);
INSERT INTO Cart (customer_id) VALUES(4);
INSERT INTO Cart (customer_id) VALUES(5);
INSERT INTO Cart (customer_id) VALUES(6);
INSERT INTO Cart (customer_id) VALUES(7);
INSERT INTO Cart (customer_id) VALUES(8);
INSERT INTO Cart (customer_id) VALUES(9);
INSERT INTO Cart (customer_id) VALUES(10);

--Order inserts
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (1, 1, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (2, 2, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (3, 3, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (4, 4, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (5, 5, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (6, 6, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (7, 7, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (8, 8, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (9, 9, 'order placed');
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (10, 10, 'order placed');
    
--LicenseKey inserts
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (1, 1, 'LM2345KJH4567', TO_DATE('2024-01-15', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (2, 2, 'PI1234LQA1234', TO_DATE('2024-02-20', 'YYYY-MM-DD'), NULL, NULL, 180, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (3, 3, 'FT3456KJH5678', TO_DATE('2024-03-25', 'YYYY-MM-DD'), NULL, NULL, 30, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (4, 4, 'SG6789JHG8901', TO_DATE('2024-04-10', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (5, 5, 'SS1234HJ89KL', TO_DATE('2024-05-05', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (6, 6, 'UC2345TY6758', TO_DATE('2024-06-15', 'YYYY-MM-DD'), NULL, NULL, 180, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (7, 7, 'GA3456FY7657', TO_DATE('2024-07-20', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (8, 8, 'LE5678GJ6547', TO_DATE('2024-08-15', 'YYYY-MM-DD'), NULL, NULL, 90, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (9, 9, 'OF3456GH1234', TO_DATE('2024-09-10', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');
INSERT INTO LicenseKey (product_id, order_id, license_code, issued_at, claimed_at, claimed_by, license_length, status) 
    VALUES (10, 10, 'CB2345FD2346', TO_DATE('2024-10-05', 'YYYY-MM-DD'), NULL, NULL, 365, 'unclaimed');

--CartProduct insertions
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (1, 1, 2);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (2, 2, 2);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (3, 3, 2);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (4, 4, 1);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (5, 5, 1);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (6, 6, 2);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (7, 7, 1);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (8, 8, 1);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (9, 9, 1);
INSERT INTO CartProduct (cart_id, product_id, quantity) 
    VALUES (10, 10, 1);
    
--calculate correct values into Cart based on CartProduct
UPDATE Cart c SET subtotal = (SELECT SUM(p.price * cp.quantity) 
                                FROM Product p JOIN CartProduct cp ON p.id = cp.product_id
                                WHERE cp.cart_id = c.id);
UPDATE CART SET tax = subtotal * 0.13;
--SELECT * FROM Cart;

--create Cart that are not in Order and assign them to Customer 
--for when there are no triggers making Cart when there are new Customer
INSERT INTO Cart (customer_id) VALUES(1);
INSERT INTO Cart (customer_id) VALUES(2);
INSERT INTO Cart (customer_id) VALUES(3);
INSERT INTO Cart (customer_id) VALUES(4);
INSERT INTO Cart (customer_id) VALUES(5);
INSERT INTO Cart (customer_id) VALUES(6);
INSERT INTO Cart (customer_id) VALUES(7);
INSERT INTO Cart (customer_id) VALUES(8);
INSERT INTO Cart (customer_id) VALUES(9);
INSERT INTO Cart (customer_id) VALUES(10);
UPDATE Customer SET current_cart_id = 11 WHERE id = 1;
UPDATE Customer SET current_cart_id = 12 WHERE id = 2;
UPDATE Customer SET current_cart_id = 13 WHERE id = 3;
UPDATE Customer SET current_cart_id = 14 WHERE id = 4;
UPDATE Customer SET current_cart_id = 15 WHERE id = 5;
UPDATE Customer SET current_cart_id = 16 WHERE id = 6;
UPDATE Customer SET current_cart_id = 17 WHERE id = 7;
UPDATE Customer SET current_cart_id = 18 WHERE id = 8;
UPDATE Customer SET current_cart_id = 19 WHERE id = 9;
UPDATE Customer SET current_cart_id = 20 WHERE id = 10;

