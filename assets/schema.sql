--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Postgres.app)
-- Dumped by pg_dump version 16.4

-- Started on 2024-11-14 14:19:40 +07

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


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 25147)
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    c_id integer NOT NULL,
    c_name character varying(50) NOT NULL,
    c_description character varying(1000) NOT NULL,
    c_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 25153)
-- Name: categories_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_sequence OWNER TO postgres;

--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 216
-- Name: categories_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_sequence OWNED BY public.categories.c_id;


--
-- TOC entry 223 (class 1259 OID 25212)
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    dc_id integer NOT NULL,
    dc_code character(6) NOT NULL,
    dc_percent integer NOT NULL,
    dc_order_id integer DEFAULT '-1'::integer NOT NULL,
    dc_max_price integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25215)
-- Name: discounts_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discounts_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discounts_sequence OWNER TO postgres;

--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 224
-- Name: discounts_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discounts_sequence OWNED BY public.discounts.dc_id;


--
-- TOC entry 217 (class 1259 OID 25154)
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 218 (class 1259 OID 25158)
-- Name: order_items_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_sequence OWNER TO postgres;

--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 218
-- Name: order_items_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_sequence OWNED BY public.order_items.oi_id;


--
-- TOC entry 219 (class 1259 OID 25159)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    o_id integer NOT NULL,
    o_status character(10) NOT NULL,
    o_date timestamp with time zone NOT NULL,
    o_deleted boolean DEFAULT false NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 25163)
-- Name: orders_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_sequence OWNER TO postgres;

--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 220
-- Name: orders_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_sequence OWNED BY public.orders.o_id;


--
-- TOC entry 221 (class 1259 OID 25164)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

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

--
-- TOC entry 222 (class 1259 OID 25170)
-- Name: products_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_sequence
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_sequence OWNER TO postgres;

--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 222
-- Name: products_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_sequence OWNED BY public.products.p_id;


--
-- TOC entry 3485 (class 2604 OID 25171)
-- Name: categories c_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN c_id SET DEFAULT nextval('public.categories_sequence'::regclass);


--
-- TOC entry 3493 (class 2604 OID 25219)
-- Name: discounts dc_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts ALTER COLUMN dc_id SET DEFAULT nextval('public.discounts_sequence'::regclass);


--
-- TOC entry 3487 (class 2604 OID 25172)
-- Name: order_items oi_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN oi_id SET DEFAULT nextval('public.order_items_sequence'::regclass);


--
-- TOC entry 3489 (class 2604 OID 25173)
-- Name: orders o_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN o_id SET DEFAULT nextval('public.orders_sequence'::regclass);


--
-- TOC entry 3491 (class 2604 OID 25174)
-- Name: products p_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN p_id SET DEFAULT nextval('public.products_sequence'::regclass);


--
-- TOC entry 3497 (class 2606 OID 25176)
-- Name: categories Categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT "Categories_pkey" PRIMARY KEY (c_id);


--
-- TOC entry 3505 (class 2606 OID 25217)
-- Name: discounts Discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT "Discounts_pkey" PRIMARY KEY (dc_id);


--
-- TOC entry 3499 (class 2606 OID 25178)
-- Name: order_items OrderItems_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_pkey" PRIMARY KEY (oi_id);


--
-- TOC entry 3501 (class 2606 OID 25180)
-- Name: orders Orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT "Orders_pkey" PRIMARY KEY (o_id);


--
-- TOC entry 3503 (class 2606 OID 25182)
-- Name: products Products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_pkey" PRIMARY KEY (p_id);


--
-- TOC entry 3506 (class 2606 OID 25183)
-- Name: order_items OrderItems_oi_orderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_orderId_fkey" FOREIGN KEY (oi_order_id) REFERENCES public.orders(o_id) NOT VALID;


--
-- TOC entry 3507 (class 2606 OID 25188)
-- Name: order_items OrderItems_oi_productId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT "OrderItems_oi_productId_fkey" FOREIGN KEY (oi_product_id) REFERENCES public.products(p_id) NOT VALID;


--
-- TOC entry 3508 (class 2606 OID 25193)
-- Name: products Products_d_categoryId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT "Products_d_categoryId_fkey" FOREIGN KEY (p_category_id) REFERENCES public.categories(c_id) NOT VALID;


-- Completed on 2024-11-14 14:19:40 +07

--
-- PostgreSQL database dump complete
--

