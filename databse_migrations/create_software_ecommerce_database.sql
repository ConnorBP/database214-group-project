--  migrations to create initial database tables for the "software e-commerce" database

CREATE TABLE `Customer`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(255) NOT NULL,
    `password_hash` VARCHAR(64) NOT NULL,
    `full_name` VARCHAR(64) NOT NULL,
    `phone_number` VARCHAR(15) NULL,
    `birthday` DATETIME NULL,
    `billing_address` VARCHAR(255) NOT NULL
);
CREATE TABLE `Product`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `category_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `price` DOUBLE NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `file_size` BIGINT NULL
);
CREATE TABLE `Cart`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `customer_id` BIGINT UNSIGNED NOT NULL,
    `subtotal` BIGINT NOT NULL,
    `tax` BIGINT NOT NULL
);
CREATE TABLE `Order`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `customer_id` BIGINT UNSIGNED NOT NULL,
    `cart_id` BIGINT UNSIGNED NOT NULL,
    `order_placed` BIGINT NOT NULL,
    `order_status` BIGINT NOT NULL,
    `subtotal` BIGINT NOT NULL,
    `tax` BIGINT NOT NULL,
    `status` BIGINT NOT NULL
);
CREATE TABLE `LicenseKey`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `license_code` VARCHAR(255) NOT NULL,
    `issued_at` DATETIME NOT NULL,
    `claimed_at` DATETIME NULL,
    `claimed_by` BIGINT UNSIGNED NULL,
    `license_length` BIGINT NOT NULL,
    `Status` BIGINT NOT NULL
);
CREATE TABLE `CartProduct`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `cart_id` BIGINT NOT NULL,
    `product_id` BIGINT NOT NULL,
    `quantity` BIGINT NOT NULL
);
CREATE TABLE `ProductCategory`(
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL
);
ALTER TABLE
    `Order` ADD CONSTRAINT `order_cart_id_foreign` FOREIGN KEY(`cart_id`) REFERENCES `Cart`(`id`);
ALTER TABLE
    `Order` ADD CONSTRAINT `order_customer_id_foreign` FOREIGN KEY(`customer_id`) REFERENCES `Customer`(`id`);
ALTER TABLE
    `Product` ADD CONSTRAINT `product_category_id_foreign` FOREIGN KEY(`category_id`) REFERENCES `ProductCategory`(`id`);
ALTER TABLE
    `LicenseKey` ADD CONSTRAINT `licensekey_product_id_foreign` FOREIGN KEY(`product_id`) REFERENCES `Product`(`id`);
ALTER TABLE
    `LicenseKey` ADD CONSTRAINT `licensekey_claimed_by_foreign` FOREIGN KEY(`claimed_by`) REFERENCES `Customer`(`id`);
ALTER TABLE
    `LicenseKey` ADD CONSTRAINT `licensekey_order_id_foreign` FOREIGN KEY(`order_id`) REFERENCES `Order`(`id`);
ALTER TABLE
    `Cart` ADD CONSTRAINT `cart_customer_id_foreign` FOREIGN KEY(`customer_id`) REFERENCES `Customer`(`id`);
ALTER TABLE
    `CartProduct` ADD CONSTRAINT `cartproduct_product_id_foreign` FOREIGN KEY(`product_id`) REFERENCES `Product`(`id`);
ALTER TABLE
    `CartProduct` ADD CONSTRAINT `cartproduct_cart_id_foreign` FOREIGN KEY(`cart_id`) REFERENCES `Cart`(`id`);