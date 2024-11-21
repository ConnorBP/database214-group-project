
---correct order to run files:
--      1 create tables
--      2 insert records 
--      3 add features (this file)

--MISSING: sequence
--MISSING: package (make it with created procedures and functions)
--MISSING: global variables (include in package)


--indicies



--triggers

--update Cart price when products in it are added
--implementation considers mutation errors
--the table that acativated the trigger cannot be edited
--triggers caused by other triggers cannot edit other tables in the chain
CREATE OR REPLACE TRIGGER cart_totals_trigger
        AFTER INSERT OR UPDATE ON CartProduct
        FOR EACH ROW
    DECLARE
        old_subtotal Cart.subtotal%TYPE;
        adjustment_subtotal Cart.subtotal%TYPE;
        new_subtotal Cart.subtotal%TYPE;
        new_tax Cart.tax%TYPE;
    BEGIN
        SELECT subtotal INTO old_subtotal FROM Cart WHERE id = :NEW.cart_id;
        DBMS_OUTPUT.PUT_LINE(:NEW.cart_id);
        DBMS_OUTPUT.PUT_LINE(old_subtotal);
        SELECT price * (:NEW.quantity) INTO adjustment_subtotal
            FROM Product WHERE id = :NEW.product_id;
        DBMS_OUTPUT.PUT_LINE(adjustment_subtotal);
        new_subtotal := old_subtotal + adjustment_subtotal;    
        UPDATE Cart SET subtotal = new_subtotal WHERE id = :NEW.cart_id;
    END;

--condenses lines for the same Cart and Product in 


--assigns empty shopping cart to upon new Customer creation
--cannot edit the table that activated the trigger during the trigger
CREATE OR REPLACE TRIGGER customer_cart_trigger
        AFTER INSERT ON Customer
        FOR EACH ROW
    BEGIN
        INSERT INTO Cart(customer_id) VALUES (:NEW.id);
        UPDATE Customer SET current_cart_id = (SELECT MAX(Cart.id) FROM Cart WHERE Cart.customer_id = :NEW.id) WHERE Customer.id = :NEW.id;
    END;
CREATE OR REPLACE TRIGGER assign_current_cart_trigger
    AFTER INSERT ON Cart
    FOR EACH ROW
    FOLLOWS 
    BEGIN
        UPDATE Customer SET current_cart_id = :NEW.id WHERE id = :NEW.Customer_id;
    END;


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
END;

--empty all Cart (not in orders)
--deletes all rows of CartProduct no in an Order
--Cart total will update from trigger
CREATE OR REPLACE PROCEDURE empty_cart
(num IN NUMBER) --syntax requires on parameter at lesat
IS
BEGIN
    DELETE FROM CartProduct WHERE cart_id NOT IN (SELECT cart_id FROM "Order");
END;

--OPTION: make a procedure to create new user and assign a new current cart to them


--functions

--count orders made for a date



--count number of a product sold on a specific date




