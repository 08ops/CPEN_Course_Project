--
-- PostgreSQL database dump
--

\restrict YeGVKv5GaxT62e9CfsLhTslmlo0SDLXDq98HDvLexsnfTpP4dheRcoOgwUt6wnt

-- Dumped from database version 16.13 (Homebrew)
-- Dumped by pg_dump version 16.13 (Homebrew)

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

--
-- Data for Name: department; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.department (department_id, code, name, college, school, email, phone, office_location, established_on, created_at, updated_at) FROM stdin;
1	CPEN	Computer Engineering	College of Basic and Applied Sciences	School of Engineering Sciences	cpen@ug.edu.gh	+233 30 250 1234	Engineering Block B, Room 21	2005-09-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	MATH	Mathematics	College of Basic and Applied Sciences	School of Physical and Mathematical Sciences	maths@ug.edu.gh	+233 30 250 2345	Mathematics Building, Room 4	1948-10-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	UGRC	Office of Academic Affairs (University Required Courses)	Academic Affairs Directorate	University-wide	ugrc@ug.edu.gh	+233 30 250 3456	Central Administration Block	2010-08-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.course (course_id, course_code, title, description, credit_hours, level, department_id, is_core, is_active, created_at, updated_at) FROM stdin;
1	CPEN 401	Advanced Embedded Systems	Real-time operating systems, device drivers and embedded networking.	3	400	1	f	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	CPEN 208	Introduction to Software Engineering	Software process models, requirements, design, databases, version control, testing and deployment.	3	200	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	CPEN 207	Computer Architecture	Instruction set architecture, pipelining, memory hierarchy and I/O organisation.	3	200	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	CPEN 205	Data Structures and Algorithms	Lists, trees, graphs, hashing, sorting, searching and complexity analysis.	3	200	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	CPEN 203	Digital Systems Design	Combinational and sequential logic, finite state machines and HDL-based design.	3	200	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	CPEN 201	Circuit Theory	Network theorems, transient analysis, AC steady-state analysis and resonance.	3	200	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	CPEN 105	Programming for Engineers	Structured programming, problem solving and algorithm design in C and Python.	3	100	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	CPEN 103	Introduction to Computer Engineering	Overview of the computer engineering discipline, number systems and basic logic.	3	100	1	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	MATH 223	Linear Algebra and Differential Equations	Matrices, vector spaces, eigenvalues and ordinary differential equations.	3	200	2	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	UGRC 210	Academic Writing II	Advanced academic writing, referencing, research reporting and presentation.	3	200	3	t	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: academic_year; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.academic_year (academic_year_id, name, start_date, end_date, is_current, created_at) FROM stdin;
1	2024/2025	2024-08-05	2025-07-25	f	2026-08-03 20:52:48.539735+00
2	2025/2026	2025-08-04	2026-07-24	t	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: semester; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.semester (semester_id, academic_year_id, name, sequence_no, start_date, end_date, registration_deadline, is_current, created_at) FROM stdin;
1	1	Second Semester	2	2025-01-13	2025-05-30	2025-02-07	f	2026-08-03 20:52:48.539735+00
2	1	First Semester	1	2024-08-05	2024-12-20	2024-09-06	f	2026-08-03 20:52:48.539735+00
3	2	Second Semester	2	2026-01-12	2026-05-29	2026-02-06	f	2026-08-03 20:52:48.539735+00
4	2	First Semester	1	2025-08-04	2025-12-19	2025-09-05	t	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: course_offering; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.course_offering (offering_id, course_id, semester_id, section, capacity, venue, meeting_days, start_time, end_time, delivery_mode, is_open_for_registration, created_at, updated_at) FROM stdin;
1	1	4	A	40	Embedded Systems Laboratory	Tue, Fri	13:30:00	15:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	2	4	A	60	Computer Laboratory 1	Wed, Fri	10:30:00	12:00:00	hybrid	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	3	4	A	60	Engineering Lecture Theatre 1	Tue, Thu	08:30:00	10:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	4	4	A	60	Computer Laboratory 3	Mon, Fri	13:30:00	15:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	5	4	A	60	Engineering Lecture Theatre 2	Tue, Thu	10:30:00	12:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	6	4	A	60	Engineering Lecture Theatre 1	Mon, Wed	08:30:00	10:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	9	4	A	80	Mathematics Lecture Hall A	Mon, Wed	15:30:00	17:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	10	4	A	90	JQB Lecture Hall 12	Thu	17:30:00	20:00:00	in_person	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: course_prerequisite; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.course_prerequisite (course_id, prerequisite_id) FROM stdin;
1	3
4	7
2	7
5	8
3	8
\.


--
-- Data for Name: programme; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.programme (programme_id, department_id, code, name, degree_award, duration_years, total_credits, is_active, created_at, updated_at) FROM stdin;
1	1	MPHIL-CPEN	MPhil Computer Engineering	MPhil	2	48	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	1	BSC-CPEN	BSc Computer Engineering	BSc	4	132	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: people; Owner: -
--

