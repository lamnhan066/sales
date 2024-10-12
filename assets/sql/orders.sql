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

CREATE TABLE public.orders (
    o_id integer NOT NULL,
    o_status character(10) NOT NULL,
    o_date date NOT NULL,
    o_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

CREATE SEQUENCE public.orders_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_sequence OWNER TO postgres;

ALTER SEQUENCE public.orders_sequence OWNED BY public.orders.o_id;

ALTER TABLE ONLY public.orders ALTER COLUMN o_id SET DEFAULT nextval('public.orders_sequence'::regclass);


ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (o_id);