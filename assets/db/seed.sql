--
-- PostgreSQL database dump
--

\restrict Iv017OFjjos8iouf7PZ16tJbBbld4ebgSWZ2ihgYxg7RuPRoo6oeLshpCtJGDVH

-- Dumped from database version 16.10 (Debian 16.10-1.pgdg13+1)
-- Dumped by pg_dump version 16.10 (Debian 16.10-1.pgdg13+1)

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


DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS shifts CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP SEQUENCE IF EXISTS items_id_seq CASCADE;
DROP SEQUENCE IF EXISTS shifts_id_seq CASCADE;
DROP SEQUENCE IF EXISTS users_id_seq CASCADE;

--
-- Name: shifts; Type: TABLE; Schema: public; Owner: myuser
--
CREATE TABLE public.shifts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    shift_date date NOT NULL,
    shift_type text,
    CONSTRAINT shifts_shift_type_check CHECK ((shift_type = ANY (ARRAY['Frühschicht'::text, 'Spätschicht'::text, 'Urlaub'::text, 'Krank'::text])))
);


ALTER TABLE public.shifts OWNER TO myuser;

--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.shifts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shifts_id_seq OWNER TO myuser;

--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: myuser
--
CREATE TABLE public.users (
    id integer NOT NULL,
    name text NOT NULL,
    password text
);


ALTER TABLE public.users OWNER TO myuser;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: myuser
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO myuser;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: myuser
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.items (id, name) FROM stdin;
\.


