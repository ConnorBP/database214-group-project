
---correct order to run files:
--      1 create tables
--      2 insert records 
--      3 add features (this file)

--MISSING: sequence
--MISSING: package (make it with created procedures and functions)
--MISSING: global variables (include in package)

--OPTION: make a procedure to create new user and assign a new current cart to them

--indicies

--Customer table full_name index
CREATE INDEX customer_full_name_idx ON Customer(full_name);

--Product table name index
CREATE INDEX product_name_idx ON Product(name);


--triggers

--update Cart price when products in it are added
--implementation considers mutation errors
--the table that acativated the trigger cannot be edited
--triggers caused by other triggers cannot edit other tables in the chain
CREATE OR REPLACE TRIGGER cart_totals_trigger
        AFTER INSERT ON CartProduct
        FOR EACH ROW
    DECLARE
        old_subtotal Cart.subtotal%TYPE;
        adjustment_subtotal Cart.subtotal%TYPE;
        new_subtotal Cart.subtotal%TYPE;
        new_tax Cart.tax%TYPE;
    BEGIN
        SELECT subtotal INTO old_subtotal FROM Cart WHERE id = :NEW.cart_id;
        SELECT price * (:NEW.quantity) INTO adjustment_subtotal
            FROM Product WHERE id = :NEW.product_id;
        new_subtotal := old_subtotal + adjustment_subtotal;    
        UPDATE Cart SET subtotal = new_subtotal WHERE id = :NEW.cart_id;
        new_tax := new_subtotal * 0.13;
        UPDATE Cart SET tax = new_tax WHERE id = :NEW.cart_id;
    END;
/

--condenses lines for the same Cart with the same product_id and cart_id
--when an order is being created
--this one is useful if the previous update price trigger is used
CREATE OR REPLACE TRIGGER cart_cleanup_trigger
        AFTER INSERT ON "Order"
        FOR EACH ROW
    DECLARE
        CURSOR cursor1 IS SELECT SUM(quantity) total_qty, MIN(id) min_id, COUNT(*) total_count, product_id
                            FROM CartProduct
                            WHERE cart_id = :NEW.cart_id
                            GROUP BY product_id;
    BEGIN
       --updates and keeps the first entry of a Product for a Cart in CartProduct
       --cursor already filters for a specific cart
        FOR rec_cur IN cursor1 LOOP
            UPDATE CartProduct SET quantity = rec_cur.total_qty
                WHERE id = rec_cur.min_id AND product_id = rec_cur.product_id;
            DELETE FROM CartProduct
                WHERE id > rec_cur.min_id AND product_id = rec_cur.product_id;
        END LOOP;
    END;
/


--procedures

--create Order with a Cart for Customer (after paying)
CREATE OR REPLACE PROCEDURE gen_order
(
    customer_id_in IN Customer.id%TYPE
)
IS
    customer1 Customer%ROWTYPE;
    cart1_id Cart.id%TYPE;
BEGIN
    SELECT * INTO customer1 FROM Customer WHERE id = customer_id_in;
    INSERT INTO "Order"(customer_id, cart_id, status) 
        VALUES (customer_id_in, customer1.current_cart_id, 'order placed');    --new Order
    INSERT INTO Cart(customer_id) VALUES (customer_id_in);              --new Cart
    SELECT id INTO cart1_id FROM Cart 
        WHERE id = (SELECT MAX(id) FROM Cart WHERE customer_id = customer_id_in);   --finds id of the new Cart
    UPDATE Customer SET current_cart_id = cart1_id WHERE id = customer_id_in;
    COMMIT;
END;
/

--empty all Cart not in Order
--deletes all rows of CartProduct no in an Order
--Cart total will update from trigger
CREATE OR REPLACE PROCEDURE empty_cart
(dummyNum IN cart.id%TYPE) --syntax requires on parameter at lesat; THIS NUMBER DOES NOTHING
IS
BEGIN
    DELETE FROM CartProduct WHERE cart_id NOT IN (SELECT cart_id FROM "Order");
    UPDATE Cart SET subtotal = 0 WHERE id NOT IN (SELECT cart_id FROM "Order");
    UPDATE Cart SET tax = 0 WHERE id NOT IN (SELECT cart_id FROM "Order");
    COMMIT;
END;
/


--functions

--count orders made for a date
CREATE OR REPLACE FUNCTION count_orders_on_date
(
    in_date IN "Order".created_at%TYPE
)
RETURN NUMBER
IS
    out_count NUMBER;
    in_year_char VARCHAR2(4) := TO_CHAR(in_date, 'YYYY');
    in_month_char VARCHAR(2) := TO_CHAR(in_date, 'MM');
    in_day_char VARCHAR(2) := TO_CHAR(in_date, 'DD');
BEGIN
    SELECT COUNT(*) INTO out_count FROM "Order"
        WHERE in_year_char = TO_CHAR(created_at, 'YYYY')
            AND in_month_char = TO_CHAR(created_at, 'MM')
            AND in_day_char = TO_CHAR(created_at, 'DD');
    RETURN out_count;
END;
/

--count number of a product sold on a specific date
CREATE OR REPLACE FUNCTION count_product_sold_on_date
(
    in_date IN "Order".created_at%TYPE,
    in_product_id IN Product.id%TYPE
)
RETURN NUMBER
IS
    out_count NUMBER;
    in_year_char VARCHAR2(4) := TO_CHAR(in_date, 'YYYY');
    in_month_char VARCHAR(2) := TO_CHAR(in_date, 'MM');
    in_day_char VARCHAR(2) := TO_CHAR(in_date, 'DD');
