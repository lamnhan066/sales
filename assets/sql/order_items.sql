--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Postgres.app)
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-12 23:34:05 +07

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

CREATE TABLE public.order_items (
    oi_id integer NOT NULL,
    oi_quantity integer NOT NULL,
    oi_unit_sale_price integer NOT NULL,
    oi_total_price integer NOT NULL,
    oi_product_id integer NOT NULL,
    oi_order_id integer NOT NULL,
    oi_deleted boolean DEFAULT false NOT NULL
);

ALTER TABLE public.order_items OWNER TO postgres;


CREATE SEQUENCE public.order_items_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.order_items_sequence OWNER TO postgres;

ALTER SEQUENCE public.order_items_sequence OWNED BY public.order_items.oi_id;

ALTER TABLE ONLY public.order_items ALTER COLUMN oi_id SET DEFAULT nextval('public.order_items_sequence'::regclass);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_pkey" PRIMARY KEY (oi_id);

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_orderId_fkey" FOREIGN KEY (oi_order_id) REFERENCES public.orders(o_id) NOT VALID;

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_productId_fkey" FOREIGN KEY (oi_product_id) REFERENCES public.products(p_id) NOT VALID;