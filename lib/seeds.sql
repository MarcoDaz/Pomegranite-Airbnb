DROP TABLE IF EXISTS
  "public"."users",
  "public"."spaces",
  "public"."requests";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS
  users_id_seq,
  spaces_id_seq,
  requests_id_seq;

-- Table Definition
CREATE TABLE "public"."users" (
    "id" SERIAL,
    "email" text,
    "password" text,
    PRIMARY KEY ("id")
);

CREATE TABLE "public"."spaces" (
    "id" SERIAL,
    "name" text,
    "description" text,
    "price" number,
    "available_from" date,
    "available_to" date,
    "user_id" int,
    PRIMARY KEY ("id")
);

CREATE TABLE "public"."requests" (
    "id" SERIAL,
    "space_id" int,
    "owner_user_id" int,
    "requester_user_id" int,
    "date" date,
    "confirmed" boolean, 
    PRIMARY KEY ("id")
);

INSERT INTO "public"."users" ("email", "password")
VALUES ()

INSERT INTO "public"."spaces" (
  "name",
  "description",
  "price",
  "available_from",
  "available_to",
  "user_id",
)
VALUES ()

INSERT INTO "public"."requests" (
  "space_id",
  "owner_user_id",
  "requester_user_id",
  "date",
  "confirmed", 
)
VALUES ()
