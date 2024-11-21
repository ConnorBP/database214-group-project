
--drop tables
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Product CASCADE CONSTRAINTS;
DROP TABLE Cart CASCADE CONSTRAINTS;
DROP TABLE "Order" CASCADE CONSTRAINTS;
DROP TABLE LicenseKey CASCADE CONSTRAINTS;
DROP TABLE CartProduct CASCADE CONSTRAINTS;
DROP TABLE ProductCategory CASCADE CONSTRAINTS;

--drop indicies


--drop triggers
DROP TRIGGER cart_totals_trigger;
DROP TRIGGER customer_cart_trigger;
DROP TRIGGER assign_current_cart_trigger;

--drop procedures


