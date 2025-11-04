--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6 (Debian 17.6-1.pgdg12+1)
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

ALTER TABLE IF EXISTS ONLY public.shifts DROP CONSTRAINT IF EXISTS shifts_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shifts DROP CONSTRAINT IF EXISTS shifts_shift_type_id_fkey;
ALTER TABLE IF EXISTS ONLY public.shifts DROP CONSTRAINT IF EXISTS fk_user;
ALTER TABLE IF EXISTS ONLY public.shifts DROP CONSTRAINT IF EXISTS fk_shift_type;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_employee_id_key;
ALTER TABLE IF EXISTS ONLY public.shifts DROP CONSTRAINT IF EXISTS shifts_pkey;
ALTER TABLE IF EXISTS ONLY public.shift_types DROP CONSTRAINT IF EXISTS shift_types_pkey;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.shifts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.shift_types ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.shifts_id_seq;
DROP TABLE IF EXISTS public.shifts;
DROP SEQUENCE IF EXISTS public.shift_types_id_seq;
DROP TABLE IF EXISTS public.shift_types;
DROP TABLE IF EXISTS public.companies;
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: shift_schedule_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO shift_schedule_db_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: companies; Type: TABLE; Schema: public; Owner: shift_schedule_db_user
--

CREATE TABLE public.companies (
    id integer,
    name character varying(100),
    holidays_default integer
);


ALTER TABLE public.companies OWNER TO shift_schedule_db_user;

--
-- Name: shift_types; Type: TABLE; Schema: public; Owner: shift_schedule_db_user
--

CREATE TABLE public.shift_types (
    id integer NOT NULL,
    type_name character varying(50) NOT NULL,
    type_color bigint DEFAULT 16777215,
    type_time_start time without time zone,
    type_time_end time without time zone
);


ALTER TABLE public.shift_types OWNER TO shift_schedule_db_user;

--
-- Name: shift_types_id_seq; Type: SEQUENCE; Schema: public; Owner: shift_schedule_db_user
--

CREATE SEQUENCE public.shift_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shift_types_id_seq OWNER TO shift_schedule_db_user;

--
-- Name: shift_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shift_schedule_db_user
--

ALTER SEQUENCE public.shift_types_id_seq OWNED BY public.shift_types.id;


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: shift_schedule_db_user
--

CREATE TABLE public.shifts (
    id integer NOT NULL,
    shift_date date NOT NULL,
    shift_type_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.shifts OWNER TO shift_schedule_db_user;

--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: shift_schedule_db_user
--

CREATE SEQUENCE public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shifts_id_seq OWNER TO shift_schedule_db_user;

--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shift_schedule_db_user
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: shift_schedule_db_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    password character varying(255),
    employee_id integer NOT NULL,
    company_id integer,
    holidays integer,
    isadmin boolean
);


ALTER TABLE public.users OWNER TO shift_schedule_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: shift_schedule_db_user
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO shift_schedule_db_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shift_schedule_db_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: shift_types id; Type: DEFAULT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shift_types ALTER COLUMN id SET DEFAULT nextval('public.shift_types_id_seq'::regclass);


--
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT INTO public.companies VALUES (1, 'Chronos', 30);


--
-- Data for Name: shift_types; Type: TABLE DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT INTO public.shift_types VALUES (1, 'Frühschicht', 4367989, '06:00:00', '14:00:00');
INSERT INTO public.shift_types VALUES (2, 'Spätschicht', 16760576, '14:00:00', '22:00:00');
INSERT INTO public.shift_types VALUES (3, 'Nachtschicht', 7304056, '22:00:00', '06:00:00');
INSERT INTO public.shift_types VALUES (4, 'Krank', 15745618, '00:00:00', '24:00:00');
INSERT INTO public.shift_types VALUES (5, 'Urlaub', 4242352, '00:00:00', '24:00:00');


