
---correct order to run files:
--      1 create_software_ecommerce_database.sql; create tables
--      2 insert.sql; insert records 
--      3 features.sql; add features 
--      4 testFormal.sql; tests everything and outputs to DBMS_OUTPUT (this file)

--      the file drop.sql was included to delete everything made for our project

--this file does formal tests using all the scripts written
--RUN THIS FILE RIGHT AFTER the other 3 files have been run
--everything that needs to be read will be displayed on DBMS_OUTPUT

--MISSING procedure tests; left spot for it

--only one difference between package procedures and functions
--package's gen_order manipulate's the package's global variable

--trigger 1: cart_totals_trigger
DECLARE
    cart_record Cart%ROWTYPE;
    var1 Cart.subtotal%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing trigger 1: cart_totals_triggger');
    SELECT * INTO cart_record FROM Cart WHERE id = 12;
    DBMS_OUTPUT.PUT_LINE('Totals for Cart 12 of Customer 2 before products added');
    DBMS_OUTPUT.PUT_LINE('subtotal: ' || cart_record.subtotal || '; tax: ' || cart_record.tax);
    DBMS_OUTPUT.PUT_LINE('Inserting 3 prodcuts priced at $65 each into cart 12');
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 3);
    SELECT * INTO cart_record FROM Cart WHERE id = 12;
    DBMS_OUTPUT.PUT_LINE('Totals for Cart 12 of Customer 2 after products added');
    DBMS_OUTPUT.PUT_LINE('subtotal: ' || cart_record.subtotal || '; tax: ' || cart_record.tax);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--trigger 2: cart_cleanup_trigger
