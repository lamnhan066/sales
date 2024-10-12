SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public.categories (
    c_id integer NOT NULL,
    c_name character varying(50) NOT NULL,
    c_description character varying(1000) NOT NULL,
    c_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

CREATE SEQUENCE public.categories_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_sequence OWNER TO postgres;

ALTER SEQUENCE public.categories_sequence OWNED BY public.categories.c_id;

ALTER TABLE ONLY public.categories ALTER COLUMN c_id SET DEFAULT nextval('public.categories_sequence'::regclass);

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "Categories_pkey" PRIMARY KEY (c_id);