--
-- Data for Name: shifts; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.shifts (id, user_id, shift_date, shift_type) FROM stdin;
1	1	2025-01-01	Urlaub
2	1	2025-01-02	Urlaub
3	1	2025-01-03	Frühschicht
4	1	2025-01-04	Frühschicht
5	1	2025-01-05	Frühschicht
6	1	2025-01-06	Krank
7	1	2025-01-07	Frühschicht
8	1	2025-01-08	Spätschicht
9	1	2025-01-09	Krank
10	1	2025-01-10	Frühschicht
11	1	2025-01-11	Krank
12	1	2025-01-12	Spätschicht
13	1	2025-01-13	Krank
14	1	2025-01-14	Spätschicht
15	1	2025-01-15	Spätschicht
16	1	2025-01-16	Frühschicht
17	1	2025-01-17	Urlaub
18	1	2025-01-18	Frühschicht
19	1	2025-01-19	Urlaub
20	1	2025-01-20	Frühschicht
21	1	2025-01-21	Spätschicht
22	1	2025-01-22	Krank
23	1	2025-01-23	Urlaub
24	1	2025-01-24	Urlaub
25	1	2025-01-25	Urlaub
26	1	2025-01-26	Frühschicht
27	1	2025-01-27	Krank
28	1	2025-01-28	Spätschicht
29	1	2025-01-29	Spätschicht
30	1	2025-01-30	Urlaub
31	1	2025-01-31	Spätschicht
32	1	2025-02-01	Krank
33	1	2025-02-02	Krank
34	1	2025-02-03	Spätschicht
35	1	2025-02-04	Urlaub
36	1	2025-02-05	Krank
37	1	2025-02-06	Urlaub
38	1	2025-02-07	Urlaub
39	1	2025-02-08	Krank
40	1	2025-02-09	Krank
41	1	2025-02-10	Urlaub
42	1	2025-02-11	Urlaub
43	1	2025-02-12	Spätschicht
44	1	2025-02-13	Krank
45	1	2025-02-14	Urlaub
46	1	2025-02-15	Spätschicht
47	1	2025-02-16	Frühschicht
48	1	2025-02-17	Urlaub
49	1	2025-02-18	Urlaub
50	1	2025-02-19	Urlaub
51	1	2025-02-20	Spätschicht
52	1	2025-02-21	Frühschicht
53	1	2025-02-22	Urlaub
54	1	2025-02-23	Urlaub
55	1	2025-02-24	Urlaub
56	1	2025-02-25	Urlaub
57	1	2025-02-26	Urlaub
58	1	2025-02-27	Krank
59	1	2025-02-28	Frühschicht
60	1	2025-03-01	Urlaub
61	1	2025-03-02	Krank
62	1	2025-03-03	Krank
63	1	2025-03-04	Urlaub
64	1	2025-03-05	Frühschicht
65	1	2025-03-06	Spätschicht
66	1	2025-03-07	Frühschicht
67	1	2025-03-08	Krank
68	1	2025-03-09	Krank
69	1	2025-03-10	Spätschicht
70	1	2025-03-11	Spätschicht
71	1	2025-03-12	Spätschicht
72	1	2025-03-13	Urlaub
73	1	2025-03-14	Krank
74	1	2025-03-15	Frühschicht
75	1	2025-03-16	Spätschicht
76	1	2025-03-17	Spätschicht
77	1	2025-03-18	Frühschicht
78	1	2025-03-19	Frühschicht
79	1	2025-03-20	Krank
80	1	2025-03-21	Krank
81	1	2025-03-22	Urlaub
82	1	2025-03-23	Urlaub
83	1	2025-03-24	Frühschicht
84	1	2025-03-25	Urlaub
85	1	2025-03-26	Spätschicht
86	1	2025-03-27	Krank
87	1	2025-03-28	Krank
88	1	2025-03-29	Krank
89	1	2025-03-30	Krank
90	1	2025-03-31	Urlaub
91	1	2025-04-01	Krank
92	1	2025-04-02	Krank
93	1	2025-04-03	Frühschicht
94	1	2025-04-04	Urlaub
95	1	2025-04-05	Krank
96	1	2025-04-06	Spätschicht
97	1	2025-04-07	Frühschicht
98	1	2025-04-08	Spätschicht
99	1	2025-04-09	Frühschicht
100	1	2025-04-10	Krank
101	1	2025-04-11	Frühschicht
102	1	2025-04-12	Urlaub
103	1	2025-04-13	Spätschicht
104	1	2025-04-14	Krank
105	1	2025-04-15	Krank
106	1	2025-04-16	Frühschicht
107	1	2025-04-17	Urlaub
108	1	2025-04-18	Krank
109	1	2025-04-19	Spätschicht
110	1	2025-04-20	Krank
111	1	2025-04-21	Spätschicht
112	1	2025-04-22	Krank
113	1	2025-04-23	Spätschicht
114	1	2025-04-24	Frühschicht
115	1	2025-04-25	Frühschicht
116	1	2025-04-26	Spätschicht
117	1	2025-04-27	Krank
118	1	2025-04-28	Krank
119	1	2025-04-29	Frühschicht
120	1	2025-04-30	Urlaub
121	1	2025-05-01	Spätschicht
122	1	2025-05-02	Urlaub
123	1	2025-05-03	Spätschicht
124	1	2025-05-04	Urlaub
125	1	2025-05-05	Frühschicht
126	1	2025-05-06	Urlaub
127	1	2025-05-07	Spätschicht
128	1	2025-05-08	Frühschicht
129	1	2025-05-09	Urlaub
130	1	2025-05-10	Frühschicht
131	1	2025-05-11	Frühschicht
132	1	2025-05-12	Krank
133	1	2025-05-13	Frühschicht
134	1	2025-05-14	Urlaub
135	1	2025-05-15	Frühschicht
136	1	2025-05-16	Urlaub
137	1	2025-05-17	Frühschicht
138	1	2025-05-18	Krank
139	1	2025-05-19	Frühschicht
140	1	2025-05-20	Urlaub
141	1	2025-05-21	Frühschicht
142	1	2025-05-22	Krank
143	1	2025-05-23	Frühschicht
144	1	2025-05-24	Spätschicht
145	1	2025-05-25	Krank
146	1	2025-05-26	Spätschicht
147	1	2025-05-27	Spätschicht
148	1	2025-05-28	Urlaub
149	1	2025-05-29	Frühschicht
150	1	2025-05-30	Urlaub
151	1	2025-05-31	Spätschicht
152	1	2025-06-01	Frühschicht
153	1	2025-06-02	Krank
154	1	2025-06-03	Krank
155	1	2025-06-04	Urlaub
156	1	2025-06-05	Urlaub
157	1	2025-06-06	Krank
158	1	2025-06-07	Urlaub
159	1	2025-06-08	Spätschicht
160	1	2025-06-09	Frühschicht
161	1	2025-06-10	Urlaub
162	1	2025-06-11	Krank
163	1	2025-06-12	Urlaub
164	1	2025-06-13	Urlaub
165	1	2025-06-14	Spätschicht
166	1	2025-06-15	Urlaub
167	1	2025-06-16	Spätschicht
168	1	2025-06-17	Urlaub
169	1	2025-06-18	Krank
170	1	2025-06-19	Krank
171	1	2025-06-20	Spätschicht
172	1	2025-06-21	Frühschicht
173	1	2025-06-22	Frühschicht
174	1	2025-06-23	Frühschicht
175	1	2025-06-24	Urlaub
176	1	2025-06-25	Spätschicht
177	1	2025-06-26	Krank
178	1	2025-06-27	Frühschicht
179	1	2025-06-28	Urlaub
180	1	2025-06-29	Frühschicht
181	1	2025-06-30	Spätschicht
182	1	2025-07-01	Frühschicht
183	1	2025-07-02	Frühschicht
184	1	2025-07-03	Frühschicht
185	1	2025-07-04	Urlaub
186	1	2025-07-05	Frühschicht
187	1	2025-07-06	Krank
188	1	2025-07-07	Spätschicht
189	1	2025-07-08	Urlaub
190	1	2025-07-09	Frühschicht
191	1	2025-07-10	Urlaub
192	1	2025-07-11	Frühschicht
193	1	2025-07-12	Urlaub
194	1	2025-07-13	Spätschicht
195	1	2025-07-14	Urlaub
196	1	2025-07-15	Spätschicht
197	1	2025-07-16	Frühschicht
198	1	2025-07-17	Spätschicht
199	1	2025-07-18	Urlaub
200	1	2025-07-19	Frühschicht
201	1	2025-07-20	Krank
202	1	2025-07-21	Krank
203	1	2025-07-22	Krank
204	1	2025-07-23	Frühschicht
205	1	2025-07-24	Urlaub
206	1	2025-07-25	Frühschicht
207	1	2025-07-26	Krank
208	1	2025-07-27	Urlaub
209	1	2025-07-28	Urlaub
210	1	2025-07-29	Spätschicht
211	1	2025-07-30	Urlaub
212	1	2025-07-31	Urlaub
213	1	2025-08-01	Urlaub
214	1	2025-08-02	Krank
215	1	2025-08-03	Urlaub
216	1	2025-08-04	Spätschicht
217	1	2025-08-05	Spätschicht
218	1	2025-08-06	Frühschicht
219	1	2025-08-07	Spätschicht
220	1	2025-08-08	Spätschicht
221	1	2025-08-09	Urlaub
222	1	2025-08-10	Frühschicht
223	1	2025-08-11	Frühschicht
224	1	2025-08-12	Krank
225	1	2025-08-13	Frühschicht
226	1	2025-08-14	Frühschicht
227	1	2025-08-15	Spätschicht
228	1	2025-08-16	Krank
229	1	2025-08-17	Urlaub
230	1	2025-08-18	Krank
231	1	2025-08-19	Krank
232	1	2025-08-20	Krank
233	1	2025-08-21	Frühschicht
234	1	2025-08-22	Frühschicht
235	1	2025-08-23	Krank
236	1	2025-08-24	Spätschicht
237	1	2025-08-25	Krank
238	1	2025-08-26	Krank
239	1	2025-08-27	Frühschicht
240	1	2025-08-28	Frühschicht
241	1	2025-08-29	Spätschicht
242	1	2025-08-30	Krank
243	1	2025-08-31	Frühschicht
244	1	2025-09-01	Frühschicht
245	1	2025-09-02	Frühschicht
246	1	2025-09-03	Frühschicht
247	1	2025-09-04	Spätschicht
248	1	2025-09-05	Spätschicht
249	1	2025-09-06	Krank
250	1	2025-09-07	Spätschicht
251	1	2025-09-08	Spätschicht
252	1	2025-09-09	Frühschicht
253	1	2025-09-10	Krank
254	1	2025-09-11	Spätschicht
255	1	2025-09-12	Frühschicht
256	1	2025-09-13	Urlaub
257	1	2025-09-14	Spätschicht
258	1	2025-09-15	Krank
259	1	2025-09-16	Frühschicht
260	1	2025-09-17	Frühschicht
261	1	2025-09-18	Krank
262	1	2025-09-19	Krank
263	1	2025-09-20	Urlaub
264	1	2025-09-21	Frühschicht
265	1	2025-09-22	Krank
266	1	2025-09-23	Spätschicht
267	1	2025-09-24	Spätschicht
268	1	2025-09-25	Spätschicht
269	1	2025-09-26	Frühschicht
270	1	2025-09-27	Spätschicht
271	1	2025-09-28	Krank
272	1	2025-09-29	Krank
273	1	2025-09-30	Krank
274	1	2025-10-01	Spätschicht
275	1	2025-10-02	Frühschicht
276	1	2025-10-03	Urlaub
277	1	2025-10-04	Frühschicht
278	1	2025-10-05	Spätschicht
279	1	2025-10-06	Spätschicht
280	1	2025-10-07	Krank
281	1	2025-10-08	Krank
282	1	2025-10-09	Krank
283	1	2025-10-10	Krank
284	1	2025-10-11	Urlaub
285	1	2025-10-12	Krank
286	1	2025-10-13	Frühschicht
287	1	2025-10-14	Spätschicht
288	1	2025-10-15	Urlaub
289	1	2025-10-16	Urlaub
290	1	2025-10-17	Krank
291	1	2025-10-18	Krank
292	1	2025-10-19	Spätschicht
293	1	2025-10-20	Krank
294	1	2025-10-21	Urlaub
295	1	2025-10-22	Urlaub
296	1	2025-10-23	Frühschicht
297	1	2025-10-24	Spätschicht
298	1	2025-10-25	Urlaub
299	1	2025-10-26	Urlaub
300	1	2025-10-27	Spätschicht
301	1	2025-10-28	Urlaub
302	1	2025-10-29	Krank
303	1	2025-10-30	Spätschicht
304	1	2025-10-31	Spätschicht
305	1	2025-11-01	Spätschicht
306	1	2025-11-02	Krank
307	1	2025-11-03	Krank
308	1	2025-11-04	Urlaub
309	1	2025-11-05	Urlaub
310	1	2025-11-06	Spätschicht
311	1	2025-11-07	Spätschicht
312	1	2025-11-08	Urlaub
313	1	2025-11-09	Urlaub
314	1	2025-11-10	Urlaub
315	1	2025-11-11	Spätschicht
316	1	2025-11-12	Spätschicht
317	1	2025-11-13	Krank
318	1	2025-11-14	Krank
319	1	2025-11-15	Urlaub
320	1	2025-11-16	Krank
321	1	2025-11-17	Urlaub
322	1	2025-11-18	Krank
323	1	2025-11-19	Frühschicht
324	1	2025-11-20	Urlaub
325	1	2025-11-21	Frühschicht
326	1	2025-11-22	Urlaub
327	1	2025-11-23	Urlaub
328	1	2025-11-24	Frühschicht
329	1	2025-11-25	Frühschicht
330	1	2025-11-26	Urlaub
331	1	2025-11-27	Spätschicht
332	1	2025-11-28	Urlaub
333	1	2025-11-29	Spätschicht
334	1	2025-11-30	Spätschicht
335	1	2025-12-01	Urlaub
336	1	2025-12-02	Spätschicht
337	1	2025-12-03	Urlaub
338	1	2025-12-04	Krank
339	1	2025-12-05	Frühschicht
340	1	2025-12-06	Urlaub
341	1	2025-12-07	Krank
342	1	2025-12-08	Spätschicht
343	1	2025-12-09	Krank
344	1	2025-12-10	Frühschicht
345	1	2025-12-11	Urlaub
346	1	2025-12-12	Urlaub
347	1	2025-12-13	Krank
348	1	2025-12-14	Urlaub
349	1	2025-12-15	Frühschicht
350	1	2025-12-16	Krank
351	1	2025-12-17	Urlaub
352	1	2025-12-18	Urlaub
353	1	2025-12-19	Spätschicht
354	1	2025-12-20	Frühschicht
355	1	2025-12-21	Spätschicht
356	1	2025-12-22	Urlaub
357	1	2025-12-23	Krank
358	1	2025-12-24	Krank
359	1	2025-12-25	Spätschicht
360	1	2025-12-26	Frühschicht
361	1	2025-12-27	Frühschicht
362	1	2025-12-28	Krank
363	1	2025-12-29	Krank
364	1	2025-12-30	Urlaub
365	1	2025-12-31	Urlaub
366	2	2025-01-01	Urlaub
367	2	2025-01-02	Spätschicht
368	2	2025-01-03	Frühschicht
369	2	2025-01-04	Urlaub
370	2	2025-01-05	Spätschicht
371	2	2025-01-06	Urlaub
372	2	2025-01-07	Frühschicht
373	2	2025-01-08	Krank
374	2	2025-01-09	Urlaub
375	2	2025-01-10	Frühschicht
376	2	2025-01-11	Frühschicht
377	2	2025-01-12	Urlaub
378	2	2025-01-13	Krank
379	2	2025-01-14	Frühschicht
380	2	2025-01-15	Urlaub
381	2	2025-01-16	Urlaub
382	2	2025-01-17	Spätschicht
383	2	2025-01-18	Frühschicht
384	2	2025-01-19	Frühschicht
385	2	2025-01-20	Urlaub
386	2	2025-01-21	Urlaub
387	2	2025-01-22	Krank
388	2	2025-01-23	Spätschicht
389	2	2025-01-24	Urlaub
390	2	2025-01-25	Urlaub
391	2	2025-01-26	Frühschicht
392	2	2025-01-27	Urlaub
393	2	2025-01-28	Frühschicht
394	2	2025-01-29	Spätschicht
395	2	2025-01-30	Urlaub
396	2	2025-01-31	Spätschicht
397	2	2025-02-01	Urlaub
398	2	2025-02-02	Frühschicht
399	2	2025-02-03	Spätschicht
400	2	2025-02-04	Krank
401	2	2025-02-05	Frühschicht
402	2	2025-02-06	Spätschicht
403	2	2025-02-07	Spätschicht
404	2	2025-02-08	Frühschicht
405	2	2025-02-09	Frühschicht
406	2	2025-02-10	Urlaub
407	2	2025-02-11	Frühschicht
408	2	2025-02-12	Frühschicht
409	2	2025-02-13	Frühschicht
410	2	2025-02-14	Urlaub
411	2	2025-02-15	Urlaub
412	2	2025-02-16	Frühschicht
413	2	2025-02-17	Krank
414	2	2025-02-18	Spätschicht
415	2	2025-02-19	Spätschicht
416	2	2025-02-20	Urlaub
417	2	2025-02-21	Frühschicht
418	2	2025-02-22	Urlaub
419	2	2025-02-23	Urlaub
420	2	2025-02-24	Urlaub
421	2	2025-02-25	Spätschicht
422	2	2025-02-26	Krank
423	2	2025-02-27	Spätschicht
424	2	2025-02-28	Spätschicht
425	2	2025-03-01	Frühschicht
426	2	2025-03-02	Krank
427	2	2025-03-03	Urlaub
428	2	2025-03-04	Frühschicht
429	2	2025-03-05	Urlaub
430	2	2025-03-06	Krank
431	2	2025-03-07	Spätschicht
432	2	2025-03-08	Krank
433	2	2025-03-09	Frühschicht
434	2	2025-03-10	Krank
435	2	2025-03-11	Frühschicht
436	2	2025-03-12	Spätschicht
437	2	2025-03-13	Spätschicht
438	2	2025-03-14	Urlaub
439	2	2025-03-15	Urlaub
440	2	2025-03-16	Spätschicht
441	2	2025-03-17	Frühschicht
442	2	2025-03-18	Krank
443	2	2025-03-19	Krank
444	2	2025-03-20	Krank
445	2	2025-03-21	Frühschicht
446	2	2025-03-22	Frühschicht
447	2	2025-03-23	Urlaub
448	2	2025-03-24	Spätschicht
449	2	2025-03-25	Frühschicht
450	2	2025-03-26	Krank
451	2	2025-03-27	Frühschicht
452	2	2025-03-28	Urlaub
453	2	2025-03-29	Spätschicht
454	2	2025-03-30	Frühschicht
455	2	2025-03-31	Krank
456	2	2025-04-01	Spätschicht
457	2	2025-04-02	Krank
458	2	2025-04-03	Krank
459	2	2025-04-04	Urlaub
460	2	2025-04-05	Frühschicht
461	2	2025-04-06	Urlaub
462	2	2025-04-07	Krank
463	2	2025-04-08	Frühschicht
464	2	2025-04-09	Krank
465	2	2025-04-10	Urlaub
466	2	2025-04-11	Spätschicht
467	2	2025-04-12	Krank
468	2	2025-04-13	Frühschicht
469	2	2025-04-14	Spätschicht
470	2	2025-04-15	Spätschicht
471	2	2025-04-16	Urlaub
472	2	2025-04-17	Krank
473	2	2025-04-18	Frühschicht
474	2	2025-04-19	Krank
475	2	2025-04-20	Urlaub
476	2	2025-04-21	Spätschicht
477	2	2025-04-22	Spätschicht
478	2	2025-04-23	Krank
479	2	2025-04-24	Frühschicht
480	2	2025-04-25	Krank
481	2	2025-04-26	Krank
482	2	2025-04-27	Spätschicht
483	2	2025-04-28	Urlaub
484	2	2025-04-29	Krank
485	2	2025-04-30	Frühschicht
486	2	2025-05-01	Urlaub
487	2	2025-05-02	Urlaub
488	2	2025-05-03	Spätschicht
489	2	2025-05-04	Frühschicht
490	2	2025-05-05	Frühschicht
491	2	2025-05-06	Spätschicht
492	2	2025-05-07	Urlaub
493	2	2025-05-08	Spätschicht
494	2	2025-05-09	Spätschicht
495	2	2025-05-10	Spätschicht
496	2	2025-05-11	Spätschicht
497	2	2025-05-12	Krank
498	2	2025-05-13	Frühschicht
499	2	2025-05-14	Frühschicht
500	2	2025-05-15	Krank
501	2	2025-05-16	Frühschicht
502	2	2025-05-17	Krank
503	2	2025-05-18	Urlaub
504	2	2025-05-19	Spätschicht
505	2	2025-05-20	Krank
506	2	2025-05-21	Frühschicht
507	2	2025-05-22	Spätschicht
508	2	2025-05-23	Frühschicht
509	2	2025-05-24	Krank
510	2	2025-05-25	Urlaub
511	2	2025-05-26	Urlaub
512	2	2025-05-27	Spätschicht
513	2	2025-05-28	Urlaub
514	2	2025-05-29	Frühschicht
515	2	2025-05-30	Frühschicht
516	2	2025-05-31	Frühschicht
517	2	2025-06-01	Frühschicht
518	2	2025-06-02	Urlaub
519	2	2025-06-03	Spätschicht
520	2	2025-06-04	Frühschicht
521	2	2025-06-05	Frühschicht
522	2	2025-06-06	Frühschicht
523	2	2025-06-07	Frühschicht
524	2	2025-06-08	Urlaub
525	2	2025-06-09	Spätschicht
526	2	2025-06-10	Urlaub
527	2	2025-06-11	Frühschicht
528	2	2025-06-12	Krank
529	2	2025-06-13	Spätschicht
530	2	2025-06-14	Frühschicht
531	2	2025-06-15	Urlaub
532	2	2025-06-16	Krank
533	2	2025-06-17	Spätschicht
534	2	2025-06-18	Frühschicht
535	2	2025-06-19	Urlaub
536	2	2025-06-20	Krank
537	2	2025-06-21	Frühschicht
538	2	2025-06-22	Urlaub
539	2	2025-06-23	Spätschicht
540	2	2025-06-24	Spätschicht
541	2	2025-06-25	Frühschicht
542	2	2025-06-26	Frühschicht
543	2	2025-06-27	Spätschicht
544	2	2025-06-28	Urlaub
545	2	2025-06-29	Spätschicht
546	2	2025-06-30	Krank
547	2	2025-07-01	Spätschicht
548	2	2025-07-02	Krank
549	2	2025-07-03	Frühschicht
550	2	2025-07-04	Krank
551	2	2025-07-05	Krank
552	2	2025-07-06	Krank
553	2	2025-07-07	Krank
554	2	2025-07-08	Frühschicht
555	2	2025-07-09	Frühschicht
556	2	2025-07-10	Krank
557	2	2025-07-11	Frühschicht
558	2	2025-07-12	Frühschicht
559	2	2025-07-13	Spätschicht
560	2	2025-07-14	Frühschicht
561	2	2025-07-15	Krank
562	2	2025-07-16	Krank
563	2	2025-07-17	Frühschicht
564	2	2025-07-18	Urlaub
565	2	2025-07-19	Urlaub
566	2	2025-07-20	Krank
567	2	2025-07-21	Krank
568	2	2025-07-22	Frühschicht
569	2	2025-07-23	Frühschicht
570	2	2025-07-24	Frühschicht
571	2	2025-07-25	Urlaub
572	2	2025-07-26	Krank
573	2	2025-07-27	Spätschicht
574	2	2025-07-28	Spätschicht
575	2	2025-07-29	Krank
576	2	2025-07-30	Urlaub
577	2	2025-07-31	Spätschicht
578	2	2025-08-01	Frühschicht
579	2	2025-08-02	Urlaub
580	2	2025-08-03	Frühschicht
581	2	2025-08-04	Urlaub
582	2	2025-08-05	Krank
583	2	2025-08-06	Urlaub
584	2	2025-08-07	Krank
585	2	2025-08-08	Frühschicht
586	2	2025-08-09	Urlaub
587	2	2025-08-10	Urlaub
588	2	2025-08-11	Frühschicht
589	2	2025-08-12	Frühschicht
590	2	2025-08-13	Krank
591	2	2025-08-14	Krank
592	2	2025-08-15	Frühschicht
593	2	2025-08-16	Urlaub
594	2	2025-08-17	Krank
595	2	2025-08-18	Urlaub
596	2	2025-08-19	Urlaub
597	2	2025-08-20	Krank
598	2	2025-08-21	Urlaub
599	2	2025-08-22	Krank
600	2	2025-08-23	Krank
601	2	2025-08-24	Krank
602	2	2025-08-25	Urlaub
603	2	2025-08-26	Krank
604	2	2025-08-27	Frühschicht
605	2	2025-08-28	Spätschicht
606	2	2025-08-29	Krank
607	2	2025-08-30	Krank
608	2	2025-08-31	Krank
609	2	2025-09-01	Krank
610	2	2025-09-02	Spätschicht
611	2	2025-09-03	Spätschicht
612	2	2025-09-04	Krank
613	2	2025-09-05	Urlaub
614	2	2025-09-06	Frühschicht
615	2	2025-09-07	Spätschicht
616	2	2025-09-08	Urlaub
617	2	2025-09-09	Krank
618	2	2025-09-10	Frühschicht
619	2	2025-09-11	Urlaub
620	2	2025-09-12	Frühschicht
621	2	2025-09-13	Frühschicht
622	2	2025-09-14	Krank
623	2	2025-09-15	Frühschicht
624	2	2025-09-16	Frühschicht
625	2	2025-09-17	Spätschicht
626	2	2025-09-18	Spätschicht
627	2	2025-09-19	Urlaub
628	2	2025-09-20	Krank
629	2	2025-09-21	Krank
630	2	2025-09-22	Krank
631	2	2025-09-23	Spätschicht
632	2	2025-09-24	Frühschicht
633	2	2025-09-25	Spätschicht
634	2	2025-09-26	Frühschicht
635	2	2025-09-27	Urlaub
636	2	2025-09-28	Frühschicht
637	2	2025-09-29	Spätschicht
638	2	2025-09-30	Frühschicht
639	2	2025-10-01	Frühschicht
640	2	2025-10-02	Frühschicht
641	2	2025-10-03	Krank
642	2	2025-10-04	Urlaub
643	2	2025-10-05	Frühschicht
644	2	2025-10-06	Urlaub
645	2	2025-10-07	Urlaub
646	2	2025-10-08	Spätschicht
647	2	2025-10-09	Spätschicht
648	2	2025-10-10	Krank
649	2	2025-10-11	Spätschicht
650	2	2025-10-12	Frühschicht
651	2	2025-10-13	Urlaub
652	2	2025-10-14	Frühschicht
653	2	2025-10-15	Frühschicht
654	2	2025-10-16	Spätschicht
655	2	2025-10-17	Spätschicht
656	2	2025-10-18	Urlaub
657	2	2025-10-19	Krank
658	2	2025-10-20	Urlaub
659	2	2025-10-21	Krank
660	2	2025-10-22	Frühschicht
661	2	2025-10-23	Krank
662	2	2025-10-24	Spätschicht
663	2	2025-10-25	Urlaub
664	2	2025-10-26	Krank
665	2	2025-10-27	Urlaub
666	2	2025-10-28	Spätschicht
667	2	2025-10-29	Spätschicht
668	2	2025-10-30	Frühschicht
669	2	2025-10-31	Frühschicht
670	2	2025-11-01	Frühschicht
671	2	2025-11-02	Frühschicht
672	2	2025-11-03	Spätschicht
673	2	2025-11-04	Krank
674	2	2025-11-05	Frühschicht
675	2	2025-11-06	Spätschicht
676	2	2025-11-07	Frühschicht
677	2	2025-11-08	Krank
678	2	2025-11-09	Frühschicht
679	2	2025-11-10	Frühschicht
680	2	2025-11-11	Frühschicht
681	2	2025-11-12	Urlaub
682	2	2025-11-13	Krank
683	2	2025-11-14	Urlaub
684	2	2025-11-15	Urlaub
685	2	2025-11-16	Urlaub
686	2	2025-11-17	Urlaub
687	2	2025-11-18	Urlaub
688	2	2025-11-19	Urlaub
689	2	2025-11-20	Krank
690	2	2025-11-21	Krank
691	2	2025-11-22	Krank
692	2	2025-11-23	Frühschicht
693	2	2025-11-24	Frühschicht
694	2	2025-11-25	Spätschicht
695	2	2025-11-26	Spätschicht
696	2	2025-11-27	Krank
697	2	2025-11-28	Krank
698	2	2025-11-29	Spätschicht
699	2	2025-11-30	Frühschicht
700	2	2025-12-01	Spätschicht
701	2	2025-12-02	Frühschicht
702	2	2025-12-03	Frühschicht
703	2	2025-12-04	Spätschicht
704	2	2025-12-05	Krank
705	2	2025-12-06	Urlaub
706	2	2025-12-07	Frühschicht
707	2	2025-12-08	Urlaub
708	2	2025-12-09	Spätschicht
709	2	2025-12-10	Urlaub
710	2	2025-12-11	Urlaub
711	2	2025-12-12	Frühschicht
712	2	2025-12-13	Spätschicht
713	2	2025-12-14	Krank
714	2	2025-12-15	Spätschicht
715	2	2025-12-16	Krank
716	2	2025-12-17	Frühschicht
717	2	2025-12-18	Spätschicht
718	2	2025-12-19	Urlaub
719	2	2025-12-20	Spätschicht
720	2	2025-12-21	Urlaub
721	2	2025-12-22	Spätschicht
722	2	2025-12-23	Urlaub
723	2	2025-12-24	Krank
724	2	2025-12-25	Frühschicht
725	2	2025-12-26	Urlaub
726	2	2025-12-27	Frühschicht
727	2	2025-12-28	Frühschicht
728	2	2025-12-29	Frühschicht
729	2	2025-12-30	Urlaub
730	2	2025-12-31	Frühschicht
731	3	2025-01-01	Frühschicht
732	3	2025-01-02	Spätschicht
733	3	2025-01-03	Spätschicht
734	3	2025-01-04	Frühschicht
735	3	2025-01-05	Frühschicht
736	3	2025-01-06	Frühschicht
737	3	2025-01-07	Urlaub
738	3	2025-01-08	Urlaub
739	3	2025-01-09	Spätschicht
740	3	2025-01-10	Frühschicht
741	3	2025-01-11	Krank
742	3	2025-01-12	Frühschicht
743	3	2025-01-13	Spätschicht
744	3	2025-01-14	Spätschicht
745	3	2025-01-15	Urlaub
746	3	2025-01-16	Frühschicht
747	3	2025-01-17	Krank
748	3	2025-01-18	Spätschicht
749	3	2025-01-19	Spätschicht
750	3	2025-01-20	Spätschicht
751	3	2025-01-21	Urlaub
752	3	2025-01-22	Urlaub
753	3	2025-01-23	Krank
754	3	2025-01-24	Frühschicht
755	3	2025-01-25	Krank
756	3	2025-01-26	Spätschicht
757	3	2025-01-27	Frühschicht
758	3	2025-01-28	Urlaub
759	3	2025-01-29	Urlaub
760	3	2025-01-30	Spätschicht
761	3	2025-01-31	Frühschicht
762	3	2025-02-01	Urlaub
763	3	2025-02-02	Krank
764	3	2025-02-03	Krank
765	3	2025-02-04	Krank
766	3	2025-02-05	Krank
767	3	2025-02-06	Spätschicht
768	3	2025-02-07	Urlaub
769	3	2025-02-08	Krank
770	3	2025-02-09	Spätschicht
771	3	2025-02-10	Frühschicht
772	3	2025-02-11	Spätschicht
773	3	2025-02-12	Urlaub
774	3	2025-02-13	Spätschicht
775	3	2025-02-14	Krank
776	3	2025-02-15	Urlaub
777	3	2025-02-16	Krank
778	3	2025-02-17	Krank
779	3	2025-02-18	Urlaub
780	3	2025-02-19	Frühschicht
781	3	2025-02-20	Frühschicht
782	3	2025-02-21	Urlaub
783	3	2025-02-22	Urlaub
784	3	2025-02-23	Spätschicht
785	3	2025-02-24	Spätschicht
786	3	2025-02-25	Urlaub
787	3	2025-02-26	Frühschicht
788	3	2025-02-27	Frühschicht
789	3	2025-02-28	Spätschicht
790	3	2025-03-01	Spätschicht
791	3	2025-03-02	Frühschicht
792	3	2025-03-03	Krank
793	3	2025-03-04	Frühschicht
794	3	2025-03-05	Spätschicht
795	3	2025-03-06	Frühschicht
796	3	2025-03-07	Krank
797	3	2025-03-08	Frühschicht
798	3	2025-03-09	Urlaub
799	3	2025-03-10	Spätschicht
800	3	2025-03-11	Frühschicht
801	3	2025-03-12	Frühschicht
802	3	2025-03-13	Frühschicht
803	3	2025-03-14	Krank
804	3	2025-03-15	Spätschicht
805	3	2025-03-16	Krank
806	3	2025-03-17	Urlaub
807	3	2025-03-18	Spätschicht
808	3	2025-03-19	Frühschicht
809	3	2025-03-20	Frühschicht
810	3	2025-03-21	Krank
811	3	2025-03-22	Urlaub
812	3	2025-03-23	Spätschicht
813	3	2025-03-24	Krank
814	3	2025-03-25	Spätschicht
815	3	2025-03-26	Krank
816	3	2025-03-27	Krank
817	3	2025-03-28	Frühschicht
818	3	2025-03-29	Spätschicht
819	3	2025-03-30	Urlaub
820	3	2025-03-31	Frühschicht
821	3	2025-04-01	Krank
822	3	2025-04-02	Frühschicht
823	3	2025-04-03	Frühschicht
824	3	2025-04-04	Urlaub
825	3	2025-04-05	Spätschicht
826	3	2025-04-06	Urlaub
827	3	2025-04-07	Frühschicht
828	3	2025-04-08	Urlaub
829	3	2025-04-09	Spätschicht
830	3	2025-04-10	Spätschicht
831	3	2025-04-11	Frühschicht
832	3	2025-04-12	Frühschicht
833	3	2025-04-13	Frühschicht
834	3	2025-04-14	Urlaub
835	3	2025-04-15	Krank
836	3	2025-04-16	Krank
837	3	2025-04-17	Spätschicht
838	3	2025-04-18	Urlaub
839	3	2025-04-19	Frühschicht
840	3	2025-04-20	Urlaub
841	3	2025-04-21	Spätschicht
842	3	2025-04-22	Frühschicht
843	3	2025-04-23	Krank
844	3	2025-04-24	Krank
845	3	2025-04-25	Krank
846	3	2025-04-26	Urlaub
847	3	2025-04-27	Urlaub
848	3	2025-04-28	Spätschicht
849	3	2025-04-29	Urlaub
850	3	2025-04-30	Urlaub
851	3	2025-05-01	Spätschicht
852	3	2025-05-02	Urlaub
853	3	2025-05-03	Frühschicht
854	3	2025-05-04	Urlaub
855	3	2025-05-05	Krank
856	3	2025-05-06	Frühschicht
857	3	2025-05-07	Frühschicht
858	3	2025-05-08	Spätschicht
859	3	2025-05-09	Frühschicht
860	3	2025-05-10	Frühschicht
861	3	2025-05-11	Krank
862	3	2025-05-12	Krank
863	3	2025-05-13	Frühschicht
864	3	2025-05-14	Urlaub
865	3	2025-05-15	Krank
866	3	2025-05-16	Frühschicht
867	3	2025-05-17	Krank
868	3	2025-05-18	Urlaub
869	3	2025-05-19	Spätschicht
870	3	2025-05-20	Krank
871	3	2025-05-21	Spätschicht
872	3	2025-05-22	Urlaub
873	3	2025-05-23	Frühschicht
874	3	2025-05-24	Spätschicht
875	3	2025-05-25	Spätschicht
876	3	2025-05-26	Frühschicht
877	3	2025-05-27	Krank
878	3	2025-05-28	Krank
879	3	2025-05-29	Krank
880	3	2025-05-30	Frühschicht
881	3	2025-05-31	Spätschicht
882	3	2025-06-01	Spätschicht
883	3	2025-06-02	Spätschicht
884	3	2025-06-03	Frühschicht
885	3	2025-06-04	Spätschicht
886	3	2025-06-05	Urlaub
887	3	2025-06-06	Krank
888	3	2025-06-07	Spätschicht
889	3	2025-06-08	Urlaub
890	3	2025-06-09	Frühschicht
891	3	2025-06-10	Krank
892	3	2025-06-11	Krank
893	3	2025-06-12	Frühschicht
894	3	2025-06-13	Frühschicht
895	3	2025-06-14	Krank
896	3	2025-06-15	Urlaub
897	3	2025-06-16	Spätschicht
898	3	2025-06-17	Krank
899	3	2025-06-18	Urlaub
900	3	2025-06-19	Spätschicht
901	3	2025-06-20	Frühschicht
902	3	2025-06-21	Frühschicht
903	3	2025-06-22	Spätschicht
904	3	2025-06-23	Frühschicht
905	3	2025-06-24	Spätschicht
906	3	2025-06-25	Spätschicht
907	3	2025-06-26	Krank
908	3	2025-06-27	Krank
909	3	2025-06-28	Frühschicht
910	3	2025-06-29	Urlaub
911	3	2025-06-30	Urlaub
912	3	2025-07-01	Urlaub
913	3	2025-07-02	Urlaub
914	3	2025-07-03	Frühschicht
915	3	2025-07-04	Urlaub
916	3	2025-07-05	Spätschicht
917	3	2025-07-06	Krank
918	3	2025-07-07	Frühschicht
919	3	2025-07-08	Krank
920	3	2025-07-09	Frühschicht
921	3	2025-07-10	Frühschicht
922	3	2025-07-11	Frühschicht
923	3	2025-07-12	Frühschicht
924	3	2025-07-13	Spätschicht
925	3	2025-07-14	Frühschicht
926	3	2025-07-15	Urlaub
927	3	2025-07-16	Spätschicht
928	3	2025-07-17	Spätschicht
929	3	2025-07-18	Spätschicht
930	3	2025-07-19	Spätschicht
931	3	2025-07-20	Krank
932	3	2025-07-21	Spätschicht
933	3	2025-07-22	Frühschicht
934	3	2025-07-23	Frühschicht
935	3	2025-07-24	Spätschicht
936	3	2025-07-25	Krank
937	3	2025-07-26	Urlaub
938	3	2025-07-27	Krank
939	3	2025-07-28	Krank
940	3	2025-07-29	Krank
941	3	2025-07-30	Frühschicht
942	3	2025-07-31	Urlaub
943	3	2025-08-01	Urlaub
944	3	2025-08-02	Frühschicht
945	3	2025-08-03	Spätschicht
946	3	2025-08-04	Urlaub
947	3	2025-08-05	Frühschicht
948	3	2025-08-06	Frühschicht
949	3	2025-08-07	Frühschicht
950	3	2025-08-08	Frühschicht
951	3	2025-08-09	Urlaub
952	3	2025-08-10	Krank
953	3	2025-08-11	Krank
954	3	2025-08-12	Krank
955	3	2025-08-13	Spätschicht
956	3	2025-08-14	Urlaub
957	3	2025-08-15	Urlaub
958	3	2025-08-16	Frühschicht
959	3	2025-08-17	Frühschicht
960	3	2025-08-18	Frühschicht
961	3	2025-08-19	Urlaub
962	3	2025-08-20	Krank
963	3	2025-08-21	Urlaub
964	3	2025-08-22	Spätschicht
965	3	2025-08-23	Frühschicht
966	3	2025-08-24	Urlaub
967	3	2025-08-25	Spätschicht
968	3	2025-08-26	Urlaub
969	3	2025-08-27	Urlaub
970	3	2025-08-28	Spätschicht
971	3	2025-08-29	Urlaub
972	3	2025-08-30	Urlaub
973	3	2025-08-31	Krank
974	3	2025-09-01	Frühschicht
975	3	2025-09-02	Urlaub
976	3	2025-09-03	Frühschicht
977	3	2025-09-04	Krank
978	3	2025-09-05	Frühschicht
979	3	2025-09-06	Urlaub
980	3	2025-09-07	Frühschicht
981	3	2025-09-08	Urlaub
982	3	2025-09-09	Frühschicht
983	3	2025-09-10	Spätschicht
984	3	2025-09-11	Spätschicht
985	3	2025-09-12	Spätschicht
986	3	2025-09-13	Krank
987	3	2025-09-14	Frühschicht
988	3	2025-09-15	Frühschicht
989	3	2025-09-16	Krank
990	3	2025-09-17	Krank
991	3	2025-09-18	Spätschicht
992	3	2025-09-19	Spätschicht
993	3	2025-09-20	Frühschicht
994	3	2025-09-21	Frühschicht
995	3	2025-09-22	Frühschicht
996	3	2025-09-23	Krank
997	3	2025-09-24	Spätschicht
998	3	2025-09-25	Spätschicht
999	3	2025-09-26	Urlaub
1000	3	2025-09-27	Krank
1001	3	2025-09-28	Spätschicht
1002	3	2025-09-29	Spätschicht
1003	3	2025-09-30	Urlaub
1004	3	2025-10-01	Krank
1005	3	2025-10-02	Urlaub
1006	3	2025-10-03	Krank
1007	3	2025-10-04	Frühschicht
1008	3	2025-10-05	Krank
1009	3	2025-10-06	Frühschicht
1010	3	2025-10-07	Krank
1011	3	2025-10-08	Krank
1012	3	2025-10-09	Urlaub
1013	3	2025-10-10	Krank
1014	3	2025-10-11	Krank
1015	3	2025-10-12	Krank
1016	3	2025-10-13	Spätschicht
1017	3	2025-10-14	Spätschicht
1018	3	2025-10-15	Krank
1019	3	2025-10-16	Krank
1020	3	2025-10-17	Krank
1021	3	2025-10-18	Spätschicht
1022	3	2025-10-19	Krank
1023	3	2025-10-20	Urlaub
1024	3	2025-10-21	Spätschicht
1025	3	2025-10-22	Urlaub
1026	3	2025-10-23	Urlaub
1027	3	2025-10-24	Spätschicht
1028	3	2025-10-25	Spätschicht
1029	3	2025-10-26	Frühschicht
1030	3	2025-10-27	Frühschicht
1031	3	2025-10-28	Krank
1032	3	2025-10-29	Krank
1033	3	2025-10-30	Krank
1034	3	2025-10-31	Krank
1035	3	2025-11-01	Spätschicht
1036	3	2025-11-02	Urlaub
1037	3	2025-11-03	Krank
1038	3	2025-11-04	Frühschicht
1039	3	2025-11-05	Frühschicht
1040	3	2025-11-06	Spätschicht
1041	3	2025-11-07	Frühschicht
1042	3	2025-11-08	Urlaub
1043	3	2025-11-09	Krank
1044	3	2025-11-10	Spätschicht
1045	3	2025-11-11	Urlaub
1046	3	2025-11-12	Frühschicht
1047	3	2025-11-13	Spätschicht
1048	3	2025-11-14	Spätschicht
1049	3	2025-11-15	Spätschicht
1050	3	2025-11-16	Frühschicht
1051	3	2025-11-17	Frühschicht
1052	3	2025-11-18	Krank
1053	3	2025-11-19	Spätschicht
1054	3	2025-11-20	Frühschicht
1055	3	2025-11-21	Spätschicht
1056	3	2025-11-22	Krank
1057	3	2025-11-23	Krank
1058	3	2025-11-24	Spätschicht
1059	3	2025-11-25	Krank
1060	3	2025-11-26	Frühschicht
1061	3	2025-11-27	Spätschicht
1062	3	2025-11-28	Urlaub
1063	3	2025-11-29	Krank
1064	3	2025-11-30	Krank
1065	3	2025-12-01	Krank
1066	3	2025-12-02	Krank
1067	3	2025-12-03	Urlaub
1068	3	2025-12-04	Frühschicht
1069	3	2025-12-05	Krank
1070	3	2025-12-06	Krank
1071	3	2025-12-07	Urlaub
1072	3	2025-12-08	Spätschicht
1073	3	2025-12-09	Spätschicht
1074	3	2025-12-10	Frühschicht
1075	3	2025-12-11	Frühschicht
1076	3	2025-12-12	Krank
1077	3	2025-12-13	Frühschicht
1078	3	2025-12-14	Spätschicht
1079	3	2025-12-15	Spätschicht
1080	3	2025-12-16	Frühschicht
1081	3	2025-12-17	Krank
1082	3	2025-12-18	Frühschicht
1083	3	2025-12-19	Frühschicht
1084	3	2025-12-20	Frühschicht
1085	3	2025-12-21	Urlaub
1086	3	2025-12-22	Krank
1087	3	2025-12-23	Frühschicht
1088	3	2025-12-24	Spätschicht
1089	3	2025-12-25	Frühschicht
1090	3	2025-12-26	Urlaub
1091	3	2025-12-27	Frühschicht
1092	3	2025-12-28	Krank
1093	3	2025-12-29	Urlaub
1094	3	2025-12-30	Spätschicht
1095	3	2025-12-31	Spätschicht
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: myuser
--

COPY public.users (id, name, password) FROM stdin;
1	Alice	$2b$10$YoBEulFz7N9kILLTwqwZxeweh58ON1BnYvjn33tb8.y6e/yUUABNq
2	Bob	$2b$10$YoBEulFz7N9kILLTwqwZxeweh58ON1BnYvjn33tb8.y6e/yUUABNq
3	Charlie	$2b$10$YoBEulFz7N9kILLTwqwZxeweh58ON1BnYvjn33tb8.y6e/yUUABNq
\.


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.items_id_seq', 1, false);


--
-- Name: shifts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.shifts_id_seq', 1095, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: myuser
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: shifts shifts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: myuser
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict Iv017OFjjos8iouf7PZ16tJbBbld4ebgSWZ2ihgYxg7RuPRoo6oeLshpCtJGDVH

