-- =============================================================================
-- File    : 02_tables.sql
-- Purpose : Create every table required by the five functionalities in the brief
--           together with primary keys, foreign keys and CHECK constraints.
-- Usage   : psql -d cpen208_ceds -f 02_tables.sql
-- -----------------------------------------------------------------------------
-- FUNCTIONALITY  ->  TABLES
--   1. Student Personal information .. people.person, people.student,
--                                       people.next_of_kin
--   2. Student Fees Payments ......... finance.fee_structure, finance.fee_item,
--                                       finance.student_bill, finance.bill_line,
--                                       finance.payment
--   3. Course Enrollment ............. academics.course, academics.course_offering,
--                                       academics.enrollment
--   4. Lecturers to Course Assignment  academics.lecturer_course_assignment
--   5. Lecturers to TA assignment .... academics.lecturer_ta_assignment
--   +  Web application (Q2) ......... app.app_user, app.user_session, app.audit_log
-- =============================================================================

SET search_path = core, people, academics, finance, app, public;

-- #############################################################################
-- SECTION A : core  - reference data & academic calendar
-- #############################################################################

CREATE TABLE core.department (
    department_id   INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code            VARCHAR(10)  NOT NULL UNIQUE,
    name            VARCHAR(120) NOT NULL UNIQUE,
    college         VARCHAR(120) NOT NULL DEFAULT 'College of Basic and Applied Sciences',
    school          VARCHAR(120) NOT NULL DEFAULT 'School of Engineering Sciences',
    email           core.email_address,
    phone           core.phone_number,
    office_location VARCHAR(120),
    established_on  DATE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE core.department IS 'Academic departments. The Computer Engineering Department is the subject of this system.';

CREATE TABLE core.programme (
    programme_id    INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    department_id   INTEGER   NOT NULL REFERENCES core.department(department_id)
                              ON UPDATE CASCADE ON DELETE RESTRICT,
    code            VARCHAR(15)  NOT NULL UNIQUE,
    name            VARCHAR(150) NOT NULL,
    degree_award    VARCHAR(60)  NOT NULL,              -- e.g. BSc, MPhil
    duration_years  SMALLINT     NOT NULL DEFAULT 4,
    total_credits   SMALLINT     NOT NULL DEFAULT 132,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT programme_duration_ck    CHECK (duration_years BETWEEN 1 AND 8),
    CONSTRAINT programme_credits_ck     CHECK (total_credits > 0)
);
COMMENT ON TABLE core.programme IS 'Degree programmes run by a department, e.g. BSc Computer Engineering.';

CREATE TABLE core.academic_year (
    academic_year_id INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             VARCHAR(12) NOT NULL UNIQUE,       -- '2025/2026'
    start_date       DATE     NOT NULL,
    end_date         DATE     NOT NULL,
    is_current       BOOLEAN  NOT NULL DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT academic_year_range_ck CHECK (end_date > start_date)
);
-- Only one academic year may be flagged current at a time.
CREATE UNIQUE INDEX academic_year_one_current_uq
    ON core.academic_year (is_current) WHERE is_current;
COMMENT ON TABLE core.academic_year IS 'Academic sessions, e.g. 2025/2026.';

CREATE TABLE core.semester (
    semester_id      INTEGER  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    academic_year_id INTEGER  NOT NULL REFERENCES core.academic_year(academic_year_id)
                              ON UPDATE CASCADE ON DELETE CASCADE,
    name             VARCHAR(30) NOT NULL,              -- 'First Semester'
    sequence_no      SMALLINT NOT NULL,                 -- 1, 2, 3(summer)
    start_date       DATE     NOT NULL,
    end_date         DATE     NOT NULL,
    registration_deadline DATE,
    is_current       BOOLEAN  NOT NULL DEFAULT FALSE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT semester_range_ck    CHECK (end_date > start_date),
    CONSTRAINT semester_sequence_ck CHECK (sequence_no BETWEEN 1 AND 3),
    CONSTRAINT semester_uq          UNIQUE (academic_year_id, sequence_no)
);
CREATE UNIQUE INDEX semester_one_current_uq
    ON core.semester (is_current) WHERE is_current;
COMMENT ON TABLE core.semester IS 'Semesters within an academic year. CPEN 208 runs in First Semester 2025/2026.';

-- #############################################################################
-- SECTION B : people  - FUNCTIONALITY 1, Student Personal information
-- #############################################################################
-- DESIGN NOTE (supertype / subtype)
--   `person` holds the attributes every human in the system shares. `student`,
--   `lecturer` and `teaching_assistant` are role tables that each hold a 1:1
--   link to a person plus the attributes unique to that role. This matters
--   because a teaching assistant is very often ALSO a student - modelling them
--   as one person with two roles avoids duplicating personal data and keeps a
--   single source of truth for name / e-mail / phone.
-- #############################################################################

CREATE TABLE people.person (
    person_id       INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title           VARCHAR(20),                        -- Mr, Ms, Dr, Prof
    first_name      VARCHAR(60)  NOT NULL,
    middle_name     VARCHAR(60),
    last_name       VARCHAR(60)  NOT NULL,
    date_of_birth   DATE         NOT NULL,
    gender          core.gender_type NOT NULL,
    marital_status  core.marital_status_type NOT NULL DEFAULT 'Single',
    national_id     VARCHAR(30)  UNIQUE,                -- Ghana Card number
    email           core.email_address NOT NULL UNIQUE,
    phone           core.phone_number  NOT NULL,
    alt_phone       core.phone_number,
    nationality     VARCHAR(60)  NOT NULL DEFAULT 'Ghanaian',
    home_region     VARCHAR(60),
    postal_address  VARCHAR(150),
    residential_address VARCHAR(200),
    photo_url       VARCHAR(255),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT person_dob_ck   CHECK (date_of_birth < CURRENT_DATE),
    CONSTRAINT person_age_ck   CHECK (date_of_birth > DATE '1930-01-01')
);
COMMENT ON TABLE people.person IS
    'Supertype holding personal information common to students, lecturers and TAs.';

CREATE TABLE people.student (
    student_id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id           INTEGER NOT NULL UNIQUE
                        REFERENCES people.person(person_id)
                        ON UPDATE CASCADE ON DELETE CASCADE,
    student_number      VARCHAR(15) NOT NULL UNIQUE,    -- UG index number
    programme_id        INTEGER NOT NULL REFERENCES core.programme(programme_id)
                        ON UPDATE CASCADE ON DELETE RESTRICT,
    current_level       SMALLINT NOT NULL DEFAULT 100,  -- 100..400
    admission_date      DATE     NOT NULL,
    expected_completion DATE,
    status              core.student_status_type NOT NULL DEFAULT 'active',
    residential_status  core.residential_status_type NOT NULL DEFAULT 'non-resident',
    hall_of_residence   VARCHAR(80),
    entry_qualification VARCHAR(80),                    -- WASSCE, Diploma ...
    cgpa                NUMERIC(3,2),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT student_level_ck  CHECK (current_level IN (100,200,300,400,500,600)),
    CONSTRAINT student_cgpa_ck   CHECK (cgpa IS NULL OR cgpa BETWEEN 0 AND 4.00),
    CONSTRAINT student_completion_ck
        CHECK (expected_completion IS NULL OR expected_completion > admission_date),
    -- A resident student must be assigned to a hall; a commuter must not be.
    CONSTRAINT student_hall_ck CHECK (
        (residential_status = 'resident'     AND hall_of_residence IS NOT NULL) OR
        (residential_status = 'non-resident' AND hall_of_residence IS NULL)
    )
);
COMMENT ON TABLE people.student IS 'FUNCTIONALITY 1 - the student role of a person, with academic standing.';

CREATE TABLE people.next_of_kin (
    next_of_kin_id  INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id      INTEGER NOT NULL REFERENCES people.student(student_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    full_name       VARCHAR(150) NOT NULL,
    relationship    VARCHAR(40)  NOT NULL,              -- Father, Mother, Guardian
    phone           core.phone_number NOT NULL,
    email           core.email_address,
    occupation      VARCHAR(80),
    address         VARCHAR(200),
    is_primary      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
-- Each student may have at most one PRIMARY emergency contact.
CREATE UNIQUE INDEX next_of_kin_one_primary_uq
    ON people.next_of_kin (student_id) WHERE is_primary;
COMMENT ON TABLE people.next_of_kin IS 'Emergency / guardian contacts - part of student personal information.';

CREATE TABLE people.lecturer (
    lecturer_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id       INTEGER NOT NULL UNIQUE
                    REFERENCES people.person(person_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    staff_number    VARCHAR(15) NOT NULL UNIQUE,
    department_id   INTEGER NOT NULL REFERENCES core.department(department_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    academic_rank   core.lecturer_rank_type NOT NULL DEFAULT 'Lecturer',
    highest_qualification VARCHAR(60),                  -- PhD, MPhil ...
    specialisation  VARCHAR(120),
    office_location VARCHAR(80),
    office_phone    core.phone_number,
    employment_date DATE NOT NULL,
    status          core.staff_status_type NOT NULL DEFAULT 'active',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE people.lecturer IS 'Teaching staff. Referenced by functionalities 4 and 5.';

CREATE TABLE people.teaching_assistant (
    ta_id           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    person_id       INTEGER NOT NULL UNIQUE
                    REFERENCES people.person(person_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    ta_code         VARCHAR(15) NOT NULL UNIQUE,
    -- A TA who is also a registered student is linked back to that record.
    student_id      INTEGER UNIQUE REFERENCES people.student(student_id)
                    ON UPDATE CASCADE ON DELETE SET NULL,
    department_id   INTEGER NOT NULL REFERENCES core.department(department_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    ta_type         core.ta_type NOT NULL DEFAULT 'graduate',
    appointment_date DATE NOT NULL,
    end_date        DATE,
    monthly_stipend core.money_amount NOT NULL DEFAULT 0,
    max_weekly_hours SMALLINT NOT NULL DEFAULT 20,
    status          core.staff_status_type NOT NULL DEFAULT 'active',
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ta_period_ck CHECK (end_date IS NULL OR end_date > appointment_date),
    CONSTRAINT ta_hours_ck  CHECK (max_weekly_hours BETWEEN 1 AND 40),
    -- A graduate/undergraduate TA must be tied to a student record;
    -- an external TA must not be.
    CONSTRAINT ta_student_link_ck CHECK (
        (ta_type IN ('graduate','undergraduate') AND student_id IS NOT NULL) OR
        (ta_type = 'external' AND student_id IS NULL)
    )
);
COMMENT ON TABLE people.teaching_assistant IS 'FUNCTIONALITY 5 - the TA pool that lecturers draw from.';

-- #############################################################################
-- SECTION C : academics - FUNCTIONALITIES 3, 4 and 5
-- #############################################################################

CREATE TABLE academics.course (
    course_id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_code     VARCHAR(12) NOT NULL UNIQUE,        -- 'CPEN 208'
    title           VARCHAR(150) NOT NULL,
    description     TEXT,
    credit_hours    SMALLINT NOT NULL,
    level           SMALLINT NOT NULL,
    department_id   INTEGER NOT NULL REFERENCES core.department(department_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    is_core         BOOLEAN NOT NULL DEFAULT TRUE,      -- core vs elective
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT course_credit_ck CHECK (credit_hours BETWEEN 1 AND 6),
    CONSTRAINT course_level_ck  CHECK (level IN (100,200,300,400,500,600))
);
COMMENT ON TABLE academics.course IS 'The course catalogue - a course exists independently of any semester.';

-- Self-referencing many-to-many: a course may require other courses first.
CREATE TABLE academics.course_prerequisite (
    course_id       INTEGER NOT NULL REFERENCES academics.course(course_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    prerequisite_id INTEGER NOT NULL REFERENCES academics.course(course_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    PRIMARY KEY (course_id, prerequisite_id),
    CONSTRAINT prerequisite_not_self_ck CHECK (course_id <> prerequisite_id)
);
COMMENT ON TABLE academics.course_prerequisite IS 'Courses that must be passed before enrolling in another course.';

-- A course_offering is one running of a course in one semester. Enrolment and
-- teaching assignment both hang off the OFFERING, not the course, because the
-- lecturer and the class list change every semester.
CREATE TABLE academics.course_offering (
    offering_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    course_id       INTEGER NOT NULL REFERENCES academics.course(course_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    semester_id     INTEGER NOT NULL REFERENCES core.semester(semester_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    section         VARCHAR(5) NOT NULL DEFAULT 'A',
    capacity        SMALLINT NOT NULL DEFAULT 60,
    venue           VARCHAR(80),
    meeting_days    VARCHAR(40),                        -- 'Mon, Wed'
    start_time      TIME,
    end_time        TIME,
    delivery_mode   core.delivery_mode_type NOT NULL DEFAULT 'in_person',
    is_open_for_registration BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT course_offering_uq       UNIQUE (course_id, semester_id, section),
    CONSTRAINT course_offering_cap_ck   CHECK (capacity > 0),
    CONSTRAINT course_offering_time_ck  CHECK (end_time IS NULL OR start_time IS NULL OR end_time > start_time)
);
COMMENT ON TABLE academics.course_offering IS 'A course running in a specific semester and section.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 3 : Course Enrollment
-- ---------------------------------------------------------------------------
CREATE TABLE academics.enrollment (
    enrollment_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id      INTEGER NOT NULL REFERENCES people.student(student_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    offering_id     INTEGER NOT NULL REFERENCES academics.course_offering(offering_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    enrolled_on     DATE NOT NULL DEFAULT CURRENT_DATE,
    status          core.enrollment_status_type NOT NULL DEFAULT 'enrolled',
    is_retake       BOOLEAN NOT NULL DEFAULT FALSE,
    continuous_assessment NUMERIC(5,2),                 -- out of 30/40
    exam_score      NUMERIC(5,2),                       -- out of 70/60
    final_score     NUMERIC(5,2),
    letter_grade    VARCHAR(2),
    grade_point     NUMERIC(3,2),
    dropped_on      DATE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- A student may register for a given offering only once.
    CONSTRAINT enrollment_uq UNIQUE (student_id, offering_id),
    CONSTRAINT enrollment_ca_ck    CHECK (continuous_assessment IS NULL OR continuous_assessment BETWEEN 0 AND 100),
    CONSTRAINT enrollment_exam_ck  CHECK (exam_score IS NULL OR exam_score BETWEEN 0 AND 100),
    CONSTRAINT enrollment_final_ck CHECK (final_score IS NULL OR final_score BETWEEN 0 AND 100),
    CONSTRAINT enrollment_gp_ck    CHECK (grade_point IS NULL OR grade_point BETWEEN 0 AND 4.00),
    CONSTRAINT enrollment_grade_ck CHECK (letter_grade IS NULL OR letter_grade IN
                                    ('A','B+','B','C+','C','D+','D','E','F','I','X')),
    -- A dropped registration must record the date it was dropped, and only then.
    CONSTRAINT enrollment_dropped_ck CHECK (
        (status = 'dropped' AND dropped_on IS NOT NULL) OR
        (status <> 'dropped' AND dropped_on IS NULL)
    )
);
COMMENT ON TABLE academics.enrollment IS
    'FUNCTIONALITY 3 - resolves the many-to-many between students and course offerings.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 4 : Lecturers to Course Assignment
-- ---------------------------------------------------------------------------
CREATE TABLE academics.lecturer_course_assignment (
    assignment_id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lecturer_id     INTEGER NOT NULL REFERENCES people.lecturer(lecturer_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    offering_id     INTEGER NOT NULL REFERENCES academics.course_offering(offering_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    teaching_role   core.teaching_role_type NOT NULL DEFAULT 'lead_lecturer',
    contact_hours_per_week SMALLINT NOT NULL DEFAULT 3,
    assigned_on     DATE NOT NULL DEFAULT CURRENT_DATE,
    assigned_by     VARCHAR(120),                       -- Head of Department
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    remarks         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- One lecturer cannot be assigned to the same offering twice.
    CONSTRAINT lecturer_course_uq UNIQUE (lecturer_id, offering_id),
    CONSTRAINT lecturer_course_hours_ck CHECK (contact_hours_per_week BETWEEN 1 AND 20)
);
-- Business rule: exactly one LEAD lecturer per offering.
CREATE UNIQUE INDEX lecturer_course_one_lead_uq
    ON academics.lecturer_course_assignment (offering_id)
    WHERE teaching_role = 'lead_lecturer' AND is_active;

COMMENT ON TABLE academics.lecturer_course_assignment IS
    'FUNCTIONALITY 4 - which lecturer teaches which course offering, and in what role.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 5 : Lecturers to TA assignment
-- ---------------------------------------------------------------------------
-- A TA is assigned to work UNDER a lecturer. In practice that help is scoped to
-- a particular course the lecturer teaches, so the assignment optionally points
-- at the lecturer_course_assignment. When offering-independent (e.g. a TA who
-- supports a lecturer's whole research/teaching load) the offering is NULL.
CREATE TABLE academics.lecturer_ta_assignment (
    ta_assignment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    lecturer_id     INTEGER NOT NULL REFERENCES people.lecturer(lecturer_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    ta_id           INTEGER NOT NULL REFERENCES people.teaching_assistant(ta_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    offering_id     INTEGER REFERENCES academics.course_offering(offering_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    semester_id     INTEGER NOT NULL REFERENCES core.semester(semester_id)
                    ON UPDATE CASCADE ON DELETE RESTRICT,
    responsibility  VARCHAR(200) NOT NULL DEFAULT 'Laboratory supervision and grading',
    weekly_hours    SMALLINT NOT NULL DEFAULT 6,
    assigned_on     DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date        DATE,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT lecturer_ta_hours_ck  CHECK (weekly_hours BETWEEN 1 AND 40),
    CONSTRAINT lecturer_ta_period_ck CHECK (end_date IS NULL OR end_date >= assigned_on)
);
-- UNIQUE over a nullable column needs two partial indexes to behave correctly:
-- NULLs are distinct in a plain UNIQUE, which would allow duplicate rows.
CREATE UNIQUE INDEX lecturer_ta_with_offering_uq
    ON academics.lecturer_ta_assignment (lecturer_id, ta_id, offering_id)
    WHERE offering_id IS NOT NULL;
CREATE UNIQUE INDEX lecturer_ta_no_offering_uq
    ON academics.lecturer_ta_assignment (lecturer_id, ta_id, semester_id)
    WHERE offering_id IS NULL;

COMMENT ON TABLE academics.lecturer_ta_assignment IS
    'FUNCTIONALITY 5 - assigns a teaching assistant to a lecturer, optionally scoped to one course offering.';

-- #############################################################################
-- SECTION D : finance - FUNCTIONALITY 2, Student Fees Payments
-- #############################################################################
-- BILLING MODEL
--   fee_structure  -> the published price list for (programme, level, year,
--                     residential status)
--   fee_item       -> the individual lines of that price list
--   student_bill   -> a price list applied to ONE student for ONE academic year
--   bill_line      -> the frozen copy of the fee items on that bill (so that a
--                     later change to the price list never rewrites history)
--   payment        -> money actually received against a bill
--
--   OUTSTANDING = SUM(bill_line.amount) - SUM(confirmed payment.amount)
-- #############################################################################

CREATE TABLE finance.fee_structure (
    fee_structure_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    programme_id     INTEGER NOT NULL REFERENCES core.programme(programme_id)
                     ON UPDATE CASCADE ON DELETE RESTRICT,
    academic_year_id INTEGER NOT NULL REFERENCES core.academic_year(academic_year_id)
                     ON UPDATE CASCADE ON DELETE RESTRICT,
    level            SMALLINT NOT NULL,
    residential_status core.residential_status_type NOT NULL,
    currency         CHAR(3) NOT NULL DEFAULT 'GHS',
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fee_structure_uq    UNIQUE (programme_id, academic_year_id, level, residential_status),
    CONSTRAINT fee_structure_level_ck CHECK (level IN (100,200,300,400,500,600))
);
COMMENT ON TABLE finance.fee_structure IS 'Published fee schedule for a programme/level/year/residency combination.';

CREATE TABLE finance.fee_item (
    fee_item_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fee_structure_id INTEGER NOT NULL REFERENCES finance.fee_structure(fee_structure_id)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    item_name        VARCHAR(100) NOT NULL,
    category         core.fee_category_type NOT NULL,
    amount           core.money_amount NOT NULL,
    is_mandatory     BOOLEAN NOT NULL DEFAULT TRUE,
    description      TEXT,
    CONSTRAINT fee_item_uq UNIQUE (fee_structure_id, item_name)
);
COMMENT ON TABLE finance.fee_item IS 'Individual charges that make up a fee structure (tuition, SRC dues, ...).';

CREATE TABLE finance.student_bill (
    bill_id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bill_reference   VARCHAR(30) NOT NULL UNIQUE,
    student_id       INTEGER NOT NULL REFERENCES people.student(student_id)
                     ON UPDATE CASCADE ON DELETE CASCADE,
    academic_year_id INTEGER NOT NULL REFERENCES core.academic_year(academic_year_id)
                     ON UPDATE CASCADE ON DELETE RESTRICT,
    fee_structure_id INTEGER REFERENCES finance.fee_structure(fee_structure_id)
                     ON UPDATE CASCADE ON DELETE SET NULL,
    total_amount     core.money_amount NOT NULL DEFAULT 0,
    currency         CHAR(3) NOT NULL DEFAULT 'GHS',
    issued_on        DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date         DATE NOT NULL,
    status           core.bill_status_type NOT NULL DEFAULT 'issued',
    notes            TEXT,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- One bill per student per academic year.
    CONSTRAINT student_bill_uq      UNIQUE (student_id, academic_year_id),
    CONSTRAINT student_bill_due_ck  CHECK (due_date >= issued_on)
);
COMMENT ON TABLE finance.student_bill IS
    'FUNCTIONALITY 2 - the amount a student owes for an academic year.';

CREATE TABLE finance.bill_line (
    bill_line_id    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bill_id         INTEGER NOT NULL REFERENCES finance.student_bill(bill_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    fee_item_id     INTEGER REFERENCES finance.fee_item(fee_item_id)
                    ON UPDATE CASCADE ON DELETE SET NULL,
    description     VARCHAR(120) NOT NULL,
    category        core.fee_category_type NOT NULL,
    amount          core.money_amount NOT NULL,
    CONSTRAINT bill_line_uq UNIQUE (bill_id, description)
);
COMMENT ON TABLE finance.bill_line IS 'Frozen snapshot of the fee items charged on a bill.';

CREATE TABLE finance.payment (
    payment_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    receipt_number  VARCHAR(30) NOT NULL UNIQUE,
    student_id      INTEGER NOT NULL REFERENCES people.student(student_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    bill_id         INTEGER NOT NULL REFERENCES finance.student_bill(bill_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    amount          core.money_amount NOT NULL,
    currency        CHAR(3) NOT NULL DEFAULT 'GHS',
    payment_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    payment_method  core.payment_method_type NOT NULL,
    bank_or_channel VARCHAR(80),                        -- GCB, MTN MoMo ...
    transaction_ref VARCHAR(60),
    status          core.payment_status_type NOT NULL DEFAULT 'confirmed',
    received_by     VARCHAR(120),
    remarks         TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT payment_amount_ck CHECK (amount > 0)
);
COMMENT ON TABLE finance.payment IS
    'FUNCTIONALITY 2 - money received from a student. Only status = confirmed reduces the outstanding balance.';

-- #############################################################################
-- SECTION E : app - authentication layer for the Next.js 14 application (Q2)
--             and the REST API (Project 2)
-- #############################################################################

CREATE TABLE app.app_user (
    user_id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username        VARCHAR(60) NOT NULL UNIQUE,
    email           core.email_address NOT NULL UNIQUE,
    password_hash   VARCHAR(255) NOT NULL,   -- bcrypt, never the plain password
    role            core.app_role_type NOT NULL DEFAULT 'student',
    -- Links the login to the human it represents (NULL for pure admin accounts).
    person_id       INTEGER UNIQUE REFERENCES people.person(person_id)
                    ON UPDATE CASCADE ON DELETE SET NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    email_verified  BOOLEAN NOT NULL DEFAULT FALSE,
    failed_login_attempts SMALLINT NOT NULL DEFAULT 0,
    locked_until    TIMESTAMPTZ,
    last_login_at   TIMESTAMPTZ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT app_user_username_ck CHECK (username ~ '^[A-Za-z0-9._-]{3,60}$'),
    CONSTRAINT app_user_hash_ck     CHECK (length(password_hash) >= 20)
);
COMMENT ON TABLE app.app_user IS 'Login accounts for the Next.js application and the REST API.';

CREATE TABLE app.user_session (
    session_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         INTEGER NOT NULL REFERENCES app.app_user(user_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
    token_hash      VARCHAR(128) NOT NULL UNIQUE,  -- SHA-256 of the cookie value
    issued_at       TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at      TIMESTAMPTZ NOT NULL,
    revoked_at      TIMESTAMPTZ,
    ip_address      INET,
    user_agent      VARCHAR(300),
    CONSTRAINT user_session_expiry_ck CHECK (expires_at > issued_at)
);
COMMENT ON TABLE app.user_session IS 'Server-side session records; the browser only ever holds an opaque token.';

CREATE TABLE app.audit_log (
    audit_id        BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id         INTEGER REFERENCES app.app_user(user_id)
                    ON UPDATE CASCADE ON DELETE SET NULL,
    action          VARCHAR(60) NOT NULL,       -- LOGIN, REGISTER, ENROL ...
    entity          VARCHAR(60),                -- table or resource affected
    entity_id       VARCHAR(60),
    details         JSONB,
    ip_address      INET,
    occurred_at     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON TABLE app.audit_log IS 'Append-only trail of security-relevant actions.';
