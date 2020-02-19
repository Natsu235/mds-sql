DROP DATABASE IF EXISTS nightclub;
CREATE DATABASE nightclub CHARACTER SET utf8;
USE nightclub;


-- CREATE TABLES --

CREATE TABLE `nightclub` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `author` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `song` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `duration` TIME NOT NULL,
  `id_author` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_author`) REFERENCES `author`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `song_type` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `song_song_type` (
  `id_song` BIGINT UNSIGNED NOT NULL,
  `id_song_type` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_song`) REFERENCES `song`(`id`),
  FOREIGN KEY (`id_song_type`) REFERENCES `song_type`(`id`)
);

CREATE TABLE `address` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `postal_code` VARCHAR(50) NOT NULL,
  `civic_num` VARCHAR(50) NOT NULL,
  `street_name` VARCHAR(50) NOT NULL,
  `town_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `schedule` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_at` TIME NOT NULL,
  `end_at` TIME NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `post` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `base_salary` INT UNSIGNED NOT NULL,
  `id_schedule` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_schedule`) REFERENCES `schedule`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `employee` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `number` VARCHAR(50) NOT NULL UNIQUE,
  `start_at` DATE NOT NULL,
  `end_at` DATE NULL,
  `salary` INT UNSIGNED NOT NULL,
  `id_post` BIGINT UNSIGNED NOT NULL,
  `id_address` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_post`) REFERENCES `post`(`id`),
  FOREIGN KEY (`id_address`) REFERENCES `address`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `dj` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `employee_dj` (
  `id_employee` BIGINT UNSIGNED NOT NULL,
  `id_dj` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_employee`) REFERENCES `employee`(`id`),
  FOREIGN KEY (`id_dj`) REFERENCES `dj`(`id`)
);

CREATE TABLE `gear` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  `price` DECIMAL NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `state` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `gear_state` (
  `observed_at` DATE NOT NULL,
  `id_state` BIGINT UNSIGNED NOT NULL,
  `id_gear` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_state`) REFERENCES `state`(`id`),
  FOREIGN KEY (`id_gear`) REFERENCES `gear`(`id`)
);

CREATE TABLE `theme_room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `theme_room_gear` (
  `quantity` INT NOT NULL,
  `id_theme_room` BIGINT UNSIGNED NOT NULL,
  `id_gear` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_theme_room`) REFERENCES `theme_room`(`id`),
  FOREIGN KEY (`id_gear`) REFERENCES `gear`(`id`)
);

CREATE TABLE `allowed_people` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `base_room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL UNIQUE,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `base_room_allowed_people` (
  `id_base_room` BIGINT UNSIGNED NOT NULL,
  `id_allowed_people` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_base_room`) REFERENCES `base_room`(`id`),
  FOREIGN KEY (`id_allowed_people`) REFERENCES `allowed_people`(`id`)
);

CREATE TABLE `building` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `size` DECIMAL(10,2) NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  `id_nightclub` BIGINT UNSIGNED NOT NULL,
  `id_address` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`),
  FOREIGN KEY (`id_nightclub`) REFERENCES `nightclub`(`id`),
  FOREIGN KEY (`id_address`) REFERENCES `address`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL,
  `entrance_price` DECIMAL NOT NULL,
  `nb_people` INT UNSIGNED NOT NULL,
  `set_at` DATE NOT NULL,
  `id_building` BIGINT UNSIGNED NOT NULL,
  `id_base_room` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_building`) REFERENCES `building`(`id`),
  FOREIGN KEY (`id_base_room`) REFERENCES `base_room`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `room_salable_gear` (
  `price` DECIMAL NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `buy_at` DATE NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  `id_gear` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`),
  FOREIGN KEY (`id_gear`) REFERENCES `gear`(`id`)
);

CREATE TABLE `room_gear` (
  `set_at` DATE NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `id_gear` BIGINT UNSIGNED NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_gear`) REFERENCES `gear`(`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`)
);

CREATE TABLE `room_state` (
  `observed_at` DATE NOT NULL,
  `id_state` BIGINT UNSIGNED NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_state`) REFERENCES `state`(`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`)
);

CREATE TABLE `room_theme_room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `start_at` DATE NOT NULL,
  `end_at` DATE NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  `id_theme` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`),
  FOREIGN KEY (`id_theme`) REFERENCES `theme`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `dj_room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `work_at` DATE NOT NULL,
  `start_at` TIME NOT NULL,
  `end_at` TIME NOT NULL,
  `id_dj` BIGINT UNSIGNED NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_dj`) REFERENCES `dj`(`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `played` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `played_on` DATE NOT NULL,
  `id_song` BIGINT UNSIGNED NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_song`) REFERENCES `song`(`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `customer` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstname` VARCHAR(50) NOT NULL,
  `lastname` VARCHAR(50) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  PRIMARY KEY (`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `customer_room` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `buy_at` DATE NOT NULL,
  `id_customer` BIGINT UNSIGNED NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  `id_gear` BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`id_customer`) REFERENCES `customer`(`id`),
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`),
  FOREIGN KEY (`id_gear`) REFERENCES `gear`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `leasing_room` (
  `start_at` DATE NOT NULL,
  `end_at` DATE,
  `price` DECIMAL NOT NULL,
  `id_room` BIGINT UNSIGNED NOT NULL,
  `id_customer` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_room`) REFERENCES `room`(`id`),
  FOREIGN KEY (`id_customer`) REFERENCES `customer`(`id`)
) AUTO_INCREMENT=1;

CREATE TABLE `leasing_building` (
  `start_at` DATE NOT NULL,
  `end_at` DATE,
  `price` DECIMAL NOT NULL,
  `id_building` BIGINT UNSIGNED NOT NULL,
  `id_customer` BIGINT UNSIGNED NOT NULL,
  FOREIGN KEY (`id_building`) REFERENCES `building`(`id`),
  FOREIGN KEY (`id_customer`) REFERENCES `customer`(`id`)
) AUTO_INCREMENT=1;
