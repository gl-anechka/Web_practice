DROP DATABASE IF EXISTS storage;
CREATE DATABASE storage;

-- перечислимый тип для определения поставщика/потребителя
CREATE TYPE partner_type_enum AS ENUM ('PROVIDER', 'CONSUMER', 'BOTH');

-- перечислимый тип для определения единицы измерения
CREATE TYPE unit_enum AS ENUM ('kg', 'pcs');

-- статус товара по времени нахождения на складе
CREATE TYPE store_status_enum AS ENUM ('OK', 'NEAR_EXPIRY', 'EXPIRED', 'SPOILED');

-- тип товара
CREATE TABLE product_type (
    id_type SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE partner (
    id_partner SERIAL,
    name VARCHAR(100),
    address TEXT,
    phone VARCHAR(12),
    email VARCHAR(100),
    type ENUM,
    PRIMARY KEY (id_partner)
);

CREATE TABLE "product" (
                           "id_product" serial,
                           "title" varchar(300),
                           "id_type" integer,
                           "unit" ENUM,
                           "kg_per_unit" real,
                           PRIMARY KEY ("id_product"),
                           CONSTRAINT "FK_product_id_type"
                               FOREIGN KEY ("id_type")
                                   REFERENCES "product_type"("id_type")
);

CREATE TABLE "supply" (
                          "id_supply" serial,
                          "id_provider" integer,
                          "id_product" integer,
                          "time" timestamp,
                          "amount" real,
                          PRIMARY KEY ("id_supply"),
                          CONSTRAINT "FK_supply_id_provider"
                              FOREIGN KEY ("id_provider")
                                  REFERENCES "partner"("id_partner"),
                          CONSTRAINT "FK_supply_id_product"
                              FOREIGN KEY ("id_product")
                                  REFERENCES "product"("id_product")
);

CREATE TABLE "order" (
                         "id_order" serial,
                         "id_consumer" integer,
                         "id_product" integer,
                         "time" timestamp,
                         "amount" real,
                         "completed" bool,
                         PRIMARY KEY ("id_order"),
                         CONSTRAINT "FK_order_id_consumer"
                             FOREIGN KEY ("id_consumer")
                                 REFERENCES "partner"("id_partner"),
                         CONSTRAINT "FK_order_id_product"
                             FOREIGN KEY ("id_product")
                                 REFERENCES "product"("id_product")
);

CREATE TABLE "place" (
                         "id_place" serial,
                         "room_num" integer,
                         "shelf_num" integer,
                         "kg_limit" real,
                         PRIMARY KEY ("id_place")
);

CREATE TABLE "storehouse" (
                              "id_storehouse" serial,
                              "id_product" integer,
                              "amount" real,
                              "id_place" integer,
                              "id_supply" integer,
                              "received_at" timestamp,
                              "expires_at" timestamp,
                              "status" ENUM,
                              "id_order" integer,
                              PRIMARY KEY ("id_storehouse"),
                              CONSTRAINT "FK_storehouse_id_product"
                                  FOREIGN KEY ("id_product")
                                      REFERENCES "product"("id_product"),
                              CONSTRAINT "FK_storehouse_id_place"
                                  FOREIGN KEY ("id_place")
                                      REFERENCES "place"("id_place"),
                              CONSTRAINT "FK_storehouse_id_supply"
                                  FOREIGN KEY ("id_supply")
                                      REFERENCES "supply"("id_supply"),
                              CONSTRAINT "FK_storehouse_id_order"
                                  FOREIGN KEY ("id_order")
                                      REFERENCES "order"("id_order")
);

