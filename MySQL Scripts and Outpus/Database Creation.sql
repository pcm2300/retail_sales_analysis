-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema retail_sales
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema retail_sales
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `retail_sales` DEFAULT CHARACTER SET utf8 ;
USE `retail_sales` ;

-- -----------------------------------------------------
-- Table `retail_sales`.`brands`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`brands` (
  `brand_id` INT NOT NULL,
  `brand_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`brand_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`categories` (
  `category_id` INT NOT NULL,
  `category_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`stores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`stores` (
  `store_id` INT NOT NULL,
  `storescol` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(45) NULL,
  `email` VARCHAR(50) NULL,
  `street` VARCHAR(100) NULL,
  `city` VARCHAR(45) NULL,
  `state` CHAR(2) NULL,
  `zip_code` CHAR(5) NULL,
  PRIMARY KEY (`store_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`staffs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`staffs` (
  `staff_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `Last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `phone` VARCHAR(45) NULL,
  `active` SMALLINT(1) NOT NULL,
  `store_id` INT NOT NULL,
  `manager_id` INT NULL,
  PRIMARY KEY (`staff_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `manager_id_idx` (`manager_id` ASC) VISIBLE,
  INDEX `store_id_idx` (`store_id` ASC) VISIBLE,
  CONSTRAINT `store_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `retail_sales`.`stores` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `manager_id`
    FOREIGN KEY (`manager_id`)
    REFERENCES `retail_sales`.`staffs` (`staff_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`orders` (
  `order_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `order_status` VARCHAR(45) NOT NULL,
  `order_date` DATE NOT NULL,
  `required_date` DATE NULL,
  `shipped_date` DATE NULL,
  `store_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `Staff_id_idx` (`staff_id` ASC) VISIBLE,
  INDEX `store_id_idx` (`store_id` ASC) VISIBLE,
  INDEX `custoner_id_idx` (`customer_id` ASC) VISIBLE,
  CONSTRAINT `custoner_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `retail_sales`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `store_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `retail_sales`.`stores` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `Staff_id`
    FOREIGN KEY (`staff_id`)
    REFERENCES `retail_sales`.`staffs` (`staff_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`customers` (
  `customer_id` INT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NULL,
  `email` VARCHAR(50) NULL,
  `street` VARCHAR(50) NULL,
  `city` VARCHAR(50) NULL,
  `state` CHAR(2) NULL,
  `zip_code` CHAR(5) NULL,
  `orders_order_id` INT NOT NULL,
  PRIMARY KEY (`customer_id`),
  INDEX `fk_customers_orders1_idx` (`orders_order_id` ASC) VISIBLE,
  CONSTRAINT `fk_customers_orders1`
    FOREIGN KEY (`orders_order_id`)
    REFERENCES `retail_sales`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`products` (
  `product_id` INT NOT NULL,
  `product_name` VARCHAR(100) NOT NULL,
  `brand_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  `model_year` SMALLINT(4) NULL,
  `list_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`product_id`),
  INDEX `brand_id_idx` (`brand_id` ASC) VISIBLE,
  INDEX `category_id_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `brand_id`
    FOREIGN KEY (`brand_id`)
    REFERENCES `retail_sales`.`brands` (`brand_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `category_id`
    FOREIGN KEY (`category_id`)
    REFERENCES `retail_sales`.`categories` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`order_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`order_items` (
  `order_id` INT NOT NULL,
  `item_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  `list_price` DECIMAL(10,2) NOT NULL,
  `discount` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`order_id`, `item_id`),
  INDEX `product_id_idx` (`product_id` ASC) VISIBLE,
  CONSTRAINT `order_id`
    FOREIGN KEY (`order_id`)
    REFERENCES `retail_sales`.`orders` (`order_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_id`
    FOREIGN KEY (`product_id`)
    REFERENCES `retail_sales`.`products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `retail_sales`.`stocks`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `retail_sales`.`stocks` (
  `store_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `quantity` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`store_id`),
  CONSTRAINT `store_id`
    FOREIGN KEY (`store_id`)
    REFERENCES `retail_sales`.`stores` (`store_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_id`
    FOREIGN KEY ()
    REFERENCES `retail_sales`.`products` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
