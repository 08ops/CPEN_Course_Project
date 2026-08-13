-- =============================================================================
-- File    : 06_seed_data.sql
-- Purpose : Insert scripts that populate every table with sample data.
-- Usage   : psql -d cpen208_ceds -f 06_seed_data.sql
-- -----------------------------------------------------------------------------
-- DATA SAMPLE
--   The brief says "use your class as the data sample". The sample below models
--   the CPEN 208 (Introduction to Software Engineering) class of the Computer
--   Engineering Department, Level 200, First Semester 2025/2026:
--     * 32 Level-200 students taking CPEN 208 and its sister courses,
--     * 2 Level-400 students and 2 MPhil students who serve as teaching
--       assistants,
--     * 7 lecturers, 5 teaching assistants, 10 courses, 8 semester offerings.
--
--   PRIVACY ASSUMPTION: apart from the author's own record (22128981), all
--   personal details - names, dates of birth, Ghana Card numbers, phone
--   numbers, e-mail addresses, fee balances - are synthetic stand-ins for real
--   classmates and staff. They are realistic in shape so that every constraint
--   and function is exercised, but they identify nobody.
--
--   Scripts are written with natural-key look-ups (course_code, student_number,
--   ...) rather than hard-coded surrogate ids, so the file can be re-run on a
--   freshly created database without editing.
-- =============================================================================

SET search_path = core, people, academics, finance, app, public;

BEGIN;

-- #############################################################################
-- 1. REFERENCE DATA
-- #############################################################################

INSERT INTO core.department (code, name, college, school, email, phone, office_location, established_on) VALUES
('CPEN', 'Computer Engineering',  'College of Basic and Applied Sciences', 'School of Engineering Sciences',
 'cpen@ug.edu.gh',  '+233 30 250 1234', 'Engineering Block B, Room 21', DATE '2005-09-01'),
('MATH', 'Mathematics',           'College of Basic and Applied Sciences', 'School of Physical and Mathematical Sciences',
 'maths@ug.edu.gh', '+233 30 250 2345', 'Mathematics Building, Room 4',  DATE '1948-10-01'),
('UGRC', 'Office of Academic Affairs (University Required Courses)', 'Academic Affairs Directorate', 'University-wide',
 'ugrc@ug.edu.gh',  '+233 30 250 3456', 'Central Administration Block', DATE '2010-08-01');

INSERT INTO core.programme (department_id, code, name, degree_award, duration_years, total_credits)
SELECT d.department_id, v.code, v.name, v.award, v.years, v.credits
FROM  (VALUES
        ('CPEN', 'BSC-CPEN',   'BSc Computer Engineering',    'BSc',   4, 132),
        ('CPEN', 'MPHIL-CPEN', 'MPhil Computer Engineering',  'MPhil', 2,  48)
      ) AS v(dept, code, name, award, years, credits)
JOIN   core.department d ON d.code = v.dept;

INSERT INTO core.academic_year (name, start_date, end_date, is_current) VALUES
('2024/2025', DATE '2024-08-05', DATE '2025-07-25', FALSE),
('2025/2026', DATE '2025-08-04', DATE '2026-07-24', TRUE);

INSERT INTO core.semester (academic_year_id, name, sequence_no, start_date, end_date, registration_deadline, is_current)
SELECT ay.academic_year_id, v.name, v.seq, v.sd, v.ed, v.rd, v.cur
FROM  (VALUES
        ('2024/2025', 'First Semester',  1, DATE '2024-08-05', DATE '2024-12-20', DATE '2024-09-06', FALSE),
        ('2024/2025', 'Second Semester', 2, DATE '2025-01-13', DATE '2025-05-30', DATE '2025-02-07', FALSE),
        ('2025/2026', 'First Semester',  1, DATE '2025-08-04', DATE '2025-12-19', DATE '2025-09-05', TRUE),
        ('2025/2026', 'Second Semester', 2, DATE '2026-01-12', DATE '2026-05-29', DATE '2026-02-06', FALSE)
      ) AS v(year, name, seq, sd, ed, rd, cur)
JOIN   core.academic_year ay ON ay.name = v.year;

-- #############################################################################
-- 2. PEOPLE - the CPEN 208 class  (FUNCTIONALITY 1)
-- #############################################################################