COPY people.person (person_id, title, first_name, middle_name, last_name, date_of_birth, gender, marital_status, national_id, email, phone, alt_phone, nationality, home_region, postal_address, residential_address, photo_url, created_at, updated_at) FROM stdin;
1	\N	Gideon	Elorm	Glago	2004-03-17	Male	Single	GHA-721004551-3	gideon.glago@st.ug.edu.gh	+233 24 411 0981	\N	Ghanaian	Volta	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	\N	Nana Ama	Serwaa	Boateng	2004-06-02	Female	Single	GHA-721004552-1	nanaama.boateng@st.ug.edu.gh	+233 24 512 0102	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	\N	Kwabena	Osei	Mensah	2003-11-25	Male	Single	GHA-721004553-9	kwabena.mensah@st.ug.edu.gh	+233 20 331 0203	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	\N	Akosua	Dede	Quartey	2004-01-09	Female	Single	GHA-721004554-7	akosua.quartey@st.ug.edu.gh	+233 55 220 0304	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	\N	Yaw	Antwi	Boasiako	2003-09-14	Male	Single	GHA-721004555-5	yaw.boasiako@st.ug.edu.gh	+233 27 445 0405	\N	Ghanaian	Bono	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	\N	Efua	Naa Adjeley	Lamptey	2004-05-21	Female	Single	GHA-721004556-3	efua.lamptey@st.ug.edu.gh	+233 24 667 0506	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	\N	Kofi	Agyeman	Duah	2003-12-30	Male	Single	GHA-721004557-1	kofi.duah@st.ug.edu.gh	+233 26 778 0607	\N	Ghanaian	Eastern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	\N	Abena	Nyarko	Asante	2004-08-11	Female	Single	GHA-721004558-9	abena.asante@st.ug.edu.gh	+233 24 889 0708	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	\N	Kwame	Nkrumah	Ofori	2003-07-04	Male	Single	GHA-721004559-7	kwame.ofori@st.ug.edu.gh	+233 20 990 0809	\N	Ghanaian	Central	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	\N	Adwoa	Serwaa	Amponsah	2004-02-18	Female	Single	GHA-721004560-5	adwoa.amponsah@st.ug.edu.gh	+233 55 101 0910	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	\N	Selorm	Kwabla	Dzradosi	2003-10-08	Male	Single	GHA-721004561-3	selorm.dzradosi@st.ug.edu.gh	+233 27 212 1011	\N	Ghanaian	Volta	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	\N	Hawa	Abdul	Rahman	2004-04-27	Female	Single	GHA-721004562-1	hawa.rahman@st.ug.edu.gh	+233 24 323 1112	\N	Ghanaian	Northern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	\N	Emmanuel	Tetteh	Nortey	2003-08-19	Male	Single	GHA-721004563-9	emmanuel.nortey@st.ug.edu.gh	+233 26 434 1213	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	\N	Priscilla	Akweley	Sowah	2004-07-06	Female	Single	GHA-721004564-7	priscilla.sowah@st.ug.edu.gh	+233 20 545 1314	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	\N	Ibrahim	Yakubu	Mahama	2003-05-15	Male	Single	GHA-721004565-5	ibrahim.mahama@st.ug.edu.gh	+233 55 656 1415	\N	Ghanaian	Northern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	\N	Cynthia	Mensimah	Baidoo	2004-09-23	Female	Single	GHA-721004566-3	cynthia.baidoo@st.ug.edu.gh	+233 24 767 1516	\N	Ghanaian	Central	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	\N	Daniel	Kojo	Ampofo	2003-12-01	Male	Single	GHA-721004567-1	daniel.ampofo@st.ug.edu.gh	+233 27 878 1617	\N	Ghanaian	Eastern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	\N	Elikem	Mawuli	Agbeko	2004-03-29	Male	Single	GHA-721004568-9	elikem.agbeko@st.ug.edu.gh	+233 26 989 1718	\N	Ghanaian	Volta	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
19	\N	Rashida	Alhassan	Fuseini	2003-11-12	Female	Single	GHA-721004569-7	rashida.fuseini@st.ug.edu.gh	+233 20 190 1819	\N	Ghanaian	Upper East	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
20	\N	Michael	Nii Armah	Tagoe	2004-06-17	Male	Single	GHA-721004570-5	michael.tagoe@st.ug.edu.gh	+233 55 201 1920	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
21	\N	Genevieve	Adjoa	Bonsu	2004-01-31	Female	Single	GHA-721004571-3	genevieve.bonsu@st.ug.edu.gh	+233 24 312 2021	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
22	\N	Prince	Kwabena	Owusu	2003-09-08	Male	Single	GHA-721004572-1	prince.owusu@st.ug.edu.gh	+233 27 423 2122	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
23	\N	Sandra	Esinam	Ahiable	2004-05-05	Female	Single	GHA-721004573-9	sandra.ahiable@st.ug.edu.gh	+233 26 534 2223	\N	Ghanaian	Volta	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
24	\N	Joseph	Kwaku	Danso	2003-07-22	Male	Single	GHA-721004574-7	joseph.danso@st.ug.edu.gh	+233 20 645 2324	\N	Ghanaian	Eastern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
25	\N	Linda	Afriyie	Frimpong	2004-10-14	Female	Single	GHA-721004575-5	linda.frimpong@st.ug.edu.gh	+233 55 756 2425	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
26	\N	Samuel	Nii Odartey	Lartey	2003-04-03	Male	Single	GHA-721004576-3	samuel.lartey@st.ug.edu.gh	+233 24 867 2526	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
27	\N	Patience	Yaa	Konadu	2004-08-28	Female	Single	GHA-721004577-1	patience.konadu@st.ug.edu.gh	+233 27 978 2627	\N	Ghanaian	Bono	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
28	\N	Bright	Kwasi	Adjei	2003-12-16	Male	Single	GHA-721004578-9	bright.adjei@st.ug.edu.gh	+233 26 089 2728	\N	Ghanaian	Western	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
29	\N	Comfort	Abena	Pokuaa	2004-02-09	Female	Single	GHA-721004579-7	comfort.pokuaa@st.ug.edu.gh	+233 20 290 2829	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
30	\N	Richmond	Kojo	Aidoo	2003-06-26	Male	Single	GHA-721004580-5	richmond.aidoo@st.ug.edu.gh	+233 55 301 2930	\N	Ghanaian	Central	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
31	\N	Vera	Akorfa	Kudzo	2004-11-19	Female	Single	GHA-721004581-3	vera.kudzo@st.ug.edu.gh	+233 24 412 3031	\N	Ghanaian	Volta	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
32	\N	Isaac	Kwadwo	Bediako	2003-10-02	Male	Single	GHA-721004582-1	isaac.bediako@st.ug.edu.gh	+233 27 523 3132	\N	Ghanaian	Eastern	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
33	\N	Nathaniel	Kwesi	Otoo	2002-03-11	Male	Single	GHA-721004583-9	nathaniel.otoo@st.ug.edu.gh	+233 26 634 3233	\N	Ghanaian	Greater Accra	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
34	\N	Belinda	Nana Yaa	Addo	2002-07-30	Female	Single	GHA-721004584-7	belinda.addo@st.ug.edu.gh	+233 20 745 3334	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
35	\N	Felix	Kwame	Aggrey	1999-05-18	Male	Single	GHA-721004585-5	felix.aggrey@st.ug.edu.gh	+233 55 856 3435	\N	Ghanaian	Central	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
36	\N	Doris	Ama	Owusuaa	1998-12-07	Female	Single	GHA-721004586-3	doris.owusuaa@st.ug.edu.gh	+233 24 967 3536	\N	Ghanaian	Ashanti	P. O. Box LG 77, Legon, Accra	University of Ghana, Legon Campus, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
37	Dr.	Kwesi	Ampofo	Danquah	1980-04-12	Male	Single	GHA-610004501-2	kadanquah@ug.edu.gh	+233 24 601 0011	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
38	Prof.	Naa Adukwei	\N	Tetteh	1972-09-30	Female	Single	GHA-610004502-0	natetteh@ug.edu.gh	+233 24 602 0012	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
39	Dr.	Yaw	Boadu	Antwi	1984-01-22	Male	Single	GHA-610004503-8	ybantwi@ug.edu.gh	+233 24 603 0013	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
40	Dr.	Esi	Mensimah	Koomson	1986-06-05	Female	Single	GHA-610004504-6	emkoomson@ug.edu.gh	+233 24 604 0014	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
41	Mr.	Justice	Nii Ayi	Bortey	1990-11-17	Male	Single	GHA-610004505-4	jnabortey@ug.edu.gh	+233 24 605 0015	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
42	Dr.	Mabel	Owusu	Ansah	1981-02-28	Female	Single	GHA-610004506-2	moansah@ug.edu.gh	+233 24 606 0016	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
43	Mrs.	Adjoa	Yeboah	Nkansah	1983-08-09	Female	Single	GHA-610004507-0	aynkansah@ug.edu.gh	+233 24 607 0017	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	Legon Staff Village, Accra	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
44	\N	Wisdom	Selorm	Ahiakpor	2000-02-14	Male	Single	GHA-610004508-8	wisdom.ahiakpor@ug.edu.gh	+233 24 608 0018	\N	Ghanaian	\N	P. O. Box LG 25, Legon, Accra	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: people; Owner: -
--

