-- When testing locally please create test database 'makersbnb_test'
-- On terminal:
-- > createdb 'makersbnb_test'
-- > psql -h '127.0.0.1' makersbnb_test < spec/seeds.sql

DROP TABLE IF EXISTS
  "public"."users",
  "public"."spaces",
  "public"."requests";

-- TABLE: users
-- CREATE SEQUENCE IF NOT EXISTS users_id_seq;

CREATE TABLE "public"."users" (
    "id" SERIAL,
    "email" text,
    "password" text,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."users" ("email", "password")
VALUES ('123@gmail.com', '123456'),
       ('def@gmail.com', '123456');

-- TABLE: spaces
-- CREATE SEQUENCE IF NOT EXISTS spaces_id_seq;

CREATE TABLE "public"."spaces" (
    "id" SERIAL,
    "name" text,
    "description" text,
    "price" numeric,
    "available_from" date,
    "available_to" date,
    "user_id" int,
    PRIMARY KEY ("id")
);

-- date inputs: '01/02/03' for January 2, 2003 in MDY mode
INSERT INTO "public"."spaces" (
  "name",
  "description",
  "price",
  "available_from",
  "available_to",
  "user_id"
)
VALUES
  (
    '308 Negra Arroyo Lane, Albuquerque',
    'Quaint house with pool out back',
    100,
    '2022-09-23',
    '2022-09-30',
    '2'
  ),
  (
    '671 Lincoln Avenue in Winnetka',
    'Great for a christmas visit',
    200,
    '2022-12-22',
    '2022-12-30',
    '1'
  ),
  (
    '251 N. Bristol Avenue, Brentwood',
    'Royalty once lived here',
    300,
    '2023-01-20',
    '2023-01-30',
    '2'
  );

-- TABLE: requests
-- CREATE SEQUENCE IF NOT EXISTS requests_id_seq;

CREATE TABLE "public"."requests" (
    "id" SERIAL,
    "space_id" int,
    "owner_user_id" int,
    "requester_user_id" int,
    "date" date,
    "confirmed" text,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."requests" (
  "space_id",
  "owner_user_id",
  "requester_user_id",
  "date",
  "confirmed"
)
VALUES ('1', '2', '1', '2022-09-24', false),
       ('2', '1', '2', '2022-12-26', false);

ALTER TABLE "public"."spaces"
  ADD FOREIGN KEY ("user_id")
  REFERENCES "public"."users"("id");

ALTER TABLE "public"."requests"
  ADD FOREIGN KEY ("owner_user_id")
  REFERENCES "public"."users"("id");

ALTER TABLE "public"."requests"
  ADD FOREIGN KEY ("requester_user_id")
  REFERENCES "public"."users"("id");