-- Data-modifying CTE: insert the person, then use the returned person_id to
-- insert the matching student row in the same statement.
WITH raw(first_name, middle_name, last_name, dob, gender, email, phone, national_id,
         home_region, student_number, prog, level, admission, residency, hall, entry, cgpa) AS (
VALUES
-- ---- the author -----------------------------------------------------------
('Gideon','Elorm','Glago',            DATE '2004-03-17','Male',  'gideon.glago@st.ug.edu.gh',        '+233 24 411 0981','GHA-721004551-3','Volta',        '22128981','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.62),
-- ---- classmates (synthetic) ----------------------------------------------
('Nana Ama','Serwaa','Boateng',       DATE '2004-06-02','Female','nanaama.boateng@st.ug.edu.gh',     '+233 24 512 0102','GHA-721004552-1','Ashanti',      '22129014','BSC-CPEN',200,DATE '2022-08-08','resident','Volta Hall',   'WASSCE',3.48),
('Kwabena','Osei','Mensah',           DATE '2003-11-25','Male',  'kwabena.mensah@st.ug.edu.gh',      '+233 20 331 0203','GHA-721004553-9','Ashanti',      '22129027','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.05),
('Akosua','Dede','Quartey',           DATE '2004-01-09','Female','akosua.quartey@st.ug.edu.gh',      '+233 55 220 0304','GHA-721004554-7','Greater Accra','22129033','BSC-CPEN',200,DATE '2022-08-08','resident','Akuafo Hall',  'WASSCE',3.71),
('Yaw','Antwi','Boasiako',            DATE '2003-09-14','Male',  'yaw.boasiako@st.ug.edu.gh',        '+233 27 445 0405','GHA-721004555-5','Bono',         '22129048','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.87),
('Efua','Naa Adjeley','Lamptey',      DATE '2004-05-21','Female','efua.lamptey@st.ug.edu.gh',        '+233 24 667 0506','GHA-721004556-3','Greater Accra','22129055','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.33),
('Kofi','Agyeman','Duah',             DATE '2003-12-30','Male',  'kofi.duah@st.ug.edu.gh',           '+233 26 778 0607','GHA-721004557-1','Eastern',      '22129061','BSC-CPEN',200,DATE '2022-08-08','resident','Commonwealth Hall','WASSCE',3.12),
('Abena','Nyarko','Asante',           DATE '2004-08-11','Female','abena.asante@st.ug.edu.gh',        '+233 24 889 0708','GHA-721004558-9','Ashanti',      '22129077','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.55),
('Kwame','Nkrumah','Ofori',           DATE '2003-07-04','Male',  'kwame.ofori@st.ug.edu.gh',         '+233 20 990 0809','GHA-721004559-7','Central',      '22129082','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.94),
('Adwoa','Serwaa','Amponsah',         DATE '2004-02-18','Female','adwoa.amponsah@st.ug.edu.gh',      '+233 55 101 0910','GHA-721004560-5','Ashanti',      '22129096','BSC-CPEN',200,DATE '2022-08-08','resident','Volta Hall',   'WASSCE',3.80),
('Selorm','Kwabla','Dzradosi',        DATE '2003-10-08','Male',  'selorm.dzradosi@st.ug.edu.gh',     '+233 27 212 1011','GHA-721004561-3','Volta',        '22129103','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.21),
('Hawa','Abdul','Rahman',             DATE '2004-04-27','Female','hawa.rahman@st.ug.edu.gh',         '+233 24 323 1112','GHA-721004562-1','Northern',     '22129118','BSC-CPEN',200,DATE '2022-08-08','resident','Akuafo Hall',  'WASSCE',3.44),
('Emmanuel','Tetteh','Nortey',        DATE '2003-08-19','Male',  'emmanuel.nortey@st.ug.edu.gh',     '+233 26 434 1213','GHA-721004563-9','Greater Accra','22129124','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.76),
('Priscilla','Akweley','Sowah',       DATE '2004-07-06','Female','priscilla.sowah@st.ug.edu.gh',     '+233 20 545 1314','GHA-721004564-7','Greater Accra','22129139','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.67),
('Ibrahim','Yakubu','Mahama',         DATE '2003-05-15','Male',  'ibrahim.mahama@st.ug.edu.gh',      '+233 55 656 1415','GHA-721004565-5','Northern',     '22129145','BSC-CPEN',200,DATE '2022-08-08','resident','Legon Hall',   'WASSCE',3.09),
('Cynthia','Mensimah','Baidoo',       DATE '2004-09-23','Female','cynthia.baidoo@st.ug.edu.gh',      '+233 24 767 1516','GHA-721004566-3','Central',      '22129158','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.38),
('Daniel','Kojo','Ampofo',            DATE '2003-12-01','Male',  'daniel.ampofo@st.ug.edu.gh',       '+233 27 878 1617','GHA-721004567-1','Eastern',      '22129163','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.65),
('Elikem','Mawuli','Agbeko',          DATE '2004-03-29','Male',  'elikem.agbeko@st.ug.edu.gh',       '+233 26 989 1718','GHA-721004568-9','Volta',        '22129177','BSC-CPEN',200,DATE '2022-08-08','resident','Legon Hall',   'WASSCE',3.52),
('Rashida','Alhassan','Fuseini',      DATE '2003-11-12','Female','rashida.fuseini@st.ug.edu.gh',     '+233 20 190 1819','GHA-721004569-7','Upper East',   '22129184','BSC-CPEN',200,DATE '2022-08-08','resident','Volta Hall',   'WASSCE',3.26),
('Michael','Nii Armah','Tagoe',       DATE '2004-06-17','Male',  'michael.tagoe@st.ug.edu.gh',       '+233 55 201 1920','GHA-721004570-5','Greater Accra','22129199','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.98),
('Genevieve','Adjoa','Bonsu',         DATE '2004-01-31','Female','genevieve.bonsu@st.ug.edu.gh',     '+233 24 312 2021','GHA-721004571-3','Ashanti',      '22129205','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.74),
('Prince','Kwabena','Owusu',          DATE '2003-09-08','Male',  'prince.owusu@st.ug.edu.gh',        '+233 27 423 2122','GHA-721004572-1','Ashanti',      '22129211','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.16),
('Sandra','Esinam','Ahiable',         DATE '2004-05-05','Female','sandra.ahiable@st.ug.edu.gh',      '+233 26 534 2223','GHA-721004573-9','Volta',        '22129228','BSC-CPEN',200,DATE '2022-08-08','resident','Akuafo Hall',  'WASSCE',3.41),
('Joseph','Kwaku','Danso',            DATE '2003-07-22','Male',  'joseph.danso@st.ug.edu.gh',        '+233 20 645 2324','GHA-721004574-7','Eastern',      '22129234','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.83),
('Linda','Afriyie','Frimpong',        DATE '2004-10-14','Female','linda.frimpong@st.ug.edu.gh',      '+233 55 756 2425','GHA-721004575-5','Ashanti',      '22129247','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.59),
('Samuel','Nii Odartey','Lartey',     DATE '2003-04-03','Male',  'samuel.lartey@st.ug.edu.gh',       '+233 24 867 2526','GHA-721004576-3','Greater Accra','22129253','BSC-CPEN',200,DATE '2022-08-08','resident','Commonwealth Hall','WASSCE',3.07),
('Patience','Yaa','Konadu',           DATE '2004-08-28','Female','patience.konadu@st.ug.edu.gh',     '+233 27 978 2627','GHA-721004577-1','Bono',         '22129266','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.29),
('Bright','Kwasi','Adjei',            DATE '2003-12-16','Male',  'bright.adjei@st.ug.edu.gh',        '+233 26 089 2728','GHA-721004578-9','Western',      '22129272','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.71),
('Comfort','Abena','Pokuaa',          DATE '2004-02-09','Female','comfort.pokuaa@st.ug.edu.gh',      '+233 20 290 2829','GHA-721004579-7','Ashanti',      '22129285','BSC-CPEN',200,DATE '2022-08-08','resident','Volta Hall',   'WASSCE',3.63),
('Richmond','Kojo','Aidoo',           DATE '2003-06-26','Male',  'richmond.aidoo@st.ug.edu.gh',      '+233 55 301 2930','GHA-721004580-5','Central',      '22129291','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.18),
('Vera','Akorfa','Kudzo',             DATE '2004-11-19','Female','vera.kudzo@st.ug.edu.gh',          '+233 24 412 3031','GHA-721004581-3','Volta',        '22129308','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',3.46),
('Isaac','Kwadwo','Bediako',          DATE '2003-10-02','Male',  'isaac.bediako@st.ug.edu.gh',       '+233 27 523 3132','GHA-721004582-1','Eastern',      '22129314','BSC-CPEN',200,DATE '2022-08-08','non-resident',NULL,          'WASSCE',2.90),
-- ---- Level 400 students who serve as undergraduate teaching assistants ----
('Nathaniel','Kwesi','Otoo',          DATE '2002-03-11','Male',  'nathaniel.otoo@st.ug.edu.gh',      '+233 26 634 3233','GHA-721004583-9','Greater Accra','21045612','BSC-CPEN',400,DATE '2021-08-09','non-resident',NULL,          'WASSCE',3.78),
('Belinda','Nana Yaa','Addo',         DATE '2002-07-30','Female','belinda.addo@st.ug.edu.gh',        '+233 20 745 3334','GHA-721004584-7','Ashanti',      '21047733','BSC-CPEN',400,DATE '2021-08-09','resident','Akuafo Hall',  'WASSCE',3.85),
-- ---- MPhil students who serve as graduate teaching assistants -------------
('Felix','Kwame','Aggrey',            DATE '1999-05-18','Male',  'felix.aggrey@st.ug.edu.gh',        '+233 55 856 3435','GHA-721004585-5','Central',      '24500112','MPHIL-CPEN',600,DATE '2024-09-02','non-resident',NULL,        'BSc Computer Engineering',3.90),
('Doris','Ama','Owusuaa',             DATE '1998-12-07','Female','doris.owusuaa@st.ug.edu.gh',       '+233 24 967 3536','GHA-721004586-3','Ashanti',      '24500198','MPHIL-CPEN',600,DATE '2024-09-02','non-resident',NULL,        'BSc Computer Science',3.82)
),
ins_person AS (
    INSERT INTO people.person
        (first_name, middle_name, last_name, date_of_birth, gender, email, phone,
         national_id, home_region, nationality, postal_address, residential_address)
    SELECT r.first_name, r.middle_name, r.last_name, r.dob, r.gender::core.gender_type,
           r.email, r.phone, r.national_id, r.home_region, 'Ghanaian',
           'P. O. Box LG 77, Legon, Accra',
           'University of Ghana, Legon Campus, Accra'
    FROM   raw r
    RETURNING person_id, email
)
INSERT INTO people.student
    (person_id, student_number, programme_id, current_level, admission_date,
     expected_completion, status, residential_status, hall_of_residence,
     entry_qualification, cgpa)
SELECT ip.person_id,
       r.student_number,
       pg.programme_id,
       r.level,
       r.admission,
       r.admission + (pg.duration_years * 365),
       'active'::core.student_status_type,
       r.residency::core.residential_status_type,
       r.hall,
       r.entry,
       r.cgpa
FROM   ins_person ip
JOIN   raw r          ON r.email = ip.email
JOIN   core.programme pg ON pg.code = r.prog;

-- Emergency contacts for a representative subset of the class.
INSERT INTO people.next_of_kin (student_id, full_name, relationship, phone, email, occupation, address, is_primary)
SELECT s.student_id, v.name, v.rel, v.phone, v.email, v.occ,
       'P. O. Box 245, Accra', TRUE
FROM  (VALUES
        ('22128981','Mrs. Comfort Elorm Glago','Mother','+233 24 555 7001','comfort.glago@gmail.com','Teacher'),
        ('22129014','Mr. Kwaku Boateng',       'Father','+233 24 555 7002','k.boateng@gmail.com',    'Accountant'),
        ('22129027','Mrs. Grace Mensah',       'Mother','+233 24 555 7003','g.mensah@gmail.com',     'Trader'),
        ('22129033','Mr. Nii Armah Quartey',   'Father','+233 24 555 7004','n.quartey@gmail.com',    'Civil Servant'),
        ('22129048','Mrs. Yaa Boasiako',       'Mother','+233 24 555 7005','y.boasiako@gmail.com',   'Nurse'),
        ('22129055','Mr. Samuel Lamptey',      'Father','+233 24 555 7006','s.lamptey@gmail.com',    'Engineer'),
        ('22129061','Mrs. Akua Duah',          'Mother','+233 24 555 7007','a.duah@gmail.com',       'Seamstress'),
        ('22129077','Mr. Kofi Asante',         'Father','+233 24 555 7008','k.asante@gmail.com',     'Banker'),
        ('21045612','Mrs. Naa Otoo',           'Mother','+233 24 555 7009','n.otoo@gmail.com',       'Pharmacist'),
        ('24500112','Mrs. Mary Aggrey',        'Mother','+233 24 555 7010','m.aggrey@gmail.com',     'Retired')
      ) AS v(student_number, name, rel, phone, email, occ)
JOIN  people.student s ON s.student_number = v.student_number;

-- ---------------------------------------------------------------------------
-- LECTURERS
-- ---------------------------------------------------------------------------
WITH raw(title, first_name, middle_name, last_name, dob, gender, email, phone, national_id,
         staff_number, dept, rank, qual, spec, office, office_phone, employed) AS (
VALUES
('Dr.','Kwesi','Ampofo','Danquah',    DATE '1980-04-12','Male',  'kadanquah@ug.edu.gh','+233 24 601 0011','GHA-610004501-2','CPEN/2015/041','CPEN','Senior Lecturer',    'PhD Software Engineering','Software Engineering, Requirements Engineering','Engineering Block B, Room 34','+233 30 250 1241', DATE '2015-09-01'),
('Prof.','Naa Adukwei',NULL,'Tetteh', DATE '1972-09-30','Female','natetteh@ug.edu.gh', '+233 24 602 0012','GHA-610004502-0','CPEN/2008/012','CPEN','Professor',          'PhD Computer Architecture','Computer Architecture, VLSI Design','Engineering Block B, Room 12','+233 30 250 1212', DATE '2008-02-01'),
('Dr.','Yaw','Boadu','Antwi',         DATE '1984-01-22','Male',  'ybantwi@ug.edu.gh',  '+233 24 603 0013','GHA-610004503-8','CPEN/2017/067','CPEN','Lecturer',           'PhD Electronic Engineering','Digital Systems, Embedded Design','Engineering Block B, Room 27','+233 30 250 1227', DATE '2017-10-01'),
('Dr.','Esi','Mensimah','Koomson',    DATE '1986-06-05','Female','emkoomson@ug.edu.gh','+233 24 604 0014','GHA-610004504-6','CPEN/2019/083','CPEN','Lecturer',           'PhD Computer Science','Algorithms, Data Structures, Machine Learning','Engineering Block B, Room 31','+233 30 250 1231', DATE '2019-08-15'),
('Mr.','Justice','Nii Ayi','Bortey',  DATE '1990-11-17','Male',  'jnabortey@ug.edu.gh','+233 24 605 0015','GHA-610004505-4','CPEN/2021/104','CPEN','Assistant Lecturer', 'MPhil Electrical Engineering','Circuit Theory, Power Electronics','Engineering Block B, Room 19','+233 30 250 1219', DATE '2021-01-11'),
('Dr.','Mabel','Owusu','Ansah',       DATE '1981-02-28','Female','moansah@ug.edu.gh',  '+233 24 606 0016','GHA-610004506-2','MATH/2016/055','MATH','Senior Lecturer',    'PhD Applied Mathematics','Linear Algebra, Differential Equations','Mathematics Building, Room 15','+233 30 250 2315', DATE '2016-09-01'),
('Mrs.','Adjoa','Yeboah','Nkansah',   DATE '1983-08-09','Female','aynkansah@ug.edu.gh','+233 24 607 0017','GHA-610004507-0','UGRC/2018/029','UGRC','Lecturer',           'MPhil English','Academic Writing, Communication Skills','Central Admin Block, Room 8','+233 30 250 3408', DATE '2018-09-03')
),
ins_person AS (
    INSERT INTO people.person
        (title, first_name, middle_name, last_name, date_of_birth, gender, email, phone,
         national_id, nationality, postal_address, residential_address)
    SELECT r.title, r.first_name, r.middle_name, r.last_name, r.dob, r.gender::core.gender_type,
           r.email, r.phone, r.national_id, 'Ghanaian',
           'P. O. Box LG 25, Legon, Accra', 'Legon Staff Village, Accra'
    FROM   raw r
    RETURNING person_id, email
)
INSERT INTO people.lecturer
    (person_id, staff_number, department_id, academic_rank, highest_qualification,
     specialisation, office_location, office_phone, employment_date, status)
SELECT ip.person_id, r.staff_number, d.department_id,
       r.rank::core.lecturer_rank_type, r.qual, r.spec, r.office, r.office_phone,
       r.employed, 'active'::core.staff_status_type
FROM   ins_person ip
JOIN   raw r ON r.email = ip.email
JOIN   core.department d ON d.code = r.dept;

-- ---------------------------------------------------------------------------
-- TEACHING ASSISTANTS
-- Graduate / undergraduate TAs reuse the person record of their student row,
-- which is exactly why people.person exists as a supertype.
-- ---------------------------------------------------------------------------
INSERT INTO people.teaching_assistant
    (person_id, ta_code, student_id, department_id, ta_type, appointment_date,
     monthly_stipend, max_weekly_hours, status)
SELECT s.person_id, v.ta_code, s.student_id, d.department_id,
       v.ta_type::core.ta_type, v.appointed, v.stipend, v.max_hours, 'active'
FROM  (VALUES
        ('24500112','TA/2025/001','graduate',      DATE '2025-08-11', 1200.00, 20::SMALLINT),
        ('24500198','TA/2025/002','graduate',      DATE '2025-08-11', 1200.00, 20::SMALLINT),
        ('21045612','TA/2025/003','undergraduate', DATE '2025-08-18',  650.00, 12::SMALLINT),
        ('21047733','TA/2025/004','undergraduate', DATE '2025-08-18',  650.00, 12::SMALLINT)
      ) AS v(student_number, ta_code, ta_type, appointed, stipend, max_hours)
JOIN   people.student s   ON s.student_number = v.student_number
JOIN   core.department d  ON d.code = 'CPEN';

-- One external TA (national service personnel) - has no student record, which
-- is why teaching_assistant.student_id is nullable.
WITH ins_person AS (
    INSERT INTO people.person
        (first_name, middle_name, last_name, date_of_birth, gender, email, phone,
         national_id, nationality, postal_address)
    VALUES ('Wisdom','Selorm','Ahiakpor', DATE '2000-02-14','Male',
            'wisdom.ahiakpor@ug.edu.gh','+233 24 608 0018','GHA-610004508-8',
            'Ghanaian','P. O. Box LG 25, Legon, Accra')
    RETURNING person_id
)
INSERT INTO people.teaching_assistant
    (person_id, ta_code, student_id, department_id, ta_type, appointment_date,
     end_date, monthly_stipend, max_weekly_hours, status)
SELECT ip.person_id, 'TA/2025/005', NULL, d.department_id, 'external',
       DATE '2025-09-01', DATE '2026-08-31', 900.00, 20, 'active'
FROM   ins_person ip CROSS JOIN core.department d WHERE d.code = 'CPEN';

-- #############################################################################
-- 3. COURSES AND OFFERINGS  (FUNCTIONALITY 3 groundwork)
-- #############################################################################

INSERT INTO academics.course (course_code, title, description, credit_hours, level, department_id, is_core)
SELECT v.code, v.title, v.descr, v.credits, v.level, d.department_id, v.is_core
FROM  (VALUES
        ('CPEN 103','Introduction to Computer Engineering','Overview of the computer engineering discipline, number systems and basic logic.',           3,100,'CPEN',TRUE),
        ('CPEN 105','Programming for Engineers','Structured programming, problem solving and algorithm design in C and Python.',                        3,100,'CPEN',TRUE),
        ('CPEN 201','Circuit Theory','Network theorems, transient analysis, AC steady-state analysis and resonance.',                                   3,200,'CPEN',TRUE),
        ('CPEN 203','Digital Systems Design','Combinational and sequential logic, finite state machines and HDL-based design.',                         3,200,'CPEN',TRUE),
        ('CPEN 205','Data Structures and Algorithms','Lists, trees, graphs, hashing, sorting, searching and complexity analysis.',                      3,200,'CPEN',TRUE),
        ('CPEN 207','Computer Architecture','Instruction set architecture, pipelining, memory hierarchy and I/O organisation.',                         3,200,'CPEN',TRUE),
        ('CPEN 208','Introduction to Software Engineering','Software process models, requirements, design, databases, version control, testing and deployment.',3,200,'CPEN',TRUE),
        ('MATH 223','Linear Algebra and Differential Equations','Matrices, vector spaces, eigenvalues and ordinary differential equations.',            3,200,'MATH',TRUE),
        ('UGRC 210','Academic Writing II','Advanced academic writing, referencing, research reporting and presentation.',                               3,200,'UGRC',TRUE),
        ('CPEN 401','Advanced Embedded Systems','Real-time operating systems, device drivers and embedded networking.',                                 3,400,'CPEN',FALSE)
      ) AS v(code, title, descr, credits, level, dept, is_core)
JOIN   core.department d ON d.code = v.dept;

INSERT INTO academics.course_prerequisite (course_id, prerequisite_id)
SELECT c.course_id, p.course_id
FROM  (VALUES
        ('CPEN 203','CPEN 103'),
        ('CPEN 205','CPEN 105'),
        ('CPEN 207','CPEN 103'),
        ('CPEN 208','CPEN 105'),
        ('CPEN 401','CPEN 207')
      ) AS v(course, prereq)
JOIN   academics.course c ON c.course_code = v.course
JOIN   academics.course p ON p.course_code = v.prereq;

-- All offerings run in First Semester 2025/2026, the semester of this project.
INSERT INTO academics.course_offering
    (course_id, semester_id, section, capacity, venue, meeting_days, start_time, end_time, delivery_mode)
SELECT c.course_id, sem.semester_id, v.section, v.capacity, v.venue,
       v.days, v.start_t, v.end_t, v.mode::core.delivery_mode_type
FROM  (VALUES
        ('CPEN 201','A',60,'Engineering Lecture Theatre 1','Mon, Wed', TIME '08:30', TIME '10:00','in_person'),
        ('CPEN 203','A',60,'Engineering Lecture Theatre 2','Tue, Thu', TIME '10:30', TIME '12:00','in_person'),
        ('CPEN 205','A',60,'Computer Laboratory 3',        'Mon, Fri', TIME '13:30', TIME '15:00','in_person'),
        ('CPEN 207','A',60,'Engineering Lecture Theatre 1','Tue, Thu', TIME '08:30', TIME '10:00','in_person'),
        ('CPEN 208','A',60,'Computer Laboratory 1',        'Wed, Fri', TIME '10:30', TIME '12:00','hybrid'),
        ('MATH 223','A',80,'Mathematics Lecture Hall A',   'Mon, Wed', TIME '15:30', TIME '17:00','in_person'),
        ('UGRC 210','A',90,'JQB Lecture Hall 12',          'Thu',      TIME '17:30', TIME '20:00','in_person'),
        ('CPEN 401','A',40,'Embedded Systems Laboratory',  'Tue, Fri', TIME '13:30', TIME '15:00','in_person')
      ) AS v(course, section, capacity, venue, days, start_t, end_t, mode)
JOIN   academics.course c ON c.course_code = v.course
JOIN   core.semester sem  ON sem.is_current;

-- #############################################################################
-- 4. LECTURER TO COURSE ASSIGNMENT  (FUNCTIONALITY 4)
-- #############################################################################

INSERT INTO academics.lecturer_course_assignment
    (lecturer_id, offering_id, teaching_role, contact_hours_per_week, assigned_on, assigned_by, remarks)
SELECT l.lecturer_id, o.offering_id, v.role::core.teaching_role_type, v.hours,
       DATE '2025-08-06', 'Head of Department, Computer Engineering', v.remarks
FROM  (VALUES
        ('CPEN/2021/104','CPEN 201','lead_lecturer', 3::SMALLINT, 'Course coordinator'),
        ('CPEN/2017/067','CPEN 203','lead_lecturer', 3::SMALLINT, 'Course coordinator'),
        ('CPEN/2019/083','CPEN 205','lead_lecturer', 3::SMALLINT, 'Course coordinator'),
        ('CPEN/2008/012','CPEN 207','lead_lecturer', 3::SMALLINT, 'Course coordinator'),
        ('CPEN/2015/041','CPEN 208','lead_lecturer', 3::SMALLINT, 'Course coordinator and project supervisor'),
        ('CPEN/2019/083','CPEN 208','co_lecturer',   1::SMALLINT, 'Delivers the database design and SQL sessions'),
        ('MATH/2016/055','MATH 223','lead_lecturer', 3::SMALLINT, 'Service course taught for the Engineering School'),
        ('UGRC/2018/029','UGRC 210','lead_lecturer', 3::SMALLINT, 'University required course'),
        ('CPEN/2008/012','CPEN 401','lead_lecturer', 3::SMALLINT, 'Final year elective')
      ) AS v(staff_number, course, role, hours, remarks)
JOIN   people.lecturer l ON l.staff_number = v.staff_number
JOIN   academics.course c ON c.course_code = v.course
JOIN   academics.course_offering o ON o.course_id = c.course_id
JOIN   core.semester sem ON sem.semester_id = o.semester_id AND sem.is_current;

-- #############################################################################
-- 5. LECTURER TO TA ASSIGNMENT  (FUNCTIONALITY 5)
-- #############################################################################

INSERT INTO academics.lecturer_ta_assignment
    (lecturer_id, ta_id, offering_id, semester_id, responsibility, weekly_hours, assigned_on)
SELECT l.lecturer_id, t.ta_id, o.offering_id, sem.semester_id,
       v.responsibility, v.hours, DATE '2025-08-20'
FROM  (VALUES
        ('CPEN/2015/041','TA/2025/001','CPEN 208','Laboratory supervision, Git/GitHub tutorials and grading of project submissions', 8::SMALLINT),
        ('CPEN/2015/041','TA/2025/002','CPEN 208','Marking of continuous assessment and PostgreSQL laboratory support',              6::SMALLINT),
        ('CPEN/2019/083','TA/2025/003','CPEN 205','Weekly algorithms tutorial and code review of assignments',                       6::SMALLINT),
        ('CPEN/2017/067','TA/2025/004','CPEN 203','Digital logic laboratory supervision and Verilog demonstrations',                 6::SMALLINT),
        ('CPEN/2008/012','TA/2025/005','CPEN 207','Assembly language laboratory support and attendance records',                    10::SMALLINT),
        ('CPEN/2008/012','TA/2025/001','CPEN 401','Embedded systems laboratory support',                                             6::SMALLINT)
      ) AS v(staff_number, ta_code, course, responsibility, hours)
JOIN   people.lecturer l ON l.staff_number = v.staff_number
JOIN   people.teaching_assistant t ON t.ta_code = v.ta_code
JOIN   academics.course c ON c.course_code = v.course
JOIN   academics.course_offering o ON o.course_id = c.course_id
JOIN   core.semester sem ON sem.semester_id = o.semester_id AND sem.is_current;

-- #############################################################################
-- 6. COURSE ENROLMENT  (FUNCTIONALITY 3)
-- #############################################################################

-- Every active Level 200 student registers for all seven Level 200 courses.
INSERT INTO academics.enrollment (student_id, offering_id, enrolled_on, status)
SELECT s.student_id, o.offering_id, DATE '2025-08-25', 'enrolled'
FROM   people.student s
JOIN   academics.course_offering o ON TRUE
JOIN   academics.course c   ON c.course_id = o.course_id
JOIN   core.semester sem    ON sem.semester_id = o.semester_id AND sem.is_current
WHERE  s.current_level = 200
  AND  s.status = 'active'
  AND  c.level  = 200;

-- The two Level 400 students register for the final-year elective.
INSERT INTO academics.enrollment (student_id, offering_id, enrolled_on, status)
SELECT s.student_id, o.offering_id, DATE '2025-08-26', 'enrolled'
FROM   people.student s
JOIN   academics.course c ON c.course_code = 'CPEN 401'
JOIN   academics.course_offering o ON o.course_id = c.course_id
JOIN   core.semester sem ON sem.semester_id = o.semester_id AND sem.is_current
WHERE  s.current_level = 400 AND s.status = 'active';

-- A few realistic exceptions so the data is not uniformly perfect:
--   * two students dropped MATH 223 after the add/drop window,
--   * one student is repeating CPEN 201.
UPDATE academics.enrollment e
SET    status = 'dropped', dropped_on = DATE '2025-09-12'
FROM   people.student s, academics.course_offering o, academics.course c
WHERE  e.student_id  = s.student_id
  AND  e.offering_id = o.offering_id
  AND  o.course_id   = c.course_id
  AND  c.course_code = 'MATH 223'
  AND  s.student_number IN ('22129163','22129272');

UPDATE academics.enrollment e
SET    is_retake = TRUE
FROM   people.student s, academics.course_offering o, academics.course c
WHERE  e.student_id  = s.student_id
  AND  e.offering_id = o.offering_id
  AND  o.course_id   = c.course_id
  AND  c.course_code = 'CPEN 201'
  AND  s.student_number = '22129124';

-- Continuous assessment already recorded for CPEN 208 (the marks are the
-- deterministic result of the student's index, purely so the column is not
-- empty in the sample).
UPDATE academics.enrollment e
SET    continuous_assessment = 18 + (e.student_id * 7) % 13
FROM   academics.course_offering o, academics.course c
WHERE  e.offering_id = o.offering_id
  AND  o.course_id   = c.course_id
  AND  c.course_code = 'CPEN 208'
  AND  e.status      = 'enrolled';

-- #############################################################################
-- 7. FEES  (FUNCTIONALITY 2)
-- #############################################################################

INSERT INTO finance.fee_structure (programme_id, academic_year_id, level, residential_status, currency)
SELECT pg.programme_id, ay.academic_year_id, v.level, v.residency::core.residential_status_type, 'GHS'
FROM  (VALUES
        ('BSC-CPEN',  200,'non-resident'),
        ('BSC-CPEN',  200,'resident'),
        ('BSC-CPEN',  400,'non-resident'),
        ('BSC-CPEN',  400,'resident'),
        ('MPHIL-CPEN',600,'non-resident')
      ) AS v(prog, level, residency)
JOIN   core.programme pg ON pg.code = v.prog
JOIN   core.academic_year ay ON ay.is_current;

-- Fee items. Amounts are illustrative but of a realistic order of magnitude
-- for a publicly funded Ghanaian university, expressed in Ghana Cedis.
INSERT INTO finance.fee_item (fee_structure_id, item_name, category, amount, is_mandatory, description)
SELECT fs.fee_structure_id, v.item, v.cat::core.fee_category_type, v.amount, TRUE, v.descr
FROM  (VALUES
        ('BSC-CPEN',  200,'non-resident','Academic Facility User Fee','academic_facility',2050.00,'Laboratories, library, ICT and utilities'),
        ('BSC-CPEN',  200,'non-resident','Tuition (Subsidised)',      'tuition',          1890.00,'Government subsidised tuition for Ghanaian students'),
        ('BSC-CPEN',  200,'non-resident','Examination Fee',           'examination',       320.00,'End of semester examinations'),
        ('BSC-CPEN',  200,'non-resident','SRC Dues',                  'src_dues',          150.00,'Students Representative Council'),
        ('BSC-CPEN',  200,'non-resident','Student Insurance',         'other',              60.00,'Group personal accident cover'),

        ('BSC-CPEN',  200,'resident',    'Academic Facility User Fee','academic_facility',2050.00,'Laboratories, library, ICT and utilities'),
        ('BSC-CPEN',  200,'resident',    'Tuition (Subsidised)',      'tuition',          1890.00,'Government subsidised tuition for Ghanaian students'),
        ('BSC-CPEN',  200,'resident',    'Examination Fee',           'examination',       320.00,'End of semester examinations'),
        ('BSC-CPEN',  200,'resident',    'SRC Dues',                  'src_dues',          150.00,'Students Representative Council'),
        ('BSC-CPEN',  200,'resident',    'Student Insurance',         'other',              60.00,'Group personal accident cover'),
        ('BSC-CPEN',  200,'resident',    'Residential Facility Fee',  'residential',      1800.00,'Hall of residence accommodation for the academic year'),

        ('BSC-CPEN',  400,'non-resident','Academic Facility User Fee','academic_facility',2250.00,'Laboratories, library, ICT and utilities'),
        ('BSC-CPEN',  400,'non-resident','Tuition (Subsidised)',      'tuition',          2050.00,'Government subsidised tuition for Ghanaian students'),
        ('BSC-CPEN',  400,'non-resident','Examination Fee',           'examination',       350.00,'End of semester examinations'),
        ('BSC-CPEN',  400,'non-resident','SRC Dues',                  'src_dues',          150.00,'Students Representative Council'),
        ('BSC-CPEN',  400,'non-resident','Project Supervision Fee',   'other',             280.00,'Final year project supervision and binding'),

        ('BSC-CPEN',  400,'resident',    'Academic Facility User Fee','academic_facility',2250.00,'Laboratories, library, ICT and utilities'),
        ('BSC-CPEN',  400,'resident',    'Tuition (Subsidised)',      'tuition',          2050.00,'Government subsidised tuition for Ghanaian students'),
        ('BSC-CPEN',  400,'resident',    'Examination Fee',           'examination',       350.00,'End of semester examinations'),
        ('BSC-CPEN',  400,'resident',    'SRC Dues',                  'src_dues',          150.00,'Students Representative Council'),
        ('BSC-CPEN',  400,'resident',    'Project Supervision Fee',   'other',             280.00,'Final year project supervision and binding'),
        ('BSC-CPEN',  400,'resident',    'Residential Facility Fee',  'residential',      1800.00,'Hall of residence accommodation for the academic year'),

        ('MPHIL-CPEN',600,'non-resident','Tuition (Graduate)',        'tuition',          6500.00,'MPhil tuition for the academic year'),
        ('MPHIL-CPEN',600,'non-resident','Academic Facility User Fee','academic_facility',1200.00,'Research laboratories, library and ICT'),
        ('MPHIL-CPEN',600,'non-resident','Examination and Thesis Fee','examination',       400.00,'Examinations, thesis examination and binding'),
        ('MPHIL-CPEN',600,'non-resident','GRASAG Dues',               'src_dues',          120.00,'Graduate Students Association of Ghana')
      ) AS v(prog, level, residency, item, cat, amount, descr)
JOIN   core.programme pg ON pg.code = v.prog
JOIN   finance.fee_structure fs
       ON fs.programme_id = pg.programme_id
      AND fs.level = v.level
      AND fs.residential_status = v.residency::core.residential_status_type;

-- Generate a bill for every active student using the stored function. This
-- doubles as a live test that finance.fn_generate_student_bill works.
DO $$
DECLARE
    r RECORD;
    v_year INTEGER;
BEGIN
    SELECT academic_year_id INTO v_year FROM core.academic_year WHERE is_current;

    FOR r IN SELECT student_id FROM people.student WHERE status = 'active' ORDER BY student_id
    LOOP
        PERFORM finance.fn_generate_student_bill(r.student_id, v_year, DATE '2025-10-31');
    END LOOP;
END;
$$;

-- ---------------------------------------------------------------------------
-- PAYMENTS
-- A deliberate spread so that the outstanding-fees function has every case to
-- report: fully paid, part paid in instalments, nothing paid, plus a pending
-- and a reversed payment that must NOT reduce the balance.
-- ---------------------------------------------------------------------------
INSERT INTO finance.payment
    (receipt_number, student_id, bill_id, amount, payment_date, payment_method,
     bank_or_channel, transaction_ref, status, received_by, remarks)
SELECT 'RCPT-2025-' || LPAD((ROW_NUMBER() OVER (ORDER BY b.student_id, i.n))::TEXT, 6, '0'),
       b.student_id,
       b.bill_id,
       ROUND(b.total_amount * i.fraction, 2),
       i.pay_date,
       i.method::core.payment_method_type,
       i.channel,
       'TXN' || LPAD(b.student_id::TEXT, 4, '0') || LPAD(i.n::TEXT, 2, '0'),
       'confirmed'::core.payment_status_type,
       'Finance Office, University of Ghana',
       i.remarks
FROM   finance.student_bill b
JOIN   LATERAL (
        -- The instalment plan is chosen from the student id so the sample is
        -- deterministic: re-running the script always produces the same data.
        SELECT * FROM (VALUES
            -- pattern 0 : paid in full, one transfer
            (0, 1, 1.00,   DATE '2025-09-15','bank_transfer','GCB Bank - Legon Branch','Full payment at registration'),
            -- pattern 1 : 60% in two instalments
            (1, 1, 0.35,   DATE '2025-09-10','mobile_money', 'MTN Mobile Money',       'First instalment'),
            (1, 2, 0.25,   DATE '2025-11-04','mobile_money', 'MTN Mobile Money',       'Second instalment'),
            -- pattern 2 : 35% only
            (2, 1, 0.35,   DATE '2025-09-18','bank_transfer','Absa Bank - Legon',      'Part payment'),
            -- pattern 3 : nothing paid (no rows)
            -- pattern 4 : paid in full over three instalments
            (4, 1, 0.40,   DATE '2025-09-08','mobile_money', 'Telecel Cash',           'First instalment'),
            (4, 2, 0.35,   DATE '2025-10-20','bank_transfer','Ecobank - Legon',        'Second instalment'),
            (4, 3, 0.25,   DATE '2025-12-01','bank_transfer','Ecobank - Legon',        'Final instalment')
        ) AS p(pattern, n, fraction, pay_date, method, channel, remarks)
        WHERE p.pattern = b.student_id % 5
) i ON TRUE
WHERE  b.status <> 'cancelled'
  -- The author's own record is given an explicit instalment plan further
  -- down, so it must be excluded here or it would be paid twice over.
  AND  b.student_id <> (SELECT student_id FROM people.student
                        WHERE student_number = '22128981');

-- One payment still awaiting bank confirmation. It must NOT reduce the
-- outstanding balance - this is the case the function is designed to exclude.
INSERT INTO finance.payment
    (receipt_number, student_id, bill_id, amount, payment_date, payment_method,
     bank_or_channel, transaction_ref, status, received_by, remarks)
SELECT 'RCPT-2025-900001', b.student_id, b.bill_id, 1500.00, DATE '2025-12-15',
       'cheque', 'Stanbic Bank', 'CHQ0099123', 'pending',
       'Finance Office, University of Ghana',
       'Cheque lodged, awaiting clearance - excluded from outstanding balance'
FROM   finance.student_bill b
JOIN   people.student s ON s.student_id = b.student_id
WHERE  s.student_number = '22129027';

-- One reversed payment (the mobile money transfer bounced).
INSERT INTO finance.payment
    (receipt_number, student_id, bill_id, amount, payment_date, payment_method,
     bank_or_channel, transaction_ref, status, received_by, remarks)
SELECT 'RCPT-2025-900002', b.student_id, b.bill_id, 800.00, DATE '2025-10-05',
       'mobile_money', 'MTN Mobile Money', 'TXNREV0001', 'reversed',
       'Finance Office, University of Ghana',
       'Transaction reversed by the payment provider - excluded from outstanding balance'
FROM   finance.student_bill b
JOIN   people.student s ON s.student_id = b.student_id
WHERE  s.student_number = '22129048';

-- A scholarship award that settles a student's balance completely.
INSERT INTO finance.payment
    (receipt_number, student_id, bill_id, amount, payment_date, payment_method,
     bank_or_channel, transaction_ref, status, received_by, remarks)
SELECT 'RCPT-2025-900003', b.student_id, b.bill_id,
       b.total_amount - COALESCE((SELECT SUM(p.amount) FROM finance.payment p
                                  WHERE p.bill_id = b.bill_id AND p.status = 'confirmed'), 0),
       DATE '2025-09-25', 'scholarship', 'GETFund Scholarship Secretariat', 'GETF/2025/0417',
       'confirmed', 'Scholarships Office', 'GETFund merit scholarship - balance settled in full'
FROM   finance.student_bill b
JOIN   people.student s ON s.student_id = b.student_id
WHERE  s.student_number = '22129096'
  AND  b.total_amount - COALESCE((SELECT SUM(p.amount) FROM finance.payment p
                                  WHERE p.bill_id = b.bill_id AND p.status = 'confirmed'), 0) > 0;

-- Two instalments for the author's own record (22128981) so that the primary
-- demonstration account shows a realistic part-paid statement in the web app.
INSERT INTO finance.payment
    (receipt_number, student_id, bill_id, amount, payment_date, payment_method,
     bank_or_channel, transaction_ref, status, received_by, remarks)
SELECT v.receipt, b.student_id, b.bill_id, v.amount, v.pay_date,
       v.method::core.payment_method_type, v.channel, v.txn,
       'confirmed'::core.payment_status_type,
       'Finance Office, University of Ghana', v.remarks
FROM   finance.student_bill b
JOIN   people.student s ON s.student_id = b.student_id
CROSS  JOIN (VALUES
        ('RCPT-2025-900004', 2000.00, DATE '2025-09-12','bank_transfer','GCB Bank - Legon Branch','TXNGEG0001','First instalment paid at registration'),
        ('RCPT-2025-900005', 1200.00, DATE '2025-11-18','mobile_money', 'MTN Mobile Money',       'TXNGEG0002','Second instalment')
       ) AS v(receipt, amount, pay_date, method, channel, txn, remarks)
WHERE  s.student_number = '22128981';

-- Bills whose due date has passed with a balance are flagged overdue by the
-- payment trigger; refresh the ones that never received a payment at all.
UPDATE finance.student_bill b
SET    status = 'overdue'
WHERE  b.due_date < CURRENT_DATE
  AND  b.status = 'issued'
  AND  NOT EXISTS (SELECT 1 FROM finance.payment p
                   WHERE p.bill_id = b.bill_id AND p.status = 'confirmed');

-- #############################################################################
-- 8. APPLICATION USERS  (for the Next.js 14 app and the REST API)
-- #############################################################################
-- Passwords are hashed with bcrypt using pgcrypto's crypt()/gen_salt('bf'),
-- which produces the same $2a$ format that bcryptjs verifies in Node.
-- Demo password for EVERY seeded account: Password123!
-- #############################################################################

-- Administrator (not linked to a person record).
INSERT INTO app.app_user (username, email, password_hash, role, person_id, is_active, email_verified)
VALUES ('admin', 'admin@cpen.ug.edu.gh',
        crypt('Password123!', gen_salt('bf', 10)), 'admin', NULL, TRUE, TRUE);

-- Student accounts: username = student number.
INSERT INTO app.app_user (username, email, password_hash, role, person_id, is_active, email_verified)
SELECT s.student_number, pr.email,
       crypt('Password123!', gen_salt('bf', 10)), 'student', pr.person_id, TRUE, TRUE
FROM   people.student s
JOIN   people.person pr ON pr.person_id = s.person_id
WHERE  s.student_number IN ('22128981','22129014','22129027','22129033','22129048',
                            '22129096','22129163','21045612','24500112');

-- Lecturer accounts: username = the part of the e-mail before the @.
INSERT INTO app.app_user (username, email, password_hash, role, person_id, is_active, email_verified)
SELECT SPLIT_PART(pr.email, '@', 1), pr.email,
       crypt('Password123!', gen_salt('bf', 10)), 'lecturer', pr.person_id, TRUE, TRUE
FROM   people.lecturer l
JOIN   people.person pr ON pr.person_id = l.person_id;

-- The external teaching assistant needs a login too. The graduate/undergraduate
-- TAs already have one through their student account.
INSERT INTO app.app_user (username, email, password_hash, role, person_id, is_active, email_verified)
SELECT SPLIT_PART(pr.email, '@', 1), pr.email,
       crypt('Password123!', gen_salt('bf', 10)), 'teaching_assistant', pr.person_id, TRUE, TRUE
FROM   people.teaching_assistant t
JOIN   people.person pr ON pr.person_id = t.person_id
WHERE  t.ta_type = 'external';

INSERT INTO app.audit_log (user_id, action, entity, entity_id, details)
SELECT u.user_id, 'SEED', 'app_user', u.user_id::TEXT,
       json_build_object('source','06_seed_data.sql','role',u.role)::jsonb
FROM   app.app_user u;

COMMIT;

-- =============================================================================
-- Row counts after seeding - a quick sanity check for the marker.
-- =============================================================================
SELECT 'core.department'                     AS table_name, COUNT(*) FROM core.department
UNION ALL SELECT 'core.programme',                 COUNT(*) FROM core.programme
UNION ALL SELECT 'core.academic_year',             COUNT(*) FROM core.academic_year
UNION ALL SELECT 'core.semester',                  COUNT(*) FROM core.semester
UNION ALL SELECT 'people.person',                  COUNT(*) FROM people.person
UNION ALL SELECT 'people.student',                 COUNT(*) FROM people.student
UNION ALL SELECT 'people.next_of_kin',             COUNT(*) FROM people.next_of_kin
UNION ALL SELECT 'people.lecturer',                COUNT(*) FROM people.lecturer
UNION ALL SELECT 'people.teaching_assistant',      COUNT(*) FROM people.teaching_assistant
UNION ALL SELECT 'academics.course',               COUNT(*) FROM academics.course
UNION ALL SELECT 'academics.course_prerequisite',  COUNT(*) FROM academics.course_prerequisite
UNION ALL SELECT 'academics.course_offering',      COUNT(*) FROM academics.course_offering
UNION ALL SELECT 'academics.enrollment',           COUNT(*) FROM academics.enrollment
UNION ALL SELECT 'academics.lecturer_course_assignment', COUNT(*) FROM academics.lecturer_course_assignment
UNION ALL SELECT 'academics.lecturer_ta_assignment',     COUNT(*) FROM academics.lecturer_ta_assignment
UNION ALL SELECT 'finance.fee_structure',          COUNT(*) FROM finance.fee_structure
UNION ALL SELECT 'finance.fee_item',               COUNT(*) FROM finance.fee_item
UNION ALL SELECT 'finance.student_bill',           COUNT(*) FROM finance.student_bill
UNION ALL SELECT 'finance.bill_line',              COUNT(*) FROM finance.bill_line
UNION ALL SELECT 'finance.payment',                COUNT(*) FROM finance.payment
UNION ALL SELECT 'app.app_user',                   COUNT(*) FROM app.app_user
ORDER BY 1;