DECLARE
    CURSOR cartproduct_cur IS
        SELECT * FROM Cartproduct; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing trigger 2: cart_cleanup_triggger');
    DBMS_OUTPUT.PUT_LINE('trigger reduces duplicate rows for a product in one cart into 1 row');
    DBMS_OUTPUT.PUT_LINE('Adding a few rows for Cart 12 of Customer 2 in the Cart_product table');
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 1);
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (12, 7, 1);
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart_product table before order is made with Cart');
    FOR rec_cur IN cartproduct_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'line id: ' || rec_cur.id ||
            '; cart id: ' || rec_cur.cart_id ||
            '; product id: ' || rec_cur.product_id ||
            '; product quantity: ' || rec_cur.quantity
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Creating order with Cart 12 of Customer 2');
    DBMS_OUTPUT.PUT_LINE('(using order creation procedure that was verified; will be tested in the next block');
    gen_order(2);
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart_product table after order is made with Cart');
    FOR rec_cur IN cartproduct_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'line id: ' || rec_cur.id ||
            '; cart id: ' || rec_cur.cart_id ||
            '; product id: ' || rec_cur.product_id ||
            '; product quantity: ' || rec_cur.quantity
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--procedure 1: gen_order
DECLARE
    CURSOR cart_cur IS
        SELECT * FROM Cart WHERE customer_id = 3;
    CURSOR order_cur IS
        SELECT * FROM "Order" WHERE customer_id = 3; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing procedure 1: gen_order');
    DBMS_OUTPUT.PUT_LINE('procedure creates order for a Customer using the current cart id');
    DBMS_OUTPUT.PUT_LINE('also assigns new cart to customer after old cart has been put on an order');
    DBMS_OUTPUT.PUT_LINE('Adding a row for Cart 13 of Customer 3 in the Cart_product table');
    DBMS_OUTPUT.NEW_LINE;
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (13, 1, 1);
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart table for Customer 3 before gen_order is used');
    FOR rec_cur1 IN cart_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'cart id: ' || rec_cur1.id ||
            '; customer id: ' || rec_cur1.customer_id ||
            '; subtotal: ' || rec_cur1.subtotal ||
            '; tax: ' || rec_cur1.tax
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Order table for Customer 3 before gen_order is used');
    FOR rec_cur2 IN order_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'order id: ' || rec_cur2.id ||
            '; customer id: ' || rec_cur2.customer_id ||
            '; cart id: ' || rec_cur2.cart_id
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Creating order with Cart 13 of Customer 3; currently on Cart 13');
    DBMS_OUTPUT.NEW_LINE;
    gen_order(3);
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart table for Customer 3 after gen_order is used');
    FOR rec_cur1 IN cart_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'cart id: ' || rec_cur1.id ||
            '; customer id: ' || rec_cur1.customer_id ||
            '; subtotal: ' || rec_cur1.subtotal ||
            '; tax: ' || rec_cur1.tax
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Order table for Customer 3 after gen_order is used');
    FOR rec_cur2 IN order_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'order id: ' || rec_cur2.id ||
            '; customer id: ' || rec_cur2.customer_id ||
            '; cart id: ' || rec_cur2.cart_id
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--procedure 2: empty_cart
DECLARE
    CURSOR cartproduct_cur IS
        SELECT o.id order_id, o.created_at, cp.cart_id, cp.id cartproduct_id, cp.product_id, cp.quantity
            FROM "Order" o JOIN Cart c ON o.cart_id = c.id
            RIGHT OUTER JOIN CartProduct cp ON c.id = cp.cart_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing procedure 2: empty_cart');
    DBMS_OUTPUT.PUT_LINE('Adding a few rows for Cart 14 in the Cart_product table');
    DBMS_OUTPUT.NEW_LINE;
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (14, 7, 1);
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (14, 6, 1);
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart_product table');
    FOR rec_cur IN cartproduct_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'order id: ' || NVL(TO_CHAR(rec_cur.order_id), 'null') ||
            '; created date: ' || NVL(TO_CHAR(rec_cur.created_at), 'null') ||
            '; cart_id: ' || rec_cur.cart_id ||
            '; cartproduct id: ' || rec_cur.cartproduct_id ||
            '; product id: ' || rec_cur.product_id ||
            '; product quantity: ' || rec_cur.quantity
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Procedure deletes all product lists not in an order yet');
    DBMS_OUTPUT.PUT_LINE('(Cart 14 is not associated with an order yet)');
    DBMS_OUTPUT.NEW_LINE;
    empty_cart(1);  --the number does nothing, syntax just required me to have a parameter
    DBMS_OUTPUT.PUT_LINE('Displaying all lines in the Cart_product table');
    FOR rec_cur IN cartproduct_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'order id: ' || NVL(TO_CHAR(rec_cur.order_id), 'null') ||
            '; created date: ' || NVL(TO_CHAR(rec_cur.created_at), 'null') ||
            '; cart_id: ' || rec_cur.cart_id ||
            '; cartproduct id: ' || rec_cur.cartproduct_id ||
            '; product id: ' || rec_cur.product_id ||
            '; product quantity: ' || rec_cur.quantity
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--function 1: count_orders_on_date
DECLARE
    loop_counter NUMBER:= 1;
    CURSOR order_cur IS
        SELECT * FROM "Order"; 
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing function 1: count_orders_on_date');
    DBMS_OUTPUT.PUT_LINE('considering order that already exists before this line in this file');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Displaying all order id with creation dates');
    FOR rec_cur IN order_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'row count: ' || loop_counter ||
            '; order id: ' || rec_cur.id ||
            '; created date: ' || rec_cur.created_at
        );
    loop_counter := loop_counter + 1;    
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Number of orders created today: ' || count_orders_on_date(SYSDATE));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Changing Order 2 to have created date to yesterday');
    DBMS_OUTPUT.PUT_LINE('(DECREASES ORDERS MADE ON A DATE BY 1)');
    UPDATE "Order" SET created_at = SYSDATE - 1 WHERE id = 2;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Running count_corders_on_date for today/SYSDATE');
    DBMS_OUTPUT.PUT_LINE('Number of orders created today: ' || count_orders_on_date(SYSDATE));
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--function 2: count_product_sold_on_date
DECLARE
    CURSOR cartproduct_cur IS
        SELECT o.id order_id, o.created_at, cp.cart_id, cp.id cartproduct_id, cp.product_id, cp.quantity
            FROM "Order" o JOIN Cart c ON o.cart_id = c.id
            RIGHT OUTER JOIN CartProduct cp ON c.id = cp.cart_id;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing function 2: count_product_sold_on_date');
    DBMS_OUTPUT.PUT_LINE('WILL BE OBSERVING PRODUCT ID 1 FOR TODAY/SYSDATE');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Inserting product id 1 items into Cart 15, that are not orders yet');
    INSERT INTO CartProduct(cart_id, product_id, quantity) VALUES (15, 1, 3);
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Displaying products in orders and not in orders');
    FOR rec_cur IN cartproduct_cur LOOP
        DBMS_OUTPUT.PUT_LINE(
            'order id: ' || NVL(TO_CHAR(rec_cur.order_id), 'null') ||
            '; created date: ' || NVL(TO_CHAR(rec_cur.created_at), 'null') ||
            '; cart_id: ' || rec_cur.cart_id ||
            '; cartproduct id: ' || rec_cur.cartproduct_id ||
            '; product id: ' || rec_cur.product_id ||
            '; product quantity: ' || rec_cur.quantity
        );
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Products not bought (paid for) yet are not in orders');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Number of product id 1 bought today/SYSDATE in orders: ' ||
                    count_product_sold_on_date(SYSDATE, 1)
    );
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.NEW_LINE;
END;
/


--package (containing procedures and functions created before)
--only one difference between package procedures and functions
--package's gen_order manipulate's the package's global variable

--package procedure store_tools.gen_order

--pacakge prodcedure store_tools.empty_cart

--package function store_tools.count_orders_on_date

--package function store_tool.count_product_sold_on_date



--sequence order_cart_update_seq
--created a trigger to use this sequence more effectively: order_cart_update_trigger
--these are used to keep track of how many times the cart attached to an order has been changed
--changing the cart on an order should not occur normally
--in a sense, this sequence counts occassions of tampering
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing sequence: order_cart_update_seq');
    DBMS_OUTPUT.PUT_LINE('test uses order_cart_update_trigger');
    DBMS_OUTPUT.PUT_LINE('counts number of times a cart on an order was changed, which is likely tampering');
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT_LINE('Initial times cart on an order changed: ' || order_cart_update_seq.CURRVAL);
    DBMS_OUTPUT.PUT_LINE('"Tampering" with Order 1, setting its cart from Cart 1 to 11');
    UPDATE "Order" SET cart_id = 11 WHERE id = 1;
    DBMS_OUTPUT.PUT_LINE('After update, times cart on an order changed: ' || order_cart_update_seq.CURRVAL);
END;
/



