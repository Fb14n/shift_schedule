-- SAFE SEED FILE (IDEMPOTENT)
-- Struktur (nur wenn nicht vorhanden):
--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6 (Debian 17.6-2.pgdg12+1)
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.companies (
    id integer,
    name character varying(100),
    holidays_default integer
);


--
-- Name: shift_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.shift_types (
    id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    type_color bigint DEFAULT 16777215,
    type_time_start time without time zone,
    type_time_end time without time zone
);


--
-- Name: shift_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.shift_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shift_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shift_types_id_seq OWNED BY public.shift_types.id;


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.shifts (
    id integer NOT NULL,
    shift_date date NOT NULL,
    shift_type_id integer NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE IF NOT EXISTS public.users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    password character varying(255),
    employee_id integer NOT NULL,
    company_id integer,
    holidays integer,
    is_admin boolean
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE IF NOT EXISTS public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: shift_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_types ALTER COLUMN id SET DEFAULT nextval('public.shift_types_id_seq'::regclass);


--
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: shift_types shift_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shift_types
    ADD CONSTRAINT shift_types_pkey IF NOT EXISTS PRIMARY KEY (id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey IF NOT EXISTS PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey IF NOT EXISTS PRIMARY KEY (id);


--
-- Name: users_employee_company_unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_employee_company_unique_idx ON public.users USING btree (employee_id, company_id);


--
-- Name: shifts fk_shift_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT fk_shift_type IF NOT EXISTS FOREIGN KEY (shift_type_id) REFERENCES public.shift_types(id) ON DELETE CASCADE;


--
-- Name: shifts fk_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT fk_user IF NOT EXISTS FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shifts shifts_shift_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_shift_type_id_fkey IF NOT EXISTS FOREIGN KEY (shift_type_id) REFERENCES public.shift_types(id);


--
-- Name: shifts shifts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_user_id_fkey IF NOT EXISTS FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--



-- Daten (nur fehlende Zeilen werden eingefügt):
--
-- "PostgreSQL" database dump
--


-- "Dumped" from "database" version 17.6 ("Debian" 17.6-2.pgdg12+1)
-- "Dumped" by "pg_dump" version 17.6

SET "statement_timeout" = 0;
SET "lock_timeout" = 0;
SET "idle_in_transaction_session_timeout" = 0;
SET "transaction_timeout" = 0;
SET "client_encoding" = 'UTF8';
SET "standard_conforming_strings" = on;
SELECT pg_catalog.set_config('search_path', '', "false") "ON" CONFLICT "DO" NOTHING;
SET "check_function_bodies" = false;
SET "xmloption" = content;
SET "client_min_messages" = warning;
SET "row_security" = off;

--
-- "Data" for Name: companies; Type: "TABLE" DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT "INTO" public.companies ("id", "name", "holidays_default") "VALUES" (1, 'Chronos', 30) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.companies ("id", "name", "holidays_default") "VALUES" (2, 'Company GmbH', 28) "ON" CONFLICT "DO" NOTHING;


--
-- "Data" for Name: shift_types; Type: "TABLE" DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT "INTO" public.shift_types ("id", "type_name", "type_color", "type_time_start", "type_time_end") "VALUES" (1, 'Frühschicht', 4367989, '06:00:00', '14:00:00') "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shift_types ("id", "type_name", "type_color", "type_time_start", "type_time_end") "VALUES" (2, 'Spätschicht', 16760576, '14:00:00', '22:00:00') "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shift_types ("id", "type_name", "type_color", "type_time_start", "type_time_end") "VALUES" (3, 'Nachtschicht', 7304056, '22:00:00', '06:00:00') "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shift_types ("id", "type_name", "type_color", "type_time_start", "type_time_end") "VALUES" (4, 'Krank', 15745618, '00:00:00', '24:00:00') "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shift_types ("id", "type_name", "type_color", "type_time_start", "type_time_end") "VALUES" (5, 'Urlaub', 4242352, '00:00:00', '24:00:00') "ON" CONFLICT "DO" NOTHING;


--
-- "Data" for Name: users; Type: "TABLE" DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (5, 'Peter', 'Muster', '$2b$10$lCJdIlabK91HIMRMTjQvA.duIqp1/Np1WZM8wK5DiPUU7Smgitst6', 1004, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (6, 'Olaf', 'Rad', '$2b$10$pW.G2N8YLtY0t76jui0KAutuDPsCaGCb4ajf1vUsdfmDCxKPaM93K', 1005, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (7, 'Bernd', 'Hall', '$2b$10$X55KztRcGYNIY72.jD4TfOLfDWbKF8jFoVXbi/F5tGSswu5bbqzUm', 1003, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (8, 'Ulf', 'Stein', '$2b$10$rBxXaCjRGPkE3U87NLafu.Zr/0Gpwo4m5cJ1Yswj.LDiLD8E/iXE6', 1006, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (9, 'Ralf', 'Baum', '$2b$10$a6nuueEHvGUFZ6w7QL2ApeIazk7X8DtLPAwEL04sFVlq5pwPT0TLG', 1007, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (10, 'Uwe', 'Bäcker', '$2b$10$9a37MBSEgqpH6KJ9jXPPEus1KNxXXG0SDwGsypQuBzBPlbN8h15oe', 1008, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (48, 'Kevin', 'Marsch', '$2b$10$67S6WomxqLkHG3E6zMuhvOdzASx0ZMvfD7Vk8dToCa06666/OT.Lm', 1009, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (49, 'Alex', 'Tal', '$2b$10$gYBAcZFGi8hQO4kB3EAjNuyOfFAqZL84FdtWlYatSIgdbigGnma2S', 1010, 1, 30, "true") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (1, 'Alice', 'Muster', '$2b$10$ZWFtn9cFGL/MgVgQM61xiOKvY125GLTEIB.Zi0h09JhZjSh4aP.HG', 1000, 1, 28, "false") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (2, 'Bob', 'Muster', '$2b$10$cnbI95MxTXoS0ICCRzjK0ePcbzxfrBCnwVC.oyjkkqSmOgAHI/eZS', 1001, 1, 30, "true") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (3, 'Carsten', 'Stern', '$2a$10$IfTwGWhx/v6Um13v2YdG9.yWvfzWlqreLg0x./aJ0f/dC4b9W4vL.', 1002, 1, 30, "true") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (4, 'Hans', 'Test', '$2b$10$dQ7hittq9Ui28c5birItf.ZA8uaogLkL8XWubBqA457u7yMHRl//.', 1011, 2, 25, "true") "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.users ("id", "first_name", "last_name", "password", "employee_id", "company_id", "holidays", "is_admin") "VALUES" (50, 'Hans', 'Meier', '$2b$10$C1ldW17Kknmx9SFPK095uuCyB.0imEsI.0JI7bS0JNE7AAsjZuQKC', 1012, 1, 30, "false") "ON" CONFLICT "DO" NOTHING;


--
-- "Data" for Name: shifts; Type: "TABLE" DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (161, '2025-06-10', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (162, '2025-06-11', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (163, '2025-06-12', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (164, '2025-06-13', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (165, '2025-06-14', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (166, '2025-06-15', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (167, '2025-06-16', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (168, '2025-06-17', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (169, '2025-06-18', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (170, '2025-06-19', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (171, '2025-06-20', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (172, '2025-06-21', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (173, '2025-06-22', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (174, '2025-06-23', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (175, '2025-06-24', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (176, '2025-06-25', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (177, '2025-06-26', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (178, '2025-06-27', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (179, '2025-06-28', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (180, '2025-06-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (181, '2025-06-30', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (182, '2025-07-01', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (183, '2025-07-02', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (184, '2025-07-03', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (185, '2025-07-04', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (186, '2025-07-05', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (187, '2025-07-06', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (188, '2025-07-07', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (189, '2025-07-08', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (190, '2025-07-09', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (191, '2025-07-10', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (192, '2025-07-11', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (193, '2025-07-12', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (194, '2025-07-13', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (195, '2025-07-14', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (196, '2025-07-15', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (197, '2025-07-16', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (198, '2025-07-17', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (199, '2025-07-18', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (200, '2025-07-19', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (366, '2025-01-01', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (367, '2025-01-02', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (368, '2025-01-03', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (369, '2025-01-04', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (370, '2025-01-05', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (371, '2025-01-06', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (372, '2025-01-07', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (373, '2025-01-08', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (374, '2025-01-09', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (375, '2025-01-10', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (376, '2025-01-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (377, '2025-01-12', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (378, '2025-01-13', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (379, '2025-01-14', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (380, '2025-01-15', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (381, '2025-01-16', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (382, '2025-01-17', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (383, '2025-01-18', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (384, '2025-01-19', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (385, '2025-01-20', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (386, '2025-01-21', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (387, '2025-01-22', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (388, '2025-01-23', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (389, '2025-01-24', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (390, '2025-01-25', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (391, '2025-01-26', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (392, '2025-01-27', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (393, '2025-01-28', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (394, '2025-01-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (395, '2025-01-30', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (396, '2025-01-31', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (397, '2025-02-01', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (398, '2025-02-02', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (399, '2025-02-03', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (400, '2025-02-04', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (401, '2025-02-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (402, '2025-02-06', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (403, '2025-02-07', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (404, '2025-02-08', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (405, '2025-02-09', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (406, '2025-02-10', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (407, '2025-02-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (408, '2025-02-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (409, '2025-02-13', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (410, '2025-02-14', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (411, '2025-02-15', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (412, '2025-02-16', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (413, '2025-02-17', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (414, '2025-02-18', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (415, '2025-02-19', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (416, '2025-02-20', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (417, '2025-02-21', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (418, '2025-02-22', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (419, '2025-02-23', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (420, '2025-02-24', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (421, '2025-02-25', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (422, '2025-02-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (423, '2025-02-27', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (424, '2025-02-28', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (425, '2025-03-01', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (426, '2025-03-02', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (427, '2025-03-03', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (428, '2025-03-04', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (429, '2025-03-05', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (430, '2025-03-06', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (431, '2025-03-07', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (432, '2025-03-08', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (433, '2025-03-09', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (434, '2025-03-10', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (435, '2025-03-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (436, '2025-03-12', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (437, '2025-03-13', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (438, '2025-03-14', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (439, '2025-03-15', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (440, '2025-03-16', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (441, '2025-03-17', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (442, '2025-03-18', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (443, '2025-03-19', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (444, '2025-03-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (445, '2025-03-21', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (446, '2025-03-22', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (447, '2025-03-23', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (448, '2025-03-24', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (449, '2025-03-25', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (450, '2025-03-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (451, '2025-03-27', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (452, '2025-03-28', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (453, '2025-03-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (454, '2025-03-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (455, '2025-03-31', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (456, '2025-04-01', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (457, '2025-04-02', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (458, '2025-04-03', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (459, '2025-04-04', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (460, '2025-04-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (461, '2025-04-06', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (462, '2025-04-07', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (463, '2025-04-08', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (464, '2025-04-09', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (465, '2025-04-10', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (466, '2025-04-11', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (467, '2025-04-12', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (468, '2025-04-13', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (469, '2025-04-14', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (470, '2025-04-15', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (471, '2025-04-16', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (472, '2025-04-17', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (473, '2025-04-18', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (474, '2025-04-19', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (475, '2025-04-20', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (476, '2025-04-21', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (477, '2025-04-22', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (478, '2025-04-23', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (479, '2025-04-24', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (480, '2025-04-25', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (481, '2025-04-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (482, '2025-04-27', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (483, '2025-04-28', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (484, '2025-04-29', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (485, '2025-04-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (486, '2025-05-01', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (487, '2025-05-02', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (488, '2025-05-03', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (489, '2025-05-04', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (490, '2025-05-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (491, '2025-05-06', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (492, '2025-05-07', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (493, '2025-05-08', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (494, '2025-05-09', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (495, '2025-05-10', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (496, '2025-05-11', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (497, '2025-05-12', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (498, '2025-05-13', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (499, '2025-05-14', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (500, '2025-05-15', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (501, '2025-05-16', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (502, '2025-05-17', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (503, '2025-05-18', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (504, '2025-05-19', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (505, '2025-05-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (506, '2025-05-21', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (507, '2025-05-22', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (508, '2025-05-23', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (509, '2025-05-24', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (510, '2025-05-25', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (511, '2025-05-26', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (512, '2025-05-27', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (513, '2025-05-28', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (514, '2025-05-29', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (515, '2025-05-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (516, '2025-05-31', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (517, '2025-06-01', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (518, '2025-06-02', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (519, '2025-06-03', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (520, '2025-06-04', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (521, '2025-06-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (522, '2025-06-06', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (523, '2025-06-07', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (524, '2025-06-08', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (525, '2025-06-09', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (526, '2025-06-10', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (527, '2025-06-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (528, '2025-06-12', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (529, '2025-06-13', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (530, '2025-06-14', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (531, '2025-06-15', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (532, '2025-06-16', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (533, '2025-06-17', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (534, '2025-06-18', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (535, '2025-06-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (536, '2025-06-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (537, '2025-06-21', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (538, '2025-06-22', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (539, '2025-06-23', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (540, '2025-06-24', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (541, '2025-06-25', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (542, '2025-06-26', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (543, '2025-06-27', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (544, '2025-06-28', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (545, '2025-06-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (546, '2025-06-30', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (547, '2025-07-01', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (548, '2025-07-02', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (549, '2025-07-03', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (550, '2025-07-04', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (551, '2025-07-05', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (552, '2025-07-06', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (553, '2025-07-07', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (554, '2025-07-08', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (555, '2025-07-09', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (556, '2025-07-10', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (557, '2025-07-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (558, '2025-07-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (559, '2025-07-13', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (560, '2025-07-14', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (561, '2025-07-15', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (562, '2025-07-16', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (563, '2025-07-17', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (564, '2025-07-18', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (565, '2025-07-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (566, '2025-07-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (567, '2025-07-21', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (568, '2025-07-22', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (569, '2025-07-23', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (570, '2025-07-24', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (571, '2025-07-25', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (572, '2025-07-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (573, '2025-07-27', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (574, '2025-07-28', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (575, '2025-07-29', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (576, '2025-07-30', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (577, '2025-07-31', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (578, '2025-08-01', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (579, '2025-08-02', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (580, '2025-08-03', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (581, '2025-08-04', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (582, '2025-08-05', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (584, '2025-08-07', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (585, '2025-08-08', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (586, '2025-08-09', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (587, '2025-08-10', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (588, '2025-08-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (589, '2025-08-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (590, '2025-08-13', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (591, '2025-08-14', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (592, '2025-08-15', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (593, '2025-08-16', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (594, '2025-08-17', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (595, '2025-08-18', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (596, '2025-08-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (597, '2025-08-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (598, '2025-08-21', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (599, '2025-08-22', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (600, '2025-08-23', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (601, '2025-08-24', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (602, '2025-08-25', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (603, '2025-08-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (604, '2025-08-27', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (605, '2025-08-28', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (606, '2025-08-29', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (607, '2025-08-30', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (608, '2025-08-31', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (609, '2025-09-01', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (610, '2025-09-02', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (611, '2025-09-03', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (612, '2025-09-04', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (613, '2025-09-05', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (614, '2025-09-06', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (615, '2025-09-07', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (616, '2025-09-08', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (617, '2025-09-09', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (618, '2025-09-10', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (619, '2025-09-11', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (620, '2025-09-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (621, '2025-09-13', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (622, '2025-09-14', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (623, '2025-09-15', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (624, '2025-09-16', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (625, '2025-09-17', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (626, '2025-09-18', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (627, '2025-09-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (628, '2025-09-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (629, '2025-09-21', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (630, '2025-09-22', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (631, '2025-09-23', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (632, '2025-09-24', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (633, '2025-09-25', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (634, '2025-09-26', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (635, '2025-09-27', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (636, '2025-09-28', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (637, '2025-09-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (638, '2025-09-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (639, '2025-10-01', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (640, '2025-10-02', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (641, '2025-10-03', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (642, '2025-10-04', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (643, '2025-10-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (644, '2025-10-06', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (645, '2025-10-07', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (646, '2025-10-08', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (647, '2025-10-09', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (648, '2025-10-10', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (649, '2025-10-11', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (650, '2025-10-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (651, '2025-10-13', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (583, '2025-08-06', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (652, '2025-10-14', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (653, '2025-10-15', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (654, '2025-10-16', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (655, '2025-10-17', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (656, '2025-10-18', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (657, '2025-10-19', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (658, '2025-10-20', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (659, '2025-10-21', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (660, '2025-10-22', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (661, '2025-10-23', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (662, '2025-10-24', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (663, '2025-10-25', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (664, '2025-10-26', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (665, '2025-10-27', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (666, '2025-10-28', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (667, '2025-10-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (668, '2025-10-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (669, '2025-10-31', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (670, '2025-11-01', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (671, '2025-11-02', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (672, '2025-11-03', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (673, '2025-11-04', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (674, '2025-11-05', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (675, '2025-11-06', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (676, '2025-11-07', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (677, '2025-11-08', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (678, '2025-11-09', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (679, '2025-11-10', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (680, '2025-11-11', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (681, '2025-11-12', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (682, '2025-11-13', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (683, '2025-11-14', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (684, '2025-11-15', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (685, '2025-11-16', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (686, '2025-11-17', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (687, '2025-11-18', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (688, '2025-11-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (689, '2025-11-20', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (690, '2025-11-21', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (691, '2025-11-22', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (692, '2025-11-23', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (693, '2025-11-24', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (694, '2025-11-25', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (695, '2025-11-26', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (696, '2025-11-27', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (697, '2025-11-28', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (698, '2025-11-29', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (699, '2025-11-30', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (700, '2025-12-01', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (701, '2025-12-02', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (702, '2025-12-03', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (703, '2025-12-04', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (704, '2025-12-05', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (705, '2025-12-06', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (706, '2025-12-07', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (707, '2025-12-08', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (708, '2025-12-09', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (709, '2025-12-10', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (710, '2025-12-11', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (711, '2025-12-12', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (712, '2025-12-13', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (713, '2025-12-14', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (714, '2025-12-15', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (715, '2025-12-16', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (716, '2025-12-17', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (717, '2025-12-18', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (718, '2025-12-19', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (719, '2025-12-20', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (720, '2025-12-21', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (721, '2025-12-22', 2, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (722, '2025-12-23', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (723, '2025-12-24', 4, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (724, '2025-12-25', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (725, '2025-12-26', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (726, '2025-12-27', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (727, '2025-12-28', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (728, '2025-12-29', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (729, '2025-12-30', 5, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (730, '2025-12-31', 1, 2) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (731, '2025-01-01', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (732, '2025-01-02', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (733, '2025-01-03', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (734, '2025-01-04', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (735, '2025-01-05', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (736, '2025-01-06', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (737, '2025-01-07', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (738, '2025-01-08', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (739, '2025-01-09', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (740, '2025-01-10', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (741, '2025-01-11', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (742, '2025-01-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (743, '2025-01-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (744, '2025-01-14', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (745, '2025-01-15', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (746, '2025-01-16', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (747, '2025-01-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (748, '2025-01-18', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (749, '2025-01-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (750, '2025-01-20', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (751, '2025-01-21', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (752, '2025-01-22', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (753, '2025-01-23', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (754, '2025-01-24', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (755, '2025-01-25', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (756, '2025-01-26', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (757, '2025-01-27', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (758, '2025-01-28', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (759, '2025-01-29', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (760, '2025-01-30', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (761, '2025-01-31', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (762, '2025-02-01', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (763, '2025-02-02', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (764, '2025-02-03', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (765, '2025-02-04', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (766, '2025-02-05', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (767, '2025-02-06', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (768, '2025-02-07', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (769, '2025-02-08', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (770, '2025-02-09', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (771, '2025-02-10', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (772, '2025-02-11', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (773, '2025-02-12', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (774, '2025-02-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (775, '2025-02-14', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (776, '2025-02-15', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (777, '2025-02-16', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (778, '2025-02-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (779, '2025-02-18', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (780, '2025-02-19', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (781, '2025-02-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (782, '2025-02-21', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (783, '2025-02-22', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (784, '2025-02-23', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (785, '2025-02-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (786, '2025-02-25', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (787, '2025-02-26', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (788, '2025-02-27', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (789, '2025-02-28', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (790, '2025-03-01', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (791, '2025-03-02', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (792, '2025-03-03', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (793, '2025-03-04', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (794, '2025-03-05', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (795, '2025-03-06', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (796, '2025-03-07', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (797, '2025-03-08', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (798, '2025-03-09', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (799, '2025-03-10', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (800, '2025-03-11', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (801, '2025-03-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (802, '2025-03-13', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (803, '2025-03-14', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (804, '2025-03-15', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (805, '2025-03-16', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (806, '2025-03-17', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (807, '2025-03-18', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (808, '2025-03-19', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (809, '2025-03-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (810, '2025-03-21', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (811, '2025-03-22', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (812, '2025-03-23', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (813, '2025-03-24', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (814, '2025-03-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (815, '2025-03-26', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (816, '2025-03-27', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (817, '2025-03-28', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (818, '2025-03-29', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (819, '2025-03-30', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (820, '2025-03-31', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (821, '2025-04-01', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (822, '2025-04-02', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (823, '2025-04-03', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (824, '2025-04-04', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (825, '2025-04-05', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (826, '2025-04-06', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (827, '2025-04-07', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (828, '2025-04-08', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (829, '2025-04-09', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (830, '2025-04-10', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (831, '2025-04-11', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (832, '2025-04-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (69, '2025-03-10', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (70, '2025-03-11', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (833, '2025-04-13', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (834, '2025-04-14', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (835, '2025-04-15', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (836, '2025-04-16', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (837, '2025-04-17', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (838, '2025-04-18', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (839, '2025-04-19', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (840, '2025-04-20', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (841, '2025-04-21', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (842, '2025-04-22', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (843, '2025-04-23', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (844, '2025-04-24', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (845, '2025-04-25', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (846, '2025-04-26', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (847, '2025-04-27', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (848, '2025-04-28', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (849, '2025-04-29', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (850, '2025-04-30', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (851, '2025-05-01', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (852, '2025-05-02', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (853, '2025-05-03', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (854, '2025-05-04', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (855, '2025-05-05', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (856, '2025-05-06', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (857, '2025-05-07', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (858, '2025-05-08', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (859, '2025-05-09', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (860, '2025-05-10', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (861, '2025-05-11', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (862, '2025-05-12', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (863, '2025-05-13', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (864, '2025-05-14', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (865, '2025-05-15', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (866, '2025-05-16', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (867, '2025-05-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (868, '2025-05-18', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (869, '2025-05-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (870, '2025-05-20', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (871, '2025-05-21', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (872, '2025-05-22', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (873, '2025-05-23', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (874, '2025-05-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (875, '2025-05-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (876, '2025-05-26', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (877, '2025-05-27', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (878, '2025-05-28', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (879, '2025-05-29', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (880, '2025-05-30', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (881, '2025-05-31', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (882, '2025-06-01', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (883, '2025-06-02', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (884, '2025-06-03', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (885, '2025-06-04', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (886, '2025-06-05', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (887, '2025-06-06', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (888, '2025-06-07', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (889, '2025-06-08', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (890, '2025-06-09', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (891, '2025-06-10', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (892, '2025-06-11', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (893, '2025-06-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (894, '2025-06-13', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (895, '2025-06-14', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (896, '2025-06-15', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (897, '2025-06-16', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (898, '2025-06-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (899, '2025-06-18', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (900, '2025-06-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (901, '2025-06-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (902, '2025-06-21', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (903, '2025-06-22', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (904, '2025-06-23', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (905, '2025-06-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (906, '2025-06-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (907, '2025-06-26', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (908, '2025-06-27', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (909, '2025-06-28', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (910, '2025-06-29', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (911, '2025-06-30', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (912, '2025-07-01', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (913, '2025-07-02', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (914, '2025-07-03', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (915, '2025-07-04', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (916, '2025-07-05', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (917, '2025-07-06', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (918, '2025-07-07', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (919, '2025-07-08', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (920, '2025-07-09', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (921, '2025-07-10', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (922, '2025-07-11', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (923, '2025-07-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (924, '2025-07-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (925, '2025-07-14', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (926, '2025-07-15', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (927, '2025-07-16', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (928, '2025-07-17', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (929, '2025-07-18', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (930, '2025-07-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (931, '2025-07-20', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (932, '2025-07-21', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (933, '2025-07-22', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (934, '2025-07-23', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (935, '2025-07-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (936, '2025-07-25', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (937, '2025-07-26', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (939, '2025-07-28', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (940, '2025-07-29', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (941, '2025-07-30', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (942, '2025-07-31', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (943, '2025-08-01', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (944, '2025-08-02', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (945, '2025-08-03', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (946, '2025-08-04', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (947, '2025-08-05', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (948, '2025-08-06', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (949, '2025-08-07', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (950, '2025-08-08', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (951, '2025-08-09', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (952, '2025-08-10', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (953, '2025-08-11', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (954, '2025-08-12', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (955, '2025-08-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (956, '2025-08-14', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (957, '2025-08-15', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (958, '2025-08-16', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (959, '2025-08-17', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (960, '2025-08-18', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (961, '2025-08-19', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (962, '2025-08-20', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (963, '2025-08-21', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (964, '2025-08-22', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (965, '2025-08-23', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (966, '2025-08-24', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (967, '2025-08-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (968, '2025-08-26', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (969, '2025-08-27', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (970, '2025-08-28', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (971, '2025-08-29', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (972, '2025-08-30', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (973, '2025-08-31', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (974, '2025-09-01', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (975, '2025-09-02', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (976, '2025-09-03', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (977, '2025-09-04', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (978, '2025-09-05', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (979, '2025-09-06', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (980, '2025-09-07', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (981, '2025-09-08', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (982, '2025-09-09', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (983, '2025-09-10', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (984, '2025-09-11', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (985, '2025-09-12', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (986, '2025-09-13', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (987, '2025-09-14', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (988, '2025-09-15', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (989, '2025-09-16', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (990, '2025-09-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (991, '2025-09-18', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (992, '2025-09-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (993, '2025-09-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (994, '2025-09-21', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (995, '2025-09-22', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (996, '2025-09-23', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (997, '2025-09-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (998, '2025-09-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (999, '2025-09-26', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1000, '2025-09-27', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1001, '2025-09-28', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1002, '2025-09-29', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1003, '2025-09-30', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1004, '2025-10-01', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1005, '2025-10-02', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1006, '2025-10-03', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1007, '2025-10-04', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1008, '2025-10-05', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1009, '2025-10-06', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1010, '2025-10-07', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1011, '2025-10-08', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1012, '2025-10-09', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1013, '2025-10-10', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1014, '2025-10-11', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1015, '2025-10-12', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1016, '2025-10-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1017, '2025-10-14', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1018, '2025-10-15', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1019, '2025-10-16', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (938, '2025-07-27', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (71, '2025-03-12', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (72, '2025-03-13', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (73, '2025-03-14', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (74, '2025-03-15', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (75, '2025-03-16', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (76, '2025-03-17', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (77, '2025-03-18', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (78, '2025-03-19', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (79, '2025-03-20', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (80, '2025-03-21', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (81, '2025-03-22', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (82, '2025-03-23', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (83, '2025-03-24', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (84, '2025-03-25', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (85, '2025-03-26', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (86, '2025-03-27', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (87, '2025-03-28', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (88, '2025-03-29', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (89, '2025-03-30', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (90, '2025-03-31', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (91, '2025-04-01', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (92, '2025-04-02', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (93, '2025-04-03', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (94, '2025-04-04', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (95, '2025-04-05', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (96, '2025-04-06', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (97, '2025-04-07', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (98, '2025-04-08', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (99, '2025-04-09', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (100, '2025-04-10', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (101, '2025-04-11', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (102, '2025-04-12', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (103, '2025-04-13', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (104, '2025-04-14', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (105, '2025-04-15', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (106, '2025-04-16', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (107, '2025-04-17', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (108, '2025-04-18', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (109, '2025-04-19', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (110, '2025-04-20', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (111, '2025-04-21', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (112, '2025-04-22', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (113, '2025-04-23', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (114, '2025-04-24', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (115, '2025-04-25', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (116, '2025-04-26', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (117, '2025-04-27', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (118, '2025-04-28', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (119, '2025-04-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (120, '2025-04-30', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (121, '2025-05-01', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (122, '2025-05-02', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (123, '2025-05-03', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (124, '2025-05-04', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (125, '2025-05-05', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (126, '2025-05-06', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (127, '2025-05-07', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (128, '2025-05-08', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (129, '2025-05-09', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (130, '2025-05-10', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (131, '2025-05-11', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (132, '2025-05-12', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (133, '2025-05-13', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (134, '2025-05-14', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (135, '2025-05-15', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (136, '2025-05-16', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (137, '2025-05-17', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (138, '2025-05-18', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (139, '2025-05-19', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (140, '2025-05-20', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (141, '2025-05-21', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (142, '2025-05-22', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (143, '2025-05-23', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (144, '2025-05-24', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (145, '2025-05-25', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (146, '2025-05-26', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (147, '2025-05-27', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (148, '2025-05-28', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (149, '2025-05-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (150, '2025-05-30', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (151, '2025-05-31', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (152, '2025-06-01', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (153, '2025-06-02', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (154, '2025-06-03', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (155, '2025-06-04', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (156, '2025-06-05', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (157, '2025-06-06', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (158, '2025-06-07', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (159, '2025-06-08', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (160, '2025-06-09', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1020, '2025-10-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1021, '2025-10-18', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1022, '2025-10-19', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1023, '2025-10-20', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1024, '2025-10-21', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1025, '2025-10-22', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1026, '2025-10-23', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1027, '2025-10-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1028, '2025-10-25', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1029, '2025-10-26', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1030, '2025-10-27', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1031, '2025-10-28', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1032, '2025-10-29', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1033, '2025-10-30', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1034, '2025-10-31', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1035, '2025-11-01', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1036, '2025-11-02', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1037, '2025-11-03', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1044, '2025-11-10', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1045, '2025-11-11', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1046, '2025-11-12', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1047, '2025-11-13', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1048, '2025-11-14', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1049, '2025-11-15', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1050, '2025-11-16', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1051, '2025-11-17', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1052, '2025-11-18', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1053, '2025-11-19', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1054, '2025-11-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1055, '2025-11-21', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1056, '2025-11-22', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1057, '2025-11-23', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1058, '2025-11-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1059, '2025-11-25', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1060, '2025-11-26', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1061, '2025-11-27', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1062, '2025-11-28', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1063, '2025-11-29', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1064, '2025-11-30', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1065, '2025-12-01', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1066, '2025-12-02', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1067, '2025-12-03', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1068, '2025-12-04', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1069, '2025-12-05', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1070, '2025-12-06', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1071, '2025-12-07', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1072, '2025-12-08', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1073, '2025-12-09', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1074, '2025-12-10', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1075, '2025-12-11', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1076, '2025-12-12', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1077, '2025-12-13', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1078, '2025-12-14', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1079, '2025-12-15', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1080, '2025-12-16', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1081, '2025-12-17', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1082, '2025-12-18', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1083, '2025-12-19', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1084, '2025-12-20', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1085, '2025-12-21', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1086, '2025-12-22', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1087, '2025-12-23', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1088, '2025-12-24', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1089, '2025-12-25', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1090, '2025-12-26', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1091, '2025-12-27', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1092, '2025-12-28', 4, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1093, '2025-12-29', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1094, '2025-12-30', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1095, '2025-12-31', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1268, '2025-11-04', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1043, '2025-11-09', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1042, '2025-11-08', 5, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1266, '2025-11-05', 1, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1269, '2025-11-06', 2, 3) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1096, '2025-07-20', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1097, '2025-07-21', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1098, '2025-07-22', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1099, '2025-07-23', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1100, '2025-07-24', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1101, '2025-07-25', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1102, '2025-07-26', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1103, '2025-07-27', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1104, '2025-07-28', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1105, '2025-07-29', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1106, '2025-07-30', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1107, '2025-07-31', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1108, '2025-08-01', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1109, '2025-08-02', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1110, '2025-08-03', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1111, '2025-08-04', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1112, '2025-08-05', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1113, '2025-08-06', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1114, '2025-08-07', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1115, '2025-08-08', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1116, '2025-08-09', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1117, '2025-08-10', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1118, '2025-08-11', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1119, '2025-08-12', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1120, '2025-08-13', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1121, '2025-08-14', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1122, '2025-08-15', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1123, '2025-08-16', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1124, '2025-08-17', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1125, '2025-08-18', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1126, '2025-08-19', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1127, '2025-08-20', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1128, '2025-08-21', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1129, '2025-08-22', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1130, '2025-08-23', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1131, '2025-08-24', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1132, '2025-08-25', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1133, '2025-08-26', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1134, '2025-08-27', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1135, '2025-08-28', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1136, '2025-08-29', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1137, '2025-08-30', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1138, '2025-08-31', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1139, '2025-09-01', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1140, '2025-09-02', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1141, '2025-09-03', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1142, '2025-09-04', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1143, '2025-09-05', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1144, '2025-09-06', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1145, '2025-09-07', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1146, '2025-09-08', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1147, '2025-09-09', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1148, '2025-09-10', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1149, '2025-09-11', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1150, '2025-09-12', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1151, '2025-09-13', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1152, '2025-09-14', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1153, '2025-09-15', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1154, '2025-09-16', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1155, '2025-09-17', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1156, '2025-09-18', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1157, '2025-09-19', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1158, '2025-09-20', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1159, '2025-09-21', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1160, '2025-09-22', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1161, '2025-09-23', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1162, '2025-09-24', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1163, '2025-09-25', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1164, '2025-09-26', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1165, '2025-09-27', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1166, '2025-09-28', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1167, '2025-09-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1168, '2025-09-30', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1169, '2025-10-01', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1170, '2025-10-02', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1171, '2025-10-03', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1172, '2025-10-04', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1173, '2025-10-05', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1174, '2025-10-06', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1175, '2025-10-07', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1176, '2025-10-08', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1177, '2025-10-09', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1178, '2025-10-10', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1179, '2025-10-11', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1180, '2025-10-12', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1181, '2025-10-13', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1182, '2025-10-14', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1183, '2025-10-15', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1184, '2025-10-16', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1185, '2025-10-17', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1186, '2025-10-18', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1187, '2025-10-19', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1188, '2025-10-20', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1189, '2025-10-21', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1190, '2025-10-22', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1191, '2025-10-23', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1192, '2025-10-24', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1193, '2025-10-25', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1194, '2025-10-26', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1195, '2025-10-27', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1196, '2025-10-28', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1197, '2025-10-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1198, '2025-10-30', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1199, '2025-10-31', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1200, '2025-11-01', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1201, '2025-11-02', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1202, '2025-11-03', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1203, '2025-11-04', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1204, '2025-11-05', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1205, '2025-11-06', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1206, '2025-11-07', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1207, '2025-11-08', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1208, '2025-11-09', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1209, '2025-11-10', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1210, '2025-11-11', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1211, '2025-11-12', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1212, '2025-11-13', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1213, '2025-11-14', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1214, '2025-11-15', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1215, '2025-11-16', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1216, '2025-11-17', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1217, '2025-11-18', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1218, '2025-11-19', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1219, '2025-11-20', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1220, '2025-11-21', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1221, '2025-11-22', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1222, '2025-11-23', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1223, '2025-11-24', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1224, '2025-11-25', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1225, '2025-11-26', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1226, '2025-11-27', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1227, '2025-11-28', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1228, '2025-11-29', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1229, '2025-11-30', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1230, '2025-12-01', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1231, '2025-12-02', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1232, '2025-12-03', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1233, '2025-12-04', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1234, '2025-12-05', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1235, '2025-12-06', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1236, '2025-12-07', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1237, '2025-12-08', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1238, '2025-12-09', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1239, '2025-12-10', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1240, '2025-12-11', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1241, '2025-12-12', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1242, '2025-12-13', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1243, '2025-12-14', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1244, '2025-12-15', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1245, '2025-12-16', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1246, '2025-12-17', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1247, '2025-12-18', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1248, '2025-12-19', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1249, '2025-12-20', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1250, '2025-12-21', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1251, '2025-12-22', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1252, '2025-12-23', 5, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1253, '2025-12-24', 4, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1254, '2025-12-25', 2, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1255, '2025-12-26', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1256, '2025-12-27', 1, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1257, '2025-12-28', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1258, '2025-12-29', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1259, '2025-12-30', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1260, '2025-12-31', 3, 1) "ON" CONFLICT "DO" NOTHING;
INSERT "INTO" public.shifts ("id", "shift_date", "shift_type_id", "user_id") "VALUES" (1270, '2025-11-07', 4, 3) "ON" CONFLICT "DO" NOTHING;


--
-- Name: shift_types_id_seq; Type: "SEQUENCE" SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.shift_types_id_seq', 5, "true") "ON" CONFLICT "DO" NOTHING;


--
-- Name: shifts_id_seq; Type: "SEQUENCE" SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.shifts_id_seq', 1270, "true") "ON" CONFLICT "DO" NOTHING;


--
-- Name: users_id_seq; Type: "SEQUENCE" SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 50, "true") "ON" CONFLICT "DO" NOTHING;


--
-- "PostgreSQL" database "dump" complete
--


