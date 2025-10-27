-- PostgreSQL database dump - Überarbeitet für die direkte Ausführung per Skript

-- Grundeinstellungen für die Sitzung
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

-- Bestehende Tabellen und Sequenzen sicher löschen, um Konflikte zu vermeiden
DROP TABLE IF EXISTS public.shifts CASCADE;
DROP TABLE IF EXISTS public.shift_types CASCADE;
DROP TABLE IF EXISTS public.users CASCADE;
DROP SEQUENCE IF EXISTS public.shifts_id_seq CASCADE;
DROP SEQUENCE IF EXISTS public.shift_types_id_seq CASCADE;
DROP SEQUENCE IF EXISTS public.users_id_seq CASCADE;


--
-- Tabelle: users
--
CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    password character varying(255),
    employee_id integer NOT NULL
);

CREATE SEQUENCE public.users_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);

--
-- Tabelle: shift_types
-- (Ergänzt um Spalten, die in der API verwendet werden)
--
CREATE TABLE public.shift_types (
    id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    type_color BIGINT DEFAULT 16777215, -- Standardfarbe: Weiß
    type_time_start TIME,
    type_time_end TIME
);

CREATE SEQUENCE public.shift_types_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.shift_types_id_seq OWNED BY public.shift_types.id;
ALTER TABLE ONLY public.shift_types ALTER COLUMN id SET DEFAULT nextval('public.shift_types_id_seq'::regclass);


--
-- Tabelle: shifts
--
CREATE TABLE public.shifts (
    id integer NOT NULL,
    shift_date date NOT NULL,
    shift_type_id integer NOT NULL,
    user_id integer NOT NULL
);

CREATE SEQUENCE public.shifts_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;
ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- Daten einfügen für: shift_types
-- (Ersetzt den COPY-Befehl durch INSERT)
--
INSERT INTO public.shift_types (id, type_name) VALUES
(1, 'Frühschicht'),
(2, 'Spätschicht'),
(3, 'Nachtschicht'),
(4, 'Krank'),
(5, 'Urlaub');


--
-- Daten einfügen für: shifts
-- (Ersetzt den COPY-Befehl durch INSERT)
-- WICHTIG: Die user_id '1' und '2' müssen in der 'users'-Tabelle existieren.
-- Füge hier bei Bedarf zuerst deine Benutzer ein.
-- Beispiel:
-- INSERT INTO public.users (id, first_name, last_name, employee_id, password) VALUES
-- (1, 'Max', 'Mustermann', 101, '$2b$10$...'), -- Passwort muss gehasht sein
-- (2, 'Erika', 'Mustermann', 102, '$2b$10$...');

INSERT INTO public.shifts (id, shift_date, shift_type_id, user_id) VALUES
(161, '2025-06-10', 5, 1),
(162, '2025-06-11', 4, 1),
(163, '2025-06-12', 5, 1),
(164, '2025-06-13', 5, 1),
(165, '2025-06-14', 2, 1),
(166, '2025-06-15', 5, 1),
(167, '2025-06-16', 2, 1),
(168, '2025-06-17', 5, 1),
(169, '2025-06-18', 4, 1),
(170, '2025-06-19', 4, 1),
(171, '2025-06-20', 2, 1),
(172, '2025-06-21', 1, 1),
(173, '2025-06-22', 1, 1),
(174, '2025-06-23', 1, 1),
(175, '2025-06-24', 5, 1),
(176, '2025-06-25', 2, 1),
(177, '2025-06-26', 4, 1),
(178, '2025-06-27', 1, 1),
(179, '2025-06-28', 5, 1),
(180, '2025-06-29', 1, 1),
(181, '2025-06-30', 2, 1),
(182, '2025-07-01', 1, 1),
(183, '2025-07-02', 1, 1),
(184, '2025-07-03', 1, 1),
(185, '2025-07-04', 5, 1),
(186, '2025-07-05', 1, 1),
(187, '2025-07-06', 4, 1),
(188, '2025-07-07', 2, 1),
(189, '2025-07-08', 5, 1),
(190, '2025-07-09', 1, 1),
(191, '2025-07-10', 5, 1),
(192, '2025-07-11', 1, 1),
(193, '2025-07-12', 5, 1),
(194, '2025-07-13', 2, 1),
(195, '2025-07-14', 5, 1),
(196, '2025-07-15', 2, 1),
(197, '2025-07-16', 1, 1),
(198, '2025-07-17', 2, 1),
(199, '2025-07-18', 5, 1),
(200, '2025-07-19', 1, 1),
(366, '2025-01-01', 5, 2),
(367, '2025-01-02', 2, 2),
(368, '2025-01-03', 1, 2),
(369, '2025-01-04', 5, 2),
(370, '2025-01-05', 2, 2),
(371, '2025-01-06', 5, 2),
(372, '2025-01-07', 1, 2),
(373, '2025-01-08', 4, 2),
(374, '2025-01-09', 5, 2),
(375, '2025-01-10', 1, 2),
(376, '2025-01-11', 1, 2),
(377, '2025-01-12', 5, 2),
(378, '2025-01-13', 4, 2),
(379, '2025-01-14', 1, 2),
(380, '2025-01-15', 5, 2),
(381, '2025-01-16', 5, 2),
(382, '2025-01-17', 2, 2),
(383, '2025-01-18', 1, 2),
(384, '2025-01-19', 1, 2),
(385, '2025-01-20', 5, 2),
(386, '2025-01-21', 5, 2),
(387, '2025-01-22', 4, 2),
(388, '2025-01-23', 2, 2),
(389, '2025-01-24', 5, 2),
(390, '2025-01-25', 5, 2),
(391, '2025-01-26', 1, 2);
-- (...füge hier bei Bedarf die restlichen Daten für 'shifts' ein)


--
-- Fremdschlüssel-Beziehungen definieren
--
ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_shift_type_id_fkey FOREIGN KEY (shift_type_id) REFERENCES public.shift_types(id);

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Primärschlüssel definieren
--
ALTER TABLE ONLY public.shift_types
    ADD CONSTRAINT shift_types_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

-- Eindeutigkeit für employee_id sicherstellen
ALTER TABLE public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


-- Setzt die Sequenzen auf den höchsten aktuellen Wert in den Tabellen,
-- damit neue INSERTS nach dem Seeding keine Konflikte verursachen.
SELECT setval('public.users_id_seq', COALESCE((SELECT MAX(id) FROM public.users), 1), true);
SELECT setval('public.shift_types_id_seq', COALESCE((SELECT MAX(id) FROM public.shift_types), 1), true);
SELECT setval('public.shifts_id_seq', COALESCE((SELECT MAX(id) FROM public.shifts), 1), true);