COPY people.student (student_id, person_id, student_number, programme_id, current_level, admission_date, expected_completion, status, residential_status, hall_of_residence, entry_qualification, cgpa, created_at, updated_at) FROM stdin;
1	36	24500198	1	600	2024-09-02	2026-09-02	active	non-resident	\N	BSc Computer Science	3.82	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	35	24500112	1	600	2024-09-02	2026-09-02	active	non-resident	\N	BSc Computer Engineering	3.90	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	34	21047733	2	400	2021-08-09	2025-08-08	active	resident	Akuafo Hall	WASSCE	3.85	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	33	21045612	2	400	2021-08-09	2025-08-08	active	non-resident	\N	WASSCE	3.78	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	32	22129314	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.90	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	31	22129308	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.46	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	30	22129291	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.18	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	29	22129285	2	200	2022-08-08	2026-08-07	active	resident	Volta Hall	WASSCE	3.63	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	28	22129272	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.71	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	27	22129266	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.29	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	26	22129253	2	200	2022-08-08	2026-08-07	active	resident	Commonwealth Hall	WASSCE	3.07	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	25	22129247	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.59	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	24	22129234	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.83	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	23	22129228	2	200	2022-08-08	2026-08-07	active	resident	Akuafo Hall	WASSCE	3.41	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	22	22129211	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.16	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	21	22129205	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.74	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	20	22129199	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.98	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	19	22129184	2	200	2022-08-08	2026-08-07	active	resident	Volta Hall	WASSCE	3.26	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
19	18	22129177	2	200	2022-08-08	2026-08-07	active	resident	Legon Hall	WASSCE	3.52	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
20	17	22129163	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.65	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
21	16	22129158	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.38	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
22	15	22129145	2	200	2022-08-08	2026-08-07	active	resident	Legon Hall	WASSCE	3.09	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
23	14	22129139	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.67	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
24	13	22129124	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.76	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
25	12	22129118	2	200	2022-08-08	2026-08-07	active	resident	Akuafo Hall	WASSCE	3.44	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
26	11	22129103	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.21	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
27	10	22129096	2	200	2022-08-08	2026-08-07	active	resident	Volta Hall	WASSCE	3.80	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
28	9	22129082	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.94	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
29	8	22129077	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.55	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
30	7	22129061	2	200	2022-08-08	2026-08-07	active	resident	Commonwealth Hall	WASSCE	3.12	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
31	6	22129055	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.33	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
32	5	22129048	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	2.87	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
33	4	22129033	2	200	2022-08-08	2026-08-07	active	resident	Akuafo Hall	WASSCE	3.71	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
34	3	22129027	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.05	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
35	2	22129014	2	200	2022-08-08	2026-08-07	active	resident	Volta Hall	WASSCE	3.48	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
36	1	22128981	2	200	2022-08-08	2026-08-07	active	non-resident	\N	WASSCE	3.62	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: enrollment; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.enrollment (enrollment_id, student_id, offering_id, enrolled_on, status, is_retake, continuous_assessment, exam_score, final_score, letter_grade, grade_point, dropped_on, created_at, updated_at) FROM stdin;
2	5	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	5	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	5	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	5	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	5	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	5	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	6	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	6	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	6	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	6	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	6	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	6	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	7	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	7	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	7	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
19	7	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
20	7	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
21	7	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
23	8	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
24	8	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
25	8	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
26	8	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
27	8	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
28	8	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
30	9	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
31	9	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
32	9	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
33	9	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
35	9	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
37	10	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
38	10	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
39	10	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
40	10	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
41	10	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
42	10	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
44	11	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
45	11	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
46	11	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
47	11	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
48	11	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
49	11	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
51	12	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
52	12	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
53	12	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
54	12	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
55	12	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
56	12	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
58	13	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
59	13	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
60	13	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
61	13	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
62	13	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
63	13	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
65	14	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
66	14	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
67	14	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
68	14	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
69	14	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
70	14	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
72	15	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
73	15	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
74	15	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
75	15	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
76	15	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
77	15	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
79	16	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
80	16	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
81	16	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
82	16	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
83	16	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
84	16	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
86	17	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
87	17	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
88	17	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
89	17	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
90	17	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
91	17	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
93	18	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
94	18	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
95	18	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
96	18	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
97	18	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
98	18	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
100	19	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
101	19	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
102	19	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
103	19	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
104	19	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
105	19	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
107	20	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
108	20	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
109	20	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
110	20	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
112	20	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
114	21	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
115	21	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
116	21	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
117	21	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
118	21	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
119	21	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
121	22	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
122	22	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
123	22	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
124	22	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
125	22	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
126	22	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
128	23	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
129	23	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
130	23	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
131	23	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
132	23	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
133	23	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
135	24	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
136	24	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
137	24	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
139	24	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
140	24	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
142	25	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
143	25	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
144	25	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
145	25	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
146	25	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
147	25	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
149	26	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
150	26	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
151	26	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
152	26	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
153	26	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
154	26	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
156	27	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
157	27	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
158	27	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
159	27	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
160	27	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
161	27	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
163	28	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
164	28	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
165	28	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
166	28	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
167	28	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
168	28	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
170	29	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
171	29	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
172	29	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
173	29	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
174	29	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
175	29	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
177	30	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
178	30	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
179	30	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
180	30	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
181	30	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
182	30	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
184	31	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
185	31	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
186	31	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
187	31	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
188	31	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
189	31	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
191	32	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
192	32	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
193	32	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
194	32	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
195	32	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
196	32	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
198	33	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
199	33	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
200	33	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
201	33	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
202	33	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
203	33	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
205	34	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
206	34	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
207	34	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
208	34	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
209	34	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
210	34	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
212	35	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
213	35	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
214	35	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
215	35	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
216	35	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
217	35	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
219	36	3	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
220	36	4	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
221	36	5	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
222	36	6	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
223	36	7	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
224	36	8	2025-08-25	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
225	3	1	2025-08-26	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
226	4	1	2025-08-26	enrolled	f	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
34	9	7	2025-08-25	dropped	f	\N	\N	\N	\N	\N	2025-09-12	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
111	20	7	2025-08-25	dropped	f	\N	\N	\N	\N	\N	2025-09-12	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
138	24	6	2025-08-25	enrolled	t	\N	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
1	5	2	2025-08-25	enrolled	f	27.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	6	2	2025-08-25	enrolled	f	21.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	7	2	2025-08-25	enrolled	f	28.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
22	8	2	2025-08-25	enrolled	f	22.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
29	9	2	2025-08-25	enrolled	f	29.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
36	10	2	2025-08-25	enrolled	f	23.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
43	11	2	2025-08-25	enrolled	f	30.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
50	12	2	2025-08-25	enrolled	f	24.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
57	13	2	2025-08-25	enrolled	f	18.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
64	14	2	2025-08-25	enrolled	f	25.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
71	15	2	2025-08-25	enrolled	f	19.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
78	16	2	2025-08-25	enrolled	f	26.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
85	17	2	2025-08-25	enrolled	f	20.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
92	18	2	2025-08-25	enrolled	f	27.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
99	19	2	2025-08-25	enrolled	f	21.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
106	20	2	2025-08-25	enrolled	f	28.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
113	21	2	2025-08-25	enrolled	f	22.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
120	22	2	2025-08-25	enrolled	f	29.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
127	23	2	2025-08-25	enrolled	f	23.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
134	24	2	2025-08-25	enrolled	f	30.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
141	25	2	2025-08-25	enrolled	f	24.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
148	26	2	2025-08-25	enrolled	f	18.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
155	27	2	2025-08-25	enrolled	f	25.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
162	28	2	2025-08-25	enrolled	f	19.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
169	29	2	2025-08-25	enrolled	f	26.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
176	30	2	2025-08-25	enrolled	f	20.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
183	31	2	2025-08-25	enrolled	f	27.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
190	32	2	2025-08-25	enrolled	f	21.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
197	33	2	2025-08-25	enrolled	f	28.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
204	34	2	2025-08-25	enrolled	f	22.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
211	35	2	2025-08-25	enrolled	f	29.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
218	36	2	2025-08-25	enrolled	f	23.00	\N	\N	\N	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: lecturer; Type: TABLE DATA; Schema: people; Owner: -
--

