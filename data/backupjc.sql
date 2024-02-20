--
-- PostgreSQL database dump
--

-- Dumped from database version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.8 (Ubuntu 14.8-0ubuntu0.22.04.1)

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

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: jc
--

CREATE TABLE public.clientes (
    nome text,
    endereco text,
    telefone text,
    id integer NOT NULL
);


ALTER TABLE public.clientes OWNER TO jc;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: jc
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_id_seq OWNER TO jc;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jc
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: ordem_de_servico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordem_de_servico (
    id integer NOT NULL,
    data date NOT NULL,
    nome_cliente character varying(100) NOT NULL,
    titulo_servico character varying(100) NOT NULL,
    descricao text,
    valor_cobrado numeric(10,2),
    forma_pagamento character varying(100),
    cliente_id integer
);


ALTER TABLE public.ordem_de_servico OWNER TO postgres;

--
-- Name: ordem_de_servico_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordem_de_servico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordem_de_servico_id_seq OWNER TO postgres;

--
-- Name: ordem_de_servico_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordem_de_servico_id_seq OWNED BY public.ordem_de_servico.id;


--
-- Name: ordem_servico; Type: TABLE; Schema: public; Owner: jc
--

CREATE TABLE public.ordem_servico (
    id integer NOT NULL,
    data date NOT NULL,
    nome_cliente character varying(100) NOT NULL,
    titulo_servico character varying(255) NOT NULL,
    descricao character varying(255) NOT NULL,
    valor_cobrado double precision,
    forma_pagamento character varying(100)
);


ALTER TABLE public.ordem_servico OWNER TO jc;

--
-- Name: ordem_servico_id_seq; Type: SEQUENCE; Schema: public; Owner: jc
--

CREATE SEQUENCE public.ordem_servico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ordem_servico_id_seq OWNER TO jc;

--
-- Name: ordem_servico_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: jc
--

ALTER SEQUENCE public.ordem_servico_id_seq OWNED BY public.ordem_servico.id;


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: jc
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: ordem_de_servico id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordem_de_servico ALTER COLUMN id SET DEFAULT nextval('public.ordem_de_servico_id_seq'::regclass);


--
-- Name: ordem_servico id; Type: DEFAULT; Schema: public; Owner: jc
--

ALTER TABLE ONLY public.ordem_servico ALTER COLUMN id SET DEFAULT nextval('public.ordem_servico_id_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: jc
--

COPY public.clientes (nome, endereco, telefone, id) FROM stdin;
Marllons Garcia da Silveira	Planaltina	+5561999153406	2
TEstador	Planaltina	+5561999153406	3
Mae	quadr1	3123123212	4
uyututyuu	tyuytuytuty	453453554345	5
TEste	teste	6161611616161	7
\.


--
-- Data for Name: ordem_de_servico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ordem_de_servico (id, data, nome_cliente, titulo_servico, descricao, valor_cobrado, forma_pagamento, cliente_id) FROM stdin;
24	2023-06-19	Marllons Garcia da Silveira	yrdyr	testadores	12.00	dinheiro	2
25	2023-06-19	Marllons Garcia da Silveira	teste	teste	12.00	dinheiro	2
36	2023-06-19	Mae	tretertre	tertertertre	6788.00	dinheiro	4
38	2023-06-19	Mae	mae	nada	80.03	dinheiro	4
39	2023-06-27	Marllons Garcia da Silveira	Teste	teste	1.00	dinheiro	2
40	2023-06-14	TEste	editado	etrere	56.90	dinheiro	7
41	2023-06-27	TEste	uyuykuy	kyukjuykuy	2424.00	dinheiro	7
42	2023-06-24	Mae	242424	242424	4242424.00	dinheiro	4
\.


--
-- Data for Name: ordem_servico; Type: TABLE DATA; Schema: public; Owner: jc
--

COPY public.ordem_servico (id, data, nome_cliente, titulo_servico, descricao, valor_cobrado, forma_pagamento) FROM stdin;
\.


--
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jc
--

SELECT pg_catalog.setval('public.clientes_id_seq', 7, true);


--
-- Name: ordem_de_servico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ordem_de_servico_id_seq', 42, true);


--
-- Name: ordem_servico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: jc
--

SELECT pg_catalog.setval('public.ordem_servico_id_seq', 1, false);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: jc
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: ordem_servico ordem_servico_pkey; Type: CONSTRAINT; Schema: public; Owner: jc
--

ALTER TABLE ONLY public.ordem_servico
    ADD CONSTRAINT ordem_servico_pkey PRIMARY KEY (id);


--
-- Name: ordem_de_servico fk_cliente_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordem_de_servico
    ADD CONSTRAINT fk_cliente_id FOREIGN KEY (cliente_id) REFERENCES public.clientes(id);


--
-- Name: TABLE ordem_de_servico; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.ordem_de_servico TO jc;


--
-- Name: SEQUENCE ordem_de_servico_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,UPDATE ON SEQUENCE public.ordem_de_servico_id_seq TO jc;


--
-- PostgreSQL database dump complete
--

