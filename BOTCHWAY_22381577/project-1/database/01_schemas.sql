-- =============================================================================
-- File    : 01_schemas.sql
-- Purpose : Create the schemas (namespaces) and the shared ENUM types/domains.
-- Run as  : owner of cpen208_ceds
-- Usage   : psql -d cpen208_ceds -f 01_schemas.sql
-- -----------------------------------------------------------------------------
-- WHY SCHEMAS?
--   The brief asks for "Schema(s) when needed". The system covers five distinct
--   business areas, so the tables are grouped by bounded context rather than
--   dumped into `public`. This gives us:
--     * clear ownership / permission boundaries per subject area,
--     * shorter, non-prefixed table names (finance.payment vs fees_payment),
--     * the ability to grant the API service account narrow access.
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS core;       -- reference data shared by everything
CREATE SCHEMA IF NOT EXISTS people;     -- persons: students, lecturers, TAs
CREATE SCHEMA IF NOT EXISTS academics;  -- courses, enrolment, teaching assignment
CREATE SCHEMA IF NOT EXISTS finance;    -- fee structures, bills, payments
CREATE SCHEMA IF NOT EXISTS app;        -- application/auth layer for the web app

COMMENT ON SCHEMA core      IS 'Reference & lookup data: departments, programmes, academic calendar.';
COMMENT ON SCHEMA people    IS 'Person master data and its student / lecturer / teaching-assistant roles.';
COMMENT ON SCHEMA academics IS 'Courses, semester offerings, enrolment and teaching assignments.';
COMMENT ON SCHEMA finance   IS 'Fee structures, student bills and fee payments.';
COMMENT ON SCHEMA app       IS 'Application layer: users, sessions and audit trail for the Next.js app and REST API.';

-- Make unqualified lookups resolve in a sensible order for interactive use.
ALTER DATABASE cpen208_ceds
    SET search_path = core, people, academics, finance, app, public;

SET search_path = core, people, academics, finance, app, public;

-- pgcrypto gives us crypt()/gen_salt('bf') so the seed script can store real
-- bcrypt password hashes. Installed into public so it is on every search_path.
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;

-- =============================================================================
-- ENUM TYPES
-- Enumerations are used where the domain is small, stable and closed. Anything
-- that the department may want to edit at runtime (programmes, fee items ...)
-- is a lookup TABLE instead, not an enum.
-- =============================================================================

CREATE TYPE core.gender_type AS ENUM (
    'Male', 'Female', 'Other', 'Prefer not to say'
);

CREATE TYPE core.marital_status_type AS ENUM (
    'Single', 'Married', 'Divorced', 'Widowed'
);

CREATE TYPE core.student_status_type AS ENUM (
    'active',       -- currently registered and studying
    'deferred',     -- approved break in studies
    'suspended',    -- disciplinary / academic suspension
    'withdrawn',    -- left the programme
    'graduated'     -- completed the programme
);

CREATE TYPE core.residential_status_type AS ENUM (
    'resident',     -- lives in a hall of residence (pays residential fees)
    'non-resident'  -- commutes (does not pay residential fees)
);

CREATE TYPE core.staff_status_type AS ENUM (
    'active', 'on_leave', 'sabbatical', 'retired', 'resigned'
);

CREATE TYPE core.lecturer_rank_type AS ENUM (
    'Professor',
    'Associate Professor',
    'Senior Lecturer',
    'Lecturer',
    'Assistant Lecturer'
);

CREATE TYPE core.ta_type AS ENUM (
    'graduate',        -- MPhil/PhD student assisting
    'undergraduate',   -- senior undergraduate assisting
    'external'         -- industry / national service personnel
);

CREATE TYPE core.enrollment_status_type AS ENUM (
    'enrolled',   -- registered and attending
    'dropped',    -- withdrew from the course after registering
    'completed',  -- finished with a pass grade
    'failed',     -- finished with a fail grade
    'deferred'    -- carried the paper to another semester
);

CREATE TYPE core.teaching_role_type AS ENUM (
    'lead_lecturer',   -- course coordinator, owns the grade sheet
    'co_lecturer',     -- shares delivery of the syllabus
    'guest_lecturer'   -- delivers a limited number of sessions
);

CREATE TYPE core.fee_category_type AS ENUM (
    'tuition',
    'academic_facility',
    'residential',
    'src_dues',
    'examination',
    'other'
);

CREATE TYPE core.bill_status_type AS ENUM (
    'draft',      -- generated but not yet released to the student
    'issued',     -- released, nothing paid yet
    'part_paid',  -- some money received, balance outstanding
    'paid',       -- fully settled
    'overdue',    -- past due date with a balance
    'cancelled'   -- voided
);

CREATE TYPE core.payment_method_type AS ENUM (
    'bank_transfer', 'mobile_money', 'cash', 'cheque', 'card', 'scholarship'
);

CREATE TYPE core.payment_status_type AS ENUM (
    'pending',    -- lodged, awaiting bank/telco confirmation
    'confirmed',  -- cleared - only these reduce the outstanding balance
    'reversed',   -- charged back / bounced
    'failed'      -- never went through
);

CREATE TYPE core.app_role_type AS ENUM (
    'student', 'lecturer', 'teaching_assistant', 'admin'
);

CREATE TYPE core.delivery_mode_type AS ENUM (
    'in_person', 'online', 'hybrid'
);

-- =============================================================================
-- DOMAINS - reusable constrained types
-- =============================================================================

CREATE DOMAIN core.email_address AS TEXT
    CONSTRAINT email_address_format
    CHECK (VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

CREATE DOMAIN core.phone_number AS TEXT
    CONSTRAINT phone_number_format
    CHECK (VALUE ~ '^\+?[0-9][0-9 \-]{6,19}$');

CREATE DOMAIN core.money_amount AS NUMERIC(12,2)
    CONSTRAINT money_amount_non_negative CHECK (VALUE >= 0);

COMMENT ON DOMAIN core.email_address IS 'Text constrained to a valid e-mail shape.';
COMMENT ON DOMAIN core.phone_number  IS 'International or local phone number, digits with optional +, spaces and hyphens.';
COMMENT ON DOMAIN core.money_amount  IS 'Non-negative currency amount with 2 decimal places.';

-- =============================================================================
-- SHARED TRIGGER FUNCTION - keeps `updated_at` honest on every table that has it
-- =============================================================================

CREATE OR REPLACE FUNCTION core.fn_set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

COMMENT ON FUNCTION core.fn_set_updated_at() IS
    'BEFORE UPDATE trigger: stamps updated_at with the current transaction time.';