COPY people.lecturer (lecturer_id, person_id, staff_number, department_id, academic_rank, highest_qualification, specialisation, office_location, office_phone, employment_date, status, created_at, updated_at) FROM stdin;
1	41	CPEN/2021/104	1	Assistant Lecturer	MPhil Electrical Engineering	Circuit Theory, Power Electronics	Engineering Block B, Room 19	+233 30 250 1219	2021-01-11	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	40	CPEN/2019/083	1	Lecturer	PhD Computer Science	Algorithms, Data Structures, Machine Learning	Engineering Block B, Room 31	+233 30 250 1231	2019-08-15	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	39	CPEN/2017/067	1	Lecturer	PhD Electronic Engineering	Digital Systems, Embedded Design	Engineering Block B, Room 27	+233 30 250 1227	2017-10-01	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	38	CPEN/2008/012	1	Professor	PhD Computer Architecture	Computer Architecture, VLSI Design	Engineering Block B, Room 12	+233 30 250 1212	2008-02-01	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	37	CPEN/2015/041	1	Senior Lecturer	PhD Software Engineering	Software Engineering, Requirements Engineering	Engineering Block B, Room 34	+233 30 250 1241	2015-09-01	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	42	MATH/2016/055	2	Senior Lecturer	PhD Applied Mathematics	Linear Algebra, Differential Equations	Mathematics Building, Room 15	+233 30 250 2315	2016-09-01	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	43	UGRC/2018/029	3	Lecturer	MPhil English	Academic Writing, Communication Skills	Central Admin Block, Room 8	+233 30 250 3408	2018-09-03	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: lecturer_course_assignment; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.lecturer_course_assignment (assignment_id, lecturer_id, offering_id, teaching_role, contact_hours_per_week, assigned_on, assigned_by, is_active, remarks, created_at, updated_at) FROM stdin;
1	4	1	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Final year elective	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	5	2	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Course coordinator and project supervisor	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	2	2	co_lecturer	1	2025-08-06	Head of Department, Computer Engineering	t	Delivers the database design and SQL sessions	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	4	3	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Course coordinator	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	2	4	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Course coordinator	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	3	5	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Course coordinator	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	1	6	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Course coordinator	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	6	7	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	Service course taught for the Engineering School	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	7	8	lead_lecturer	3	2025-08-06	Head of Department, Computer Engineering	t	University required course	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: teaching_assistant; Type: TABLE DATA; Schema: people; Owner: -
--

COPY people.teaching_assistant (ta_id, person_id, ta_code, student_id, department_id, ta_type, appointment_date, end_date, monthly_stipend, max_weekly_hours, status, created_at, updated_at) FROM stdin;
1	36	TA/2025/002	1	1	graduate	2025-08-11	\N	1200.00	20	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	35	TA/2025/001	2	1	graduate	2025-08-11	\N	1200.00	20	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	34	TA/2025/004	3	1	undergraduate	2025-08-18	\N	650.00	12	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	33	TA/2025/003	4	1	undergraduate	2025-08-18	\N	650.00	12	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	44	TA/2025/005	\N	1	external	2025-09-01	2026-08-31	900.00	20	active	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: lecturer_ta_assignment; Type: TABLE DATA; Schema: academics; Owner: -
--

COPY academics.lecturer_ta_assignment (ta_assignment_id, lecturer_id, ta_id, offering_id, semester_id, responsibility, weekly_hours, assigned_on, end_date, is_active, created_at, updated_at) FROM stdin;
1	5	1	2	4	Marking of continuous assessment and PostgreSQL laboratory support	6	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	5	2	2	4	Laboratory supervision, Git/GitHub tutorials and grading of project submissions	8	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	4	2	1	4	Embedded systems laboratory support	6	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	3	3	5	4	Digital logic laboratory supervision and Verilog demonstrations	6	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	2	4	4	4	Weekly algorithms tutorial and code review of assignments	6	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	4	5	3	4	Assembly language laboratory support and attendance records	10	2025-08-20	\N	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: app_user; Type: TABLE DATA; Schema: app; Owner: -
--

COPY app.app_user (user_id, username, email, password_hash, role, person_id, is_active, email_verified, failed_login_attempts, locked_until, last_login_at, created_at, updated_at) FROM stdin;
1	admin	admin@cpen.ug.edu.gh	$2a$10$bU9w4Mu8xPrGQr3dUsc6ReFwfe2J.SCSvIKlOQl4meG2vJyA33fn2	admin	\N	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	24500112	felix.aggrey@st.ug.edu.gh	$2a$10$xJWMP6fLrhiOFtzctdAQ1.EUvlbGnuiGVJ4vvHv838AmoiJWtpUwq	student	35	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	21045612	nathaniel.otoo@st.ug.edu.gh	$2a$10$IIXnlHUUoe9cyWdnoVY3T.Fd61Lup/lj0iCJv2FkiNfHNTPSkjrFu	student	33	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	22129163	daniel.ampofo@st.ug.edu.gh	$2a$10$7faUv4Z5KKvIzfwys3k1H.hUwnVhF5lsA5VDwHraUFriV7QxUCjN.	student	17	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	22129096	adwoa.amponsah@st.ug.edu.gh	$2a$10$HQ8TqvrqyuEVhSr0CZj7n.rHceX7XU.yb7VP/WXoBNzY/q4D0UHFq	student	10	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	22129048	yaw.boasiako@st.ug.edu.gh	$2a$10$LY4m/7DHxX/5lP.n8M6B/eZ4o.ZopZHpTUUGHR1.aCkWQTuESvwxK	student	5	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	22129033	akosua.quartey@st.ug.edu.gh	$2a$10$hH9ykDFLhKmxOBAaY5lPke1K2rSlOkG1CeuyRakc7RLxAW2FMwaFa	student	4	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	22129027	kwabena.mensah@st.ug.edu.gh	$2a$10$yGwkVHpe97dnyYk7Q/3uFOi2enoSfX1txrexw.h/eMCZULxdswgLm	student	3	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	22129014	nanaama.boateng@st.ug.edu.gh	$2a$10$EJWklPMGN7HAH34.d880SOxYc27Vxv0Qu7Bq7ADOkRDOgt6fzjLlO	student	2	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	22128981	gideon.glago@st.ug.edu.gh	$2a$10$15HATV3jwxScBwFzh2enfuc1b7PS/iJ2OFcpIcBKiL.N/qvSy1W8C	student	1	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	jnabortey	jnabortey@ug.edu.gh	$2a$10$aUryGtLHM9jbyST0nHACc.j2iOpPvlWx8fn27DerI4L3GT1gUVj0a	lecturer	41	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	emkoomson	emkoomson@ug.edu.gh	$2a$10$zVCadreTrkvm553dFzsiR.GXApivR9/h/FvMVRdGyxhm6L2SambdK	lecturer	40	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	ybantwi	ybantwi@ug.edu.gh	$2a$10$LUzIjNKPOLMbYv.m48klouTL1J5o7m5XFvaD89JVTJcS6HHEtyFre	lecturer	39	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	natetteh	natetteh@ug.edu.gh	$2a$10$I8yc6ILAjD5jHfyLzoMnWufW87oX6RC001dJcF2SISpQ.7GtZWX5i	lecturer	38	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	kadanquah	kadanquah@ug.edu.gh	$2a$10$yEUxU5Ow3Sm7ZV.u0phAkulQZq1B/p6SgJGYwLYUVosa6sDOH4W5e	lecturer	37	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	moansah	moansah@ug.edu.gh	$2a$10$E5Aix5Gfz8CQqoo9GTDw6.rm54sbXdopbsj/F33y5AOQcffHOrFc6	lecturer	42	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	aynkansah	aynkansah@ug.edu.gh	$2a$10$M0nFF9dttvf4p9FYe.RGguaeev3UButMwkLQdSULPr7UQEiDheIAe	lecturer	43	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	wisdom.ahiakpor	wisdom.ahiakpor@ug.edu.gh	$2a$10$2hDGdH.M0EuIk0bBRVyE3uWF890unlGPH2nVkBF3V73V5SIglcvIu	teaching_assistant	44	t	t	0	\N	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: app; Owner: -
--

