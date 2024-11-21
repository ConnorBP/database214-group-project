
--MISSING: sequence
--MISSING: package (make it with created procedures and functions)
--MISSING: global variables (include in package)


--indicies



--triggers

--update Cart price when products in it change


--assigns empty shopping cart to upon new Customer creation



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
    INSERT INTO "Order"(customer_id, cart_id, order_placed, order_status, status) 
        VALUES (customer_id_in, customer1.current_cart_id, 1, 1, 1);    --new Order
    INSERT INTO Cart(customer_id) VALUES (customer_id_in);              --new Cart
    SELECT id INTO cart1_id FROM Cart 
        WHERE id = (SELECT MAX(id) FROM Cart WHERE customer_id = customer_id_in);   --finds id of the new Cart
    UPDATE Customer SET current_cart_id = cart1_id WHERE id = customer_id_in;    
END;


--empty all Cart (not in orders)
--deletes all rows of CartProduct no in an Order



--functions

--count orders made for a date



--count number of a product sold on a specific date




