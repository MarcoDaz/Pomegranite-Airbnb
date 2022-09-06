DROP TABLE IF EXISTS "public"."users",
                     "public"."spaces",
                     "public"."requests";
-- This script only contains the table creation statements and does not fully represent the table in the database. It's still missing: indices, triggers. Do not use it as a backup.

-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS users_id_seq, spaces_id_seq, requests_id_seq;

-- Table Definition
CREATE TABLE "public"."users" (
    "id" SERIAL,
    "title" text,
    "author_name" text,
    PRIMARY KEY ("id")
);

CREATE TABLE "public"."spaces" (
    "id" SERIAL,
    "title" text,
    "author_name" text,
    PRIMARY KEY ("id")
);

CREATE TABLE "public"."requests" (
    "id" SERIAL,
    "title" text,
    "author_name" text,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."books" ("id", "title", "author_name") VALUES
(1, 'Nineteen Eighty-Four', 'George Orwell'),
(2, 'Mrs Dalloway', 'Virginia Woolf'),
(3, 'Emma', 'Jane Austen'),
(4, 'Dracula', 'Bram Stoker'),
(5, 'The Age of Innocence', 'Edith Wharton');