BEGIN
    SELECT SUM(cp.quantity) INTO out_count
        FROM "Order" o JOIN  Cart c ON o.cart_id = c.id
        JOIN CartProduct cp ON c.id = cp.cart_id
        WHERE o.id IS NOT NULL
            AND cp.product_id = in_product_id
            AND in_year_char = TO_CHAR(created_at, 'YYYY')
            AND in_month_char = TO_CHAR(created_at, 'MM')
            AND in_day_char = TO_CHAR(created_at, 'DD');
    RETURN out_count;        
END;
/


--package and package body
--global variable is a counter for how many orders made with this package
CREATE OR REPLACE PACKAGE store_tools
    IS
    session_order_count NUMBER:= 0;
    PROCEDURE gen_order
    (
        customer_id_in IN Customer.id%TYPE
    );
    PROCEDURE empty_cart
    (
        dummyNum IN cart.id%TYPE
    );
    FUNCTION count_orders_on_date
    (
        in_date IN "Order".created_at%TYPE
    )
    RETURN NUMBER;
    FUNCTION count_product_sold_on_date
    (
        in_date IN "Order".created_at%TYPE,
        in_product_id IN Product.id%TYPE
    )
    RETURN NUMBER;
END;   
/

CREATE OR REPLACE
PACKAGE BODY STORE_TOOLS AS

  PROCEDURE gen_order
    (
        customer_id_in IN Customer.id%TYPE
    ) AS
    customer1 Customer%ROWTYPE;
    cart1_id Cart.id%TYPE;
    BEGIN
        SELECT * INTO customer1 FROM Customer WHERE id = customer_id_in;
        INSERT INTO "Order"(customer_id, cart_id, status) 
            VALUES (customer_id_in, customer1.current_cart_id, 'order placed');    --new Order
        INSERT INTO Cart(customer_id) VALUES (customer_id_in);              --new Cart
        SELECT id INTO cart1_id FROM Cart 
            WHERE id = (SELECT MAX(id) FROM Cart WHERE customer_id = customer_id_in);   --finds id of the new Cart
        UPDATE Customer SET current_cart_id = cart1_id WHERE id = customer_id_in;
        COMMIT;
        session_order_count := session_order_count + 1;
  END gen_order;

  PROCEDURE empty_cart
    (
        dummyNum IN cart.id%TYPE
    ) AS
  BEGIN
    DELETE FROM CartProduct WHERE cart_id NOT IN (SELECT cart_id FROM "Order");
    UPDATE Cart SET subtotal = 0 WHERE id NOT IN (SELECT cart_id FROM "Order");
    UPDATE Cart SET tax = 0 WHERE id NOT IN (SELECT cart_id FROM "Order");
    COMMIT;
  END empty_cart;

  FUNCTION count_orders_on_date
    (
        in_date IN "Order".created_at%TYPE
    )
    RETURN NUMBER AS
    out_count NUMBER;
        in_year_char VARCHAR2(4) := TO_CHAR(in_date, 'YYYY');
        in_month_char VARCHAR(2) := TO_CHAR(in_date, 'MM');
        in_day_char VARCHAR(2) := TO_CHAR(in_date, 'DD');
    BEGIN
        SELECT COUNT(*) INTO out_count FROM "Order"
            WHERE in_year_char = TO_CHAR(created_at, 'YYYY')
                AND in_month_char = TO_CHAR(created_at, 'MM')
                AND in_day_char = TO_CHAR(created_at, 'DD');
    RETURN out_count;
  END count_orders_on_date;

  FUNCTION count_product_sold_on_date
    (
        in_date IN "Order".created_at%TYPE,
        in_product_id IN Product.id%TYPE
    )
    RETURN NUMBER AS
        out_count NUMBER;
        in_year_char VARCHAR2(4) := TO_CHAR(in_date, 'YYYY');
        in_month_char VARCHAR(2) := TO_CHAR(in_date, 'MM');
        in_day_char VARCHAR(2) := TO_CHAR(in_date, 'DD');
    BEGIN
        SELECT SUM(cp.quantity) INTO out_count
            FROM "Order" o JOIN  Cart c ON o.cart_id = c.id
            JOIN CartProduct cp ON c.id = cp.cart_id
            WHERE o.id IS NOT NULL
                AND cp.product_id = in_product_id
                AND in_year_char = TO_CHAR(created_at, 'YYYY')
                AND in_month_char = TO_CHAR(created_at, 'MM')
                AND in_day_char = TO_CHAR(created_at, 'DD');
        RETURN out_count;       
  END count_product_sold_on_date;

END STORE_TOOLS;
/

--sequence

--count how many times a Order had its associated Cart changed 
--this normally should not happen, so this is tracked
CREATE SEQUENCE order_cart_update_seq
    MINVALUE 0
    START WITH 0
    INCREMENT BY 1;
--increment sequence once to make CURRVAL work
SELECT order_cart_update_seq.NEXTVAL FROM DUAL;
--trigger updates the value in this sequence when the Cart on an order changes
CREATE OR REPLACE TRIGGER order_cart_update_trigger
        AFTER UPDATE OF cart_id ON "Order"
        FOR EACH ROW
        DECLARE
            temp NUMBER;
        BEGIN
            SELECT order_cart_update_seq.NEXTVAL INTO temp FROM DUAL;
        END;   
        
