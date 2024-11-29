
--file to delete everything in the project

--drop tables
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Cart CASCADE CONSTRAINTS;
DROP TABLE "Order" CASCADE CONSTRAINTS;
DROP TABLE LicenseKey CASCADE CONSTRAINTS;
DROP TABLE CartProduct CASCADE CONSTRAINTS;
DROP TABLE ProductCategory CASCADE CONSTRAINTS;

--drop indicies
DROP INDEX customer_full_name_idx;
DROP INDEX product_name_idx;

--drop triggers
DROP TRIGGER cart_totals_trigger;
DROP TRIGGER cart_cleanup_trigger;

--drop procedures
DROP PROCEDURE gen_order;
DROP PROCEDURE empty_cart;

--drop functions
DROP FUNCTION count_orders_on_date;
DROP FUNCTION count_product_sold_on_date;

--drop package (and body)
DROP PACKAGE store_tools;

--drop sequence and related things
DROP TRIGGER order_cart_update_trigger;
DROP SEQUENCE order_cart_update_seq;

