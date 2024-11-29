--to test things written on and around Nov 21
--RUN LINES INDIVIDUALLY DEPENDING ON WHAT YOU WANT TO TEST

--hard coded values might have to be adjusted depending on values in database

--testing trigger to update Cart total and tax when quantities change
SELECT * FROM CartProduct;
SELECT * FROM Cart;
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 5);

--testing trigger to condense lines in CartProduct with the same cart_id and product_id into one line
--when order is created with Cart
--cart_cleanup_trigger
SELECT * FROM "Order";
SELECT * FROM CartProduct;
--press this multiple times to before testing
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 5);
INSERT INTO "Order" (customer_id, cart_id, status) 
    VALUES (2, 12, 'order placed'); 


--testing procedure gen_order
BEGIN
    gen_order(10);
END;    
/

SELECT * FROM Cart;
SELECT * FROM "Order";

--testing procedure empty_cart
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 5);
SELECT * FROM CartProduct;
SELECT * FROM Cart;

--the argument in the procedure does not matter
--the to make a procedure, there has to be some sort of parameter
BEGIN
    empty_cart(12);
END;
/


--testing function count_orders_on_date
SELECT * FROM "Order";
UPDATE "Order" SET created_at = SYSDATE - 1 WHERE id = 5;
SELECT count_orders_on_date(SYSDATE) FROM DUAL;

--testing function count_products_sold_on_date
SELECT o.id, o.created_at, c.id, cp.id, cp.product_id, cp.quantity
    FROM "Order" o JOIN Cart c ON o.cart_id = c.id
    RIGHT OUTER JOIN CartProduct cp ON c.id = cp.cart_id;
SELECT * FROM CartProduct;
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (13, 3, 3);
SELECT count_product_sold_on_date(SYSDATE, 3) FROM DUAL;


--package and package body test

--package procedure gen_order and global variable
BEGIN
    store_tools.gen_order(10);
    DBMS_OUTPUT.PUT_LINE(store_tools.session_order_count);
END;    
/

SELECT * FROM Cart;
SELECT * FROM "Order";

--package procedure empty_cart
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 5);
SELECT * FROM CartProduct;
SELECT * FROM Cart;

--the argument in the procedure does not matter
--the to make a procedure, there has to be some sort of parameter
BEGIN
    store_tools.empty_cart(12);
END;
/

--package function count_orders_on_date
SELECT * FROM "Order";
UPDATE "Order" SET created_at = SYSDATE - 1 WHERE id = 5;
SELECT store_tools.count_orders_on_date(SYSDATE) FROM DUAL;

--package function count_product_sold_on_date
SELECT o.id order_id, o.created_at, cp.cart_id, cp.id cartproduct_id, cp.product_id, cp.quantity
    FROM "Order" o JOIN Cart c ON o.cart_id = c.id
    RIGHT OUTER JOIN CartProduct cp ON c.id = cp.cart_id;
SELECT o.id, o.created_at, c.id
    FROM "Order" o JOIN Cart c ON o.cart_id = c.id;
SELECT * FROM CartProduct;
INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (13, 3, 3);
SELECT store_tools.count_product_sold_on_date(SYSDATE, 3) FROM DUAL;
BEGIN
    store_tools.gen_order(3);
    DBMS_OUTPUT.PUT_LINE(store_tools.session_order_count);
END;   


--Cart on Order change sequence test with its trigger
SELECT order_cart_update_seq.CURRVAL FROM DUAL;
INSERT INTO Cart (customer_id) VALUES(10);  --first cart after insert file has id 21; adjust ad needed
UPDATE "Order" SET cart_id = 22 WHERE cart_id = 21;
BEGIN
    gen_order(10);
END;
/
SELECT * FROM customer;
SELECT * FROM cart;
SELECT * FROM "Order";