COPY app.audit_log (audit_id, user_id, action, entity, entity_id, details, ip_address, occurred_at) FROM stdin;
1	1	SEED	app_user	1	{"role": "admin", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
2	2	SEED	app_user	2	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
3	3	SEED	app_user	3	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
4	4	SEED	app_user	4	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
5	5	SEED	app_user	5	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
6	6	SEED	app_user	6	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
7	7	SEED	app_user	7	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
8	8	SEED	app_user	8	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
9	9	SEED	app_user	9	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
10	10	SEED	app_user	10	{"role": "student", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
11	11	SEED	app_user	11	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
12	12	SEED	app_user	12	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
13	13	SEED	app_user	13	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
14	14	SEED	app_user	14	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
15	15	SEED	app_user	15	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
16	16	SEED	app_user	16	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
17	17	SEED	app_user	17	{"role": "lecturer", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
18	18	SEED	app_user	18	{"role": "teaching_assistant", "source": "06_seed_data.sql"}	\N	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: app; Owner: -
--

COPY app.user_session (session_id, user_id, token_hash, issued_at, expires_at, revoked_at, ip_address, user_agent) FROM stdin;
\.


--
-- Data for Name: fee_structure; Type: TABLE DATA; Schema: finance; Owner: -
--

COPY finance.fee_structure (fee_structure_id, programme_id, academic_year_id, level, residential_status, currency, is_active, created_at, updated_at) FROM stdin;
1	1	2	600	non-resident	GHS	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	2	2	400	resident	GHS	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	2	2	400	non-resident	GHS	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	2	2	200	resident	GHS	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	2	2	200	non-resident	GHS	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: fee_item; Type: TABLE DATA; Schema: finance; Owner: -
--

COPY finance.fee_item (fee_item_id, fee_structure_id, item_name, category, amount, is_mandatory, description) FROM stdin;
1	1	GRASAG Dues	src_dues	120.00	t	Graduate Students Association of Ghana
2	1	Examination and Thesis Fee	examination	400.00	t	Examinations, thesis examination and binding
3	1	Academic Facility User Fee	academic_facility	1200.00	t	Research laboratories, library and ICT
4	1	Tuition (Graduate)	tuition	6500.00	t	MPhil tuition for the academic year
5	2	Residential Facility Fee	residential	1800.00	t	Hall of residence accommodation for the academic year
6	2	Project Supervision Fee	other	280.00	t	Final year project supervision and binding
7	2	SRC Dues	src_dues	150.00	t	Students Representative Council
8	2	Examination Fee	examination	350.00	t	End of semester examinations
9	2	Tuition (Subsidised)	tuition	2050.00	t	Government subsidised tuition for Ghanaian students
10	2	Academic Facility User Fee	academic_facility	2250.00	t	Laboratories, library, ICT and utilities
11	3	Project Supervision Fee	other	280.00	t	Final year project supervision and binding
12	3	SRC Dues	src_dues	150.00	t	Students Representative Council
13	3	Examination Fee	examination	350.00	t	End of semester examinations
14	3	Tuition (Subsidised)	tuition	2050.00	t	Government subsidised tuition for Ghanaian students
15	3	Academic Facility User Fee	academic_facility	2250.00	t	Laboratories, library, ICT and utilities
16	4	Residential Facility Fee	residential	1800.00	t	Hall of residence accommodation for the academic year
17	4	Student Insurance	other	60.00	t	Group personal accident cover
18	4	SRC Dues	src_dues	150.00	t	Students Representative Council
19	4	Examination Fee	examination	320.00	t	End of semester examinations
20	4	Tuition (Subsidised)	tuition	1890.00	t	Government subsidised tuition for Ghanaian students
21	4	Academic Facility User Fee	academic_facility	2050.00	t	Laboratories, library, ICT and utilities
22	5	Student Insurance	other	60.00	t	Group personal accident cover
23	5	SRC Dues	src_dues	150.00	t	Students Representative Council
24	5	Examination Fee	examination	320.00	t	End of semester examinations
25	5	Tuition (Subsidised)	tuition	1890.00	t	Government subsidised tuition for Ghanaian students
26	5	Academic Facility User Fee	academic_facility	2050.00	t	Laboratories, library, ICT and utilities
\.


--
-- Data for Name: student_bill; Type: TABLE DATA; Schema: finance; Owner: -
--

COPY finance.student_bill (bill_id, bill_reference, student_id, academic_year_id, fee_structure_id, total_amount, currency, issued_on, due_date, status, notes, created_at, updated_at) FROM stdin;
1	BILL-20252026-00001	1	2	1	8220.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	BILL-20252026-00002	2	2	1	8220.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	BILL-20252026-00004	4	2	3	5080.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	BILL-20252026-00005	5	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	BILL-20252026-00006	6	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	BILL-20252026-00007	7	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	BILL-20252026-00009	9	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	BILL-20252026-00010	10	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	BILL-20252026-00011	11	2	4	6270.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	BILL-20252026-00012	12	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	BILL-20252026-00014	14	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	BILL-20252026-00015	15	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	BILL-20252026-00016	16	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	BILL-20252026-00017	17	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
19	BILL-20252026-00019	19	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
20	BILL-20252026-00020	20	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
21	BILL-20252026-00021	21	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
22	BILL-20252026-00022	22	2	4	6270.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
24	BILL-20252026-00024	24	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
25	BILL-20252026-00025	25	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
26	BILL-20252026-00026	26	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
29	BILL-20252026-00029	29	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
30	BILL-20252026-00030	30	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
31	BILL-20252026-00031	31	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
32	BILL-20252026-00032	32	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
34	BILL-20252026-00034	34	2	5	4470.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
35	BILL-20252026-00035	35	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
27	BILL-20252026-00027	27	2	4	6270.00	GHS	2025-08-04	2025-10-31	paid	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
36	BILL-20252026-00036	36	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	BILL-20252026-00003	3	2	2	6880.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	BILL-20252026-00008	8	2	4	6270.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	BILL-20252026-00013	13	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	BILL-20252026-00018	18	2	4	6270.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
23	BILL-20252026-00023	23	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
28	BILL-20252026-00028	28	2	5	4470.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
33	BILL-20252026-00033	33	2	4	6270.00	GHS	2025-08-04	2025-10-31	overdue	\N	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: bill_line; Type: TABLE DATA; Schema: finance; Owner: -
--

COPY finance.bill_line (bill_line_id, bill_id, fee_item_id, description, category, amount) FROM stdin;
1	1	1	GRASAG Dues	src_dues	120.00
2	1	2	Examination and Thesis Fee	examination	400.00
3	1	3	Academic Facility User Fee	academic_facility	1200.00
4	1	4	Tuition (Graduate)	tuition	6500.00
5	2	1	GRASAG Dues	src_dues	120.00
6	2	2	Examination and Thesis Fee	examination	400.00
7	2	3	Academic Facility User Fee	academic_facility	1200.00
8	2	4	Tuition (Graduate)	tuition	6500.00
9	3	5	Residential Facility Fee	residential	1800.00
10	3	6	Project Supervision Fee	other	280.00
11	3	7	SRC Dues	src_dues	150.00
12	3	8	Examination Fee	examination	350.00
13	3	9	Tuition (Subsidised)	tuition	2050.00
14	3	10	Academic Facility User Fee	academic_facility	2250.00
15	4	11	Project Supervision Fee	other	280.00
16	4	12	SRC Dues	src_dues	150.00
17	4	13	Examination Fee	examination	350.00
18	4	14	Tuition (Subsidised)	tuition	2050.00
19	4	15	Academic Facility User Fee	academic_facility	2250.00
20	5	22	Student Insurance	other	60.00
21	5	23	SRC Dues	src_dues	150.00
22	5	24	Examination Fee	examination	320.00
23	5	25	Tuition (Subsidised)	tuition	1890.00
24	5	26	Academic Facility User Fee	academic_facility	2050.00
25	6	22	Student Insurance	other	60.00
26	6	23	SRC Dues	src_dues	150.00
27	6	24	Examination Fee	examination	320.00
28	6	25	Tuition (Subsidised)	tuition	1890.00
29	6	26	Academic Facility User Fee	academic_facility	2050.00
30	7	22	Student Insurance	other	60.00
31	7	23	SRC Dues	src_dues	150.00
32	7	24	Examination Fee	examination	320.00
33	7	25	Tuition (Subsidised)	tuition	1890.00
34	7	26	Academic Facility User Fee	academic_facility	2050.00
35	8	16	Residential Facility Fee	residential	1800.00
36	8	17	Student Insurance	other	60.00
37	8	18	SRC Dues	src_dues	150.00
38	8	19	Examination Fee	examination	320.00
39	8	20	Tuition (Subsidised)	tuition	1890.00
40	8	21	Academic Facility User Fee	academic_facility	2050.00
41	9	22	Student Insurance	other	60.00
42	9	23	SRC Dues	src_dues	150.00
43	9	24	Examination Fee	examination	320.00
44	9	25	Tuition (Subsidised)	tuition	1890.00
45	9	26	Academic Facility User Fee	academic_facility	2050.00
46	10	22	Student Insurance	other	60.00
47	10	23	SRC Dues	src_dues	150.00
48	10	24	Examination Fee	examination	320.00
49	10	25	Tuition (Subsidised)	tuition	1890.00
50	10	26	Academic Facility User Fee	academic_facility	2050.00
51	11	16	Residential Facility Fee	residential	1800.00
52	11	17	Student Insurance	other	60.00
53	11	18	SRC Dues	src_dues	150.00
54	11	19	Examination Fee	examination	320.00
55	11	20	Tuition (Subsidised)	tuition	1890.00
56	11	21	Academic Facility User Fee	academic_facility	2050.00
57	12	22	Student Insurance	other	60.00
58	12	23	SRC Dues	src_dues	150.00
59	12	24	Examination Fee	examination	320.00
60	12	25	Tuition (Subsidised)	tuition	1890.00
61	12	26	Academic Facility User Fee	academic_facility	2050.00
62	13	22	Student Insurance	other	60.00
63	13	23	SRC Dues	src_dues	150.00
64	13	24	Examination Fee	examination	320.00
65	13	25	Tuition (Subsidised)	tuition	1890.00
66	13	26	Academic Facility User Fee	academic_facility	2050.00
67	14	16	Residential Facility Fee	residential	1800.00
68	14	17	Student Insurance	other	60.00
69	14	18	SRC Dues	src_dues	150.00
70	14	19	Examination Fee	examination	320.00
71	14	20	Tuition (Subsidised)	tuition	1890.00
72	14	21	Academic Facility User Fee	academic_facility	2050.00
73	15	22	Student Insurance	other	60.00
74	15	23	SRC Dues	src_dues	150.00
75	15	24	Examination Fee	examination	320.00
76	15	25	Tuition (Subsidised)	tuition	1890.00
77	15	26	Academic Facility User Fee	academic_facility	2050.00
78	16	22	Student Insurance	other	60.00
79	16	23	SRC Dues	src_dues	150.00
80	16	24	Examination Fee	examination	320.00
81	16	25	Tuition (Subsidised)	tuition	1890.00
82	16	26	Academic Facility User Fee	academic_facility	2050.00
83	17	22	Student Insurance	other	60.00
84	17	23	SRC Dues	src_dues	150.00
85	17	24	Examination Fee	examination	320.00
86	17	25	Tuition (Subsidised)	tuition	1890.00
87	17	26	Academic Facility User Fee	academic_facility	2050.00
88	18	16	Residential Facility Fee	residential	1800.00
89	18	17	Student Insurance	other	60.00
90	18	18	SRC Dues	src_dues	150.00
91	18	19	Examination Fee	examination	320.00
92	18	20	Tuition (Subsidised)	tuition	1890.00
93	18	21	Academic Facility User Fee	academic_facility	2050.00
94	19	16	Residential Facility Fee	residential	1800.00
95	19	17	Student Insurance	other	60.00
96	19	18	SRC Dues	src_dues	150.00
97	19	19	Examination Fee	examination	320.00
98	19	20	Tuition (Subsidised)	tuition	1890.00
99	19	21	Academic Facility User Fee	academic_facility	2050.00
100	20	22	Student Insurance	other	60.00
101	20	23	SRC Dues	src_dues	150.00
102	20	24	Examination Fee	examination	320.00
103	20	25	Tuition (Subsidised)	tuition	1890.00
104	20	26	Academic Facility User Fee	academic_facility	2050.00
105	21	22	Student Insurance	other	60.00
106	21	23	SRC Dues	src_dues	150.00
107	21	24	Examination Fee	examination	320.00
108	21	25	Tuition (Subsidised)	tuition	1890.00
109	21	26	Academic Facility User Fee	academic_facility	2050.00
110	22	16	Residential Facility Fee	residential	1800.00
111	22	17	Student Insurance	other	60.00
112	22	18	SRC Dues	src_dues	150.00
113	22	19	Examination Fee	examination	320.00
114	22	20	Tuition (Subsidised)	tuition	1890.00
115	22	21	Academic Facility User Fee	academic_facility	2050.00
116	23	22	Student Insurance	other	60.00
117	23	23	SRC Dues	src_dues	150.00
118	23	24	Examination Fee	examination	320.00
119	23	25	Tuition (Subsidised)	tuition	1890.00
120	23	26	Academic Facility User Fee	academic_facility	2050.00
121	24	22	Student Insurance	other	60.00
122	24	23	SRC Dues	src_dues	150.00
123	24	24	Examination Fee	examination	320.00
124	24	25	Tuition (Subsidised)	tuition	1890.00
125	24	26	Academic Facility User Fee	academic_facility	2050.00
126	25	16	Residential Facility Fee	residential	1800.00
127	25	17	Student Insurance	other	60.00
128	25	18	SRC Dues	src_dues	150.00
129	25	19	Examination Fee	examination	320.00
130	25	20	Tuition (Subsidised)	tuition	1890.00
131	25	21	Academic Facility User Fee	academic_facility	2050.00
132	26	22	Student Insurance	other	60.00
133	26	23	SRC Dues	src_dues	150.00
134	26	24	Examination Fee	examination	320.00
135	26	25	Tuition (Subsidised)	tuition	1890.00
136	26	26	Academic Facility User Fee	academic_facility	2050.00
137	27	16	Residential Facility Fee	residential	1800.00
138	27	17	Student Insurance	other	60.00
139	27	18	SRC Dues	src_dues	150.00
140	27	19	Examination Fee	examination	320.00
141	27	20	Tuition (Subsidised)	tuition	1890.00
142	27	21	Academic Facility User Fee	academic_facility	2050.00
143	28	22	Student Insurance	other	60.00
144	28	23	SRC Dues	src_dues	150.00
145	28	24	Examination Fee	examination	320.00
146	28	25	Tuition (Subsidised)	tuition	1890.00
147	28	26	Academic Facility User Fee	academic_facility	2050.00
148	29	22	Student Insurance	other	60.00
149	29	23	SRC Dues	src_dues	150.00
150	29	24	Examination Fee	examination	320.00
151	29	25	Tuition (Subsidised)	tuition	1890.00
152	29	26	Academic Facility User Fee	academic_facility	2050.00
153	30	16	Residential Facility Fee	residential	1800.00
154	30	17	Student Insurance	other	60.00
155	30	18	SRC Dues	src_dues	150.00
156	30	19	Examination Fee	examination	320.00
157	30	20	Tuition (Subsidised)	tuition	1890.00
158	30	21	Academic Facility User Fee	academic_facility	2050.00
159	31	22	Student Insurance	other	60.00
160	31	23	SRC Dues	src_dues	150.00
161	31	24	Examination Fee	examination	320.00
162	31	25	Tuition (Subsidised)	tuition	1890.00
163	31	26	Academic Facility User Fee	academic_facility	2050.00
164	32	22	Student Insurance	other	60.00
165	32	23	SRC Dues	src_dues	150.00
166	32	24	Examination Fee	examination	320.00
167	32	25	Tuition (Subsidised)	tuition	1890.00
168	32	26	Academic Facility User Fee	academic_facility	2050.00
169	33	16	Residential Facility Fee	residential	1800.00
170	33	17	Student Insurance	other	60.00
171	33	18	SRC Dues	src_dues	150.00
172	33	19	Examination Fee	examination	320.00
173	33	20	Tuition (Subsidised)	tuition	1890.00
174	33	21	Academic Facility User Fee	academic_facility	2050.00
175	34	22	Student Insurance	other	60.00
176	34	23	SRC Dues	src_dues	150.00
177	34	24	Examination Fee	examination	320.00
178	34	25	Tuition (Subsidised)	tuition	1890.00
179	34	26	Academic Facility User Fee	academic_facility	2050.00
180	35	16	Residential Facility Fee	residential	1800.00
181	35	17	Student Insurance	other	60.00
182	35	18	SRC Dues	src_dues	150.00
183	35	19	Examination Fee	examination	320.00
184	35	20	Tuition (Subsidised)	tuition	1890.00
185	35	21	Academic Facility User Fee	academic_facility	2050.00
186	36	22	Student Insurance	other	60.00
187	36	23	SRC Dues	src_dues	150.00
188	36	24	Examination Fee	examination	320.00
189	36	25	Tuition (Subsidised)	tuition	1890.00
190	36	26	Academic Facility User Fee	academic_facility	2050.00
\.


--
-- Data for Name: payment; Type: TABLE DATA; Schema: finance; Owner: -
--

COPY finance.payment (payment_id, receipt_number, student_id, bill_id, amount, currency, payment_date, payment_method, bank_or_channel, transaction_ref, status, received_by, remarks, created_at, updated_at) FROM stdin;
1	RCPT-2025-000001	1	1	2877.00	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN000101	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	RCPT-2025-000002	1	1	2055.00	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN000102	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	RCPT-2025-000003	2	2	2877.00	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN000201	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
4	RCPT-2025-000004	4	4	2032.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN000401	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
5	RCPT-2025-000005	4	4	1778.00	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN000402	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
6	RCPT-2025-000006	4	4	1270.00	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN000403	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
7	RCPT-2025-000007	5	5	4470.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN000501	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
8	RCPT-2025-000008	6	6	1564.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN000601	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
9	RCPT-2025-000009	6	6	1117.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN000602	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
10	RCPT-2025-000010	7	7	1564.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN000701	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
11	RCPT-2025-000011	9	9	1788.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN000901	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
12	RCPT-2025-000012	9	9	1564.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN000902	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
13	RCPT-2025-000013	9	9	1117.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN000903	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
14	RCPT-2025-000014	10	10	4470.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN001001	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
15	RCPT-2025-000015	11	11	2194.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN001101	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
16	RCPT-2025-000016	11	11	1567.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN001102	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
17	RCPT-2025-000017	12	12	1564.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN001201	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
18	RCPT-2025-000018	14	14	2508.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN001401	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
19	RCPT-2025-000019	14	14	2194.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN001402	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
20	RCPT-2025-000020	14	14	1567.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN001403	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
21	RCPT-2025-000021	15	15	4470.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN001501	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
22	RCPT-2025-000022	16	16	1564.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN001601	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
23	RCPT-2025-000023	16	16	1117.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN001602	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
24	RCPT-2025-000024	17	17	1564.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN001701	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
25	RCPT-2025-000025	19	19	2508.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN001901	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
26	RCPT-2025-000026	19	19	2194.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN001902	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
27	RCPT-2025-000027	19	19	1567.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN001903	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
28	RCPT-2025-000028	20	20	4470.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN002001	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
29	RCPT-2025-000029	21	21	1564.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN002101	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
30	RCPT-2025-000030	21	21	1117.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN002102	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
31	RCPT-2025-000031	22	22	2194.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN002201	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
32	RCPT-2025-000032	24	24	1788.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN002401	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
33	RCPT-2025-000033	24	24	1564.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN002402	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
34	RCPT-2025-000034	24	24	1117.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN002403	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
35	RCPT-2025-000035	25	25	6270.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN002501	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
36	RCPT-2025-000036	26	26	1564.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN002601	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
37	RCPT-2025-000037	26	26	1117.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN002602	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
38	RCPT-2025-000038	27	27	2194.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN002701	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
39	RCPT-2025-000039	29	29	1788.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN002901	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
40	RCPT-2025-000040	29	29	1564.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN002902	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
41	RCPT-2025-000041	29	29	1117.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN002903	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
42	RCPT-2025-000042	30	30	6270.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN003001	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
43	RCPT-2025-000043	31	31	1564.50	GHS	2025-09-10	mobile_money	MTN Mobile Money	TXN003101	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
44	RCPT-2025-000044	31	31	1117.50	GHS	2025-11-04	mobile_money	MTN Mobile Money	TXN003102	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
45	RCPT-2025-000045	32	32	1564.50	GHS	2025-09-18	bank_transfer	Absa Bank - Legon	TXN003201	confirmed	Finance Office, University of Ghana	Part payment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
46	RCPT-2025-000046	34	34	1788.00	GHS	2025-09-08	mobile_money	Telecel Cash	TXN003401	confirmed	Finance Office, University of Ghana	First instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
47	RCPT-2025-000047	34	34	1564.50	GHS	2025-10-20	bank_transfer	Ecobank - Legon	TXN003402	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
48	RCPT-2025-000048	34	34	1117.50	GHS	2025-12-01	bank_transfer	Ecobank - Legon	TXN003403	confirmed	Finance Office, University of Ghana	Final instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
49	RCPT-2025-000049	35	35	6270.00	GHS	2025-09-15	bank_transfer	GCB Bank - Legon Branch	TXN003501	confirmed	Finance Office, University of Ghana	Full payment at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
50	RCPT-2025-900001	34	34	1500.00	GHS	2025-12-15	cheque	Stanbic Bank	CHQ0099123	pending	Finance Office, University of Ghana	Cheque lodged, awaiting clearance - excluded from outstanding balance	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
51	RCPT-2025-900002	32	32	800.00	GHS	2025-10-05	mobile_money	MTN Mobile Money	TXNREV0001	reversed	Finance Office, University of Ghana	Transaction reversed by the payment provider - excluded from outstanding balance	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
52	RCPT-2025-900003	27	27	4075.50	GHS	2025-09-25	scholarship	GETFund Scholarship Secretariat	GETF/2025/0417	confirmed	Scholarships Office	GETFund merit scholarship - balance settled in full	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
53	RCPT-2025-900004	36	36	2000.00	GHS	2025-09-12	bank_transfer	GCB Bank - Legon Branch	TXNGEG0001	confirmed	Finance Office, University of Ghana	First instalment paid at registration	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
54	RCPT-2025-900005	36	36	1200.00	GHS	2025-11-18	mobile_money	MTN Mobile Money	TXNGEG0002	confirmed	Finance Office, University of Ghana	Second instalment	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: next_of_kin; Type: TABLE DATA; Schema: people; Owner: -
--

COPY people.next_of_kin (next_of_kin_id, student_id, full_name, relationship, phone, email, occupation, address, is_primary, created_at) FROM stdin;
1	2	Mrs. Mary Aggrey	Mother	+233 24 555 7010	m.aggrey@gmail.com	Retired	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
2	4	Mrs. Naa Otoo	Mother	+233 24 555 7009	n.otoo@gmail.com	Pharmacist	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
3	29	Mr. Kofi Asante	Father	+233 24 555 7008	k.asante@gmail.com	Banker	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
4	30	Mrs. Akua Duah	Mother	+233 24 555 7007	a.duah@gmail.com	Seamstress	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
5	31	Mr. Samuel Lamptey	Father	+233 24 555 7006	s.lamptey@gmail.com	Engineer	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
6	32	Mrs. Yaa Boasiako	Mother	+233 24 555 7005	y.boasiako@gmail.com	Nurse	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
7	33	Mr. Nii Armah Quartey	Father	+233 24 555 7004	n.quartey@gmail.com	Civil Servant	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
8	34	Mrs. Grace Mensah	Mother	+233 24 555 7003	g.mensah@gmail.com	Trader	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
9	35	Mr. Kwaku Boateng	Father	+233 24 555 7002	k.boateng@gmail.com	Accountant	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
10	36	Mrs. Comfort Elorm Glago	Mother	+233 24 555 7001	comfort.glago@gmail.com	Teacher	P. O. Box 245, Accra	t	2026-08-03 20:52:48.539735+00
\.


--
-- Name: course_course_id_seq; Type: SEQUENCE SET; Schema: academics; Owner: -
--

SELECT pg_catalog.setval('academics.course_course_id_seq', 10, true);


--
-- Name: course_offering_offering_id_seq; Type: SEQUENCE SET; Schema: academics; Owner: -
--

SELECT pg_catalog.setval('academics.course_offering_offering_id_seq', 8, true);


--
-- Name: enrollment_enrollment_id_seq; Type: SEQUENCE SET; Schema: academics; Owner: -
--

SELECT pg_catalog.setval('academics.enrollment_enrollment_id_seq', 226, true);


--
-- Name: lecturer_course_assignment_assignment_id_seq; Type: SEQUENCE SET; Schema: academics; Owner: -
--

SELECT pg_catalog.setval('academics.lecturer_course_assignment_assignment_id_seq', 9, true);


--
-- Name: lecturer_ta_assignment_ta_assignment_id_seq; Type: SEQUENCE SET; Schema: academics; Owner: -
--

SELECT pg_catalog.setval('academics.lecturer_ta_assignment_ta_assignment_id_seq', 6, true);


--
-- Name: app_user_user_id_seq; Type: SEQUENCE SET; Schema: app; Owner: -
--

SELECT pg_catalog.setval('app.app_user_user_id_seq', 18, true);


--
-- Name: audit_log_audit_id_seq; Type: SEQUENCE SET; Schema: app; Owner: -
--

SELECT pg_catalog.setval('app.audit_log_audit_id_seq', 18, true);


--
-- Name: academic_year_academic_year_id_seq; Type: SEQUENCE SET; Schema: core; Owner: -
--

SELECT pg_catalog.setval('core.academic_year_academic_year_id_seq', 2, true);


--
-- Name: department_department_id_seq; Type: SEQUENCE SET; Schema: core; Owner: -
--

SELECT pg_catalog.setval('core.department_department_id_seq', 3, true);


--
-- Name: programme_programme_id_seq; Type: SEQUENCE SET; Schema: core; Owner: -
--

SELECT pg_catalog.setval('core.programme_programme_id_seq', 2, true);


--
-- Name: semester_semester_id_seq; Type: SEQUENCE SET; Schema: core; Owner: -
--

SELECT pg_catalog.setval('core.semester_semester_id_seq', 4, true);


--
-- Name: bill_line_bill_line_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.bill_line_bill_line_id_seq', 190, true);


--
-- Name: fee_item_fee_item_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.fee_item_fee_item_id_seq', 26, true);


--
-- Name: fee_structure_fee_structure_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.fee_structure_fee_structure_id_seq', 5, true);


--
-- Name: payment_payment_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.payment_payment_id_seq', 54, true);


--
-- Name: receipt_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.receipt_seq', 1000, false);


--
-- Name: student_bill_bill_id_seq; Type: SEQUENCE SET; Schema: finance; Owner: -
--

SELECT pg_catalog.setval('finance.student_bill_bill_id_seq', 36, true);


--
-- Name: lecturer_lecturer_id_seq; Type: SEQUENCE SET; Schema: people; Owner: -
--

SELECT pg_catalog.setval('people.lecturer_lecturer_id_seq', 7, true);


--
-- Name: next_of_kin_next_of_kin_id_seq; Type: SEQUENCE SET; Schema: people; Owner: -
--

SELECT pg_catalog.setval('people.next_of_kin_next_of_kin_id_seq', 10, true);


--
-- Name: person_person_id_seq; Type: SEQUENCE SET; Schema: people; Owner: -
--

SELECT pg_catalog.setval('people.person_person_id_seq', 44, true);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: people; Owner: -
--

SELECT pg_catalog.setval('people.student_student_id_seq', 36, true);


--
-- Name: teaching_assistant_ta_id_seq; Type: SEQUENCE SET; Schema: people; Owner: -
--

SELECT pg_catalog.setval('people.teaching_assistant_ta_id_seq', 5, true);


--
-- PostgreSQL database dump complete
--

\unrestrict YeGVKv5GaxT62e9CfsLhTslmlo0SDLXDq98HDvLexsnfTpP4dheRcoOgwUt6wnt

