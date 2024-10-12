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

CREATE TABLE public.products (
    p_id integer NOT NULL,
    p_name character varying(1000) NOT NULL,
    p_sku character(10) NOT NULL,
    p_image_path character varying[] NOT NULL,
    p_import_price integer NOT NULL,
    p_unit_sale_price integer NOT NULL,
    p_count integer NOT NULL,
    p_description character varying NOT NULL,
    p_category_id integer NOT NULL,
    p_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.products OWNER TO postgres;

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (p_id);


CREATE SEQUENCE public.products_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_sequence OWNER TO postgres;

ALTER SEQUENCE public.products_sequence OWNED BY public.products.p_id;

ALTER TABLE ONLY public.products ALTER COLUMN p_id SET DEFAULT nextval('public.products_sequence'::regclass);

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_d_categoryId_fkey" FOREIGN KEY (p_category_id) REFERENCES public.categories(c_id) NOT VALID;