--
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT INTO public.shifts VALUES (161, '2025-06-10', 5, 1);
INSERT INTO public.shifts VALUES (162, '2025-06-11', 4, 1);
INSERT INTO public.shifts VALUES (163, '2025-06-12', 5, 1);
INSERT INTO public.shifts VALUES (164, '2025-06-13', 5, 1);
INSERT INTO public.shifts VALUES (165, '2025-06-14', 2, 1);
INSERT INTO public.shifts VALUES (166, '2025-06-15', 5, 1);
INSERT INTO public.shifts VALUES (167, '2025-06-16', 2, 1);
INSERT INTO public.shifts VALUES (168, '2025-06-17', 5, 1);
INSERT INTO public.shifts VALUES (169, '2025-06-18', 4, 1);
INSERT INTO public.shifts VALUES (170, '2025-06-19', 4, 1);
INSERT INTO public.shifts VALUES (171, '2025-06-20', 2, 1);
INSERT INTO public.shifts VALUES (172, '2025-06-21', 1, 1);
INSERT INTO public.shifts VALUES (173, '2025-06-22', 1, 1);
INSERT INTO public.shifts VALUES (174, '2025-06-23', 1, 1);
INSERT INTO public.shifts VALUES (175, '2025-06-24', 5, 1);
INSERT INTO public.shifts VALUES (176, '2025-06-25', 2, 1);
INSERT INTO public.shifts VALUES (177, '2025-06-26', 4, 1);
INSERT INTO public.shifts VALUES (178, '2025-06-27', 1, 1);
INSERT INTO public.shifts VALUES (179, '2025-06-28', 5, 1);
INSERT INTO public.shifts VALUES (180, '2025-06-29', 1, 1);
INSERT INTO public.shifts VALUES (181, '2025-06-30', 2, 1);
INSERT INTO public.shifts VALUES (182, '2025-07-01', 1, 1);
INSERT INTO public.shifts VALUES (183, '2025-07-02', 1, 1);
INSERT INTO public.shifts VALUES (184, '2025-07-03', 1, 1);
INSERT INTO public.shifts VALUES (185, '2025-07-04', 5, 1);
INSERT INTO public.shifts VALUES (186, '2025-07-05', 1, 1);
INSERT INTO public.shifts VALUES (187, '2025-07-06', 4, 1);
INSERT INTO public.shifts VALUES (188, '2025-07-07', 2, 1);
INSERT INTO public.shifts VALUES (189, '2025-07-08', 5, 1);
INSERT INTO public.shifts VALUES (190, '2025-07-09', 1, 1);
INSERT INTO public.shifts VALUES (191, '2025-07-10', 5, 1);
INSERT INTO public.shifts VALUES (192, '2025-07-11', 1, 1);
INSERT INTO public.shifts VALUES (193, '2025-07-12', 5, 1);
INSERT INTO public.shifts VALUES (194, '2025-07-13', 2, 1);
INSERT INTO public.shifts VALUES (195, '2025-07-14', 5, 1);
INSERT INTO public.shifts VALUES (196, '2025-07-15', 2, 1);
INSERT INTO public.shifts VALUES (197, '2025-07-16', 1, 1);
INSERT INTO public.shifts VALUES (198, '2025-07-17', 2, 1);
INSERT INTO public.shifts VALUES (199, '2025-07-18', 5, 1);
INSERT INTO public.shifts VALUES (200, '2025-07-19', 1, 1);
INSERT INTO public.shifts VALUES (366, '2025-01-01', 5, 2);
INSERT INTO public.shifts VALUES (367, '2025-01-02', 2, 2);
INSERT INTO public.shifts VALUES (368, '2025-01-03', 1, 2);
INSERT INTO public.shifts VALUES (369, '2025-01-04', 5, 2);
INSERT INTO public.shifts VALUES (370, '2025-01-05', 2, 2);
INSERT INTO public.shifts VALUES (371, '2025-01-06', 5, 2);
INSERT INTO public.shifts VALUES (372, '2025-01-07', 1, 2);
INSERT INTO public.shifts VALUES (373, '2025-01-08', 4, 2);
INSERT INTO public.shifts VALUES (374, '2025-01-09', 5, 2);
INSERT INTO public.shifts VALUES (375, '2025-01-10', 1, 2);
INSERT INTO public.shifts VALUES (376, '2025-01-11', 1, 2);
INSERT INTO public.shifts VALUES (377, '2025-01-12', 5, 2);
INSERT INTO public.shifts VALUES (378, '2025-01-13', 4, 2);
INSERT INTO public.shifts VALUES (379, '2025-01-14', 1, 2);
INSERT INTO public.shifts VALUES (380, '2025-01-15', 5, 2);
INSERT INTO public.shifts VALUES (381, '2025-01-16', 5, 2);
INSERT INTO public.shifts VALUES (382, '2025-01-17', 2, 2);
INSERT INTO public.shifts VALUES (383, '2025-01-18', 1, 2);
INSERT INTO public.shifts VALUES (384, '2025-01-19', 1, 2);
INSERT INTO public.shifts VALUES (385, '2025-01-20', 5, 2);
INSERT INTO public.shifts VALUES (386, '2025-01-21', 5, 2);
INSERT INTO public.shifts VALUES (387, '2025-01-22', 4, 2);
INSERT INTO public.shifts VALUES (388, '2025-01-23', 2, 2);
INSERT INTO public.shifts VALUES (389, '2025-01-24', 5, 2);
INSERT INTO public.shifts VALUES (390, '2025-01-25', 5, 2);
INSERT INTO public.shifts VALUES (391, '2025-01-26', 1, 2);
INSERT INTO public.shifts VALUES (392, '2025-01-27', 5, 2);
INSERT INTO public.shifts VALUES (393, '2025-01-28', 1, 2);
INSERT INTO public.shifts VALUES (394, '2025-01-29', 2, 2);
INSERT INTO public.shifts VALUES (395, '2025-01-30', 5, 2);
INSERT INTO public.shifts VALUES (396, '2025-01-31', 2, 2);
INSERT INTO public.shifts VALUES (397, '2025-02-01', 5, 2);
INSERT INTO public.shifts VALUES (398, '2025-02-02', 1, 2);
INSERT INTO public.shifts VALUES (399, '2025-02-03', 2, 2);
INSERT INTO public.shifts VALUES (400, '2025-02-04', 4, 2);
INSERT INTO public.shifts VALUES (401, '2025-02-05', 1, 2);
INSERT INTO public.shifts VALUES (402, '2025-02-06', 2, 2);
INSERT INTO public.shifts VALUES (403, '2025-02-07', 2, 2);
INSERT INTO public.shifts VALUES (404, '2025-02-08', 1, 2);
INSERT INTO public.shifts VALUES (405, '2025-02-09', 1, 2);
INSERT INTO public.shifts VALUES (406, '2025-02-10', 5, 2);
INSERT INTO public.shifts VALUES (407, '2025-02-11', 1, 2);
INSERT INTO public.shifts VALUES (408, '2025-02-12', 1, 2);
INSERT INTO public.shifts VALUES (409, '2025-02-13', 1, 2);
INSERT INTO public.shifts VALUES (410, '2025-02-14', 5, 2);
INSERT INTO public.shifts VALUES (411, '2025-02-15', 5, 2);
INSERT INTO public.shifts VALUES (412, '2025-02-16', 1, 2);
INSERT INTO public.shifts VALUES (413, '2025-02-17', 4, 2);
INSERT INTO public.shifts VALUES (414, '2025-02-18', 2, 2);
INSERT INTO public.shifts VALUES (415, '2025-02-19', 2, 2);
INSERT INTO public.shifts VALUES (416, '2025-02-20', 5, 2);
INSERT INTO public.shifts VALUES (417, '2025-02-21', 1, 2);
INSERT INTO public.shifts VALUES (418, '2025-02-22', 5, 2);
INSERT INTO public.shifts VALUES (419, '2025-02-23', 5, 2);
INSERT INTO public.shifts VALUES (420, '2025-02-24', 5, 2);
INSERT INTO public.shifts VALUES (421, '2025-02-25', 2, 2);
INSERT INTO public.shifts VALUES (422, '2025-02-26', 4, 2);
INSERT INTO public.shifts VALUES (423, '2025-02-27', 2, 2);
INSERT INTO public.shifts VALUES (424, '2025-02-28', 2, 2);
INSERT INTO public.shifts VALUES (425, '2025-03-01', 1, 2);
INSERT INTO public.shifts VALUES (426, '2025-03-02', 4, 2);
INSERT INTO public.shifts VALUES (427, '2025-03-03', 5, 2);
INSERT INTO public.shifts VALUES (428, '2025-03-04', 1, 2);
INSERT INTO public.shifts VALUES (429, '2025-03-05', 5, 2);
INSERT INTO public.shifts VALUES (430, '2025-03-06', 4, 2);
INSERT INTO public.shifts VALUES (431, '2025-03-07', 2, 2);
INSERT INTO public.shifts VALUES (432, '2025-03-08', 4, 2);
INSERT INTO public.shifts VALUES (433, '2025-03-09', 1, 2);
INSERT INTO public.shifts VALUES (434, '2025-03-10', 4, 2);
INSERT INTO public.shifts VALUES (435, '2025-03-11', 1, 2);
INSERT INTO public.shifts VALUES (436, '2025-03-12', 2, 2);
INSERT INTO public.shifts VALUES (437, '2025-03-13', 2, 2);
INSERT INTO public.shifts VALUES (438, '2025-03-14', 5, 2);
INSERT INTO public.shifts VALUES (439, '2025-03-15', 5, 2);
INSERT INTO public.shifts VALUES (440, '2025-03-16', 2, 2);
INSERT INTO public.shifts VALUES (441, '2025-03-17', 1, 2);
INSERT INTO public.shifts VALUES (442, '2025-03-18', 4, 2);
INSERT INTO public.shifts VALUES (443, '2025-03-19', 4, 2);
INSERT INTO public.shifts VALUES (444, '2025-03-20', 4, 2);
INSERT INTO public.shifts VALUES (445, '2025-03-21', 1, 2);
INSERT INTO public.shifts VALUES (446, '2025-03-22', 1, 2);
INSERT INTO public.shifts VALUES (447, '2025-03-23', 5, 2);
INSERT INTO public.shifts VALUES (448, '2025-03-24', 2, 2);
INSERT INTO public.shifts VALUES (449, '2025-03-25', 1, 2);
INSERT INTO public.shifts VALUES (450, '2025-03-26', 4, 2);
INSERT INTO public.shifts VALUES (451, '2025-03-27', 1, 2);
INSERT INTO public.shifts VALUES (452, '2025-03-28', 5, 2);
INSERT INTO public.shifts VALUES (453, '2025-03-29', 2, 2);
INSERT INTO public.shifts VALUES (454, '2025-03-30', 1, 2);
INSERT INTO public.shifts VALUES (455, '2025-03-31', 4, 2);
INSERT INTO public.shifts VALUES (456, '2025-04-01', 2, 2);
INSERT INTO public.shifts VALUES (457, '2025-04-02', 4, 2);
INSERT INTO public.shifts VALUES (458, '2025-04-03', 4, 2);
INSERT INTO public.shifts VALUES (459, '2025-04-04', 5, 2);
INSERT INTO public.shifts VALUES (460, '2025-04-05', 1, 2);
INSERT INTO public.shifts VALUES (461, '2025-04-06', 5, 2);
INSERT INTO public.shifts VALUES (462, '2025-04-07', 4, 2);
INSERT INTO public.shifts VALUES (463, '2025-04-08', 1, 2);
INSERT INTO public.shifts VALUES (464, '2025-04-09', 4, 2);
INSERT INTO public.shifts VALUES (465, '2025-04-10', 5, 2);
INSERT INTO public.shifts VALUES (466, '2025-04-11', 2, 2);
INSERT INTO public.shifts VALUES (467, '2025-04-12', 4, 2);
INSERT INTO public.shifts VALUES (468, '2025-04-13', 1, 2);
INSERT INTO public.shifts VALUES (469, '2025-04-14', 2, 2);
INSERT INTO public.shifts VALUES (470, '2025-04-15', 2, 2);
INSERT INTO public.shifts VALUES (471, '2025-04-16', 5, 2);
INSERT INTO public.shifts VALUES (472, '2025-04-17', 4, 2);
INSERT INTO public.shifts VALUES (473, '2025-04-18', 1, 2);
INSERT INTO public.shifts VALUES (474, '2025-04-19', 4, 2);
INSERT INTO public.shifts VALUES (475, '2025-04-20', 5, 2);
INSERT INTO public.shifts VALUES (476, '2025-04-21', 2, 2);
INSERT INTO public.shifts VALUES (477, '2025-04-22', 2, 2);
INSERT INTO public.shifts VALUES (478, '2025-04-23', 4, 2);
INSERT INTO public.shifts VALUES (479, '2025-04-24', 1, 2);
INSERT INTO public.shifts VALUES (480, '2025-04-25', 4, 2);
INSERT INTO public.shifts VALUES (481, '2025-04-26', 4, 2);
INSERT INTO public.shifts VALUES (482, '2025-04-27', 2, 2);
INSERT INTO public.shifts VALUES (483, '2025-04-28', 5, 2);
INSERT INTO public.shifts VALUES (484, '2025-04-29', 4, 2);
INSERT INTO public.shifts VALUES (485, '2025-04-30', 1, 2);
INSERT INTO public.shifts VALUES (486, '2025-05-01', 5, 2);
INSERT INTO public.shifts VALUES (487, '2025-05-02', 5, 2);
INSERT INTO public.shifts VALUES (488, '2025-05-03', 2, 2);
INSERT INTO public.shifts VALUES (489, '2025-05-04', 1, 2);
INSERT INTO public.shifts VALUES (490, '2025-05-05', 1, 2);
INSERT INTO public.shifts VALUES (491, '2025-05-06', 2, 2);
INSERT INTO public.shifts VALUES (492, '2025-05-07', 5, 2);
INSERT INTO public.shifts VALUES (493, '2025-05-08', 2, 2);
INSERT INTO public.shifts VALUES (494, '2025-05-09', 2, 2);
INSERT INTO public.shifts VALUES (495, '2025-05-10', 2, 2);
INSERT INTO public.shifts VALUES (496, '2025-05-11', 2, 2);
INSERT INTO public.shifts VALUES (497, '2025-05-12', 4, 2);
INSERT INTO public.shifts VALUES (498, '2025-05-13', 1, 2);
INSERT INTO public.shifts VALUES (499, '2025-05-14', 1, 2);
INSERT INTO public.shifts VALUES (500, '2025-05-15', 4, 2);
INSERT INTO public.shifts VALUES (501, '2025-05-16', 1, 2);
INSERT INTO public.shifts VALUES (502, '2025-05-17', 4, 2);
INSERT INTO public.shifts VALUES (503, '2025-05-18', 5, 2);
INSERT INTO public.shifts VALUES (504, '2025-05-19', 2, 2);
INSERT INTO public.shifts VALUES (505, '2025-05-20', 4, 2);
INSERT INTO public.shifts VALUES (506, '2025-05-21', 1, 2);
INSERT INTO public.shifts VALUES (507, '2025-05-22', 2, 2);
INSERT INTO public.shifts VALUES (508, '2025-05-23', 1, 2);
INSERT INTO public.shifts VALUES (509, '2025-05-24', 4, 2);
INSERT INTO public.shifts VALUES (510, '2025-05-25', 5, 2);
INSERT INTO public.shifts VALUES (511, '2025-05-26', 5, 2);
INSERT INTO public.shifts VALUES (512, '2025-05-27', 2, 2);
INSERT INTO public.shifts VALUES (513, '2025-05-28', 5, 2);
INSERT INTO public.shifts VALUES (514, '2025-05-29', 1, 2);
INSERT INTO public.shifts VALUES (515, '2025-05-30', 1, 2);
INSERT INTO public.shifts VALUES (516, '2025-05-31', 1, 2);
INSERT INTO public.shifts VALUES (517, '2025-06-01', 1, 2);
INSERT INTO public.shifts VALUES (518, '2025-06-02', 5, 2);
INSERT INTO public.shifts VALUES (519, '2025-06-03', 2, 2);
INSERT INTO public.shifts VALUES (520, '2025-06-04', 1, 2);
INSERT INTO public.shifts VALUES (521, '2025-06-05', 1, 2);
INSERT INTO public.shifts VALUES (522, '2025-06-06', 1, 2);
INSERT INTO public.shifts VALUES (523, '2025-06-07', 1, 2);
INSERT INTO public.shifts VALUES (524, '2025-06-08', 5, 2);
INSERT INTO public.shifts VALUES (525, '2025-06-09', 2, 2);
INSERT INTO public.shifts VALUES (526, '2025-06-10', 5, 2);
INSERT INTO public.shifts VALUES (527, '2025-06-11', 1, 2);
INSERT INTO public.shifts VALUES (528, '2025-06-12', 4, 2);
INSERT INTO public.shifts VALUES (529, '2025-06-13', 2, 2);
INSERT INTO public.shifts VALUES (530, '2025-06-14', 1, 2);
INSERT INTO public.shifts VALUES (531, '2025-06-15', 5, 2);
INSERT INTO public.shifts VALUES (532, '2025-06-16', 4, 2);
INSERT INTO public.shifts VALUES (533, '2025-06-17', 2, 2);
INSERT INTO public.shifts VALUES (534, '2025-06-18', 1, 2);
INSERT INTO public.shifts VALUES (535, '2025-06-19', 5, 2);
INSERT INTO public.shifts VALUES (536, '2025-06-20', 4, 2);
INSERT INTO public.shifts VALUES (537, '2025-06-21', 1, 2);
INSERT INTO public.shifts VALUES (538, '2025-06-22', 5, 2);
INSERT INTO public.shifts VALUES (539, '2025-06-23', 2, 2);
INSERT INTO public.shifts VALUES (540, '2025-06-24', 2, 2);
INSERT INTO public.shifts VALUES (541, '2025-06-25', 1, 2);
INSERT INTO public.shifts VALUES (542, '2025-06-26', 1, 2);
INSERT INTO public.shifts VALUES (543, '2025-06-27', 2, 2);
INSERT INTO public.shifts VALUES (544, '2025-06-28', 5, 2);
INSERT INTO public.shifts VALUES (545, '2025-06-29', 2, 2);
INSERT INTO public.shifts VALUES (546, '2025-06-30', 4, 2);
INSERT INTO public.shifts VALUES (547, '2025-07-01', 2, 2);
INSERT INTO public.shifts VALUES (548, '2025-07-02', 4, 2);
INSERT INTO public.shifts VALUES (549, '2025-07-03', 1, 2);
INSERT INTO public.shifts VALUES (550, '2025-07-04', 4, 2);
INSERT INTO public.shifts VALUES (551, '2025-07-05', 4, 2);
INSERT INTO public.shifts VALUES (552, '2025-07-06', 4, 2);
INSERT INTO public.shifts VALUES (553, '2025-07-07', 4, 2);
INSERT INTO public.shifts VALUES (554, '2025-07-08', 1, 2);
INSERT INTO public.shifts VALUES (555, '2025-07-09', 1, 2);
INSERT INTO public.shifts VALUES (556, '2025-07-10', 4, 2);
INSERT INTO public.shifts VALUES (557, '2025-07-11', 1, 2);
INSERT INTO public.shifts VALUES (558, '2025-07-12', 1, 2);
INSERT INTO public.shifts VALUES (559, '2025-07-13', 2, 2);
INSERT INTO public.shifts VALUES (560, '2025-07-14', 1, 2);
INSERT INTO public.shifts VALUES (561, '2025-07-15', 4, 2);
INSERT INTO public.shifts VALUES (562, '2025-07-16', 4, 2);
INSERT INTO public.shifts VALUES (563, '2025-07-17', 1, 2);
INSERT INTO public.shifts VALUES (564, '2025-07-18', 5, 2);
INSERT INTO public.shifts VALUES (565, '2025-07-19', 5, 2);
INSERT INTO public.shifts VALUES (566, '2025-07-20', 4, 2);
INSERT INTO public.shifts VALUES (567, '2025-07-21', 4, 2);
INSERT INTO public.shifts VALUES (568, '2025-07-22', 1, 2);
INSERT INTO public.shifts VALUES (569, '2025-07-23', 1, 2);
INSERT INTO public.shifts VALUES (570, '2025-07-24', 1, 2);
INSERT INTO public.shifts VALUES (571, '2025-07-25', 5, 2);
INSERT INTO public.shifts VALUES (572, '2025-07-26', 4, 2);
INSERT INTO public.shifts VALUES (573, '2025-07-27', 2, 2);
INSERT INTO public.shifts VALUES (574, '2025-07-28', 2, 2);
INSERT INTO public.shifts VALUES (575, '2025-07-29', 4, 2);
INSERT INTO public.shifts VALUES (576, '2025-07-30', 5, 2);
INSERT INTO public.shifts VALUES (577, '2025-07-31', 2, 2);
INSERT INTO public.shifts VALUES (578, '2025-08-01', 1, 2);
INSERT INTO public.shifts VALUES (579, '2025-08-02', 5, 2);
INSERT INTO public.shifts VALUES (580, '2025-08-03', 1, 2);
INSERT INTO public.shifts VALUES (581, '2025-08-04', 5, 2);
INSERT INTO public.shifts VALUES (582, '2025-08-05', 4, 2);
INSERT INTO public.shifts VALUES (584, '2025-08-07', 4, 2);
INSERT INTO public.shifts VALUES (585, '2025-08-08', 1, 2);
INSERT INTO public.shifts VALUES (586, '2025-08-09', 5, 2);
INSERT INTO public.shifts VALUES (587, '2025-08-10', 5, 2);
INSERT INTO public.shifts VALUES (588, '2025-08-11', 1, 2);
INSERT INTO public.shifts VALUES (589, '2025-08-12', 1, 2);
INSERT INTO public.shifts VALUES (590, '2025-08-13', 4, 2);
INSERT INTO public.shifts VALUES (591, '2025-08-14', 4, 2);
INSERT INTO public.shifts VALUES (592, '2025-08-15', 1, 2);
INSERT INTO public.shifts VALUES (593, '2025-08-16', 5, 2);
INSERT INTO public.shifts VALUES (594, '2025-08-17', 4, 2);
INSERT INTO public.shifts VALUES (595, '2025-08-18', 5, 2);
INSERT INTO public.shifts VALUES (596, '2025-08-19', 5, 2);
INSERT INTO public.shifts VALUES (597, '2025-08-20', 4, 2);
INSERT INTO public.shifts VALUES (598, '2025-08-21', 5, 2);
INSERT INTO public.shifts VALUES (599, '2025-08-22', 4, 2);
INSERT INTO public.shifts VALUES (600, '2025-08-23', 4, 2);
INSERT INTO public.shifts VALUES (601, '2025-08-24', 4, 2);
INSERT INTO public.shifts VALUES (602, '2025-08-25', 5, 2);
INSERT INTO public.shifts VALUES (603, '2025-08-26', 4, 2);
INSERT INTO public.shifts VALUES (604, '2025-08-27', 1, 2);
INSERT INTO public.shifts VALUES (605, '2025-08-28', 2, 2);
INSERT INTO public.shifts VALUES (606, '2025-08-29', 4, 2);
INSERT INTO public.shifts VALUES (607, '2025-08-30', 4, 2);
INSERT INTO public.shifts VALUES (608, '2025-08-31', 4, 2);
INSERT INTO public.shifts VALUES (609, '2025-09-01', 4, 2);
INSERT INTO public.shifts VALUES (610, '2025-09-02', 2, 2);
INSERT INTO public.shifts VALUES (611, '2025-09-03', 2, 2);
INSERT INTO public.shifts VALUES (612, '2025-09-04', 4, 2);
INSERT INTO public.shifts VALUES (613, '2025-09-05', 5, 2);
INSERT INTO public.shifts VALUES (614, '2025-09-06', 1, 2);
INSERT INTO public.shifts VALUES (615, '2025-09-07', 2, 2);
INSERT INTO public.shifts VALUES (616, '2025-09-08', 5, 2);
INSERT INTO public.shifts VALUES (617, '2025-09-09', 4, 2);
INSERT INTO public.shifts VALUES (618, '2025-09-10', 1, 2);
INSERT INTO public.shifts VALUES (619, '2025-09-11', 5, 2);
INSERT INTO public.shifts VALUES (620, '2025-09-12', 1, 2);
INSERT INTO public.shifts VALUES (621, '2025-09-13', 1, 2);
INSERT INTO public.shifts VALUES (622, '2025-09-14', 4, 2);
INSERT INTO public.shifts VALUES (623, '2025-09-15', 1, 2);
INSERT INTO public.shifts VALUES (624, '2025-09-16', 1, 2);
INSERT INTO public.shifts VALUES (625, '2025-09-17', 2, 2);
INSERT INTO public.shifts VALUES (626, '2025-09-18', 2, 2);
INSERT INTO public.shifts VALUES (627, '2025-09-19', 5, 2);
INSERT INTO public.shifts VALUES (628, '2025-09-20', 4, 2);
INSERT INTO public.shifts VALUES (629, '2025-09-21', 4, 2);
INSERT INTO public.shifts VALUES (630, '2025-09-22', 4, 2);
INSERT INTO public.shifts VALUES (631, '2025-09-23', 2, 2);
INSERT INTO public.shifts VALUES (632, '2025-09-24', 1, 2);
INSERT INTO public.shifts VALUES (633, '2025-09-25', 2, 2);
INSERT INTO public.shifts VALUES (634, '2025-09-26', 1, 2);
INSERT INTO public.shifts VALUES (635, '2025-09-27', 5, 2);
INSERT INTO public.shifts VALUES (636, '2025-09-28', 1, 2);
INSERT INTO public.shifts VALUES (637, '2025-09-29', 2, 2);
INSERT INTO public.shifts VALUES (638, '2025-09-30', 1, 2);
INSERT INTO public.shifts VALUES (639, '2025-10-01', 1, 2);
INSERT INTO public.shifts VALUES (640, '2025-10-02', 1, 2);
INSERT INTO public.shifts VALUES (641, '2025-10-03', 4, 2);
INSERT INTO public.shifts VALUES (642, '2025-10-04', 5, 2);
INSERT INTO public.shifts VALUES (643, '2025-10-05', 1, 2);
INSERT INTO public.shifts VALUES (644, '2025-10-06', 5, 2);
INSERT INTO public.shifts VALUES (645, '2025-10-07', 5, 2);
INSERT INTO public.shifts VALUES (646, '2025-10-08', 2, 2);
INSERT INTO public.shifts VALUES (647, '2025-10-09', 2, 2);
INSERT INTO public.shifts VALUES (648, '2025-10-10', 4, 2);
INSERT INTO public.shifts VALUES (649, '2025-10-11', 2, 2);
INSERT INTO public.shifts VALUES (650, '2025-10-12', 1, 2);
INSERT INTO public.shifts VALUES (651, '2025-10-13', 5, 2);
INSERT INTO public.shifts VALUES (583, '2025-08-06', 5, 2);
INSERT INTO public.shifts VALUES (652, '2025-10-14', 1, 2);
INSERT INTO public.shifts VALUES (653, '2025-10-15', 1, 2);
INSERT INTO public.shifts VALUES (654, '2025-10-16', 2, 2);
INSERT INTO public.shifts VALUES (655, '2025-10-17', 2, 2);
INSERT INTO public.shifts VALUES (656, '2025-10-18', 5, 2);
INSERT INTO public.shifts VALUES (657, '2025-10-19', 4, 2);
INSERT INTO public.shifts VALUES (658, '2025-10-20', 5, 2);
INSERT INTO public.shifts VALUES (659, '2025-10-21', 4, 2);
INSERT INTO public.shifts VALUES (660, '2025-10-22', 1, 2);
INSERT INTO public.shifts VALUES (661, '2025-10-23', 4, 2);
INSERT INTO public.shifts VALUES (662, '2025-10-24', 2, 2);
INSERT INTO public.shifts VALUES (663, '2025-10-25', 5, 2);
INSERT INTO public.shifts VALUES (664, '2025-10-26', 4, 2);
INSERT INTO public.shifts VALUES (665, '2025-10-27', 5, 2);
INSERT INTO public.shifts VALUES (666, '2025-10-28', 2, 2);
INSERT INTO public.shifts VALUES (667, '2025-10-29', 2, 2);
INSERT INTO public.shifts VALUES (668, '2025-10-30', 1, 2);
INSERT INTO public.shifts VALUES (669, '2025-10-31', 1, 2);
INSERT INTO public.shifts VALUES (670, '2025-11-01', 1, 2);
INSERT INTO public.shifts VALUES (671, '2025-11-02', 1, 2);
INSERT INTO public.shifts VALUES (672, '2025-11-03', 2, 2);
INSERT INTO public.shifts VALUES (673, '2025-11-04', 4, 2);
INSERT INTO public.shifts VALUES (674, '2025-11-05', 1, 2);
INSERT INTO public.shifts VALUES (675, '2025-11-06', 2, 2);
INSERT INTO public.shifts VALUES (676, '2025-11-07', 1, 2);
INSERT INTO public.shifts VALUES (677, '2025-11-08', 4, 2);
INSERT INTO public.shifts VALUES (678, '2025-11-09', 1, 2);
INSERT INTO public.shifts VALUES (679, '2025-11-10', 1, 2);
INSERT INTO public.shifts VALUES (680, '2025-11-11', 1, 2);
INSERT INTO public.shifts VALUES (681, '2025-11-12', 5, 2);
INSERT INTO public.shifts VALUES (682, '2025-11-13', 4, 2);
INSERT INTO public.shifts VALUES (683, '2025-11-14', 5, 2);
INSERT INTO public.shifts VALUES (684, '2025-11-15', 5, 2);
INSERT INTO public.shifts VALUES (685, '2025-11-16', 5, 2);
INSERT INTO public.shifts VALUES (686, '2025-11-17', 5, 2);
INSERT INTO public.shifts VALUES (687, '2025-11-18', 5, 2);
INSERT INTO public.shifts VALUES (688, '2025-11-19', 5, 2);
INSERT INTO public.shifts VALUES (689, '2025-11-20', 4, 2);
INSERT INTO public.shifts VALUES (690, '2025-11-21', 4, 2);
INSERT INTO public.shifts VALUES (691, '2025-11-22', 4, 2);
INSERT INTO public.shifts VALUES (692, '2025-11-23', 1, 2);
INSERT INTO public.shifts VALUES (693, '2025-11-24', 1, 2);
INSERT INTO public.shifts VALUES (694, '2025-11-25', 2, 2);
INSERT INTO public.shifts VALUES (695, '2025-11-26', 2, 2);
INSERT INTO public.shifts VALUES (696, '2025-11-27', 4, 2);
INSERT INTO public.shifts VALUES (697, '2025-11-28', 4, 2);
INSERT INTO public.shifts VALUES (698, '2025-11-29', 2, 2);
INSERT INTO public.shifts VALUES (699, '2025-11-30', 1, 2);
INSERT INTO public.shifts VALUES (700, '2025-12-01', 2, 2);
INSERT INTO public.shifts VALUES (701, '2025-12-02', 1, 2);
INSERT INTO public.shifts VALUES (702, '2025-12-03', 1, 2);
INSERT INTO public.shifts VALUES (703, '2025-12-04', 2, 2);
INSERT INTO public.shifts VALUES (704, '2025-12-05', 4, 2);
INSERT INTO public.shifts VALUES (705, '2025-12-06', 5, 2);
INSERT INTO public.shifts VALUES (706, '2025-12-07', 1, 2);
INSERT INTO public.shifts VALUES (707, '2025-12-08', 5, 2);
INSERT INTO public.shifts VALUES (708, '2025-12-09', 2, 2);
INSERT INTO public.shifts VALUES (709, '2025-12-10', 5, 2);
INSERT INTO public.shifts VALUES (710, '2025-12-11', 5, 2);
INSERT INTO public.shifts VALUES (711, '2025-12-12', 1, 2);
INSERT INTO public.shifts VALUES (712, '2025-12-13', 2, 2);
INSERT INTO public.shifts VALUES (713, '2025-12-14', 4, 2);
INSERT INTO public.shifts VALUES (714, '2025-12-15', 2, 2);
INSERT INTO public.shifts VALUES (715, '2025-12-16', 4, 2);
INSERT INTO public.shifts VALUES (716, '2025-12-17', 1, 2);
INSERT INTO public.shifts VALUES (717, '2025-12-18', 2, 2);
INSERT INTO public.shifts VALUES (718, '2025-12-19', 5, 2);
INSERT INTO public.shifts VALUES (719, '2025-12-20', 2, 2);
INSERT INTO public.shifts VALUES (720, '2025-12-21', 5, 2);
INSERT INTO public.shifts VALUES (721, '2025-12-22', 2, 2);
INSERT INTO public.shifts VALUES (722, '2025-12-23', 5, 2);
INSERT INTO public.shifts VALUES (723, '2025-12-24', 4, 2);
INSERT INTO public.shifts VALUES (724, '2025-12-25', 1, 2);
INSERT INTO public.shifts VALUES (725, '2025-12-26', 5, 2);
INSERT INTO public.shifts VALUES (726, '2025-12-27', 1, 2);
INSERT INTO public.shifts VALUES (727, '2025-12-28', 1, 2);
INSERT INTO public.shifts VALUES (728, '2025-12-29', 1, 2);
INSERT INTO public.shifts VALUES (729, '2025-12-30', 5, 2);
INSERT INTO public.shifts VALUES (730, '2025-12-31', 1, 2);
INSERT INTO public.shifts VALUES (731, '2025-01-01', 1, 3);
INSERT INTO public.shifts VALUES (732, '2025-01-02', 2, 3);
INSERT INTO public.shifts VALUES (733, '2025-01-03', 2, 3);
INSERT INTO public.shifts VALUES (734, '2025-01-04', 1, 3);
INSERT INTO public.shifts VALUES (735, '2025-01-05', 1, 3);
INSERT INTO public.shifts VALUES (736, '2025-01-06', 1, 3);
INSERT INTO public.shifts VALUES (737, '2025-01-07', 5, 3);
INSERT INTO public.shifts VALUES (738, '2025-01-08', 5, 3);
INSERT INTO public.shifts VALUES (739, '2025-01-09', 2, 3);
INSERT INTO public.shifts VALUES (740, '2025-01-10', 1, 3);
INSERT INTO public.shifts VALUES (741, '2025-01-11', 4, 3);
INSERT INTO public.shifts VALUES (742, '2025-01-12', 1, 3);
INSERT INTO public.shifts VALUES (743, '2025-01-13', 2, 3);
INSERT INTO public.shifts VALUES (744, '2025-01-14', 2, 3);
INSERT INTO public.shifts VALUES (745, '2025-01-15', 5, 3);
INSERT INTO public.shifts VALUES (746, '2025-01-16', 1, 3);
INSERT INTO public.shifts VALUES (747, '2025-01-17', 4, 3);
INSERT INTO public.shifts VALUES (748, '2025-01-18', 2, 3);
INSERT INTO public.shifts VALUES (749, '2025-01-19', 2, 3);
INSERT INTO public.shifts VALUES (750, '2025-01-20', 2, 3);
INSERT INTO public.shifts VALUES (751, '2025-01-21', 5, 3);
INSERT INTO public.shifts VALUES (752, '2025-01-22', 5, 3);
INSERT INTO public.shifts VALUES (753, '2025-01-23', 4, 3);
INSERT INTO public.shifts VALUES (754, '2025-01-24', 1, 3);
INSERT INTO public.shifts VALUES (755, '2025-01-25', 4, 3);
INSERT INTO public.shifts VALUES (756, '2025-01-26', 2, 3);
INSERT INTO public.shifts VALUES (757, '2025-01-27', 1, 3);
INSERT INTO public.shifts VALUES (758, '2025-01-28', 5, 3);
INSERT INTO public.shifts VALUES (759, '2025-01-29', 5, 3);
INSERT INTO public.shifts VALUES (760, '2025-01-30', 2, 3);
INSERT INTO public.shifts VALUES (761, '2025-01-31', 1, 3);
INSERT INTO public.shifts VALUES (762, '2025-02-01', 5, 3);
INSERT INTO public.shifts VALUES (763, '2025-02-02', 4, 3);
INSERT INTO public.shifts VALUES (764, '2025-02-03', 4, 3);
INSERT INTO public.shifts VALUES (765, '2025-02-04', 4, 3);
INSERT INTO public.shifts VALUES (766, '2025-02-05', 4, 3);
INSERT INTO public.shifts VALUES (767, '2025-02-06', 2, 3);
INSERT INTO public.shifts VALUES (768, '2025-02-07', 5, 3);
INSERT INTO public.shifts VALUES (769, '2025-02-08', 4, 3);
INSERT INTO public.shifts VALUES (770, '2025-02-09', 2, 3);
INSERT INTO public.shifts VALUES (771, '2025-02-10', 1, 3);
INSERT INTO public.shifts VALUES (772, '2025-02-11', 2, 3);
INSERT INTO public.shifts VALUES (773, '2025-02-12', 5, 3);
INSERT INTO public.shifts VALUES (774, '2025-02-13', 2, 3);
INSERT INTO public.shifts VALUES (775, '2025-02-14', 4, 3);
INSERT INTO public.shifts VALUES (776, '2025-02-15', 5, 3);
INSERT INTO public.shifts VALUES (777, '2025-02-16', 4, 3);
INSERT INTO public.shifts VALUES (778, '2025-02-17', 4, 3);
INSERT INTO public.shifts VALUES (779, '2025-02-18', 5, 3);
INSERT INTO public.shifts VALUES (780, '2025-02-19', 1, 3);
INSERT INTO public.shifts VALUES (781, '2025-02-20', 1, 3);
INSERT INTO public.shifts VALUES (782, '2025-02-21', 5, 3);
INSERT INTO public.shifts VALUES (783, '2025-02-22', 5, 3);
INSERT INTO public.shifts VALUES (784, '2025-02-23', 2, 3);
INSERT INTO public.shifts VALUES (785, '2025-02-24', 2, 3);
INSERT INTO public.shifts VALUES (786, '2025-02-25', 5, 3);
INSERT INTO public.shifts VALUES (787, '2025-02-26', 1, 3);
INSERT INTO public.shifts VALUES (788, '2025-02-27', 1, 3);
INSERT INTO public.shifts VALUES (789, '2025-02-28', 2, 3);
INSERT INTO public.shifts VALUES (790, '2025-03-01', 2, 3);
INSERT INTO public.shifts VALUES (791, '2025-03-02', 1, 3);
INSERT INTO public.shifts VALUES (792, '2025-03-03', 4, 3);
INSERT INTO public.shifts VALUES (793, '2025-03-04', 1, 3);
INSERT INTO public.shifts VALUES (794, '2025-03-05', 2, 3);
INSERT INTO public.shifts VALUES (795, '2025-03-06', 1, 3);
INSERT INTO public.shifts VALUES (796, '2025-03-07', 4, 3);
INSERT INTO public.shifts VALUES (797, '2025-03-08', 1, 3);
INSERT INTO public.shifts VALUES (798, '2025-03-09', 5, 3);
INSERT INTO public.shifts VALUES (799, '2025-03-10', 2, 3);
INSERT INTO public.shifts VALUES (800, '2025-03-11', 1, 3);
INSERT INTO public.shifts VALUES (801, '2025-03-12', 1, 3);
INSERT INTO public.shifts VALUES (802, '2025-03-13', 1, 3);
INSERT INTO public.shifts VALUES (803, '2025-03-14', 4, 3);
INSERT INTO public.shifts VALUES (804, '2025-03-15', 2, 3);
INSERT INTO public.shifts VALUES (805, '2025-03-16', 4, 3);
INSERT INTO public.shifts VALUES (806, '2025-03-17', 5, 3);
INSERT INTO public.shifts VALUES (807, '2025-03-18', 2, 3);
INSERT INTO public.shifts VALUES (808, '2025-03-19', 1, 3);
INSERT INTO public.shifts VALUES (809, '2025-03-20', 1, 3);
INSERT INTO public.shifts VALUES (810, '2025-03-21', 4, 3);
INSERT INTO public.shifts VALUES (811, '2025-03-22', 5, 3);
INSERT INTO public.shifts VALUES (812, '2025-03-23', 2, 3);
INSERT INTO public.shifts VALUES (813, '2025-03-24', 4, 3);
INSERT INTO public.shifts VALUES (814, '2025-03-25', 2, 3);
INSERT INTO public.shifts VALUES (815, '2025-03-26', 4, 3);
INSERT INTO public.shifts VALUES (816, '2025-03-27', 4, 3);
INSERT INTO public.shifts VALUES (817, '2025-03-28', 1, 3);
INSERT INTO public.shifts VALUES (818, '2025-03-29', 2, 3);
INSERT INTO public.shifts VALUES (819, '2025-03-30', 5, 3);
INSERT INTO public.shifts VALUES (820, '2025-03-31', 1, 3);
INSERT INTO public.shifts VALUES (821, '2025-04-01', 4, 3);
INSERT INTO public.shifts VALUES (822, '2025-04-02', 1, 3);
INSERT INTO public.shifts VALUES (823, '2025-04-03', 1, 3);
INSERT INTO public.shifts VALUES (824, '2025-04-04', 5, 3);
INSERT INTO public.shifts VALUES (825, '2025-04-05', 2, 3);
INSERT INTO public.shifts VALUES (826, '2025-04-06', 5, 3);
INSERT INTO public.shifts VALUES (827, '2025-04-07', 1, 3);
INSERT INTO public.shifts VALUES (828, '2025-04-08', 5, 3);
INSERT INTO public.shifts VALUES (829, '2025-04-09', 2, 3);
INSERT INTO public.shifts VALUES (830, '2025-04-10', 2, 3);
INSERT INTO public.shifts VALUES (831, '2025-04-11', 1, 3);
INSERT INTO public.shifts VALUES (832, '2025-04-12', 1, 3);
INSERT INTO public.shifts VALUES (69, '2025-03-10', 2, 1);
INSERT INTO public.shifts VALUES (70, '2025-03-11', 2, 1);
INSERT INTO public.shifts VALUES (833, '2025-04-13', 1, 3);
INSERT INTO public.shifts VALUES (834, '2025-04-14', 5, 3);
INSERT INTO public.shifts VALUES (835, '2025-04-15', 4, 3);
INSERT INTO public.shifts VALUES (836, '2025-04-16', 4, 3);
INSERT INTO public.shifts VALUES (837, '2025-04-17', 2, 3);
INSERT INTO public.shifts VALUES (838, '2025-04-18', 5, 3);
INSERT INTO public.shifts VALUES (839, '2025-04-19', 1, 3);
INSERT INTO public.shifts VALUES (840, '2025-04-20', 5, 3);
INSERT INTO public.shifts VALUES (841, '2025-04-21', 2, 3);
INSERT INTO public.shifts VALUES (842, '2025-04-22', 1, 3);
INSERT INTO public.shifts VALUES (843, '2025-04-23', 4, 3);
INSERT INTO public.shifts VALUES (844, '2025-04-24', 4, 3);
INSERT INTO public.shifts VALUES (845, '2025-04-25', 4, 3);
INSERT INTO public.shifts VALUES (846, '2025-04-26', 5, 3);
INSERT INTO public.shifts VALUES (847, '2025-04-27', 5, 3);
INSERT INTO public.shifts VALUES (848, '2025-04-28', 2, 3);
INSERT INTO public.shifts VALUES (849, '2025-04-29', 5, 3);
INSERT INTO public.shifts VALUES (850, '2025-04-30', 5, 3);
INSERT INTO public.shifts VALUES (851, '2025-05-01', 2, 3);
INSERT INTO public.shifts VALUES (852, '2025-05-02', 5, 3);
INSERT INTO public.shifts VALUES (853, '2025-05-03', 1, 3);
INSERT INTO public.shifts VALUES (854, '2025-05-04', 5, 3);
INSERT INTO public.shifts VALUES (855, '2025-05-05', 4, 3);
INSERT INTO public.shifts VALUES (856, '2025-05-06', 1, 3);
INSERT INTO public.shifts VALUES (857, '2025-05-07', 1, 3);
INSERT INTO public.shifts VALUES (858, '2025-05-08', 2, 3);
INSERT INTO public.shifts VALUES (859, '2025-05-09', 1, 3);
INSERT INTO public.shifts VALUES (860, '2025-05-10', 1, 3);
INSERT INTO public.shifts VALUES (861, '2025-05-11', 4, 3);
INSERT INTO public.shifts VALUES (862, '2025-05-12', 4, 3);
INSERT INTO public.shifts VALUES (863, '2025-05-13', 1, 3);
INSERT INTO public.shifts VALUES (864, '2025-05-14', 5, 3);
INSERT INTO public.shifts VALUES (865, '2025-05-15', 4, 3);
INSERT INTO public.shifts VALUES (866, '2025-05-16', 1, 3);
INSERT INTO public.shifts VALUES (867, '2025-05-17', 4, 3);
INSERT INTO public.shifts VALUES (868, '2025-05-18', 5, 3);
INSERT INTO public.shifts VALUES (869, '2025-05-19', 2, 3);
INSERT INTO public.shifts VALUES (870, '2025-05-20', 4, 3);
INSERT INTO public.shifts VALUES (871, '2025-05-21', 2, 3);
INSERT INTO public.shifts VALUES (872, '2025-05-22', 5, 3);
INSERT INTO public.shifts VALUES (873, '2025-05-23', 1, 3);
INSERT INTO public.shifts VALUES (874, '2025-05-24', 2, 3);
INSERT INTO public.shifts VALUES (875, '2025-05-25', 2, 3);
INSERT INTO public.shifts VALUES (876, '2025-05-26', 1, 3);
INSERT INTO public.shifts VALUES (877, '2025-05-27', 4, 3);
INSERT INTO public.shifts VALUES (878, '2025-05-28', 4, 3);
INSERT INTO public.shifts VALUES (879, '2025-05-29', 4, 3);
INSERT INTO public.shifts VALUES (880, '2025-05-30', 1, 3);
INSERT INTO public.shifts VALUES (881, '2025-05-31', 2, 3);
INSERT INTO public.shifts VALUES (882, '2025-06-01', 2, 3);
INSERT INTO public.shifts VALUES (883, '2025-06-02', 2, 3);
INSERT INTO public.shifts VALUES (884, '2025-06-03', 1, 3);
INSERT INTO public.shifts VALUES (885, '2025-06-04', 2, 3);
INSERT INTO public.shifts VALUES (886, '2025-06-05', 5, 3);
INSERT INTO public.shifts VALUES (887, '2025-06-06', 4, 3);
INSERT INTO public.shifts VALUES (888, '2025-06-07', 2, 3);
INSERT INTO public.shifts VALUES (889, '2025-06-08', 5, 3);
INSERT INTO public.shifts VALUES (890, '2025-06-09', 1, 3);
INSERT INTO public.shifts VALUES (891, '2025-06-10', 4, 3);
INSERT INTO public.shifts VALUES (892, '2025-06-11', 4, 3);
INSERT INTO public.shifts VALUES (893, '2025-06-12', 1, 3);
INSERT INTO public.shifts VALUES (894, '2025-06-13', 1, 3);
INSERT INTO public.shifts VALUES (895, '2025-06-14', 4, 3);
INSERT INTO public.shifts VALUES (896, '2025-06-15', 5, 3);
INSERT INTO public.shifts VALUES (897, '2025-06-16', 2, 3);
INSERT INTO public.shifts VALUES (898, '2025-06-17', 4, 3);
INSERT INTO public.shifts VALUES (899, '2025-06-18', 5, 3);
INSERT INTO public.shifts VALUES (900, '2025-06-19', 2, 3);
INSERT INTO public.shifts VALUES (901, '2025-06-20', 1, 3);
INSERT INTO public.shifts VALUES (902, '2025-06-21', 1, 3);
INSERT INTO public.shifts VALUES (903, '2025-06-22', 2, 3);
INSERT INTO public.shifts VALUES (904, '2025-06-23', 1, 3);
INSERT INTO public.shifts VALUES (905, '2025-06-24', 2, 3);
INSERT INTO public.shifts VALUES (906, '2025-06-25', 2, 3);
INSERT INTO public.shifts VALUES (907, '2025-06-26', 4, 3);
INSERT INTO public.shifts VALUES (908, '2025-06-27', 4, 3);
INSERT INTO public.shifts VALUES (909, '2025-06-28', 1, 3);
INSERT INTO public.shifts VALUES (910, '2025-06-29', 5, 3);
INSERT INTO public.shifts VALUES (911, '2025-06-30', 5, 3);
INSERT INTO public.shifts VALUES (912, '2025-07-01', 5, 3);
INSERT INTO public.shifts VALUES (913, '2025-07-02', 5, 3);
INSERT INTO public.shifts VALUES (914, '2025-07-03', 1, 3);
INSERT INTO public.shifts VALUES (915, '2025-07-04', 5, 3);
INSERT INTO public.shifts VALUES (916, '2025-07-05', 2, 3);
INSERT INTO public.shifts VALUES (917, '2025-07-06', 4, 3);
INSERT INTO public.shifts VALUES (918, '2025-07-07', 1, 3);
INSERT INTO public.shifts VALUES (919, '2025-07-08', 4, 3);
INSERT INTO public.shifts VALUES (920, '2025-07-09', 1, 3);
INSERT INTO public.shifts VALUES (921, '2025-07-10', 1, 3);
INSERT INTO public.shifts VALUES (922, '2025-07-11', 1, 3);
INSERT INTO public.shifts VALUES (923, '2025-07-12', 1, 3);
INSERT INTO public.shifts VALUES (924, '2025-07-13', 2, 3);
INSERT INTO public.shifts VALUES (925, '2025-07-14', 1, 3);
INSERT INTO public.shifts VALUES (926, '2025-07-15', 5, 3);
INSERT INTO public.shifts VALUES (927, '2025-07-16', 2, 3);
INSERT INTO public.shifts VALUES (928, '2025-07-17', 2, 3);
INSERT INTO public.shifts VALUES (929, '2025-07-18', 2, 3);
INSERT INTO public.shifts VALUES (930, '2025-07-19', 2, 3);
INSERT INTO public.shifts VALUES (931, '2025-07-20', 4, 3);
INSERT INTO public.shifts VALUES (932, '2025-07-21', 2, 3);
INSERT INTO public.shifts VALUES (933, '2025-07-22', 1, 3);
INSERT INTO public.shifts VALUES (934, '2025-07-23', 1, 3);
INSERT INTO public.shifts VALUES (935, '2025-07-24', 2, 3);
INSERT INTO public.shifts VALUES (936, '2025-07-25', 4, 3);
INSERT INTO public.shifts VALUES (937, '2025-07-26', 5, 3);
INSERT INTO public.shifts VALUES (939, '2025-07-28', 4, 3);
INSERT INTO public.shifts VALUES (940, '2025-07-29', 4, 3);
INSERT INTO public.shifts VALUES (941, '2025-07-30', 1, 3);
INSERT INTO public.shifts VALUES (942, '2025-07-31', 5, 3);
INSERT INTO public.shifts VALUES (943, '2025-08-01', 5, 3);
INSERT INTO public.shifts VALUES (944, '2025-08-02', 1, 3);
INSERT INTO public.shifts VALUES (945, '2025-08-03', 2, 3);
INSERT INTO public.shifts VALUES (946, '2025-08-04', 5, 3);
INSERT INTO public.shifts VALUES (947, '2025-08-05', 1, 3);
INSERT INTO public.shifts VALUES (948, '2025-08-06', 1, 3);
INSERT INTO public.shifts VALUES (949, '2025-08-07', 1, 3);
INSERT INTO public.shifts VALUES (950, '2025-08-08', 1, 3);
INSERT INTO public.shifts VALUES (951, '2025-08-09', 5, 3);
INSERT INTO public.shifts VALUES (952, '2025-08-10', 4, 3);
INSERT INTO public.shifts VALUES (953, '2025-08-11', 4, 3);
INSERT INTO public.shifts VALUES (954, '2025-08-12', 4, 3);
INSERT INTO public.shifts VALUES (955, '2025-08-13', 2, 3);
INSERT INTO public.shifts VALUES (956, '2025-08-14', 5, 3);
INSERT INTO public.shifts VALUES (957, '2025-08-15', 5, 3);
INSERT INTO public.shifts VALUES (958, '2025-08-16', 1, 3);
INSERT INTO public.shifts VALUES (959, '2025-08-17', 1, 3);
INSERT INTO public.shifts VALUES (960, '2025-08-18', 1, 3);
INSERT INTO public.shifts VALUES (961, '2025-08-19', 5, 3);
INSERT INTO public.shifts VALUES (962, '2025-08-20', 4, 3);
INSERT INTO public.shifts VALUES (963, '2025-08-21', 5, 3);
INSERT INTO public.shifts VALUES (964, '2025-08-22', 2, 3);
INSERT INTO public.shifts VALUES (965, '2025-08-23', 1, 3);
INSERT INTO public.shifts VALUES (966, '2025-08-24', 5, 3);
INSERT INTO public.shifts VALUES (967, '2025-08-25', 2, 3);
INSERT INTO public.shifts VALUES (968, '2025-08-26', 5, 3);
INSERT INTO public.shifts VALUES (969, '2025-08-27', 5, 3);
INSERT INTO public.shifts VALUES (970, '2025-08-28', 2, 3);
INSERT INTO public.shifts VALUES (971, '2025-08-29', 5, 3);
INSERT INTO public.shifts VALUES (972, '2025-08-30', 5, 3);
INSERT INTO public.shifts VALUES (973, '2025-08-31', 4, 3);
INSERT INTO public.shifts VALUES (974, '2025-09-01', 1, 3);
INSERT INTO public.shifts VALUES (975, '2025-09-02', 5, 3);
INSERT INTO public.shifts VALUES (976, '2025-09-03', 1, 3);
INSERT INTO public.shifts VALUES (977, '2025-09-04', 4, 3);
INSERT INTO public.shifts VALUES (978, '2025-09-05', 1, 3);
INSERT INTO public.shifts VALUES (979, '2025-09-06', 5, 3);
INSERT INTO public.shifts VALUES (980, '2025-09-07', 1, 3);
INSERT INTO public.shifts VALUES (981, '2025-09-08', 5, 3);
INSERT INTO public.shifts VALUES (982, '2025-09-09', 1, 3);
INSERT INTO public.shifts VALUES (983, '2025-09-10', 2, 3);
INSERT INTO public.shifts VALUES (984, '2025-09-11', 2, 3);
INSERT INTO public.shifts VALUES (985, '2025-09-12', 2, 3);
INSERT INTO public.shifts VALUES (986, '2025-09-13', 4, 3);
INSERT INTO public.shifts VALUES (987, '2025-09-14', 1, 3);
INSERT INTO public.shifts VALUES (988, '2025-09-15', 1, 3);
INSERT INTO public.shifts VALUES (989, '2025-09-16', 4, 3);
INSERT INTO public.shifts VALUES (990, '2025-09-17', 4, 3);
INSERT INTO public.shifts VALUES (991, '2025-09-18', 2, 3);
INSERT INTO public.shifts VALUES (992, '2025-09-19', 2, 3);
INSERT INTO public.shifts VALUES (993, '2025-09-20', 1, 3);
INSERT INTO public.shifts VALUES (994, '2025-09-21', 1, 3);
INSERT INTO public.shifts VALUES (995, '2025-09-22', 1, 3);
INSERT INTO public.shifts VALUES (996, '2025-09-23', 4, 3);
INSERT INTO public.shifts VALUES (997, '2025-09-24', 2, 3);
INSERT INTO public.shifts VALUES (998, '2025-09-25', 2, 3);
INSERT INTO public.shifts VALUES (999, '2025-09-26', 5, 3);
INSERT INTO public.shifts VALUES (1000, '2025-09-27', 4, 3);
INSERT INTO public.shifts VALUES (1001, '2025-09-28', 2, 3);
INSERT INTO public.shifts VALUES (1002, '2025-09-29', 2, 3);
INSERT INTO public.shifts VALUES (1003, '2025-09-30', 5, 3);
INSERT INTO public.shifts VALUES (1004, '2025-10-01', 4, 3);
INSERT INTO public.shifts VALUES (1005, '2025-10-02', 5, 3);
INSERT INTO public.shifts VALUES (1006, '2025-10-03', 4, 3);
INSERT INTO public.shifts VALUES (1007, '2025-10-04', 1, 3);
INSERT INTO public.shifts VALUES (1008, '2025-10-05', 4, 3);
INSERT INTO public.shifts VALUES (1009, '2025-10-06', 1, 3);
INSERT INTO public.shifts VALUES (1010, '2025-10-07', 4, 3);
INSERT INTO public.shifts VALUES (1011, '2025-10-08', 4, 3);
INSERT INTO public.shifts VALUES (1012, '2025-10-09', 5, 3);
INSERT INTO public.shifts VALUES (1013, '2025-10-10', 4, 3);
INSERT INTO public.shifts VALUES (1014, '2025-10-11', 4, 3);
INSERT INTO public.shifts VALUES (1015, '2025-10-12', 4, 3);
INSERT INTO public.shifts VALUES (1016, '2025-10-13', 2, 3);
INSERT INTO public.shifts VALUES (1017, '2025-10-14', 2, 3);
INSERT INTO public.shifts VALUES (1018, '2025-10-15', 4, 3);
INSERT INTO public.shifts VALUES (1019, '2025-10-16', 4, 3);
INSERT INTO public.shifts VALUES (938, '2025-07-27', 4, 3);
INSERT INTO public.shifts VALUES (71, '2025-03-12', 2, 1);
INSERT INTO public.shifts VALUES (72, '2025-03-13', 5, 1);
INSERT INTO public.shifts VALUES (73, '2025-03-14', 4, 1);
INSERT INTO public.shifts VALUES (74, '2025-03-15', 1, 1);
INSERT INTO public.shifts VALUES (75, '2025-03-16', 2, 1);
INSERT INTO public.shifts VALUES (76, '2025-03-17', 2, 1);
INSERT INTO public.shifts VALUES (77, '2025-03-18', 1, 1);
INSERT INTO public.shifts VALUES (78, '2025-03-19', 1, 1);
INSERT INTO public.shifts VALUES (79, '2025-03-20', 4, 1);
INSERT INTO public.shifts VALUES (80, '2025-03-21', 4, 1);
INSERT INTO public.shifts VALUES (81, '2025-03-22', 5, 1);
INSERT INTO public.shifts VALUES (82, '2025-03-23', 5, 1);
INSERT INTO public.shifts VALUES (83, '2025-03-24', 1, 1);
INSERT INTO public.shifts VALUES (84, '2025-03-25', 5, 1);
INSERT INTO public.shifts VALUES (85, '2025-03-26', 2, 1);
INSERT INTO public.shifts VALUES (86, '2025-03-27', 4, 1);
INSERT INTO public.shifts VALUES (87, '2025-03-28', 4, 1);
INSERT INTO public.shifts VALUES (88, '2025-03-29', 4, 1);
INSERT INTO public.shifts VALUES (89, '2025-03-30', 4, 1);
INSERT INTO public.shifts VALUES (90, '2025-03-31', 5, 1);
INSERT INTO public.shifts VALUES (91, '2025-04-01', 4, 1);
INSERT INTO public.shifts VALUES (92, '2025-04-02', 4, 1);
INSERT INTO public.shifts VALUES (93, '2025-04-03', 1, 1);
INSERT INTO public.shifts VALUES (94, '2025-04-04', 5, 1);
INSERT INTO public.shifts VALUES (95, '2025-04-05', 4, 1);
INSERT INTO public.shifts VALUES (96, '2025-04-06', 2, 1);
INSERT INTO public.shifts VALUES (97, '2025-04-07', 1, 1);
INSERT INTO public.shifts VALUES (98, '2025-04-08', 2, 1);
INSERT INTO public.shifts VALUES (99, '2025-04-09', 1, 1);
INSERT INTO public.shifts VALUES (100, '2025-04-10', 4, 1);
INSERT INTO public.shifts VALUES (101, '2025-04-11', 1, 1);
INSERT INTO public.shifts VALUES (102, '2025-04-12', 5, 1);
INSERT INTO public.shifts VALUES (103, '2025-04-13', 2, 1);
INSERT INTO public.shifts VALUES (104, '2025-04-14', 4, 1);
INSERT INTO public.shifts VALUES (105, '2025-04-15', 4, 1);
INSERT INTO public.shifts VALUES (106, '2025-04-16', 1, 1);
INSERT INTO public.shifts VALUES (107, '2025-04-17', 5, 1);
INSERT INTO public.shifts VALUES (108, '2025-04-18', 4, 1);
INSERT INTO public.shifts VALUES (109, '2025-04-19', 2, 1);
INSERT INTO public.shifts VALUES (110, '2025-04-20', 4, 1);
INSERT INTO public.shifts VALUES (111, '2025-04-21', 2, 1);
INSERT INTO public.shifts VALUES (112, '2025-04-22', 4, 1);
INSERT INTO public.shifts VALUES (113, '2025-04-23', 2, 1);
INSERT INTO public.shifts VALUES (114, '2025-04-24', 1, 1);
INSERT INTO public.shifts VALUES (115, '2025-04-25', 1, 1);
INSERT INTO public.shifts VALUES (116, '2025-04-26', 2, 1);
INSERT INTO public.shifts VALUES (117, '2025-04-27', 4, 1);
INSERT INTO public.shifts VALUES (118, '2025-04-28', 4, 1);
INSERT INTO public.shifts VALUES (119, '2025-04-29', 1, 1);
INSERT INTO public.shifts VALUES (120, '2025-04-30', 5, 1);
INSERT INTO public.shifts VALUES (121, '2025-05-01', 2, 1);
INSERT INTO public.shifts VALUES (122, '2025-05-02', 5, 1);
INSERT INTO public.shifts VALUES (123, '2025-05-03', 2, 1);
INSERT INTO public.shifts VALUES (124, '2025-05-04', 5, 1);
INSERT INTO public.shifts VALUES (125, '2025-05-05', 1, 1);
INSERT INTO public.shifts VALUES (126, '2025-05-06', 5, 1);
INSERT INTO public.shifts VALUES (127, '2025-05-07', 2, 1);
INSERT INTO public.shifts VALUES (128, '2025-05-08', 1, 1);
INSERT INTO public.shifts VALUES (129, '2025-05-09', 5, 1);
INSERT INTO public.shifts VALUES (130, '2025-05-10', 1, 1);
INSERT INTO public.shifts VALUES (131, '2025-05-11', 1, 1);
INSERT INTO public.shifts VALUES (132, '2025-05-12', 4, 1);
INSERT INTO public.shifts VALUES (133, '2025-05-13', 1, 1);
INSERT INTO public.shifts VALUES (134, '2025-05-14', 5, 1);
INSERT INTO public.shifts VALUES (135, '2025-05-15', 1, 1);
INSERT INTO public.shifts VALUES (136, '2025-05-16', 5, 1);
INSERT INTO public.shifts VALUES (137, '2025-05-17', 1, 1);
INSERT INTO public.shifts VALUES (138, '2025-05-18', 4, 1);
INSERT INTO public.shifts VALUES (139, '2025-05-19', 1, 1);
INSERT INTO public.shifts VALUES (140, '2025-05-20', 5, 1);
INSERT INTO public.shifts VALUES (141, '2025-05-21', 1, 1);
INSERT INTO public.shifts VALUES (142, '2025-05-22', 4, 1);
INSERT INTO public.shifts VALUES (143, '2025-05-23', 1, 1);
INSERT INTO public.shifts VALUES (144, '2025-05-24', 2, 1);
INSERT INTO public.shifts VALUES (145, '2025-05-25', 4, 1);
INSERT INTO public.shifts VALUES (146, '2025-05-26', 2, 1);
INSERT INTO public.shifts VALUES (147, '2025-05-27', 2, 1);
INSERT INTO public.shifts VALUES (148, '2025-05-28', 5, 1);
INSERT INTO public.shifts VALUES (149, '2025-05-29', 1, 1);
INSERT INTO public.shifts VALUES (150, '2025-05-30', 5, 1);
INSERT INTO public.shifts VALUES (151, '2025-05-31', 2, 1);
INSERT INTO public.shifts VALUES (152, '2025-06-01', 1, 1);
INSERT INTO public.shifts VALUES (153, '2025-06-02', 4, 1);
INSERT INTO public.shifts VALUES (154, '2025-06-03', 4, 1);
INSERT INTO public.shifts VALUES (155, '2025-06-04', 5, 1);
INSERT INTO public.shifts VALUES (156, '2025-06-05', 5, 1);
INSERT INTO public.shifts VALUES (157, '2025-06-06', 4, 1);
INSERT INTO public.shifts VALUES (158, '2025-06-07', 5, 1);
INSERT INTO public.shifts VALUES (159, '2025-06-08', 2, 1);
INSERT INTO public.shifts VALUES (160, '2025-06-09', 1, 1);
INSERT INTO public.shifts VALUES (1020, '2025-10-17', 4, 3);
INSERT INTO public.shifts VALUES (1021, '2025-10-18', 2, 3);
INSERT INTO public.shifts VALUES (1022, '2025-10-19', 4, 3);
INSERT INTO public.shifts VALUES (1023, '2025-10-20', 5, 3);
INSERT INTO public.shifts VALUES (1024, '2025-10-21', 2, 3);
INSERT INTO public.shifts VALUES (1025, '2025-10-22', 5, 3);
INSERT INTO public.shifts VALUES (1026, '2025-10-23', 5, 3);
INSERT INTO public.shifts VALUES (1027, '2025-10-24', 2, 3);
INSERT INTO public.shifts VALUES (1028, '2025-10-25', 2, 3);
INSERT INTO public.shifts VALUES (1029, '2025-10-26', 1, 3);
INSERT INTO public.shifts VALUES (1030, '2025-10-27', 1, 3);
INSERT INTO public.shifts VALUES (1031, '2025-10-28', 4, 3);
INSERT INTO public.shifts VALUES (1032, '2025-10-29', 4, 3);
INSERT INTO public.shifts VALUES (1033, '2025-10-30', 4, 3);
INSERT INTO public.shifts VALUES (1034, '2025-10-31', 4, 3);
INSERT INTO public.shifts VALUES (1035, '2025-11-01', 2, 3);
INSERT INTO public.shifts VALUES (1036, '2025-11-02', 5, 3);
INSERT INTO public.shifts VALUES (1037, '2025-11-03', 4, 3);
INSERT INTO public.shifts VALUES (1038, '2025-11-04', 1, 3);
INSERT INTO public.shifts VALUES (1039, '2025-11-05', 1, 3);
INSERT INTO public.shifts VALUES (1040, '2025-11-06', 2, 3);
INSERT INTO public.shifts VALUES (1041, '2025-11-07', 1, 3);
INSERT INTO public.shifts VALUES (1042, '2025-11-08', 5, 3);
INSERT INTO public.shifts VALUES (1043, '2025-11-09', 4, 3);
INSERT INTO public.shifts VALUES (1044, '2025-11-10', 2, 3);
INSERT INTO public.shifts VALUES (1045, '2025-11-11', 5, 3);
INSERT INTO public.shifts VALUES (1046, '2025-11-12', 1, 3);
INSERT INTO public.shifts VALUES (1047, '2025-11-13', 2, 3);
INSERT INTO public.shifts VALUES (1048, '2025-11-14', 2, 3);
INSERT INTO public.shifts VALUES (1049, '2025-11-15', 2, 3);
INSERT INTO public.shifts VALUES (1050, '2025-11-16', 1, 3);
INSERT INTO public.shifts VALUES (1051, '2025-11-17', 1, 3);
INSERT INTO public.shifts VALUES (1052, '2025-11-18', 4, 3);
INSERT INTO public.shifts VALUES (1053, '2025-11-19', 2, 3);
INSERT INTO public.shifts VALUES (1054, '2025-11-20', 1, 3);
INSERT INTO public.shifts VALUES (1055, '2025-11-21', 2, 3);
INSERT INTO public.shifts VALUES (1056, '2025-11-22', 4, 3);
INSERT INTO public.shifts VALUES (1057, '2025-11-23', 4, 3);
INSERT INTO public.shifts VALUES (1058, '2025-11-24', 2, 3);
INSERT INTO public.shifts VALUES (1059, '2025-11-25', 4, 3);
INSERT INTO public.shifts VALUES (1060, '2025-11-26', 1, 3);
INSERT INTO public.shifts VALUES (1061, '2025-11-27', 2, 3);
INSERT INTO public.shifts VALUES (1062, '2025-11-28', 5, 3);
INSERT INTO public.shifts VALUES (1063, '2025-11-29', 4, 3);
INSERT INTO public.shifts VALUES (1064, '2025-11-30', 4, 3);
INSERT INTO public.shifts VALUES (1065, '2025-12-01', 4, 3);
INSERT INTO public.shifts VALUES (1066, '2025-12-02', 4, 3);
INSERT INTO public.shifts VALUES (1067, '2025-12-03', 5, 3);
INSERT INTO public.shifts VALUES (1068, '2025-12-04', 1, 3);
INSERT INTO public.shifts VALUES (1069, '2025-12-05', 4, 3);
INSERT INTO public.shifts VALUES (1070, '2025-12-06', 4, 3);
INSERT INTO public.shifts VALUES (1071, '2025-12-07', 5, 3);
INSERT INTO public.shifts VALUES (1072, '2025-12-08', 2, 3);
INSERT INTO public.shifts VALUES (1073, '2025-12-09', 2, 3);
INSERT INTO public.shifts VALUES (1074, '2025-12-10', 1, 3);
INSERT INTO public.shifts VALUES (1075, '2025-12-11', 1, 3);
INSERT INTO public.shifts VALUES (1076, '2025-12-12', 4, 3);
INSERT INTO public.shifts VALUES (1077, '2025-12-13', 1, 3);
INSERT INTO public.shifts VALUES (1078, '2025-12-14', 2, 3);
INSERT INTO public.shifts VALUES (1079, '2025-12-15', 2, 3);
INSERT INTO public.shifts VALUES (1080, '2025-12-16', 1, 3);
INSERT INTO public.shifts VALUES (1081, '2025-12-17', 4, 3);
INSERT INTO public.shifts VALUES (1082, '2025-12-18', 1, 3);
INSERT INTO public.shifts VALUES (1083, '2025-12-19', 1, 3);
INSERT INTO public.shifts VALUES (1084, '2025-12-20', 1, 3);
INSERT INTO public.shifts VALUES (1085, '2025-12-21', 5, 3);
INSERT INTO public.shifts VALUES (1086, '2025-12-22', 4, 3);
INSERT INTO public.shifts VALUES (1087, '2025-12-23', 1, 3);
INSERT INTO public.shifts VALUES (1088, '2025-12-24', 2, 3);
INSERT INTO public.shifts VALUES (1089, '2025-12-25', 1, 3);
INSERT INTO public.shifts VALUES (1090, '2025-12-26', 5, 3);
INSERT INTO public.shifts VALUES (1091, '2025-12-27', 1, 3);
INSERT INTO public.shifts VALUES (1092, '2025-12-28', 4, 3);
INSERT INTO public.shifts VALUES (1093, '2025-12-29', 5, 3);
INSERT INTO public.shifts VALUES (1094, '2025-12-30', 2, 3);
INSERT INTO public.shifts VALUES (1095, '2025-12-31', 2, 3);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: shift_schedule_db_user
--

