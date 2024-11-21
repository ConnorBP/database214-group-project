-- migrations to create initial database tables for the "software e-commerce" database

CREATE TABLE Customer (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    current_cart_id NUMBER DEFAULT -1 NOT NULL,
    email VARCHAR2(255) NOT NULL,
    password_hash VARCHAR2(64) NOT NULL,
    full_name VARCHAR2(64) NOT NULL,
    phone_number VARCHAR2(15),
    birthday DATE,
    billing_address VARCHAR2(255) NOT NULL
);

CREATE TABLE Product (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    category_id NUMBER NOT NULL,
    name VARCHAR2(255) NOT NULL,
    price NUMBER(10, 2) NOT NULL,
    description VARCHAR2(255) NOT NULL,
    file_size NUMBER
);

CREATE TABLE Cart (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    subtotal NUMBER DEFAULT ON NULL 0 NOT NULL,
    tax NUMBER DEFAULT ON NULL 0 NOT NULL
);

CREATE TABLE "Order" (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    cart_id NUMBER NOT NULL,
    order_placed NUMBER NOT NULL,
    order_status NUMBER NOT NULL,
    status NUMBER NOT NULL,
    created_at DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE LicenseKey (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    product_id NUMBER NOT NULL,
    order_id NUMBER NOT NULL,
    license_code VARCHAR2(255) NOT NULL,
    issued_at DATE NOT NULL,
    claimed_at DATE,
    claimed_by NUMBER,
    license_length NUMBER NOT NULL,
    status NUMBER NOT NULL
);

CREATE TABLE CartProduct (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    cart_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    quantity NUMBER NOT NULL
);

CREATE TABLE ProductCategory (
    id NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) PRIMARY KEY,
    name VARCHAR2(255) NOT NULL
);

-- Adding foreign key constraints after to avoid any ordering issues
ALTER TABLE "Order" ADD CONSTRAINT fk_order_cart_id FOREIGN KEY (cart_id) REFERENCES Cart(id);
ALTER TABLE "Order" ADD CONSTRAINT fk_order_customer_id FOREIGN KEY (customer_id) REFERENCES Customer(id);
ALTER TABLE Product ADD CONSTRAINT fk_product_category_id FOREIGN KEY (category_id) REFERENCES ProductCategory(id);
ALTER TABLE LicenseKey ADD CONSTRAINT fk_licensekey_product_id FOREIGN KEY (product_id) REFERENCES Product(id);
ALTER TABLE LicenseKey ADD CONSTRAINT fk_licensekey_claimed_by FOREIGN KEY (claimed_by) REFERENCES Customer(id);
ALTER TABLE LicenseKey ADD CONSTRAINT fk_licensekey_order_id FOREIGN KEY (order_id) REFERENCES "Order"(id);
ALTER TABLE Cart ADD CONSTRAINT fk_cart_customer_id FOREIGN KEY (customer_id) REFERENCES Customer(id);
ALTER TABLE CartProduct ADD CONSTRAINT fk_cartproduct_product_id FOREIGN KEY (product_id) REFERENCES Product(id);
ALTER TABLE CartProduct ADD CONSTRAINT fk_cartproduct_cart_id FOREIGN KEY (cart_id) REFERENCES Cart(id);