INSERT INTO public.users VALUES (1, 'Alice', 'Muster', '$2b$10$ZWFtn9cFGL/MgVgQM61xiOKvY125GLTEIB.Zi0h09JhZjSh4aP.HG', 1000, 1, 28, false);
INSERT INTO public.users VALUES (2, 'Bob', 'Muster', '$2b$10$cnbI95MxTXoS0ICCRzjK0ePcbzxfrBCnwVC.oyjkkqSmOgAHI/eZS', 1001, 1, 30, true);
INSERT INTO public.users VALUES (3, 'Carsten', 'Muster', '$2a$10$IfTwGWhx/v6Um13v2YdG9.yWvfzWlqreLg0x./aJ0f/dC4b9W4vL.', 1002, 1, 30, false);


--
-- Name: shift_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.shift_types_id_seq', 5, true);


--
-- Name: shifts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.shifts_id_seq', 1095, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shift_schedule_db_user
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: shift_types shift_types_pkey; Type: CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shift_types
    ADD CONSTRAINT shift_types_pkey PRIMARY KEY (id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: users users_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_employee_id_key UNIQUE (employee_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: shifts fk_shift_type; Type: FK CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT fk_shift_type FOREIGN KEY (shift_type_id) REFERENCES public.shift_types(id) ON DELETE CASCADE;


--
-- Name: shifts fk_user; Type: FK CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shifts shifts_shift_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_shift_type_id_fkey FOREIGN KEY (shift_type_id) REFERENCES public.shift_types(id);


--
-- Name: shifts shifts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: shift_schedule_db_user
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO shift_schedule_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO shift_schedule_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO shift_schedule_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO shift_schedule_db_user;


--
-- PostgreSQL database dump complete
--


