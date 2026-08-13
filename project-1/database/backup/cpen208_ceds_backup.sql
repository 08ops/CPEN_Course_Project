--
-- PostgreSQL database dump
--

\restrict ofx0HL1aUldd9hyO4ERZxMJWrRMOoewLHEXlG5UOttmtk63Fk9ETzDXJwONIvT5

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

ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_student_id_fkey;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_person_id_fkey;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_department_id_fkey;
ALTER TABLE IF EXISTS ONLY people.student DROP CONSTRAINT IF EXISTS student_programme_id_fkey;
ALTER TABLE IF EXISTS ONLY people.student DROP CONSTRAINT IF EXISTS student_person_id_fkey;
ALTER TABLE IF EXISTS ONLY people.next_of_kin DROP CONSTRAINT IF EXISTS next_of_kin_student_id_fkey;
ALTER TABLE IF EXISTS ONLY people.lecturer DROP CONSTRAINT IF EXISTS lecturer_person_id_fkey;
ALTER TABLE IF EXISTS ONLY people.lecturer DROP CONSTRAINT IF EXISTS lecturer_department_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_student_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_fee_structure_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_academic_year_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.payment DROP CONSTRAINT IF EXISTS payment_student_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.payment DROP CONSTRAINT IF EXISTS payment_bill_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.fee_structure DROP CONSTRAINT IF EXISTS fee_structure_programme_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.fee_structure DROP CONSTRAINT IF EXISTS fee_structure_academic_year_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.fee_item DROP CONSTRAINT IF EXISTS fee_item_fee_structure_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.bill_line DROP CONSTRAINT IF EXISTS bill_line_fee_item_id_fkey;
ALTER TABLE IF EXISTS ONLY finance.bill_line DROP CONSTRAINT IF EXISTS bill_line_bill_id_fkey;
ALTER TABLE IF EXISTS ONLY core.semester DROP CONSTRAINT IF EXISTS semester_academic_year_id_fkey;
ALTER TABLE IF EXISTS ONLY core.programme DROP CONSTRAINT IF EXISTS programme_department_id_fkey;
ALTER TABLE IF EXISTS ONLY app.user_session DROP CONSTRAINT IF EXISTS user_session_user_id_fkey;
ALTER TABLE IF EXISTS ONLY app.audit_log DROP CONSTRAINT IF EXISTS audit_log_user_id_fkey;
ALTER TABLE IF EXISTS ONLY app.app_user DROP CONSTRAINT IF EXISTS app_user_person_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_ta_assignment DROP CONSTRAINT IF EXISTS lecturer_ta_assignment_ta_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_ta_assignment DROP CONSTRAINT IF EXISTS lecturer_ta_assignment_semester_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_ta_assignment DROP CONSTRAINT IF EXISTS lecturer_ta_assignment_offering_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_ta_assignment DROP CONSTRAINT IF EXISTS lecturer_ta_assignment_lecturer_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_course_assignment DROP CONSTRAINT IF EXISTS lecturer_course_assignment_offering_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_course_assignment DROP CONSTRAINT IF EXISTS lecturer_course_assignment_lecturer_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.enrollment DROP CONSTRAINT IF EXISTS enrollment_student_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.enrollment DROP CONSTRAINT IF EXISTS enrollment_offering_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.course_prerequisite DROP CONSTRAINT IF EXISTS course_prerequisite_prerequisite_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.course_prerequisite DROP CONSTRAINT IF EXISTS course_prerequisite_course_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.course_offering DROP CONSTRAINT IF EXISTS course_offering_semester_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.course_offering DROP CONSTRAINT IF EXISTS course_offering_course_id_fkey;
ALTER TABLE IF EXISTS ONLY academics.course DROP CONSTRAINT IF EXISTS course_department_id_fkey;
DROP TRIGGER IF EXISTS t_teaching_assistant_set_updated_at ON people.teaching_assistant;
DROP TRIGGER IF EXISTS t_student_set_updated_at ON people.student;
DROP TRIGGER IF EXISTS t_person_set_updated_at ON people.person;
DROP TRIGGER IF EXISTS t_lecturer_set_updated_at ON people.lecturer;
DROP TRIGGER IF EXISTS t_student_bill_set_updated_at ON finance.student_bill;
DROP TRIGGER IF EXISTS t_payment_set_updated_at ON finance.payment;
DROP TRIGGER IF EXISTS t_payment_refresh_bill_status ON finance.payment;
DROP TRIGGER IF EXISTS t_fee_structure_set_updated_at ON finance.fee_structure;
DROP TRIGGER IF EXISTS t_bill_line_refresh_total ON finance.bill_line;
DROP TRIGGER IF EXISTS t_programme_set_updated_at ON core.programme;
DROP TRIGGER IF EXISTS t_department_set_updated_at ON core.department;
DROP TRIGGER IF EXISTS t_app_user_set_updated_at ON app.app_user;
DROP TRIGGER IF EXISTS t_lecturer_ta_assignment_set_updated_at ON academics.lecturer_ta_assignment;
DROP TRIGGER IF EXISTS t_lecturer_course_assignment_set_updated_at ON academics.lecturer_course_assignment;
DROP TRIGGER IF EXISTS t_enrollment_validate ON academics.enrollment;
DROP TRIGGER IF EXISTS t_enrollment_set_updated_at ON academics.enrollment;
DROP TRIGGER IF EXISTS t_course_set_updated_at ON academics.course;
DROP TRIGGER IF EXISTS t_course_offering_set_updated_at ON academics.course_offering;
DROP INDEX IF EXISTS people.ta_person_ix;
DROP INDEX IF EXISTS people.ta_department_ix;
DROP INDEX IF EXISTS people.student_programme_ix;
DROP INDEX IF EXISTS people.student_person_ix;
DROP INDEX IF EXISTS people.student_level_status_ix;
DROP INDEX IF EXISTS people.person_last_first_ix;
DROP INDEX IF EXISTS people.next_of_kin_student_ix;
DROP INDEX IF EXISTS people.next_of_kin_one_primary_uq;
DROP INDEX IF EXISTS people.lecturer_person_ix;
DROP INDEX IF EXISTS people.lecturer_department_ix;
DROP INDEX IF EXISTS finance.payment_student_ix;
DROP INDEX IF EXISTS finance.payment_date_ix;
DROP INDEX IF EXISTS finance.payment_confirmed_ix;
DROP INDEX IF EXISTS finance.payment_bill_ix;
DROP INDEX IF EXISTS finance.fee_structure_programme_ix;
DROP INDEX IF EXISTS finance.fee_item_structure_ix;
DROP INDEX IF EXISTS finance.bill_year_ix;
DROP INDEX IF EXISTS finance.bill_student_ix;
DROP INDEX IF EXISTS finance.bill_status_ix;
DROP INDEX IF EXISTS finance.bill_line_bill_ix;
DROP INDEX IF EXISTS core.semester_year_ix;
DROP INDEX IF EXISTS core.semester_one_current_uq;
DROP INDEX IF EXISTS core.programme_department_ix;
DROP INDEX IF EXISTS core.academic_year_one_current_uq;
DROP INDEX IF EXISTS app.session_user_ix;
DROP INDEX IF EXISTS app.session_live_ix;
DROP INDEX IF EXISTS app.audit_user_time_ix;
DROP INDEX IF EXISTS app.audit_action_ix;
DROP INDEX IF EXISTS app.app_user_role_ix;
DROP INDEX IF EXISTS app.app_user_person_ix;
DROP INDEX IF EXISTS academics.offering_semester_ix;
DROP INDEX IF EXISTS academics.offering_course_ix;
DROP INDEX IF EXISTS academics.lta_ta_ix;
DROP INDEX IF EXISTS academics.lta_semester_ix;
DROP INDEX IF EXISTS academics.lta_offering_ix;
DROP INDEX IF EXISTS academics.lta_lecturer_ix;
DROP INDEX IF EXISTS academics.lecturer_ta_with_offering_uq;
DROP INDEX IF EXISTS academics.lecturer_ta_no_offering_uq;
DROP INDEX IF EXISTS academics.lecturer_course_one_lead_uq;
DROP INDEX IF EXISTS academics.lca_offering_ix;
DROP INDEX IF EXISTS academics.lca_lecturer_ix;
DROP INDEX IF EXISTS academics.enrollment_student_ix;
DROP INDEX IF EXISTS academics.enrollment_status_ix;
DROP INDEX IF EXISTS academics.enrollment_offering_ix;
DROP INDEX IF EXISTS academics.course_level_ix;
DROP INDEX IF EXISTS academics.course_department_ix;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_ta_code_key;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_student_id_key;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_pkey;
ALTER TABLE IF EXISTS ONLY people.teaching_assistant DROP CONSTRAINT IF EXISTS teaching_assistant_person_id_key;
ALTER TABLE IF EXISTS ONLY people.student DROP CONSTRAINT IF EXISTS student_student_number_key;
ALTER TABLE IF EXISTS ONLY people.student DROP CONSTRAINT IF EXISTS student_pkey;
ALTER TABLE IF EXISTS ONLY people.student DROP CONSTRAINT IF EXISTS student_person_id_key;
ALTER TABLE IF EXISTS ONLY people.person DROP CONSTRAINT IF EXISTS person_pkey;
ALTER TABLE IF EXISTS ONLY people.person DROP CONSTRAINT IF EXISTS person_national_id_key;
ALTER TABLE IF EXISTS ONLY people.person DROP CONSTRAINT IF EXISTS person_email_key;
ALTER TABLE IF EXISTS ONLY people.next_of_kin DROP CONSTRAINT IF EXISTS next_of_kin_pkey;
ALTER TABLE IF EXISTS ONLY people.lecturer DROP CONSTRAINT IF EXISTS lecturer_staff_number_key;
ALTER TABLE IF EXISTS ONLY people.lecturer DROP CONSTRAINT IF EXISTS lecturer_pkey;
ALTER TABLE IF EXISTS ONLY people.lecturer DROP CONSTRAINT IF EXISTS lecturer_person_id_key;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_uq;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_pkey;
ALTER TABLE IF EXISTS ONLY finance.student_bill DROP CONSTRAINT IF EXISTS student_bill_bill_reference_key;
ALTER TABLE IF EXISTS ONLY finance.payment DROP CONSTRAINT IF EXISTS payment_receipt_number_key;
ALTER TABLE IF EXISTS ONLY finance.payment DROP CONSTRAINT IF EXISTS payment_pkey;
ALTER TABLE IF EXISTS ONLY finance.fee_structure DROP CONSTRAINT IF EXISTS fee_structure_uq;
ALTER TABLE IF EXISTS ONLY finance.fee_structure DROP CONSTRAINT IF EXISTS fee_structure_pkey;
ALTER TABLE IF EXISTS ONLY finance.fee_item DROP CONSTRAINT IF EXISTS fee_item_uq;
ALTER TABLE IF EXISTS ONLY finance.fee_item DROP CONSTRAINT IF EXISTS fee_item_pkey;
ALTER TABLE IF EXISTS ONLY finance.bill_line DROP CONSTRAINT IF EXISTS bill_line_uq;
ALTER TABLE IF EXISTS ONLY finance.bill_line DROP CONSTRAINT IF EXISTS bill_line_pkey;
ALTER TABLE IF EXISTS ONLY core.semester DROP CONSTRAINT IF EXISTS semester_uq;
ALTER TABLE IF EXISTS ONLY core.semester DROP CONSTRAINT IF EXISTS semester_pkey;
ALTER TABLE IF EXISTS ONLY core.programme DROP CONSTRAINT IF EXISTS programme_pkey;
ALTER TABLE IF EXISTS ONLY core.programme DROP CONSTRAINT IF EXISTS programme_code_key;
ALTER TABLE IF EXISTS ONLY core.department DROP CONSTRAINT IF EXISTS department_pkey;
ALTER TABLE IF EXISTS ONLY core.department DROP CONSTRAINT IF EXISTS department_name_key;
ALTER TABLE IF EXISTS ONLY core.department DROP CONSTRAINT IF EXISTS department_code_key;
ALTER TABLE IF EXISTS ONLY core.academic_year DROP CONSTRAINT IF EXISTS academic_year_pkey;
ALTER TABLE IF EXISTS ONLY core.academic_year DROP CONSTRAINT IF EXISTS academic_year_name_key;
ALTER TABLE IF EXISTS ONLY app.user_session DROP CONSTRAINT IF EXISTS user_session_token_hash_key;
ALTER TABLE IF EXISTS ONLY app.user_session DROP CONSTRAINT IF EXISTS user_session_pkey;
ALTER TABLE IF EXISTS ONLY app.audit_log DROP CONSTRAINT IF EXISTS audit_log_pkey;
ALTER TABLE IF EXISTS ONLY app.app_user DROP CONSTRAINT IF EXISTS app_user_username_key;
ALTER TABLE IF EXISTS ONLY app.app_user DROP CONSTRAINT IF EXISTS app_user_pkey;
ALTER TABLE IF EXISTS ONLY app.app_user DROP CONSTRAINT IF EXISTS app_user_person_id_key;
ALTER TABLE IF EXISTS ONLY app.app_user DROP CONSTRAINT IF EXISTS app_user_email_key;
ALTER TABLE IF EXISTS ONLY academics.lecturer_ta_assignment DROP CONSTRAINT IF EXISTS lecturer_ta_assignment_pkey;
ALTER TABLE IF EXISTS ONLY academics.lecturer_course_assignment DROP CONSTRAINT IF EXISTS lecturer_course_uq;
ALTER TABLE IF EXISTS ONLY academics.lecturer_course_assignment DROP CONSTRAINT IF EXISTS lecturer_course_assignment_pkey;
ALTER TABLE IF EXISTS ONLY academics.enrollment DROP CONSTRAINT IF EXISTS enrollment_uq;
ALTER TABLE IF EXISTS ONLY academics.enrollment DROP CONSTRAINT IF EXISTS enrollment_pkey;
ALTER TABLE IF EXISTS ONLY academics.course_prerequisite DROP CONSTRAINT IF EXISTS course_prerequisite_pkey;
ALTER TABLE IF EXISTS ONLY academics.course DROP CONSTRAINT IF EXISTS course_pkey;
ALTER TABLE IF EXISTS ONLY academics.course_offering DROP CONSTRAINT IF EXISTS course_offering_uq;
ALTER TABLE IF EXISTS ONLY academics.course_offering DROP CONSTRAINT IF EXISTS course_offering_pkey;
ALTER TABLE IF EXISTS ONLY academics.course DROP CONSTRAINT IF EXISTS course_course_code_key;
DROP VIEW IF EXISTS people.v_student_directory;
DROP TABLE IF EXISTS people.next_of_kin;
DROP VIEW IF EXISTS finance.v_student_fee_status;
DROP TABLE IF EXISTS finance.student_bill;
DROP SEQUENCE IF EXISTS finance.receipt_seq;
DROP TABLE IF EXISTS finance.payment;
DROP TABLE IF EXISTS finance.fee_structure;
DROP TABLE IF EXISTS finance.fee_item;
DROP TABLE IF EXISTS finance.bill_line;
DROP TABLE IF EXISTS core.programme;
DROP TABLE IF EXISTS app.user_session;
DROP TABLE IF EXISTS app.audit_log;
DROP TABLE IF EXISTS app.app_user;
DROP VIEW IF EXISTS academics.v_lecturer_ta_allocation;
DROP TABLE IF EXISTS people.teaching_assistant;
DROP VIEW IF EXISTS academics.v_lecturer_course_allocation;
DROP TABLE IF EXISTS core.department;
DROP VIEW IF EXISTS academics.v_enrollment_detail;
DROP TABLE IF EXISTS people.student;
DROP VIEW IF EXISTS academics.v_course_offering_summary;
DROP TABLE IF EXISTS people.person;
DROP TABLE IF EXISTS people.lecturer;
DROP TABLE IF EXISTS core.semester;
DROP TABLE IF EXISTS core.academic_year;
DROP TABLE IF EXISTS academics.lecturer_ta_assignment;
DROP TABLE IF EXISTS academics.lecturer_course_assignment;
DROP TABLE IF EXISTS academics.enrollment;
DROP TABLE IF EXISTS academics.course_prerequisite;
DROP TABLE IF EXISTS academics.course_offering;
DROP TABLE IF EXISTS academics.course;
DROP FUNCTION IF EXISTS people.fn_students_json(p_programme_id integer, p_level smallint, p_search text);
DROP FUNCTION IF EXISTS people.fn_student_profile_json(p_student_id integer);
DROP FUNCTION IF EXISTS finance.fn_student_outstanding_balance(p_student_id integer, p_academic_year_id integer);
DROP FUNCTION IF EXISTS finance.fn_student_fee_statement_json(p_student_id integer);
DROP FUNCTION IF EXISTS finance.fn_refresh_bill_total();
DROP FUNCTION IF EXISTS finance.fn_refresh_bill_status();
DROP FUNCTION IF EXISTS finance.fn_record_payment(p_student_id integer, p_bill_id integer, p_amount numeric, p_method core.payment_method_type, p_channel character varying, p_transaction_ref character varying, p_received_by character varying, p_payment_date date);
DROP FUNCTION IF EXISTS finance.fn_outstanding_fees_json(p_academic_year_id integer, p_programme_id integer, p_only_indebted boolean);
DROP FUNCTION IF EXISTS finance.fn_generate_student_bill(p_student_id integer, p_academic_year_id integer, p_due_date date, p_issued_on date);
DROP FUNCTION IF EXISTS finance.fn_fees_summary_json(p_academic_year_id integer);
DROP FUNCTION IF EXISTS core.fn_set_updated_at();
DROP FUNCTION IF EXISTS app.fn_user_context_json(p_user_id integer);
DROP FUNCTION IF EXISTS app.fn_register_user(p_username character varying, p_email character varying, p_password_hash character varying, p_role core.app_role_type, p_person_id integer);
DROP FUNCTION IF EXISTS app.fn_dashboard_stats_json();
DROP FUNCTION IF EXISTS academics.fn_validate_enrollment();
DROP FUNCTION IF EXISTS academics.fn_ta_assignments_json(p_semester_id integer, p_lecturer_id integer);
DROP FUNCTION IF EXISTS academics.fn_student_enrollments_json(p_student_id integer, p_semester_id integer);
DROP FUNCTION IF EXISTS academics.fn_lecturer_workload_json(p_lecturer_id integer, p_semester_id integer);
DROP FUNCTION IF EXISTS academics.fn_enroll_student(p_student_id integer, p_offering_id integer, p_is_retake boolean);
DROP FUNCTION IF EXISTS academics.fn_drop_enrollment(p_student_id integer, p_offering_id integer);
DROP FUNCTION IF EXISTS academics.fn_class_list_json(p_offering_id integer);
DROP FUNCTION IF EXISTS academics.fn_assign_ta_to_lecturer(p_lecturer_id integer, p_ta_id integer, p_semester_id integer, p_offering_id integer, p_responsibility character varying, p_weekly_hours smallint);
DROP FUNCTION IF EXISTS academics.fn_assign_lecturer_to_course(p_lecturer_id integer, p_offering_id integer, p_role core.teaching_role_type, p_assigned_by character varying);
DROP TYPE IF EXISTS core.teaching_role_type;
DROP TYPE IF EXISTS core.ta_type;
DROP TYPE IF EXISTS core.student_status_type;
DROP TYPE IF EXISTS core.staff_status_type;
DROP TYPE IF EXISTS core.residential_status_type;
DROP DOMAIN IF EXISTS core.phone_number;
DROP TYPE IF EXISTS core.payment_status_type;
DROP TYPE IF EXISTS core.payment_method_type;
DROP DOMAIN IF EXISTS core.money_amount;
DROP TYPE IF EXISTS core.marital_status_type;
DROP TYPE IF EXISTS core.lecturer_rank_type;
DROP TYPE IF EXISTS core.gender_type;
DROP TYPE IF EXISTS core.fee_category_type;
DROP TYPE IF EXISTS core.enrollment_status_type;
DROP DOMAIN IF EXISTS core.email_address;
DROP TYPE IF EXISTS core.delivery_mode_type;
DROP TYPE IF EXISTS core.bill_status_type;
DROP TYPE IF EXISTS core.app_role_type;
DROP EXTENSION IF EXISTS pgcrypto;
DROP SCHEMA IF EXISTS people;
DROP SCHEMA IF EXISTS finance;
DROP SCHEMA IF EXISTS core;
DROP SCHEMA IF EXISTS app;
DROP SCHEMA IF EXISTS academics;
--
-- Name: academics; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA academics;


--
-- Name: SCHEMA academics; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA academics IS 'Courses, semester offerings, enrolment and teaching assignments.';


--
-- Name: app; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA app;


--
-- Name: SCHEMA app; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA app IS 'Application layer: users, sessions and audit trail for the Next.js app and REST API.';


--
-- Name: core; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA core;


--
-- Name: SCHEMA core; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA core IS 'Reference & lookup data: departments, programmes, academic calendar.';


--
-- Name: finance; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA finance;


--
-- Name: SCHEMA finance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA finance IS 'Fee structures, student bills and fee payments.';


--
-- Name: people; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA people;


--
-- Name: SCHEMA people; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA people IS 'Person master data and its student / lecturer / teaching-assistant roles.';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: app_role_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.app_role_type AS ENUM (
    'student',
    'lecturer',
    'teaching_assistant',
    'admin'
);


--
-- Name: bill_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.bill_status_type AS ENUM (
    'draft',
    'issued',
    'part_paid',
    'paid',
    'overdue',
    'cancelled'
);


--
-- Name: delivery_mode_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.delivery_mode_type AS ENUM (
    'in_person',
    'online',
    'hybrid'
);


--
-- Name: email_address; Type: DOMAIN; Schema: core; Owner: -
--

CREATE DOMAIN core.email_address AS text
	CONSTRAINT email_address_format CHECK ((VALUE ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text));


--
-- Name: DOMAIN email_address; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON DOMAIN core.email_address IS 'Text constrained to a valid e-mail shape.';


--
-- Name: enrollment_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.enrollment_status_type AS ENUM (
    'enrolled',
    'dropped',
    'completed',
    'failed',
    'deferred'
);


--
-- Name: fee_category_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.fee_category_type AS ENUM (
    'tuition',
    'academic_facility',
    'residential',
    'src_dues',
    'examination',
    'other'
);


--
-- Name: gender_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.gender_type AS ENUM (
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
);


--
-- Name: lecturer_rank_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.lecturer_rank_type AS ENUM (
    'Professor',
    'Associate Professor',
    'Senior Lecturer',
    'Lecturer',
    'Assistant Lecturer'
);


--
-- Name: marital_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.marital_status_type AS ENUM (
    'Single',
    'Married',
    'Divorced',
    'Widowed'
);


--
-- Name: money_amount; Type: DOMAIN; Schema: core; Owner: -
--

CREATE DOMAIN core.money_amount AS numeric(12,2)
	CONSTRAINT money_amount_non_negative CHECK ((VALUE >= (0)::numeric));


--
-- Name: DOMAIN money_amount; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON DOMAIN core.money_amount IS 'Non-negative currency amount with 2 decimal places.';


--
-- Name: payment_method_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.payment_method_type AS ENUM (
    'bank_transfer',
    'mobile_money',
    'cash',
    'cheque',
    'card',
    'scholarship'
);


--
-- Name: payment_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.payment_status_type AS ENUM (
    'pending',
    'confirmed',
    'reversed',
    'failed'
);


--
-- Name: phone_number; Type: DOMAIN; Schema: core; Owner: -
--

CREATE DOMAIN core.phone_number AS text
	CONSTRAINT phone_number_format CHECK ((VALUE ~ '^\+?[0-9][0-9 \-]{6,19}$'::text));


--
-- Name: DOMAIN phone_number; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON DOMAIN core.phone_number IS 'International or local phone number, digits with optional +, spaces and hyphens.';


--
-- Name: residential_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.residential_status_type AS ENUM (
    'resident',
    'non-resident'
);


--
-- Name: staff_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.staff_status_type AS ENUM (
    'active',
    'on_leave',
    'sabbatical',
    'retired',
    'resigned'
);


--
-- Name: student_status_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.student_status_type AS ENUM (
    'active',
    'deferred',
    'suspended',
    'withdrawn',
    'graduated'
);


--
-- Name: ta_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.ta_type AS ENUM (
    'graduate',
    'undergraduate',
    'external'
);


--
-- Name: teaching_role_type; Type: TYPE; Schema: core; Owner: -
--

CREATE TYPE core.teaching_role_type AS ENUM (
    'lead_lecturer',
    'co_lecturer',
    'guest_lecturer'
);


--
-- Name: fn_assign_lecturer_to_course(integer, integer, core.teaching_role_type, character varying); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_assign_lecturer_to_course(p_lecturer_id integer, p_offering_id integer, p_role core.teaching_role_type DEFAULT 'lead_lecturer'::core.teaching_role_type, p_assigned_by character varying DEFAULT 'Head of Department'::character varying) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_assignment_id INTEGER;
    v_lecturer_name TEXT;
    v_course        TEXT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM people.lecturer
                   WHERE lecturer_id = p_lecturer_id AND status = 'active') THEN
        RAISE EXCEPTION 'Lecturer % does not exist or is not active', p_lecturer_id
            USING ERRCODE = 'no_data_found';
    END IF;

    -- The partial unique index enforces one lead lecturer per offering; we
    -- translate that into a readable message.
    IF p_role = 'lead_lecturer' AND EXISTS (
           SELECT 1 FROM academics.lecturer_course_assignment
           WHERE offering_id = p_offering_id
             AND teaching_role = 'lead_lecturer' AND is_active
             AND lecturer_id <> p_lecturer_id) THEN
        RAISE EXCEPTION 'Course offering % already has a lead lecturer', p_offering_id
            USING ERRCODE = 'unique_violation';
    END IF;

    INSERT INTO academics.lecturer_course_assignment
        (lecturer_id, offering_id, teaching_role, assigned_by)
    VALUES (p_lecturer_id, p_offering_id, p_role, p_assigned_by)
    ON CONFLICT (lecturer_id, offering_id)
    DO UPDATE SET teaching_role = EXCLUDED.teaching_role,
                  is_active     = TRUE,
                  assigned_by   = EXCLUDED.assigned_by
    RETURNING assignment_id INTO v_assignment_id;

    SELECT TRIM(COALESCE(pr.title || ' ', '') || pr.first_name || ' ' || pr.last_name)
    INTO   v_lecturer_name
    FROM   people.lecturer l JOIN people.person pr ON pr.person_id = l.person_id
    WHERE  l.lecturer_id = p_lecturer_id;

    SELECT c.course_code || ' - ' || c.title INTO v_course
    FROM   academics.course_offering o JOIN academics.course c ON c.course_id = o.course_id
    WHERE  o.offering_id = p_offering_id;

    RETURN json_build_object(
        'assignment_id', v_assignment_id,
        'lecturer_id',   p_lecturer_id,
        'lecturer',      v_lecturer_name,
        'offering_id',   p_offering_id,
        'course',        v_course,
        'teaching_role', p_role,
        'assigned_on',   CURRENT_DATE);
END;
$$;


--
-- Name: FUNCTION fn_assign_lecturer_to_course(p_lecturer_id integer, p_offering_id integer, p_role core.teaching_role_type, p_assigned_by character varying); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_assign_lecturer_to_course(p_lecturer_id integer, p_offering_id integer, p_role core.teaching_role_type, p_assigned_by character varying) IS 'FUNCTIONALITY 4 - assigns a lecturer to a course offering in a given teaching role.';


--
-- Name: fn_assign_ta_to_lecturer(integer, integer, integer, integer, character varying, smallint); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_assign_ta_to_lecturer(p_lecturer_id integer, p_ta_id integer, p_semester_id integer, p_offering_id integer DEFAULT NULL::integer, p_responsibility character varying DEFAULT 'Laboratory supervision and grading'::character varying, p_weekly_hours smallint DEFAULT 6) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id            INTEGER;
    v_ta_max_hours  SMALLINT;
    v_current_hours INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM people.lecturer
                   WHERE lecturer_id = p_lecturer_id AND status = 'active') THEN
        RAISE EXCEPTION 'Lecturer % does not exist or is not active', p_lecturer_id
            USING ERRCODE = 'no_data_found';
    END IF;

    SELECT max_weekly_hours INTO v_ta_max_hours
    FROM   people.teaching_assistant
    WHERE  ta_id = p_ta_id AND status = 'active';

    IF v_ta_max_hours IS NULL THEN
        RAISE EXCEPTION 'Teaching assistant % does not exist or is not active', p_ta_id
            USING ERRCODE = 'no_data_found';
    END IF;

    -- A TA must not be committed beyond their contracted weekly hours.
    SELECT COALESCE(SUM(weekly_hours), 0) INTO v_current_hours
    FROM   academics.lecturer_ta_assignment
    WHERE  ta_id = p_ta_id AND semester_id = p_semester_id AND is_active;

    IF v_current_hours + p_weekly_hours > v_ta_max_hours THEN
        RAISE EXCEPTION
            'Assignment would put TA % at % hours/week, above the contracted maximum of %',
            p_ta_id, v_current_hours + p_weekly_hours, v_ta_max_hours
            USING ERRCODE = 'check_violation';
    END IF;

    -- If the assignment is course-scoped, the lecturer must actually teach it.
    IF p_offering_id IS NOT NULL AND NOT EXISTS (
           SELECT 1 FROM academics.lecturer_course_assignment
           WHERE lecturer_id = p_lecturer_id AND offering_id = p_offering_id AND is_active) THEN
        RAISE EXCEPTION
            'Lecturer % is not assigned to course offering %, so a TA cannot be attached to it',
            p_lecturer_id, p_offering_id
            USING ERRCODE = 'check_violation';
    END IF;

    INSERT INTO academics.lecturer_ta_assignment
        (lecturer_id, ta_id, offering_id, semester_id, responsibility, weekly_hours)
    VALUES
        (p_lecturer_id, p_ta_id, p_offering_id, p_semester_id, p_responsibility, p_weekly_hours)
    RETURNING ta_assignment_id INTO v_id;

    RETURN json_build_object(
        'ta_assignment_id', v_id,
        'lecturer_id',      p_lecturer_id,
        'ta_id',            p_ta_id,
        'offering_id',      p_offering_id,
        'semester_id',      p_semester_id,
        'weekly_hours',     p_weekly_hours,
        'responsibility',   p_responsibility,
        'assigned_on',      CURRENT_DATE);
END;
$$;


--
-- Name: FUNCTION fn_assign_ta_to_lecturer(p_lecturer_id integer, p_ta_id integer, p_semester_id integer, p_offering_id integer, p_responsibility character varying, p_weekly_hours smallint); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_assign_ta_to_lecturer(p_lecturer_id integer, p_ta_id integer, p_semester_id integer, p_offering_id integer, p_responsibility character varying, p_weekly_hours smallint) IS 'FUNCTIONALITY 5 - assigns a teaching assistant to a lecturer, guarding the TA''s weekly hour cap.';


--
-- Name: fn_class_list_json(integer); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_class_list_json(p_offering_id integer) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT json_build_object(
        'offering_id',  o.offering_id,
        'course_code',  c.course_code,
        'course_title', c.title,
        'section',      o.section,
        'semester',     sem.name,
        'academic_year',ay.name,
        'capacity',     o.capacity,
        'enrolled_count', (SELECT COUNT(*) FROM academics.enrollment e
                           WHERE e.offering_id = o.offering_id AND e.status <> 'dropped'),
        'students', COALESCE((
            SELECT json_agg(json_build_object(
                       'student_id',     s.student_id,
                       'student_number', s.student_number,
                       'full_name',      TRIM(pr.first_name || ' ' || pr.last_name),
                       'email',          pr.email,
                       'level',          s.current_level,
                       'status',         e.status,
                       'letter_grade',   e.letter_grade)
                   ORDER BY s.student_number)
            FROM   academics.enrollment e
            JOIN   people.student s ON s.student_id = e.student_id
            JOIN   people.person pr ON pr.person_id = s.person_id
            WHERE  e.offering_id = o.offering_id AND e.status <> 'dropped'
        ), '[]'::json)
    )
    FROM   academics.course_offering o
    JOIN   academics.course c    ON c.course_id     = o.course_id
    JOIN   core.semester sem     ON sem.semester_id = o.semester_id
    JOIN   core.academic_year ay ON ay.academic_year_id = sem.academic_year_id
    WHERE  o.offering_id = p_offering_id;
$$;


--
-- Name: FUNCTION fn_class_list_json(p_offering_id integer); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_class_list_json(p_offering_id integer) IS 'FUNCTIONALITY 3 - the class register for one course offering.';


--
-- Name: fn_drop_enrollment(integer, integer); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_drop_enrollment(p_student_id integer, p_offering_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INTEGER;
BEGIN
    UPDATE academics.enrollment
    SET    status = 'dropped', dropped_on = CURRENT_DATE
    WHERE  student_id = p_student_id
      AND  offering_id = p_offering_id
      AND  status = 'enrolled'
    RETURNING enrollment_id INTO v_id;

    IF v_id IS NULL THEN
        RAISE EXCEPTION 'No active registration found for student % on offering %',
            p_student_id, p_offering_id
            USING ERRCODE = 'no_data_found';
    END IF;

    RETURN json_build_object('enrollment_id', v_id, 'status', 'dropped',
                             'dropped_on', CURRENT_DATE);
END;
$$;


--
-- Name: FUNCTION fn_drop_enrollment(p_student_id integer, p_offering_id integer); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_drop_enrollment(p_student_id integer, p_offering_id integer) IS 'FUNCTIONALITY 3 - withdraws a student from a course offering.';


--
-- Name: fn_enroll_student(integer, integer, boolean); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_enroll_student(p_student_id integer, p_offering_id integer, p_is_retake boolean DEFAULT false) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_enrollment_id INTEGER;
    v_course        TEXT;
BEGIN
    -- The BEFORE INSERT trigger enforces capacity, open registration and
    -- student standing; here we only add the friendly duplicate check.
    IF EXISTS (SELECT 1 FROM academics.enrollment
               WHERE student_id = p_student_id AND offering_id = p_offering_id) THEN
        RAISE EXCEPTION 'Student % is already registered for offering %',
            p_student_id, p_offering_id
            USING ERRCODE = 'unique_violation';
    END IF;

    INSERT INTO academics.enrollment (student_id, offering_id, is_retake)
    VALUES (p_student_id, p_offering_id, p_is_retake)
    RETURNING enrollment_id INTO v_enrollment_id;

    SELECT c.course_code || ' - ' || c.title
    INTO   v_course
    FROM   academics.course_offering o
    JOIN   academics.course c ON c.course_id = o.course_id
    WHERE  o.offering_id = p_offering_id;

    RETURN json_build_object(
        'enrollment_id', v_enrollment_id,
        'student_id',    p_student_id,
        'offering_id',   p_offering_id,
        'course',        v_course,
        'status',        'enrolled',
        'enrolled_on',   CURRENT_DATE);
END;
$$;


--
-- Name: FUNCTION fn_enroll_student(p_student_id integer, p_offering_id integer, p_is_retake boolean); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_enroll_student(p_student_id integer, p_offering_id integer, p_is_retake boolean) IS 'FUNCTIONALITY 3 - registers a student for a course offering.';


--
-- Name: fn_lecturer_workload_json(integer, integer); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_lecturer_workload_json(p_lecturer_id integer, p_semester_id integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT json_build_object(
        'lecturer_id',   l.lecturer_id,
        'staff_number',  l.staff_number,
        'full_name',     TRIM(COALESCE(pr.title || ' ', '') || pr.first_name || ' ' || pr.last_name),
        'academic_rank', l.academic_rank,
        'email',         pr.email,
        'department',    d.name,
        'total_courses', (SELECT COUNT(*) FROM academics.lecturer_course_assignment a
                          JOIN academics.course_offering o2 ON o2.offering_id = a.offering_id
                          WHERE a.lecturer_id = l.lecturer_id AND a.is_active
                            AND (p_semester_id IS NULL OR o2.semester_id = p_semester_id)),
        'total_contact_hours', COALESCE((
                          SELECT SUM(a.contact_hours_per_week)
                          FROM academics.lecturer_course_assignment a
                          JOIN academics.course_offering o2 ON o2.offering_id = a.offering_id
                          WHERE a.lecturer_id = l.lecturer_id AND a.is_active
                            AND (p_semester_id IS NULL OR o2.semester_id = p_semester_id)), 0),
        'courses', COALESCE((
            SELECT json_agg(json_build_object(
                       'assignment_id',  a.assignment_id,
                       'offering_id',    o.offering_id,
                       'course_code',    c.course_code,
                       'course_title',   c.title,
                       'credit_hours',   c.credit_hours,
                       'section',        o.section,
                       'teaching_role',  a.teaching_role,
                       'contact_hours',  a.contact_hours_per_week,
                       'venue',          o.venue,
                       'meeting_days',   o.meeting_days,
                       'semester',       sem.name,
                       'enrolled_count', (SELECT COUNT(*) FROM academics.enrollment e
                                          WHERE e.offering_id = o.offering_id AND e.status <> 'dropped'),
                       'teaching_assistants', COALESCE((
                            SELECT json_agg(json_build_object(
                                       'ta_id',      t.ta_id,
                                       'ta_code',    t.ta_code,
                                       'full_name',  TRIM(tp.first_name || ' ' || tp.last_name),
                                       'ta_type',    t.ta_type,
                                       'responsibility', lta.responsibility,
                                       'weekly_hours',   lta.weekly_hours)
                                   ORDER BY t.ta_code)
                            FROM academics.lecturer_ta_assignment lta
                            JOIN people.teaching_assistant t ON t.ta_id = lta.ta_id
                            JOIN people.person tp ON tp.person_id = t.person_id
                            WHERE lta.offering_id = o.offering_id
                              AND lta.lecturer_id = l.lecturer_id
                              AND lta.is_active), '[]'::json)
                   ) ORDER BY c.course_code)
            FROM   academics.lecturer_course_assignment a
            JOIN   academics.course_offering o ON o.offering_id = a.offering_id
            JOIN   academics.course c          ON c.course_id   = o.course_id
            JOIN   core.semester sem           ON sem.semester_id = o.semester_id
            WHERE  a.lecturer_id = l.lecturer_id AND a.is_active
              AND  (p_semester_id IS NULL OR o.semester_id = p_semester_id)
        ), '[]'::json)
    )
    FROM   people.lecturer l
    JOIN   people.person pr    ON pr.person_id    = l.person_id
    JOIN   core.department d   ON d.department_id = l.department_id
    WHERE  l.lecturer_id = p_lecturer_id;
$$;


--
-- Name: FUNCTION fn_lecturer_workload_json(p_lecturer_id integer, p_semester_id integer); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_lecturer_workload_json(p_lecturer_id integer, p_semester_id integer) IS 'FUNCTIONALITY 4 & 5 - a lecturer''s courses, contact hours and the TAs assigned to each course.';


--
-- Name: fn_student_enrollments_json(integer, integer); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_student_enrollments_json(p_student_id integer, p_semester_id integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(json_agg(x ORDER BY x->>'course_code'), '[]'::json)
    FROM (
        SELECT json_build_object(
                   'enrollment_id', e.enrollment_id,
                   'offering_id',   o.offering_id,
                   'course_code',   c.course_code,
                   'course_title',  c.title,
                   'credit_hours',  c.credit_hours,
                   'section',       o.section,
                   'venue',         o.venue,
                   'meeting_days',  o.meeting_days,
                   'start_time',    o.start_time,
                   'end_time',      o.end_time,
                   'semester',      sem.name,
                   'academic_year', ay.name,
                   'status',        e.status,
                   'is_retake',     e.is_retake,
                   'enrolled_on',   e.enrolled_on,
                   'final_score',   e.final_score,
                   'letter_grade',  e.letter_grade,
                   'grade_point',   e.grade_point,
                   'lecturer',      (
                       SELECT TRIM(p2.first_name || ' ' || p2.last_name)
                       FROM   academics.lecturer_course_assignment lca
                       JOIN   people.lecturer l ON l.lecturer_id = lca.lecturer_id
                       JOIN   people.person   p2 ON p2.person_id = l.person_id
                       WHERE  lca.offering_id = o.offering_id
                         AND  lca.teaching_role = 'lead_lecturer'
                         AND  lca.is_active
                       LIMIT 1)
               ) AS x
        FROM   academics.enrollment e
        JOIN   academics.course_offering o ON o.offering_id = e.offering_id
        JOIN   academics.course c          ON c.course_id   = o.course_id
        JOIN   core.semester sem           ON sem.semester_id = o.semester_id
        JOIN   core.academic_year ay       ON ay.academic_year_id = sem.academic_year_id
        WHERE  e.student_id = p_student_id
          AND  (p_semester_id IS NULL OR o.semester_id = p_semester_id)
    ) q;
$$;


--
-- Name: FUNCTION fn_student_enrollments_json(p_student_id integer, p_semester_id integer); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_student_enrollments_json(p_student_id integer, p_semester_id integer) IS 'FUNCTIONALITY 3 - a student''s registered courses with lecturer and timetable, as JSON.';


--
-- Name: fn_ta_assignments_json(integer, integer); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_ta_assignments_json(p_semester_id integer DEFAULT NULL::integer, p_lecturer_id integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(json_agg(x ORDER BY x->>'lecturer', x->>'ta_code'), '[]'::json)
    FROM (
        SELECT json_build_object(
                   'ta_assignment_id', lta.ta_assignment_id,
                   'lecturer_id',      l.lecturer_id,
                   'lecturer',         TRIM(COALESCE(lp.title || ' ', '') ||
                                       lp.first_name || ' ' || lp.last_name),
                   'lecturer_rank',    l.academic_rank,
                   'ta_id',            t.ta_id,
                   'ta_code',          t.ta_code,
                   'ta_name',          TRIM(tp.first_name || ' ' || tp.last_name),
                   'ta_type',          t.ta_type,
                   'ta_email',         tp.email,
                   'course_code',      c.course_code,
                   'course_title',     c.title,
                   'offering_id',      lta.offering_id,
                   'semester',         sem.name,
                   'academic_year',    ay.name,
                   'responsibility',   lta.responsibility,
                   'weekly_hours',     lta.weekly_hours,
                   'assigned_on',      lta.assigned_on,
                   'is_active',        lta.is_active
               ) AS x
        FROM   academics.lecturer_ta_assignment lta
        JOIN   people.lecturer l  ON l.lecturer_id = lta.lecturer_id
        JOIN   people.person   lp ON lp.person_id  = l.person_id
        JOIN   people.teaching_assistant t ON t.ta_id = lta.ta_id
        JOIN   people.person   tp ON tp.person_id  = t.person_id
        JOIN   core.semester  sem ON sem.semester_id = lta.semester_id
        JOIN   core.academic_year ay ON ay.academic_year_id = sem.academic_year_id
        LEFT   JOIN academics.course_offering o ON o.offering_id = lta.offering_id
        LEFT   JOIN academics.course c          ON c.course_id   = o.course_id
        WHERE  (p_semester_id IS NULL OR lta.semester_id = p_semester_id)
          AND  (p_lecturer_id IS NULL OR lta.lecturer_id = p_lecturer_id)
    ) q;
$$;


--
-- Name: FUNCTION fn_ta_assignments_json(p_semester_id integer, p_lecturer_id integer); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_ta_assignments_json(p_semester_id integer, p_lecturer_id integer) IS 'FUNCTIONALITY 5 - every lecturer-to-TA assignment as a JSON array.';


--
-- Name: fn_validate_enrollment(); Type: FUNCTION; Schema: academics; Owner: -
--

CREATE FUNCTION academics.fn_validate_enrollment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_capacity  SMALLINT;
    v_enrolled  INTEGER;
    v_is_open   BOOLEAN;
    v_status    core.student_status_type;
BEGIN
    -- 1. The student must be in good standing.
    SELECT s.status INTO v_status
    FROM   people.student s WHERE s.student_id = NEW.student_id;

    IF v_status <> 'active' THEN
        RAISE EXCEPTION
            'Student % is % and cannot register for courses', NEW.student_id, v_status
            USING ERRCODE = 'check_violation';
    END IF;

    -- 2. Registration must still be open, and the class must not be full.
    SELECT o.capacity, o.is_open_for_registration
    INTO   v_capacity, v_is_open
    FROM   academics.course_offering o
    WHERE  o.offering_id = NEW.offering_id;

    IF NOT v_is_open THEN
        RAISE EXCEPTION
            'Registration is closed for course offering %', NEW.offering_id
            USING ERRCODE = 'check_violation';
    END IF;

    SELECT COUNT(*) INTO v_enrolled
    FROM   academics.enrollment e
    WHERE  e.offering_id = NEW.offering_id
      AND  e.status IN ('enrolled','completed','failed','deferred');

    IF v_enrolled >= v_capacity THEN
        RAISE EXCEPTION
            'Course offering % is full (capacity %)', NEW.offering_id, v_capacity
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION fn_validate_enrollment(); Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON FUNCTION academics.fn_validate_enrollment() IS 'Blocks registration when the student is inactive, registration is closed, or the class is full.';


--
-- Name: fn_dashboard_stats_json(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.fn_dashboard_stats_json() RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT json_build_object(
        'students',       (SELECT COUNT(*) FROM people.student  WHERE status = 'active'),
        'lecturers',      (SELECT COUNT(*) FROM people.lecturer WHERE status = 'active'),
        'teaching_assistants', (SELECT COUNT(*) FROM people.teaching_assistant WHERE status = 'active'),
        'courses',        (SELECT COUNT(*) FROM academics.course WHERE is_active),
        'offerings_this_semester', (SELECT COUNT(*) FROM academics.course_offering o
                                    JOIN core.semester s ON s.semester_id = o.semester_id
                                    WHERE s.is_current),
        'enrollments',    (SELECT COUNT(*) FROM academics.enrollment WHERE status <> 'dropped'),
        'fees',           finance.fn_fees_summary_json(
                              (SELECT academic_year_id FROM core.academic_year WHERE is_current)),
        'generated_at',   CURRENT_TIMESTAMP);
$$;


--
-- Name: FUNCTION fn_dashboard_stats_json(); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.fn_dashboard_stats_json() IS 'Headline counters for the dashboard landing page.';


--
-- Name: fn_register_user(character varying, character varying, character varying, core.app_role_type, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.fn_register_user(p_username character varying, p_email character varying, p_password_hash character varying, p_role core.app_role_type DEFAULT 'student'::core.app_role_type, p_person_id integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_user_id INTEGER;
BEGIN
    IF EXISTS (SELECT 1 FROM app.app_user WHERE lower(username) = lower(p_username)) THEN
        RAISE EXCEPTION 'Username % is already taken', p_username
            USING ERRCODE = 'unique_violation';
    END IF;

    IF EXISTS (SELECT 1 FROM app.app_user WHERE lower(email) = lower(p_email)) THEN
        RAISE EXCEPTION 'E-mail % is already registered', p_email
            USING ERRCODE = 'unique_violation';
    END IF;

    INSERT INTO app.app_user (username, email, password_hash, role, person_id)
    VALUES (p_username, lower(p_email), p_password_hash, p_role, p_person_id)
    RETURNING user_id INTO v_user_id;

    INSERT INTO app.audit_log (user_id, action, entity, entity_id, details)
    VALUES (v_user_id, 'REGISTER', 'app_user', v_user_id::TEXT,
            json_build_object('role', p_role, 'email', lower(p_email))::jsonb);

    RETURN json_build_object(
        'user_id',  v_user_id,
        'username', p_username,
        'email',    lower(p_email),
        'role',     p_role,
        'created',  TRUE);
END;
$$;


--
-- Name: FUNCTION fn_register_user(p_username character varying, p_email character varying, p_password_hash character varying, p_role core.app_role_type, p_person_id integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.fn_register_user(p_username character varying, p_email character varying, p_password_hash character varying, p_role core.app_role_type, p_person_id integer) IS 'Creates a login account. The password is hashed by the application; the plain text never reaches the database.';


--
-- Name: fn_user_context_json(integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.fn_user_context_json(p_user_id integer) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_result json;
BEGIN
    SELECT json_build_object(
        'user_id',   u.user_id,
        'username',  u.username,
        'email',     u.email,
        'role',      u.role,
        'is_active', u.is_active,
        'last_login_at', u.last_login_at,
        'person', CASE WHEN pr.person_id IS NULL THEN NULL ELSE json_build_object(
                        'person_id',  pr.person_id,
                        'full_name',  TRIM(pr.first_name || ' ' ||
                                      COALESCE(pr.middle_name || ' ', '') || pr.last_name),
                        'first_name', pr.first_name,
                        'last_name',  pr.last_name,
                        'phone',      pr.phone) END,
        'student', CASE WHEN s.student_id IS NULL THEN NULL ELSE json_build_object(
                        'student_id',     s.student_id,
                        'student_number', s.student_number,
                        'level',          s.current_level,
                        'programme',      pg.name,
                        'status',         s.status,
                        'outstanding_balance',
                             finance.fn_student_outstanding_balance(s.student_id)) END,
        'lecturer', CASE WHEN l.lecturer_id IS NULL THEN NULL ELSE json_build_object(
                        'lecturer_id',  l.lecturer_id,
                        'staff_number', l.staff_number,
                        'academic_rank',l.academic_rank) END,
        'teaching_assistant', CASE WHEN ta.ta_id IS NULL THEN NULL ELSE json_build_object(
                        'ta_id',   ta.ta_id,
                        'ta_code', ta.ta_code,
                        'ta_type', ta.ta_type) END
    )
    INTO v_result
    FROM   app.app_user u
    LEFT   JOIN people.person  pr ON pr.person_id  = u.person_id
    LEFT   JOIN people.student s  ON s.person_id   = pr.person_id
    LEFT   JOIN core.programme pg ON pg.programme_id = s.programme_id
    LEFT   JOIN people.lecturer l ON l.person_id   = pr.person_id
    LEFT   JOIN people.teaching_assistant ta ON ta.person_id = pr.person_id
    WHERE  u.user_id = p_user_id;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'User % does not exist', p_user_id
            USING ERRCODE = 'no_data_found';
    END IF;

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION fn_user_context_json(p_user_id integer); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.fn_user_context_json(p_user_id integer) IS 'Everything the dashboard needs about the signed-in user, resolved across role tables.';


--
-- Name: fn_set_updated_at(); Type: FUNCTION; Schema: core; Owner: -
--

CREATE FUNCTION core.fn_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


--
-- Name: FUNCTION fn_set_updated_at(); Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON FUNCTION core.fn_set_updated_at() IS 'BEFORE UPDATE trigger: stamps updated_at with the current transaction time.';


--
-- Name: fn_fees_summary_json(integer); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_fees_summary_json(p_academic_year_id integer DEFAULT NULL::integer) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    WITH per_student AS (
        SELECT b.student_id,
               SUM(b.total_amount) AS billed,
               COALESCE(SUM((SELECT SUM(p.amount) FROM finance.payment p
                             WHERE p.bill_id = b.bill_id AND p.status = 'confirmed')), 0) AS paid
        FROM   finance.student_bill b
        WHERE  b.status <> 'cancelled'
          AND  (p_academic_year_id IS NULL OR b.academic_year_id = p_academic_year_id)
        GROUP  BY b.student_id
    )
    SELECT json_build_object(
        'students_billed',        COUNT(*),
        'total_billed',           ROUND(COALESCE(SUM(billed), 0), 2),
        'total_collected',        ROUND(COALESCE(SUM(paid), 0), 2),
        'total_outstanding',      ROUND(COALESCE(SUM(billed - paid), 0), 2),
        'collection_rate_percent',CASE WHEN COALESCE(SUM(billed), 0) > 0
                                       THEN ROUND(100.0 * SUM(paid) / SUM(billed), 2)
                                       ELSE 0.00 END,
        'fully_paid_students',    COUNT(*) FILTER (WHERE billed - paid <= 0),
        'indebted_students',      COUNT(*) FILTER (WHERE billed - paid > 0),
        'generated_at',           CURRENT_TIMESTAMP
    )
    FROM per_student;
$$;


--
-- Name: FUNCTION fn_fees_summary_json(p_academic_year_id integer); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_fees_summary_json(p_academic_year_id integer) IS 'Aggregate fee collection statistics for the department dashboard.';


--
-- Name: fn_generate_student_bill(integer, integer, date, date); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_generate_student_bill(p_student_id integer, p_academic_year_id integer, p_due_date date DEFAULT NULL::date, p_issued_on date DEFAULT NULL::date) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_structure_id INTEGER;
    v_bill_id      INTEGER;
    v_reference    VARCHAR(30);
    v_level        SMALLINT;
    v_programme    INTEGER;
    v_residency    core.residential_status_type;
    v_due          DATE;
    v_issued       DATE;
    v_year_start   DATE;
BEGIN
    SELECT s.current_level, s.programme_id, s.residential_status
    INTO   v_level, v_programme, v_residency
    FROM   people.student s WHERE s.student_id = p_student_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
            USING ERRCODE = 'no_data_found';
    END IF;

    SELECT fs.fee_structure_id INTO v_structure_id
    FROM   finance.fee_structure fs
    WHERE  fs.programme_id       = v_programme
      AND  fs.academic_year_id   = p_academic_year_id
      AND  fs.level              = v_level
      AND  fs.residential_status = v_residency
      AND  fs.is_active;

    IF v_structure_id IS NULL THEN
        RAISE EXCEPTION
            'No active fee structure for programme %, level %, year %, residency %',
            v_programme, v_level, p_academic_year_id, v_residency
            USING ERRCODE = 'no_data_found';
    END IF;

    -- Bills belong to the academic year they charge for, not to the day the
    -- script happens to run, so the issue date defaults to the first day of
    -- that academic year. This keeps issued_on <= due_date true whenever the
    -- database is rebuilt, however long after the session that happens.
    SELECT ay.start_date, 'BILL-' || REPLACE(ay.name, '/', '') || '-' ||
           LPAD(p_student_id::TEXT, 5, '0')
    INTO   v_year_start, v_reference
    FROM   core.academic_year ay
    WHERE  ay.academic_year_id = p_academic_year_id;

    v_issued := COALESCE(p_issued_on, v_year_start, CURRENT_DATE);
    v_due    := COALESCE(p_due_date, v_issued + 60);

    IF v_due < v_issued THEN
        RAISE EXCEPTION 'Due date % cannot fall before the issue date %', v_due, v_issued
            USING ERRCODE = 'check_violation';
    END IF;

    INSERT INTO finance.student_bill
        (bill_reference, student_id, academic_year_id, fee_structure_id,
         issued_on, due_date, status)
    VALUES
        (v_reference, p_student_id, p_academic_year_id, v_structure_id,
         v_issued, v_due, 'issued')
    ON CONFLICT (student_id, academic_year_id) DO NOTHING
    RETURNING bill_id INTO v_bill_id;

    IF v_bill_id IS NULL THEN
        SELECT bill_id INTO v_bill_id
        FROM   finance.student_bill
        WHERE  student_id = p_student_id AND academic_year_id = p_academic_year_id;

        RETURN json_build_object(
            'created', FALSE,
            'bill_id', v_bill_id,
            'message', 'A bill already exists for this student and academic year.');
    END IF;

    -- Copy the price list onto the bill so later price changes cannot rewrite it.
    INSERT INTO finance.bill_line (bill_id, fee_item_id, description, category, amount)
    SELECT v_bill_id, fi.fee_item_id, fi.item_name, fi.category, fi.amount
    FROM   finance.fee_item fi
    WHERE  fi.fee_structure_id = v_structure_id
      AND  fi.is_mandatory;

    RETURN json_build_object(
        'created',      TRUE,
        'bill_id',      v_bill_id,
        'bill_reference', v_reference,
        'total_amount', (SELECT ROUND(total_amount, 2) FROM finance.student_bill WHERE bill_id = v_bill_id),
        'due_date',     v_due);
END;
$$;


--
-- Name: FUNCTION fn_generate_student_bill(p_student_id integer, p_academic_year_id integer, p_due_date date, p_issued_on date); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_generate_student_bill(p_student_id integer, p_academic_year_id integer, p_due_date date, p_issued_on date) IS 'Creates a student bill for an academic year by copying the matching fee structure onto bill lines.';


--
-- Name: fn_outstanding_fees_json(integer, integer, boolean); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_outstanding_fees_json(p_academic_year_id integer DEFAULT NULL::integer, p_programme_id integer DEFAULT NULL::integer, p_only_indebted boolean DEFAULT false) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_result json;
BEGIN
    WITH bill_payment AS (
        -- Step 1: collapse each bill to (billed, confirmed paid, last payment).
        SELECT b.bill_id,
               b.student_id,
               b.bill_reference,
               b.academic_year_id,
               b.total_amount,
               b.currency,
               b.due_date,
               b.status,
               COALESCE(SUM(p.amount) FILTER (WHERE p.status = 'confirmed'), 0)  AS paid,
               MAX(p.payment_date)    FILTER (WHERE p.status = 'confirmed')      AS last_payment_date,
               COUNT(p.payment_id)    FILTER (WHERE p.status = 'confirmed')      AS confirmed_payment_count
        FROM   finance.student_bill b
        LEFT   JOIN finance.payment p ON p.bill_id = b.bill_id
        WHERE  b.status <> 'cancelled'
          AND  (p_academic_year_id IS NULL OR b.academic_year_id = p_academic_year_id)
        GROUP  BY b.bill_id
    ),
    student_totals AS (
        -- Step 2: roll the bills up to the student and build the nested array.
        -- LEFT JOIN keeps students who have never been billed (balance 0).
        SELECT s.student_id,
               s.student_number,
               s.current_level,
               s.status                                        AS student_status,
               s.residential_status,
               pr.first_name,
               pr.middle_name,
               pr.last_name,
               pr.email,
               pr.phone,
               pg.name                                         AS programme_name,
               pg.code                                         AS programme_code,
               COALESCE(MAX(bp.currency), 'GHS')               AS currency,
               COALESCE(SUM(bp.total_amount), 0)               AS total_billed,
               COALESCE(SUM(bp.paid), 0)                       AS total_paid,
               COALESCE(SUM(bp.total_amount), 0)
                 - COALESCE(SUM(bp.paid), 0)                   AS outstanding_balance,
               MAX(bp.last_payment_date)                       AS last_payment_date,
               COUNT(bp.bill_id)                               AS bill_count,
               COALESCE(
                   json_agg(
                       json_build_object(
                           'bill_id',             bp.bill_id,
                           'bill_reference',      bp.bill_reference,
                           'academic_year',       ay.name,
                           'amount_billed',       ROUND(bp.total_amount, 2),
                           'amount_paid',         ROUND(bp.paid, 2),
                           'balance',             ROUND(bp.total_amount - bp.paid, 2),
                           'due_date',            bp.due_date,
                           'bill_status',         bp.status,
                           'payments_recorded',   bp.confirmed_payment_count,
                           'is_overdue',          (bp.total_amount - bp.paid) > 0
                                                  AND bp.due_date < CURRENT_DATE
                       )
                       ORDER BY ay.start_date DESC
                   ) FILTER (WHERE bp.bill_id IS NOT NULL),
                   '[]'::json
               )                                               AS bills
        FROM   people.student s
        JOIN   people.person    pr ON pr.person_id    = s.person_id
        JOIN   core.programme   pg ON pg.programme_id = s.programme_id
        LEFT   JOIN bill_payment bp ON bp.student_id  = s.student_id
        LEFT   JOIN core.academic_year ay ON ay.academic_year_id = bp.academic_year_id
        WHERE  (p_programme_id IS NULL OR s.programme_id = p_programme_id)
        GROUP  BY s.student_id, pr.person_id, pg.programme_id
    )
    -- Step 3: shape the final array.
    SELECT COALESCE(
               json_agg(
                   json_build_object(
                       'student_id',          t.student_id,
                       'student_number',      t.student_number,
                       'full_name',           TRIM(BOTH ' ' FROM
                                                 t.first_name || ' ' ||
                                                 COALESCE(t.middle_name || ' ', '') ||
                                                 t.last_name),
                       'email',               t.email,
                       'phone',               t.phone,
                       'programme',           t.programme_name,
                       'programme_code',      t.programme_code,
                       'level',               t.current_level,
                       'student_status',      t.student_status,
                       'residential_status',  t.residential_status,
                       'currency',            t.currency,
                       'total_billed',        ROUND(t.total_billed, 2),
                       'total_paid',          ROUND(t.total_paid, 2),
                       'outstanding_balance', ROUND(t.outstanding_balance, 2),
                       'percentage_paid',     CASE
                                                  WHEN t.total_billed > 0
                                                  THEN ROUND(100.0 * t.total_paid / t.total_billed, 2)
                                                  ELSE 0.00
                                              END,
                       'payment_status',      CASE
                                                  WHEN t.total_billed = 0            THEN 'NOT BILLED'
                                                  WHEN t.outstanding_balance <= 0    THEN 'FULLY PAID'
                                                  WHEN t.total_paid = 0              THEN 'NO PAYMENT'
                                                  ELSE 'PART PAID'
                                              END,
                       'last_payment_date',   t.last_payment_date,
                       'bill_count',          t.bill_count,
                       'bills',               t.bills
                   )
                   ORDER BY t.outstanding_balance DESC, t.student_number
               ),
               '[]'::json
           )
    INTO   v_result
    FROM   student_totals t
    WHERE  (NOT p_only_indebted OR t.outstanding_balance > 0);

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION fn_outstanding_fees_json(p_academic_year_id integer, p_programme_id integer, p_only_indebted boolean); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_outstanding_fees_json(p_academic_year_id integer, p_programme_id integer, p_only_indebted boolean) IS 'REQUIRED DELIVERABLE: outstanding fees for each student, returned as a JSON array. Outstanding = total billed - confirmed payments. Optional filters: academic year, programme, indebted-only.';


--
-- Name: fn_record_payment(integer, integer, numeric, core.payment_method_type, character varying, character varying, character varying, date); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_record_payment(p_student_id integer, p_bill_id integer, p_amount numeric, p_method core.payment_method_type, p_channel character varying DEFAULT NULL::character varying, p_transaction_ref character varying DEFAULT NULL::character varying, p_received_by character varying DEFAULT 'Online Portal'::character varying, p_payment_date date DEFAULT NULL::date) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_payment_id INTEGER;
    v_receipt    VARCHAR(30);
    v_balance    NUMERIC(12,2);
    v_bill_owner INTEGER;
BEGIN
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Payment amount must be greater than zero'
            USING ERRCODE = 'check_violation';
    END IF;

    SELECT student_id INTO v_bill_owner
    FROM   finance.student_bill WHERE bill_id = p_bill_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Bill % does not exist', p_bill_id
            USING ERRCODE = 'no_data_found';
    END IF;

    IF v_bill_owner <> p_student_id THEN
        RAISE EXCEPTION 'Bill % does not belong to student %', p_bill_id, p_student_id
            USING ERRCODE = 'check_violation';
    END IF;

    -- Receipt numbers are unique and human readable: RCPT-<year><seq>
    v_receipt := 'RCPT-' || TO_CHAR(CURRENT_DATE, 'YYYY') || '-' ||
                 LPAD(NEXTVAL('finance.receipt_seq')::TEXT, 6, '0');

    INSERT INTO finance.payment
        (receipt_number, student_id, bill_id, amount, payment_date,
         payment_method, bank_or_channel, transaction_ref, status, received_by)
    VALUES
        (v_receipt, p_student_id, p_bill_id, ROUND(p_amount, 2),
         COALESCE(p_payment_date, CURRENT_DATE),
         p_method, p_channel, p_transaction_ref, 'confirmed', p_received_by)
    RETURNING payment_id INTO v_payment_id;

    v_balance := finance.fn_student_outstanding_balance(p_student_id);

    RETURN json_build_object(
        'payment_id',          v_payment_id,
        'receipt_number',      v_receipt,
        'amount',              ROUND(p_amount, 2),
        'student_id',          p_student_id,
        'bill_id',             p_bill_id,
        'outstanding_balance', v_balance,
        'recorded_at',         CURRENT_TIMESTAMP);
END;
$$;


--
-- Name: FUNCTION fn_record_payment(p_student_id integer, p_bill_id integer, p_amount numeric, p_method core.payment_method_type, p_channel character varying, p_transaction_ref character varying, p_received_by character varying, p_payment_date date); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_record_payment(p_student_id integer, p_bill_id integer, p_amount numeric, p_method core.payment_method_type, p_channel character varying, p_transaction_ref character varying, p_received_by character varying, p_payment_date date) IS 'Records a confirmed fee payment against a bill and returns the receipt plus the new balance.';


--
-- Name: fn_refresh_bill_status(); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_refresh_bill_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_bill_id INTEGER := COALESCE(NEW.bill_id, OLD.bill_id);
    v_total   NUMERIC(12,2);
    v_paid    NUMERIC(12,2);
    v_due     DATE;
    v_status  core.bill_status_type;
BEGIN
    SELECT b.total_amount, b.due_date
    INTO   v_total, v_due
    FROM   finance.student_bill b
    WHERE  b.bill_id = v_bill_id;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;

    SELECT COALESCE(SUM(p.amount), 0)
    INTO   v_paid
    FROM   finance.payment p
    WHERE  p.bill_id = v_bill_id
      AND  p.status  = 'confirmed';

    v_status := CASE
        WHEN v_paid >= v_total AND v_total > 0     THEN 'paid'
        WHEN v_paid > 0  AND v_due < CURRENT_DATE  THEN 'overdue'
        WHEN v_paid > 0                            THEN 'part_paid'
        WHEN v_due < CURRENT_DATE                  THEN 'overdue'
        ELSE 'issued'
    END;

    -- Never overwrite a manually cancelled or still-draft bill.
    UPDATE finance.student_bill
    SET    status = v_status
    WHERE  bill_id = v_bill_id
      AND  status NOT IN ('cancelled','draft')
      AND  status IS DISTINCT FROM v_status;

    RETURN NULL;
END;
$$;


--
-- Name: FUNCTION fn_refresh_bill_status(); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_refresh_bill_status() IS 'Recalculates student_bill.status from confirmed payments and the due date.';


--
-- Name: fn_refresh_bill_total(); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_refresh_bill_total() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_bill_id INTEGER := COALESCE(NEW.bill_id, OLD.bill_id);
BEGIN
    UPDATE finance.student_bill b
    SET    total_amount = COALESCE(
               (SELECT SUM(l.amount) FROM finance.bill_line l WHERE l.bill_id = v_bill_id),
               0)
    WHERE  b.bill_id = v_bill_id;

    RETURN NULL;   -- AFTER trigger, return value ignored
END;
$$;


--
-- Name: FUNCTION fn_refresh_bill_total(); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_refresh_bill_total() IS 'Keeps student_bill.total_amount equal to the sum of its bill_line rows.';


--
-- Name: fn_student_fee_statement_json(integer); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_student_fee_statement_json(p_student_id integer) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_result json;
BEGIN
    SELECT json_build_object(
               'student_id',          s.student_id,
               'student_number',      s.student_number,
               'full_name',           TRIM(pr.first_name || ' ' ||
                                       COALESCE(pr.middle_name || ' ', '') || pr.last_name),
               'programme',           pg.name,
               'level',               s.current_level,
               'currency',            'GHS',
               'total_billed',        ROUND(COALESCE(bills.billed, 0), 2),
               'total_paid',          ROUND(COALESCE(bills.paid, 0), 2),
               'outstanding_balance', ROUND(COALESCE(bills.billed, 0) - COALESCE(bills.paid, 0), 2),
               'bills',               COALESCE(bills.detail, '[]'::json),
               'payments',            COALESCE(pay.history, '[]'::json)
           )
    INTO   v_result
    FROM   people.student s
    JOIN   people.person  pr ON pr.person_id    = s.person_id
    JOIN   core.programme pg ON pg.programme_id = s.programme_id
    LEFT   JOIN LATERAL (
        SELECT SUM(b.total_amount) AS billed,
               SUM(COALESCE(c.paid, 0)) AS paid,
               json_agg(
                   json_build_object(
                       'bill_id',        b.bill_id,
                       'bill_reference', b.bill_reference,
                       'academic_year',  ay.name,
                       'issued_on',      b.issued_on,
                       'due_date',       b.due_date,
                       'status',         b.status,
                       'amount_billed',  ROUND(b.total_amount, 2),
                       'amount_paid',    ROUND(COALESCE(c.paid, 0), 2),
                       'balance',        ROUND(b.total_amount - COALESCE(c.paid, 0), 2),
                       'lines', (
                           SELECT COALESCE(json_agg(
                                      json_build_object(
                                          'description', l.description,
                                          'category',    l.category,
                                          'amount',      ROUND(l.amount, 2))
                                      ORDER BY l.bill_line_id), '[]'::json)
                           FROM   finance.bill_line l WHERE l.bill_id = b.bill_id
                       )
                   ) ORDER BY ay.start_date DESC
               ) AS detail
        FROM   finance.student_bill b
        JOIN   core.academic_year ay ON ay.academic_year_id = b.academic_year_id
        LEFT   JOIN LATERAL (
                   SELECT SUM(p.amount) AS paid
                   FROM   finance.payment p
                   WHERE  p.bill_id = b.bill_id AND p.status = 'confirmed'
               ) c ON TRUE
        WHERE  b.student_id = s.student_id AND b.status <> 'cancelled'
    ) bills ON TRUE
    LEFT   JOIN LATERAL (
        SELECT json_agg(
                   json_build_object(
                       'payment_id',     p.payment_id,
                       'receipt_number', p.receipt_number,
                       'amount',         ROUND(p.amount, 2),
                       'payment_date',   p.payment_date,
                       'method',         p.payment_method,
                       'channel',        p.bank_or_channel,
                       'status',         p.status
                   ) ORDER BY p.payment_date DESC, p.payment_id DESC
               ) AS history
        FROM   finance.payment p
        WHERE  p.student_id = s.student_id
    ) pay ON TRUE
    WHERE  s.student_id = p_student_id;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
            USING ERRCODE = 'no_data_found';
    END IF;

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION fn_student_fee_statement_json(p_student_id integer); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_student_fee_statement_json(p_student_id integer) IS 'Full fee statement for one student: bills, their line items, and payment history, as JSON.';


--
-- Name: fn_student_outstanding_balance(integer, integer); Type: FUNCTION; Schema: finance; Owner: -
--

CREATE FUNCTION finance.fn_student_outstanding_balance(p_student_id integer, p_academic_year_id integer DEFAULT NULL::integer) RETURNS numeric
    LANGUAGE sql STABLE
    AS $$
    SELECT ROUND(
             COALESCE(SUM(b.total_amount), 0)
           - COALESCE((
                 SELECT SUM(p.amount)
                 FROM   finance.payment p
                 JOIN   finance.student_bill b2 ON b2.bill_id = p.bill_id
                 WHERE  p.student_id = p_student_id
                   AND  p.status     = 'confirmed'
                   AND  b2.status   <> 'cancelled'
                   AND  (p_academic_year_id IS NULL
                         OR b2.academic_year_id = p_academic_year_id)
             ), 0)
           , 2)
    FROM   finance.student_bill b
    WHERE  b.student_id = p_student_id
      AND  b.status    <> 'cancelled'
      AND  (p_academic_year_id IS NULL OR b.academic_year_id = p_academic_year_id);
$$;


--
-- Name: FUNCTION fn_student_outstanding_balance(p_student_id integer, p_academic_year_id integer); Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON FUNCTION finance.fn_student_outstanding_balance(p_student_id integer, p_academic_year_id integer) IS 'Outstanding fee balance for one student = total billed minus confirmed payments.';


--
-- Name: fn_student_profile_json(integer); Type: FUNCTION; Schema: people; Owner: -
--

CREATE FUNCTION people.fn_student_profile_json(p_student_id integer) RETURNS json
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_result json;
BEGIN
    SELECT json_build_object(
        'student_id',       s.student_id,
        'student_number',   s.student_number,
        'personal', json_build_object(
            'title',            pr.title,
            'first_name',       pr.first_name,
            'middle_name',      pr.middle_name,
            'last_name',        pr.last_name,
            'full_name',        TRIM(pr.first_name || ' ' ||
                                COALESCE(pr.middle_name || ' ', '') || pr.last_name),
            'date_of_birth',    pr.date_of_birth,
            'age',              DATE_PART('year', AGE(pr.date_of_birth))::INT,
            'gender',           pr.gender,
            'marital_status',   pr.marital_status,
            'nationality',      pr.nationality,
            'home_region',      pr.home_region,
            'national_id',      pr.national_id
        ),
        'contact', json_build_object(
            'email',                pr.email,
            'phone',                pr.phone,
            'alt_phone',            pr.alt_phone,
            'postal_address',       pr.postal_address,
            'residential_address',  pr.residential_address
        ),
        'academic', json_build_object(
            'programme',           pg.name,
            'programme_code',      pg.code,
            'department',          d.name,
            'level',               s.current_level,
            'status',              s.status,
            'admission_date',      s.admission_date,
            'expected_completion', s.expected_completion,
            'entry_qualification', s.entry_qualification,
            'cgpa',                s.cgpa,
            'residential_status',  s.residential_status,
            'hall_of_residence',   s.hall_of_residence
        ),
        'next_of_kin', COALESCE((
            SELECT json_agg(json_build_object(
                       'full_name',    n.full_name,
                       'relationship', n.relationship,
                       'phone',        n.phone,
                       'email',        n.email,
                       'occupation',   n.occupation,
                       'is_primary',   n.is_primary)
                   ORDER BY n.is_primary DESC, n.next_of_kin_id)
            FROM people.next_of_kin n WHERE n.student_id = s.student_id
        ), '[]'::json),
        'outstanding_balance', finance.fn_student_outstanding_balance(s.student_id)
    )
    INTO v_result
    FROM   people.student   s
    JOIN   people.person    pr ON pr.person_id    = s.person_id
    JOIN   core.programme   pg ON pg.programme_id = s.programme_id
    JOIN   core.department  d  ON d.department_id = pg.department_id
    WHERE  s.student_id = p_student_id;

    IF v_result IS NULL THEN
        RAISE EXCEPTION 'Student % does not exist', p_student_id
            USING ERRCODE = 'no_data_found';
    END IF;

    RETURN v_result;
END;
$$;


--
-- Name: FUNCTION fn_student_profile_json(p_student_id integer); Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON FUNCTION people.fn_student_profile_json(p_student_id integer) IS 'FUNCTIONALITY 1 - complete personal, contact and academic record of a student as JSON.';


--
-- Name: fn_students_json(integer, smallint, text); Type: FUNCTION; Schema: people; Owner: -
--

CREATE FUNCTION people.fn_students_json(p_programme_id integer DEFAULT NULL::integer, p_level smallint DEFAULT NULL::smallint, p_search text DEFAULT NULL::text) RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(json_agg(x ORDER BY x->>'student_number'), '[]'::json)
    FROM (
        SELECT json_build_object(
                   'student_id',     s.student_id,
                   'student_number', s.student_number,
                   'full_name',      TRIM(pr.first_name || ' ' ||
                                     COALESCE(pr.middle_name || ' ', '') || pr.last_name),
                   'email',          pr.email,
                   'phone',          pr.phone,
                   'gender',         pr.gender,
                   'programme',      pg.name,
                   'level',          s.current_level,
                   'status',         s.status,
                   'cgpa',           s.cgpa,
                   'outstanding_balance', finance.fn_student_outstanding_balance(s.student_id)
               ) AS x
        FROM   people.student s
        JOIN   people.person  pr ON pr.person_id    = s.person_id
        JOIN   core.programme pg ON pg.programme_id = s.programme_id
        WHERE  (p_programme_id IS NULL OR s.programme_id  = p_programme_id)
          AND  (p_level        IS NULL OR s.current_level = p_level)
          AND  (p_search       IS NULL OR
                pr.first_name  ILIKE '%' || p_search || '%' OR
                pr.last_name   ILIKE '%' || p_search || '%' OR
                s.student_number ILIKE '%' || p_search || '%')
    ) q;
$$;


--
-- Name: FUNCTION fn_students_json(p_programme_id integer, p_level smallint, p_search text); Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON FUNCTION people.fn_students_json(p_programme_id integer, p_level smallint, p_search text) IS 'Searchable student directory as a JSON array.';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: course; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.course (
    course_id integer NOT NULL,
    course_code character varying(12) NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    credit_hours smallint NOT NULL,
    level smallint NOT NULL,
    department_id integer NOT NULL,
    is_core boolean DEFAULT true NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT course_credit_ck CHECK (((credit_hours >= 1) AND (credit_hours <= 6))),
    CONSTRAINT course_level_ck CHECK ((level = ANY (ARRAY[100, 200, 300, 400, 500, 600])))
);


--
-- Name: TABLE course; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.course IS 'The course catalogue - a course exists independently of any semester.';


--
-- Name: course_course_id_seq; Type: SEQUENCE; Schema: academics; Owner: -
--

ALTER TABLE academics.course ALTER COLUMN course_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME academics.course_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: course_offering; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.course_offering (
    offering_id integer NOT NULL,
    course_id integer NOT NULL,
    semester_id integer NOT NULL,
    section character varying(5) DEFAULT 'A'::character varying NOT NULL,
    capacity smallint DEFAULT 60 NOT NULL,
    venue character varying(80),
    meeting_days character varying(40),
    start_time time without time zone,
    end_time time without time zone,
    delivery_mode core.delivery_mode_type DEFAULT 'in_person'::core.delivery_mode_type NOT NULL,
    is_open_for_registration boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT course_offering_cap_ck CHECK ((capacity > 0)),
    CONSTRAINT course_offering_time_ck CHECK (((end_time IS NULL) OR (start_time IS NULL) OR (end_time > start_time)))
);


--
-- Name: TABLE course_offering; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.course_offering IS 'A course running in a specific semester and section.';


--
-- Name: course_offering_offering_id_seq; Type: SEQUENCE; Schema: academics; Owner: -
--

ALTER TABLE academics.course_offering ALTER COLUMN offering_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME academics.course_offering_offering_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: course_prerequisite; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.course_prerequisite (
    course_id integer NOT NULL,
    prerequisite_id integer NOT NULL,
    CONSTRAINT prerequisite_not_self_ck CHECK ((course_id <> prerequisite_id))
);


--
-- Name: TABLE course_prerequisite; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.course_prerequisite IS 'Courses that must be passed before enrolling in another course.';


--
-- Name: enrollment; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.enrollment (
    enrollment_id integer NOT NULL,
    student_id integer NOT NULL,
    offering_id integer NOT NULL,
    enrolled_on date DEFAULT CURRENT_DATE NOT NULL,
    status core.enrollment_status_type DEFAULT 'enrolled'::core.enrollment_status_type NOT NULL,
    is_retake boolean DEFAULT false NOT NULL,
    continuous_assessment numeric(5,2),
    exam_score numeric(5,2),
    final_score numeric(5,2),
    letter_grade character varying(2),
    grade_point numeric(3,2),
    dropped_on date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT enrollment_ca_ck CHECK (((continuous_assessment IS NULL) OR ((continuous_assessment >= (0)::numeric) AND (continuous_assessment <= (100)::numeric)))),
    CONSTRAINT enrollment_dropped_ck CHECK ((((status = 'dropped'::core.enrollment_status_type) AND (dropped_on IS NOT NULL)) OR ((status <> 'dropped'::core.enrollment_status_type) AND (dropped_on IS NULL)))),
    CONSTRAINT enrollment_exam_ck CHECK (((exam_score IS NULL) OR ((exam_score >= (0)::numeric) AND (exam_score <= (100)::numeric)))),
    CONSTRAINT enrollment_final_ck CHECK (((final_score IS NULL) OR ((final_score >= (0)::numeric) AND (final_score <= (100)::numeric)))),
    CONSTRAINT enrollment_gp_ck CHECK (((grade_point IS NULL) OR ((grade_point >= (0)::numeric) AND (grade_point <= 4.00)))),
    CONSTRAINT enrollment_grade_ck CHECK (((letter_grade IS NULL) OR ((letter_grade)::text = ANY ((ARRAY['A'::character varying, 'B+'::character varying, 'B'::character varying, 'C+'::character varying, 'C'::character varying, 'D+'::character varying, 'D'::character varying, 'E'::character varying, 'F'::character varying, 'I'::character varying, 'X'::character varying])::text[]))))
);


--
-- Name: TABLE enrollment; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.enrollment IS 'FUNCTIONALITY 3 - resolves the many-to-many between students and course offerings.';


--
-- Name: enrollment_enrollment_id_seq; Type: SEQUENCE; Schema: academics; Owner: -
--

ALTER TABLE academics.enrollment ALTER COLUMN enrollment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME academics.enrollment_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lecturer_course_assignment; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.lecturer_course_assignment (
    assignment_id integer NOT NULL,
    lecturer_id integer NOT NULL,
    offering_id integer NOT NULL,
    teaching_role core.teaching_role_type DEFAULT 'lead_lecturer'::core.teaching_role_type NOT NULL,
    contact_hours_per_week smallint DEFAULT 3 NOT NULL,
    assigned_on date DEFAULT CURRENT_DATE NOT NULL,
    assigned_by character varying(120),
    is_active boolean DEFAULT true NOT NULL,
    remarks text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT lecturer_course_hours_ck CHECK (((contact_hours_per_week >= 1) AND (contact_hours_per_week <= 20)))
);


--
-- Name: TABLE lecturer_course_assignment; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.lecturer_course_assignment IS 'FUNCTIONALITY 4 - which lecturer teaches which course offering, and in what role.';


--
-- Name: lecturer_course_assignment_assignment_id_seq; Type: SEQUENCE; Schema: academics; Owner: -
--

ALTER TABLE academics.lecturer_course_assignment ALTER COLUMN assignment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME academics.lecturer_course_assignment_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: lecturer_ta_assignment; Type: TABLE; Schema: academics; Owner: -
--

CREATE TABLE academics.lecturer_ta_assignment (
    ta_assignment_id integer NOT NULL,
    lecturer_id integer NOT NULL,
    ta_id integer NOT NULL,
    offering_id integer,
    semester_id integer NOT NULL,
    responsibility character varying(200) DEFAULT 'Laboratory supervision and grading'::character varying NOT NULL,
    weekly_hours smallint DEFAULT 6 NOT NULL,
    assigned_on date DEFAULT CURRENT_DATE NOT NULL,
    end_date date,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT lecturer_ta_hours_ck CHECK (((weekly_hours >= 1) AND (weekly_hours <= 40))),
    CONSTRAINT lecturer_ta_period_ck CHECK (((end_date IS NULL) OR (end_date >= assigned_on)))
);


--
-- Name: TABLE lecturer_ta_assignment; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON TABLE academics.lecturer_ta_assignment IS 'FUNCTIONALITY 5 - assigns a teaching assistant to a lecturer, optionally scoped to one course offering.';


--
-- Name: lecturer_ta_assignment_ta_assignment_id_seq; Type: SEQUENCE; Schema: academics; Owner: -
--

ALTER TABLE academics.lecturer_ta_assignment ALTER COLUMN ta_assignment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME academics.lecturer_ta_assignment_ta_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: academic_year; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.academic_year (
    academic_year_id integer NOT NULL,
    name character varying(12) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_current boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT academic_year_range_ck CHECK ((end_date > start_date))
);


--
-- Name: TABLE academic_year; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.academic_year IS 'Academic sessions, e.g. 2025/2026.';


--
-- Name: semester; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.semester (
    semester_id integer NOT NULL,
    academic_year_id integer NOT NULL,
    name character varying(30) NOT NULL,
    sequence_no smallint NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    registration_deadline date,
    is_current boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT semester_range_ck CHECK ((end_date > start_date)),
    CONSTRAINT semester_sequence_ck CHECK (((sequence_no >= 1) AND (sequence_no <= 3)))
);


--
-- Name: TABLE semester; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.semester IS 'Semesters within an academic year. CPEN 208 runs in First Semester 2025/2026.';


--
-- Name: lecturer; Type: TABLE; Schema: people; Owner: -
--

CREATE TABLE people.lecturer (
    lecturer_id integer NOT NULL,
    person_id integer NOT NULL,
    staff_number character varying(15) NOT NULL,
    department_id integer NOT NULL,
    academic_rank core.lecturer_rank_type DEFAULT 'Lecturer'::core.lecturer_rank_type NOT NULL,
    highest_qualification character varying(60),
    specialisation character varying(120),
    office_location character varying(80),
    office_phone core.phone_number,
    employment_date date NOT NULL,
    status core.staff_status_type DEFAULT 'active'::core.staff_status_type NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE lecturer; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON TABLE people.lecturer IS 'Teaching staff. Referenced by functionalities 4 and 5.';


--
-- Name: person; Type: TABLE; Schema: people; Owner: -
--

CREATE TABLE people.person (
    person_id integer NOT NULL,
    title character varying(20),
    first_name character varying(60) NOT NULL,
    middle_name character varying(60),
    last_name character varying(60) NOT NULL,
    date_of_birth date NOT NULL,
    gender core.gender_type NOT NULL,
    marital_status core.marital_status_type DEFAULT 'Single'::core.marital_status_type NOT NULL,
    national_id character varying(30),
    email core.email_address NOT NULL,
    phone core.phone_number NOT NULL,
    alt_phone core.phone_number,
    nationality character varying(60) DEFAULT 'Ghanaian'::character varying NOT NULL,
    home_region character varying(60),
    postal_address character varying(150),
    residential_address character varying(200),
    photo_url character varying(255),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT person_age_ck CHECK ((date_of_birth > '1930-01-01'::date)),
    CONSTRAINT person_dob_ck CHECK ((date_of_birth < CURRENT_DATE))
);


--
-- Name: TABLE person; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON TABLE people.person IS 'Supertype holding personal information common to students, lecturers and TAs.';


--
-- Name: v_course_offering_summary; Type: VIEW; Schema: academics; Owner: -
--

CREATE VIEW academics.v_course_offering_summary AS
 SELECT o.offering_id,
    c.course_code,
    c.title AS course_title,
    c.credit_hours,
    c.level,
    o.section,
    o.venue,
    o.meeting_days,
    o.start_time,
    o.end_time,
    o.delivery_mode,
    o.capacity,
    sem.name AS semester,
    ay.name AS academic_year,
    o.is_open_for_registration,
    ( SELECT count(*) AS count
           FROM academics.enrollment e
          WHERE ((e.offering_id = o.offering_id) AND (e.status <> 'dropped'::core.enrollment_status_type))) AS enrolled_count,
    (o.capacity - ( SELECT count(*) AS count
           FROM academics.enrollment e
          WHERE ((e.offering_id = o.offering_id) AND (e.status <> 'dropped'::core.enrollment_status_type)))) AS seats_left,
    lect.lecturer_name
   FROM ((((academics.course_offering o
     JOIN academics.course c ON ((c.course_id = o.course_id)))
     JOIN core.semester sem ON ((sem.semester_id = o.semester_id)))
     JOIN core.academic_year ay ON ((ay.academic_year_id = sem.academic_year_id)))
     LEFT JOIN LATERAL ( SELECT TRIM(BOTH FROM (((COALESCE(((lp.title)::text || ' '::text), ''::text) || (lp.first_name)::text) || ' '::text) || (lp.last_name)::text)) AS lecturer_name
           FROM ((academics.lecturer_course_assignment a
             JOIN people.lecturer l ON ((l.lecturer_id = a.lecturer_id)))
             JOIN people.person lp ON ((lp.person_id = l.person_id)))
          WHERE ((a.offering_id = o.offering_id) AND (a.teaching_role = 'lead_lecturer'::core.teaching_role_type) AND a.is_active)
         LIMIT 1) lect ON (true));


--
-- Name: VIEW v_course_offering_summary; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON VIEW academics.v_course_offering_summary IS 'Course catalogue for a semester with live seat availability.';


--
-- Name: student; Type: TABLE; Schema: people; Owner: -
--

CREATE TABLE people.student (
    student_id integer NOT NULL,
    person_id integer NOT NULL,
    student_number character varying(15) NOT NULL,
    programme_id integer NOT NULL,
    current_level smallint DEFAULT 100 NOT NULL,
    admission_date date NOT NULL,
    expected_completion date,
    status core.student_status_type DEFAULT 'active'::core.student_status_type NOT NULL,
    residential_status core.residential_status_type DEFAULT 'non-resident'::core.residential_status_type NOT NULL,
    hall_of_residence character varying(80),
    entry_qualification character varying(80),
    cgpa numeric(3,2),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT student_cgpa_ck CHECK (((cgpa IS NULL) OR ((cgpa >= (0)::numeric) AND (cgpa <= 4.00)))),
    CONSTRAINT student_completion_ck CHECK (((expected_completion IS NULL) OR (expected_completion > admission_date))),
    CONSTRAINT student_hall_ck CHECK ((((residential_status = 'resident'::core.residential_status_type) AND (hall_of_residence IS NOT NULL)) OR ((residential_status = 'non-resident'::core.residential_status_type) AND (hall_of_residence IS NULL)))),
    CONSTRAINT student_level_ck CHECK ((current_level = ANY (ARRAY[100, 200, 300, 400, 500, 600])))
);


--
-- Name: TABLE student; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON TABLE people.student IS 'FUNCTIONALITY 1 - the student role of a person, with academic standing.';


--
-- Name: v_enrollment_detail; Type: VIEW; Schema: academics; Owner: -
--

CREATE VIEW academics.v_enrollment_detail AS
 SELECT e.enrollment_id,
    s.student_id,
    s.student_number,
    TRIM(BOTH FROM (((pr.first_name)::text || ' '::text) || (pr.last_name)::text)) AS student_name,
    s.current_level AS student_level,
    c.course_id,
    c.course_code,
    c.title AS course_title,
    c.credit_hours,
    o.offering_id,
    o.section,
    o.venue,
    o.meeting_days,
    o.start_time,
    o.end_time,
    sem.name AS semester,
    ay.name AS academic_year,
    e.status,
    e.is_retake,
    e.enrolled_on,
    e.final_score,
    e.letter_grade,
    e.grade_point,
    lect.lecturer_name
   FROM (((((((academics.enrollment e
     JOIN people.student s ON ((s.student_id = e.student_id)))
     JOIN people.person pr ON ((pr.person_id = s.person_id)))
     JOIN academics.course_offering o ON ((o.offering_id = e.offering_id)))
     JOIN academics.course c ON ((c.course_id = o.course_id)))
     JOIN core.semester sem ON ((sem.semester_id = o.semester_id)))
     JOIN core.academic_year ay ON ((ay.academic_year_id = sem.academic_year_id)))
     LEFT JOIN LATERAL ( SELECT TRIM(BOTH FROM (((COALESCE(((lp.title)::text || ' '::text), ''::text) || (lp.first_name)::text) || ' '::text) || (lp.last_name)::text)) AS lecturer_name
           FROM ((academics.lecturer_course_assignment a
             JOIN people.lecturer l ON ((l.lecturer_id = a.lecturer_id)))
             JOIN people.person lp ON ((lp.person_id = l.person_id)))
          WHERE ((a.offering_id = o.offering_id) AND (a.teaching_role = 'lead_lecturer'::core.teaching_role_type) AND a.is_active)
         LIMIT 1) lect ON (true));


--
-- Name: VIEW v_enrollment_detail; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON VIEW academics.v_enrollment_detail IS 'FUNCTIONALITY 3 - every enrolment joined to student, course, semester and lead lecturer.';


--
-- Name: department; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.department (
    department_id integer NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(120) NOT NULL,
    college character varying(120) DEFAULT 'College of Basic and Applied Sciences'::character varying NOT NULL,
    school character varying(120) DEFAULT 'School of Engineering Sciences'::character varying NOT NULL,
    email core.email_address,
    phone core.phone_number,
    office_location character varying(120),
    established_on date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE department; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.department IS 'Academic departments. The Computer Engineering Department is the subject of this system.';


--
-- Name: v_lecturer_course_allocation; Type: VIEW; Schema: academics; Owner: -
--

CREATE VIEW academics.v_lecturer_course_allocation AS
 SELECT a.assignment_id,
    l.lecturer_id,
    l.staff_number,
    TRIM(BOTH FROM (((COALESCE(((lp.title)::text || ' '::text), ''::text) || (lp.first_name)::text) || ' '::text) || (lp.last_name)::text)) AS lecturer_name,
    l.academic_rank,
    lp.email AS lecturer_email,
    d.name AS department,
    c.course_code,
    c.title AS course_title,
    c.credit_hours,
    o.offering_id,
    o.section,
    o.venue,
    o.meeting_days,
    sem.name AS semester,
    ay.name AS academic_year,
    a.teaching_role,
    a.contact_hours_per_week,
    a.assigned_on,
    a.is_active,
    ( SELECT count(*) AS count
           FROM academics.enrollment e
          WHERE ((e.offering_id = o.offering_id) AND (e.status <> 'dropped'::core.enrollment_status_type))) AS enrolled_students,
    ( SELECT count(*) AS count
           FROM academics.lecturer_ta_assignment t
          WHERE ((t.offering_id = o.offering_id) AND (t.lecturer_id = l.lecturer_id) AND t.is_active)) AS assigned_tas
   FROM (((((((academics.lecturer_course_assignment a
     JOIN people.lecturer l ON ((l.lecturer_id = a.lecturer_id)))
     JOIN people.person lp ON ((lp.person_id = l.person_id)))
     JOIN core.department d ON ((d.department_id = l.department_id)))
     JOIN academics.course_offering o ON ((o.offering_id = a.offering_id)))
     JOIN academics.course c ON ((c.course_id = o.course_id)))
     JOIN core.semester sem ON ((sem.semester_id = o.semester_id)))
     JOIN core.academic_year ay ON ((ay.academic_year_id = sem.academic_year_id)));


--
-- Name: VIEW v_lecturer_course_allocation; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON VIEW academics.v_lecturer_course_allocation IS 'FUNCTIONALITY 4 - which lecturer teaches which offering, with class size and TA count.';


--
-- Name: teaching_assistant; Type: TABLE; Schema: people; Owner: -
--

CREATE TABLE people.teaching_assistant (
    ta_id integer NOT NULL,
    person_id integer NOT NULL,
    ta_code character varying(15) NOT NULL,
    student_id integer,
    department_id integer NOT NULL,
    ta_type core.ta_type DEFAULT 'graduate'::core.ta_type NOT NULL,
    appointment_date date NOT NULL,
    end_date date,
    monthly_stipend core.money_amount DEFAULT 0 NOT NULL,
    max_weekly_hours smallint DEFAULT 20 NOT NULL,
    status core.staff_status_type DEFAULT 'active'::core.staff_status_type NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ta_hours_ck CHECK (((max_weekly_hours >= 1) AND (max_weekly_hours <= 40))),
    CONSTRAINT ta_period_ck CHECK (((end_date IS NULL) OR (end_date > appointment_date))),
    CONSTRAINT ta_student_link_ck CHECK ((((ta_type = ANY (ARRAY['graduate'::core.ta_type, 'undergraduate'::core.ta_type])) AND (student_id IS NOT NULL)) OR ((ta_type = 'external'::core.ta_type) AND (student_id IS NULL))))
);


--
-- Name: TABLE teaching_assistant; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON TABLE people.teaching_assistant IS 'FUNCTIONALITY 5 - the TA pool that lecturers draw from.';


--
-- Name: v_lecturer_ta_allocation; Type: VIEW; Schema: academics; Owner: -
--

CREATE VIEW academics.v_lecturer_ta_allocation AS
 SELECT lta.ta_assignment_id,
    l.lecturer_id,
    TRIM(BOTH FROM (((COALESCE(((lp.title)::text || ' '::text), ''::text) || (lp.first_name)::text) || ' '::text) || (lp.last_name)::text)) AS lecturer_name,
    l.academic_rank,
    t.ta_id,
    t.ta_code,
    TRIM(BOTH FROM (((tp.first_name)::text || ' '::text) || (tp.last_name)::text)) AS ta_name,
    tp.email AS ta_email,
    t.ta_type,
    st.student_number AS ta_student_number,
    c.course_code,
    c.title AS course_title,
    lta.offering_id,
    sem.name AS semester,
    ay.name AS academic_year,
    lta.responsibility,
    lta.weekly_hours,
    t.max_weekly_hours,
    lta.assigned_on,
    lta.is_active
   FROM (((((((((academics.lecturer_ta_assignment lta
     JOIN people.lecturer l ON ((l.lecturer_id = lta.lecturer_id)))
     JOIN people.person lp ON ((lp.person_id = l.person_id)))
     JOIN people.teaching_assistant t ON ((t.ta_id = lta.ta_id)))
     JOIN people.person tp ON ((tp.person_id = t.person_id)))
     LEFT JOIN people.student st ON ((st.student_id = t.student_id)))
     JOIN core.semester sem ON ((sem.semester_id = lta.semester_id)))
     JOIN core.academic_year ay ON ((ay.academic_year_id = sem.academic_year_id)))
     LEFT JOIN academics.course_offering o ON ((o.offering_id = lta.offering_id)))
     LEFT JOIN academics.course c ON ((c.course_id = o.course_id)));


--
-- Name: VIEW v_lecturer_ta_allocation; Type: COMMENT; Schema: academics; Owner: -
--

COMMENT ON VIEW academics.v_lecturer_ta_allocation IS 'FUNCTIONALITY 5 - teaching assistants mapped to the lecturers and courses they support.';


--
-- Name: app_user; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.app_user (
    user_id integer NOT NULL,
    username character varying(60) NOT NULL,
    email core.email_address NOT NULL,
    password_hash character varying(255) NOT NULL,
    role core.app_role_type DEFAULT 'student'::core.app_role_type NOT NULL,
    person_id integer,
    is_active boolean DEFAULT true NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    failed_login_attempts smallint DEFAULT 0 NOT NULL,
    locked_until timestamp with time zone,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT app_user_hash_ck CHECK ((length((password_hash)::text) >= 20)),
    CONSTRAINT app_user_username_ck CHECK (((username)::text ~ '^[A-Za-z0-9._-]{3,60}$'::text))
);


--
-- Name: TABLE app_user; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.app_user IS 'Login accounts for the Next.js application and the REST API.';


--
-- Name: app_user_user_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

ALTER TABLE app.app_user ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME app.app_user_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: audit_log; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.audit_log (
    audit_id bigint NOT NULL,
    user_id integer,
    action character varying(60) NOT NULL,
    entity character varying(60),
    entity_id character varying(60),
    details jsonb,
    ip_address inet,
    occurred_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE audit_log; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.audit_log IS 'Append-only trail of security-relevant actions.';


--
-- Name: audit_log_audit_id_seq; Type: SEQUENCE; Schema: app; Owner: -
--

ALTER TABLE app.audit_log ALTER COLUMN audit_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME app.audit_log_audit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user_session; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.user_session (
    session_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer NOT NULL,
    token_hash character varying(128) NOT NULL,
    issued_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked_at timestamp with time zone,
    ip_address inet,
    user_agent character varying(300),
    CONSTRAINT user_session_expiry_ck CHECK ((expires_at > issued_at))
);


--
-- Name: TABLE user_session; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.user_session IS 'Server-side session records; the browser only ever holds an opaque token.';


--
-- Name: academic_year_academic_year_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.academic_year ALTER COLUMN academic_year_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.academic_year_academic_year_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: department_department_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.department ALTER COLUMN department_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.department_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: programme; Type: TABLE; Schema: core; Owner: -
--

CREATE TABLE core.programme (
    programme_id integer NOT NULL,
    department_id integer NOT NULL,
    code character varying(15) NOT NULL,
    name character varying(150) NOT NULL,
    degree_award character varying(60) NOT NULL,
    duration_years smallint DEFAULT 4 NOT NULL,
    total_credits smallint DEFAULT 132 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT programme_credits_ck CHECK ((total_credits > 0)),
    CONSTRAINT programme_duration_ck CHECK (((duration_years >= 1) AND (duration_years <= 8)))
);


--
-- Name: TABLE programme; Type: COMMENT; Schema: core; Owner: -
--

COMMENT ON TABLE core.programme IS 'Degree programmes run by a department, e.g. BSc Computer Engineering.';


--
-- Name: programme_programme_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.programme ALTER COLUMN programme_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.programme_programme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: semester_semester_id_seq; Type: SEQUENCE; Schema: core; Owner: -
--

ALTER TABLE core.semester ALTER COLUMN semester_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME core.semester_semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bill_line; Type: TABLE; Schema: finance; Owner: -
--

CREATE TABLE finance.bill_line (
    bill_line_id integer NOT NULL,
    bill_id integer NOT NULL,
    fee_item_id integer,
    description character varying(120) NOT NULL,
    category core.fee_category_type NOT NULL,
    amount core.money_amount NOT NULL
);


--
-- Name: TABLE bill_line; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON TABLE finance.bill_line IS 'Frozen snapshot of the fee items charged on a bill.';


--
-- Name: bill_line_bill_line_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

ALTER TABLE finance.bill_line ALTER COLUMN bill_line_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME finance.bill_line_bill_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fee_item; Type: TABLE; Schema: finance; Owner: -
--

CREATE TABLE finance.fee_item (
    fee_item_id integer NOT NULL,
    fee_structure_id integer NOT NULL,
    item_name character varying(100) NOT NULL,
    category core.fee_category_type NOT NULL,
    amount core.money_amount NOT NULL,
    is_mandatory boolean DEFAULT true NOT NULL,
    description text
);


--
-- Name: TABLE fee_item; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON TABLE finance.fee_item IS 'Individual charges that make up a fee structure (tuition, SRC dues, ...).';


--
-- Name: fee_item_fee_item_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

ALTER TABLE finance.fee_item ALTER COLUMN fee_item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME finance.fee_item_fee_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: fee_structure; Type: TABLE; Schema: finance; Owner: -
--

CREATE TABLE finance.fee_structure (
    fee_structure_id integer NOT NULL,
    programme_id integer NOT NULL,
    academic_year_id integer NOT NULL,
    level smallint NOT NULL,
    residential_status core.residential_status_type NOT NULL,
    currency character(3) DEFAULT 'GHS'::bpchar NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fee_structure_level_ck CHECK ((level = ANY (ARRAY[100, 200, 300, 400, 500, 600])))
);


--
-- Name: TABLE fee_structure; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON TABLE finance.fee_structure IS 'Published fee schedule for a programme/level/year/residency combination.';


--
-- Name: fee_structure_fee_structure_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

ALTER TABLE finance.fee_structure ALTER COLUMN fee_structure_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME finance.fee_structure_fee_structure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: payment; Type: TABLE; Schema: finance; Owner: -
--

CREATE TABLE finance.payment (
    payment_id integer NOT NULL,
    receipt_number character varying(30) NOT NULL,
    student_id integer NOT NULL,
    bill_id integer NOT NULL,
    amount core.money_amount NOT NULL,
    currency character(3) DEFAULT 'GHS'::bpchar NOT NULL,
    payment_date date DEFAULT CURRENT_DATE NOT NULL,
    payment_method core.payment_method_type NOT NULL,
    bank_or_channel character varying(80),
    transaction_ref character varying(60),
    status core.payment_status_type DEFAULT 'confirmed'::core.payment_status_type NOT NULL,
    received_by character varying(120),
    remarks text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT payment_amount_ck CHECK (((amount)::numeric > (0)::numeric))
);


--
-- Name: TABLE payment; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON TABLE finance.payment IS 'FUNCTIONALITY 2 - money received from a student. Only status = confirmed reduces the outstanding balance.';


--
-- Name: payment_payment_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

ALTER TABLE finance.payment ALTER COLUMN payment_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME finance.payment_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: receipt_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

CREATE SEQUENCE finance.receipt_seq
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_bill; Type: TABLE; Schema: finance; Owner: -
--

CREATE TABLE finance.student_bill (
    bill_id integer NOT NULL,
    bill_reference character varying(30) NOT NULL,
    student_id integer NOT NULL,
    academic_year_id integer NOT NULL,
    fee_structure_id integer,
    total_amount core.money_amount DEFAULT 0 NOT NULL,
    currency character(3) DEFAULT 'GHS'::bpchar NOT NULL,
    issued_on date DEFAULT CURRENT_DATE NOT NULL,
    due_date date NOT NULL,
    status core.bill_status_type DEFAULT 'issued'::core.bill_status_type NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT student_bill_due_ck CHECK ((due_date >= issued_on))
);


--
-- Name: TABLE student_bill; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON TABLE finance.student_bill IS 'FUNCTIONALITY 2 - the amount a student owes for an academic year.';


--
-- Name: student_bill_bill_id_seq; Type: SEQUENCE; Schema: finance; Owner: -
--

ALTER TABLE finance.student_bill ALTER COLUMN bill_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME finance.student_bill_bill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_student_fee_status; Type: VIEW; Schema: finance; Owner: -
--

CREATE VIEW finance.v_student_fee_status AS
 SELECT s.student_id,
    s.student_number,
    TRIM(BOTH FROM (((pr.first_name)::text || ' '::text) || (pr.last_name)::text)) AS full_name,
    pg.name AS programme,
    s.current_level AS level,
    ay.name AS academic_year,
    b.bill_id,
    b.bill_reference,
    b.total_amount AS amount_billed,
    COALESCE(pay.amount_paid, (0)::numeric) AS amount_paid,
    ((b.total_amount)::numeric - COALESCE(pay.amount_paid, (0)::numeric)) AS outstanding_balance,
        CASE
            WHEN ((b.total_amount)::numeric > (0)::numeric) THEN round(((100.0 * COALESCE(pay.amount_paid, (0)::numeric)) / (b.total_amount)::numeric), 2)
            ELSE (0)::numeric
        END AS percentage_paid,
    b.due_date,
    b.status AS bill_status,
    ((((b.total_amount)::numeric - COALESCE(pay.amount_paid, (0)::numeric)) > (0)::numeric) AND (b.due_date < CURRENT_DATE)) AS is_overdue,
    pay.last_payment_date,
    COALESCE(pay.payment_count, (0)::bigint) AS payment_count
   FROM (((((finance.student_bill b
     JOIN people.student s ON ((s.student_id = b.student_id)))
     JOIN people.person pr ON ((pr.person_id = s.person_id)))
     JOIN core.programme pg ON ((pg.programme_id = s.programme_id)))
     JOIN core.academic_year ay ON ((ay.academic_year_id = b.academic_year_id)))
     LEFT JOIN LATERAL ( SELECT sum((p.amount)::numeric) AS amount_paid,
            max(p.payment_date) AS last_payment_date,
            count(*) AS payment_count
           FROM finance.payment p
          WHERE ((p.bill_id = b.bill_id) AND (p.status = 'confirmed'::core.payment_status_type))) pay ON (true))
  WHERE (b.status <> 'cancelled'::core.bill_status_type);


--
-- Name: VIEW v_student_fee_status; Type: COMMENT; Schema: finance; Owner: -
--

COMMENT ON VIEW finance.v_student_fee_status IS 'FUNCTIONALITY 2 - billed vs paid vs outstanding for every student bill.';


--
-- Name: lecturer_lecturer_id_seq; Type: SEQUENCE; Schema: people; Owner: -
--

ALTER TABLE people.lecturer ALTER COLUMN lecturer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME people.lecturer_lecturer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: next_of_kin; Type: TABLE; Schema: people; Owner: -
--

CREATE TABLE people.next_of_kin (
    next_of_kin_id integer NOT NULL,
    student_id integer NOT NULL,
    full_name character varying(150) NOT NULL,
    relationship character varying(40) NOT NULL,
    phone core.phone_number NOT NULL,
    email core.email_address,
    occupation character varying(80),
    address character varying(200),
    is_primary boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE next_of_kin; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON TABLE people.next_of_kin IS 'Emergency / guardian contacts - part of student personal information.';


--
-- Name: next_of_kin_next_of_kin_id_seq; Type: SEQUENCE; Schema: people; Owner: -
--

ALTER TABLE people.next_of_kin ALTER COLUMN next_of_kin_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME people.next_of_kin_next_of_kin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: person_person_id_seq; Type: SEQUENCE; Schema: people; Owner: -
--

ALTER TABLE people.person ALTER COLUMN person_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME people.person_person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: people; Owner: -
--

ALTER TABLE people.student ALTER COLUMN student_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME people.student_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: teaching_assistant_ta_id_seq; Type: SEQUENCE; Schema: people; Owner: -
--

ALTER TABLE people.teaching_assistant ALTER COLUMN ta_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME people.teaching_assistant_ta_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_student_directory; Type: VIEW; Schema: people; Owner: -
--

CREATE VIEW people.v_student_directory AS
 SELECT s.student_id,
    s.student_number,
    TRIM(BOTH FROM ((((pr.first_name)::text || ' '::text) || COALESCE(((pr.middle_name)::text || ' '::text), ''::text)) || (pr.last_name)::text)) AS full_name,
    pr.first_name,
    pr.last_name,
    pr.email,
    pr.phone,
    pr.gender,
    pr.date_of_birth,
    (date_part('year'::text, age((pr.date_of_birth)::timestamp with time zone)))::integer AS age,
    pr.nationality,
    pr.home_region,
    pg.code AS programme_code,
    pg.name AS programme,
    d.name AS department,
    s.current_level,
    s.status,
    s.residential_status,
    s.hall_of_residence,
    s.admission_date,
    s.cgpa
   FROM (((people.student s
     JOIN people.person pr ON ((pr.person_id = s.person_id)))
     JOIN core.programme pg ON ((pg.programme_id = s.programme_id)))
     JOIN core.department d ON ((d.department_id = pg.department_id)));


--
-- Name: VIEW v_student_directory; Type: COMMENT; Schema: people; Owner: -
--

COMMENT ON VIEW people.v_student_directory IS 'FUNCTIONALITY 1 - flattened student personal + academic information.';


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
-- Data for Name: academic_year; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.academic_year (academic_year_id, name, start_date, end_date, is_current, created_at) FROM stdin;
1	2024/2025	2024-08-05	2025-07-25	f	2026-08-03 20:52:48.539735+00
2	2025/2026	2025-08-04	2026-07-24	t	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.department (department_id, code, name, college, school, email, phone, office_location, established_on, created_at, updated_at) FROM stdin;
1	CPEN	Computer Engineering	College of Basic and Applied Sciences	School of Engineering Sciences	cpen@ug.edu.gh	+233 30 250 1234	Engineering Block B, Room 21	2005-09-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	MATH	Mathematics	College of Basic and Applied Sciences	School of Physical and Mathematical Sciences	maths@ug.edu.gh	+233 30 250 2345	Mathematics Building, Room 4	1948-10-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
3	UGRC	Office of Academic Affairs (University Required Courses)	Academic Affairs Directorate	University-wide	ugrc@ug.edu.gh	+233 30 250 3456	Central Administration Block	2010-08-01	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
\.


--
-- Data for Name: programme; Type: TABLE DATA; Schema: core; Owner: -
--

COPY core.programme (programme_id, department_id, code, name, degree_award, duration_years, total_credits, is_active, created_at, updated_at) FROM stdin;
1	1	MPHIL-CPEN	MPhil Computer Engineering	MPhil	2	48	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
2	1	BSC-CPEN	BSc Computer Engineering	BSc	4	132	t	2026-08-03 20:52:48.539735+00	2026-08-03 20:52:48.539735+00
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
-- Name: course course_course_code_key; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course
    ADD CONSTRAINT course_course_code_key UNIQUE (course_code);


--
-- Name: course_offering course_offering_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_offering
    ADD CONSTRAINT course_offering_pkey PRIMARY KEY (offering_id);


--
-- Name: course_offering course_offering_uq; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_offering
    ADD CONSTRAINT course_offering_uq UNIQUE (course_id, semester_id, section);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_id);


--
-- Name: course_prerequisite course_prerequisite_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_prerequisite
    ADD CONSTRAINT course_prerequisite_pkey PRIMARY KEY (course_id, prerequisite_id);


--
-- Name: enrollment enrollment_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.enrollment
    ADD CONSTRAINT enrollment_pkey PRIMARY KEY (enrollment_id);


--
-- Name: enrollment enrollment_uq; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.enrollment
    ADD CONSTRAINT enrollment_uq UNIQUE (student_id, offering_id);


--
-- Name: lecturer_course_assignment lecturer_course_assignment_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_pkey PRIMARY KEY (assignment_id);


--
-- Name: lecturer_course_assignment lecturer_course_uq; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_uq UNIQUE (lecturer_id, offering_id);


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_pkey; Type: CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_pkey PRIMARY KEY (ta_assignment_id);


--
-- Name: app_user app_user_email_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.app_user
    ADD CONSTRAINT app_user_email_key UNIQUE (email);


--
-- Name: app_user app_user_person_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.app_user
    ADD CONSTRAINT app_user_person_id_key UNIQUE (person_id);


--
-- Name: app_user app_user_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.app_user
    ADD CONSTRAINT app_user_pkey PRIMARY KEY (user_id);


--
-- Name: app_user app_user_username_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.app_user
    ADD CONSTRAINT app_user_username_key UNIQUE (username);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (audit_id);


--
-- Name: user_session user_session_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.user_session
    ADD CONSTRAINT user_session_pkey PRIMARY KEY (session_id);


--
-- Name: user_session user_session_token_hash_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.user_session
    ADD CONSTRAINT user_session_token_hash_key UNIQUE (token_hash);


--
-- Name: academic_year academic_year_name_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.academic_year
    ADD CONSTRAINT academic_year_name_key UNIQUE (name);


--
-- Name: academic_year academic_year_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.academic_year
    ADD CONSTRAINT academic_year_pkey PRIMARY KEY (academic_year_id);


--
-- Name: department department_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department
    ADD CONSTRAINT department_code_key UNIQUE (code);


--
-- Name: department department_name_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department
    ADD CONSTRAINT department_name_key UNIQUE (name);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.department
    ADD CONSTRAINT department_pkey PRIMARY KEY (department_id);


--
-- Name: programme programme_code_key; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.programme
    ADD CONSTRAINT programme_code_key UNIQUE (code);


--
-- Name: programme programme_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.programme
    ADD CONSTRAINT programme_pkey PRIMARY KEY (programme_id);


--
-- Name: semester semester_pkey; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.semester
    ADD CONSTRAINT semester_pkey PRIMARY KEY (semester_id);


--
-- Name: semester semester_uq; Type: CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.semester
    ADD CONSTRAINT semester_uq UNIQUE (academic_year_id, sequence_no);


--
-- Name: bill_line bill_line_pkey; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.bill_line
    ADD CONSTRAINT bill_line_pkey PRIMARY KEY (bill_line_id);


--
-- Name: bill_line bill_line_uq; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.bill_line
    ADD CONSTRAINT bill_line_uq UNIQUE (bill_id, description);


--
-- Name: fee_item fee_item_pkey; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_item
    ADD CONSTRAINT fee_item_pkey PRIMARY KEY (fee_item_id);


--
-- Name: fee_item fee_item_uq; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_item
    ADD CONSTRAINT fee_item_uq UNIQUE (fee_structure_id, item_name);


--
-- Name: fee_structure fee_structure_pkey; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_structure
    ADD CONSTRAINT fee_structure_pkey PRIMARY KEY (fee_structure_id);


--
-- Name: fee_structure fee_structure_uq; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_structure
    ADD CONSTRAINT fee_structure_uq UNIQUE (programme_id, academic_year_id, level, residential_status);


--
-- Name: payment payment_pkey; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_pkey PRIMARY KEY (payment_id);


--
-- Name: payment payment_receipt_number_key; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_receipt_number_key UNIQUE (receipt_number);


--
-- Name: student_bill student_bill_bill_reference_key; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_bill_reference_key UNIQUE (bill_reference);


--
-- Name: student_bill student_bill_pkey; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_pkey PRIMARY KEY (bill_id);


--
-- Name: student_bill student_bill_uq; Type: CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_uq UNIQUE (student_id, academic_year_id);


--
-- Name: lecturer lecturer_person_id_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.lecturer
    ADD CONSTRAINT lecturer_person_id_key UNIQUE (person_id);


--
-- Name: lecturer lecturer_pkey; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.lecturer
    ADD CONSTRAINT lecturer_pkey PRIMARY KEY (lecturer_id);


--
-- Name: lecturer lecturer_staff_number_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.lecturer
    ADD CONSTRAINT lecturer_staff_number_key UNIQUE (staff_number);


--
-- Name: next_of_kin next_of_kin_pkey; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.next_of_kin
    ADD CONSTRAINT next_of_kin_pkey PRIMARY KEY (next_of_kin_id);


--
-- Name: person person_email_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.person
    ADD CONSTRAINT person_email_key UNIQUE (email);


--
-- Name: person person_national_id_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.person
    ADD CONSTRAINT person_national_id_key UNIQUE (national_id);


--
-- Name: person person_pkey; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.person
    ADD CONSTRAINT person_pkey PRIMARY KEY (person_id);


--
-- Name: student student_person_id_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.student
    ADD CONSTRAINT student_person_id_key UNIQUE (person_id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- Name: student student_student_number_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.student
    ADD CONSTRAINT student_student_number_key UNIQUE (student_number);


--
-- Name: teaching_assistant teaching_assistant_person_id_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_person_id_key UNIQUE (person_id);


--
-- Name: teaching_assistant teaching_assistant_pkey; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_pkey PRIMARY KEY (ta_id);


--
-- Name: teaching_assistant teaching_assistant_student_id_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_student_id_key UNIQUE (student_id);


--
-- Name: teaching_assistant teaching_assistant_ta_code_key; Type: CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_ta_code_key UNIQUE (ta_code);


--
-- Name: course_department_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX course_department_ix ON academics.course USING btree (department_id);


--
-- Name: course_level_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX course_level_ix ON academics.course USING btree (level) WHERE is_active;


--
-- Name: enrollment_offering_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX enrollment_offering_ix ON academics.enrollment USING btree (offering_id);


--
-- Name: enrollment_status_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX enrollment_status_ix ON academics.enrollment USING btree (status);


--
-- Name: enrollment_student_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX enrollment_student_ix ON academics.enrollment USING btree (student_id);


--
-- Name: lca_lecturer_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lca_lecturer_ix ON academics.lecturer_course_assignment USING btree (lecturer_id);


--
-- Name: lca_offering_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lca_offering_ix ON academics.lecturer_course_assignment USING btree (offering_id);


--
-- Name: lecturer_course_one_lead_uq; Type: INDEX; Schema: academics; Owner: -
--

CREATE UNIQUE INDEX lecturer_course_one_lead_uq ON academics.lecturer_course_assignment USING btree (offering_id) WHERE ((teaching_role = 'lead_lecturer'::core.teaching_role_type) AND is_active);


--
-- Name: lecturer_ta_no_offering_uq; Type: INDEX; Schema: academics; Owner: -
--

CREATE UNIQUE INDEX lecturer_ta_no_offering_uq ON academics.lecturer_ta_assignment USING btree (lecturer_id, ta_id, semester_id) WHERE (offering_id IS NULL);


--
-- Name: lecturer_ta_with_offering_uq; Type: INDEX; Schema: academics; Owner: -
--

CREATE UNIQUE INDEX lecturer_ta_with_offering_uq ON academics.lecturer_ta_assignment USING btree (lecturer_id, ta_id, offering_id) WHERE (offering_id IS NOT NULL);


--
-- Name: lta_lecturer_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lta_lecturer_ix ON academics.lecturer_ta_assignment USING btree (lecturer_id);


--
-- Name: lta_offering_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lta_offering_ix ON academics.lecturer_ta_assignment USING btree (offering_id);


--
-- Name: lta_semester_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lta_semester_ix ON academics.lecturer_ta_assignment USING btree (semester_id);


--
-- Name: lta_ta_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX lta_ta_ix ON academics.lecturer_ta_assignment USING btree (ta_id);


--
-- Name: offering_course_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX offering_course_ix ON academics.course_offering USING btree (course_id);


--
-- Name: offering_semester_ix; Type: INDEX; Schema: academics; Owner: -
--

CREATE INDEX offering_semester_ix ON academics.course_offering USING btree (semester_id);


--
-- Name: app_user_person_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX app_user_person_ix ON app.app_user USING btree (person_id);


--
-- Name: app_user_role_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX app_user_role_ix ON app.app_user USING btree (role) WHERE is_active;


--
-- Name: audit_action_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX audit_action_ix ON app.audit_log USING btree (action);


--
-- Name: audit_user_time_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX audit_user_time_ix ON app.audit_log USING btree (user_id, occurred_at DESC);


--
-- Name: session_live_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX session_live_ix ON app.user_session USING btree (expires_at) WHERE (revoked_at IS NULL);


--
-- Name: session_user_ix; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX session_user_ix ON app.user_session USING btree (user_id);


--
-- Name: academic_year_one_current_uq; Type: INDEX; Schema: core; Owner: -
--

CREATE UNIQUE INDEX academic_year_one_current_uq ON core.academic_year USING btree (is_current) WHERE is_current;


--
-- Name: programme_department_ix; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX programme_department_ix ON core.programme USING btree (department_id);


--
-- Name: semester_one_current_uq; Type: INDEX; Schema: core; Owner: -
--

CREATE UNIQUE INDEX semester_one_current_uq ON core.semester USING btree (is_current) WHERE is_current;


--
-- Name: semester_year_ix; Type: INDEX; Schema: core; Owner: -
--

CREATE INDEX semester_year_ix ON core.semester USING btree (academic_year_id);


--
-- Name: bill_line_bill_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX bill_line_bill_ix ON finance.bill_line USING btree (bill_id);


--
-- Name: bill_status_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX bill_status_ix ON finance.student_bill USING btree (status);


--
-- Name: bill_student_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX bill_student_ix ON finance.student_bill USING btree (student_id);


--
-- Name: bill_year_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX bill_year_ix ON finance.student_bill USING btree (academic_year_id);


--
-- Name: fee_item_structure_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX fee_item_structure_ix ON finance.fee_item USING btree (fee_structure_id);


--
-- Name: fee_structure_programme_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX fee_structure_programme_ix ON finance.fee_structure USING btree (programme_id, academic_year_id);


--
-- Name: payment_bill_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX payment_bill_ix ON finance.payment USING btree (bill_id);


--
-- Name: payment_confirmed_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX payment_confirmed_ix ON finance.payment USING btree (bill_id, amount) WHERE (status = 'confirmed'::core.payment_status_type);


--
-- Name: payment_date_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX payment_date_ix ON finance.payment USING btree (payment_date DESC);


--
-- Name: payment_student_ix; Type: INDEX; Schema: finance; Owner: -
--

CREATE INDEX payment_student_ix ON finance.payment USING btree (student_id);


--
-- Name: lecturer_department_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX lecturer_department_ix ON people.lecturer USING btree (department_id);


--
-- Name: lecturer_person_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX lecturer_person_ix ON people.lecturer USING btree (person_id);


--
-- Name: next_of_kin_one_primary_uq; Type: INDEX; Schema: people; Owner: -
--

CREATE UNIQUE INDEX next_of_kin_one_primary_uq ON people.next_of_kin USING btree (student_id) WHERE is_primary;


--
-- Name: next_of_kin_student_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX next_of_kin_student_ix ON people.next_of_kin USING btree (student_id);


--
-- Name: person_last_first_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX person_last_first_ix ON people.person USING btree (lower((last_name)::text), lower((first_name)::text));


--
-- Name: student_level_status_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX student_level_status_ix ON people.student USING btree (current_level, status);


--
-- Name: student_person_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX student_person_ix ON people.student USING btree (person_id);


--
-- Name: student_programme_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX student_programme_ix ON people.student USING btree (programme_id);


--
-- Name: ta_department_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX ta_department_ix ON people.teaching_assistant USING btree (department_id);


--
-- Name: ta_person_ix; Type: INDEX; Schema: people; Owner: -
--

CREATE INDEX ta_person_ix ON people.teaching_assistant USING btree (person_id);


--
-- Name: course_offering t_course_offering_set_updated_at; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_course_offering_set_updated_at BEFORE UPDATE ON academics.course_offering FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: course t_course_set_updated_at; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_course_set_updated_at BEFORE UPDATE ON academics.course FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: enrollment t_enrollment_set_updated_at; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_enrollment_set_updated_at BEFORE UPDATE ON academics.enrollment FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: enrollment t_enrollment_validate; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_enrollment_validate BEFORE INSERT ON academics.enrollment FOR EACH ROW EXECUTE FUNCTION academics.fn_validate_enrollment();


--
-- Name: lecturer_course_assignment t_lecturer_course_assignment_set_updated_at; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_lecturer_course_assignment_set_updated_at BEFORE UPDATE ON academics.lecturer_course_assignment FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: lecturer_ta_assignment t_lecturer_ta_assignment_set_updated_at; Type: TRIGGER; Schema: academics; Owner: -
--

CREATE TRIGGER t_lecturer_ta_assignment_set_updated_at BEFORE UPDATE ON academics.lecturer_ta_assignment FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: app_user t_app_user_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER t_app_user_set_updated_at BEFORE UPDATE ON app.app_user FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: department t_department_set_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER t_department_set_updated_at BEFORE UPDATE ON core.department FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: programme t_programme_set_updated_at; Type: TRIGGER; Schema: core; Owner: -
--

CREATE TRIGGER t_programme_set_updated_at BEFORE UPDATE ON core.programme FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: bill_line t_bill_line_refresh_total; Type: TRIGGER; Schema: finance; Owner: -
--

CREATE TRIGGER t_bill_line_refresh_total AFTER INSERT OR DELETE OR UPDATE ON finance.bill_line FOR EACH ROW EXECUTE FUNCTION finance.fn_refresh_bill_total();


--
-- Name: fee_structure t_fee_structure_set_updated_at; Type: TRIGGER; Schema: finance; Owner: -
--

CREATE TRIGGER t_fee_structure_set_updated_at BEFORE UPDATE ON finance.fee_structure FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: payment t_payment_refresh_bill_status; Type: TRIGGER; Schema: finance; Owner: -
--

CREATE TRIGGER t_payment_refresh_bill_status AFTER INSERT OR DELETE OR UPDATE ON finance.payment FOR EACH ROW EXECUTE FUNCTION finance.fn_refresh_bill_status();


--
-- Name: payment t_payment_set_updated_at; Type: TRIGGER; Schema: finance; Owner: -
--

CREATE TRIGGER t_payment_set_updated_at BEFORE UPDATE ON finance.payment FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: student_bill t_student_bill_set_updated_at; Type: TRIGGER; Schema: finance; Owner: -
--

CREATE TRIGGER t_student_bill_set_updated_at BEFORE UPDATE ON finance.student_bill FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: lecturer t_lecturer_set_updated_at; Type: TRIGGER; Schema: people; Owner: -
--

CREATE TRIGGER t_lecturer_set_updated_at BEFORE UPDATE ON people.lecturer FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: person t_person_set_updated_at; Type: TRIGGER; Schema: people; Owner: -
--

CREATE TRIGGER t_person_set_updated_at BEFORE UPDATE ON people.person FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: student t_student_set_updated_at; Type: TRIGGER; Schema: people; Owner: -
--

CREATE TRIGGER t_student_set_updated_at BEFORE UPDATE ON people.student FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: teaching_assistant t_teaching_assistant_set_updated_at; Type: TRIGGER; Schema: people; Owner: -
--

CREATE TRIGGER t_teaching_assistant_set_updated_at BEFORE UPDATE ON people.teaching_assistant FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at();


--
-- Name: course course_department_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course
    ADD CONSTRAINT course_department_id_fkey FOREIGN KEY (department_id) REFERENCES core.department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: course_offering course_offering_course_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_offering
    ADD CONSTRAINT course_offering_course_id_fkey FOREIGN KEY (course_id) REFERENCES academics.course(course_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: course_offering course_offering_semester_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_offering
    ADD CONSTRAINT course_offering_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES core.semester(semester_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: course_prerequisite course_prerequisite_course_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_prerequisite
    ADD CONSTRAINT course_prerequisite_course_id_fkey FOREIGN KEY (course_id) REFERENCES academics.course(course_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: course_prerequisite course_prerequisite_prerequisite_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.course_prerequisite
    ADD CONSTRAINT course_prerequisite_prerequisite_id_fkey FOREIGN KEY (prerequisite_id) REFERENCES academics.course(course_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enrollment enrollment_offering_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.enrollment
    ADD CONSTRAINT enrollment_offering_id_fkey FOREIGN KEY (offering_id) REFERENCES academics.course_offering(offering_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: enrollment enrollment_student_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.enrollment
    ADD CONSTRAINT enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES people.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer_course_assignment lecturer_course_assignment_lecturer_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES people.lecturer(lecturer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer_course_assignment lecturer_course_assignment_offering_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_course_assignment
    ADD CONSTRAINT lecturer_course_assignment_offering_id_fkey FOREIGN KEY (offering_id) REFERENCES academics.course_offering(offering_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_lecturer_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_lecturer_id_fkey FOREIGN KEY (lecturer_id) REFERENCES people.lecturer(lecturer_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_offering_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_offering_id_fkey FOREIGN KEY (offering_id) REFERENCES academics.course_offering(offering_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_semester_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_semester_id_fkey FOREIGN KEY (semester_id) REFERENCES core.semester(semester_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lecturer_ta_assignment lecturer_ta_assignment_ta_id_fkey; Type: FK CONSTRAINT; Schema: academics; Owner: -
--

ALTER TABLE ONLY academics.lecturer_ta_assignment
    ADD CONSTRAINT lecturer_ta_assignment_ta_id_fkey FOREIGN KEY (ta_id) REFERENCES people.teaching_assistant(ta_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: app_user app_user_person_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.app_user
    ADD CONSTRAINT app_user_person_id_fkey FOREIGN KEY (person_id) REFERENCES people.person(person_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.app_user(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: user_session user_session_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.user_session
    ADD CONSTRAINT user_session_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.app_user(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: programme programme_department_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.programme
    ADD CONSTRAINT programme_department_id_fkey FOREIGN KEY (department_id) REFERENCES core.department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: semester semester_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: core; Owner: -
--

ALTER TABLE ONLY core.semester
    ADD CONSTRAINT semester_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES core.academic_year(academic_year_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bill_line bill_line_bill_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.bill_line
    ADD CONSTRAINT bill_line_bill_id_fkey FOREIGN KEY (bill_id) REFERENCES finance.student_bill(bill_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bill_line bill_line_fee_item_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.bill_line
    ADD CONSTRAINT bill_line_fee_item_id_fkey FOREIGN KEY (fee_item_id) REFERENCES finance.fee_item(fee_item_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: fee_item fee_item_fee_structure_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_item
    ADD CONSTRAINT fee_item_fee_structure_id_fkey FOREIGN KEY (fee_structure_id) REFERENCES finance.fee_structure(fee_structure_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: fee_structure fee_structure_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_structure
    ADD CONSTRAINT fee_structure_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES core.academic_year(academic_year_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: fee_structure fee_structure_programme_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.fee_structure
    ADD CONSTRAINT fee_structure_programme_id_fkey FOREIGN KEY (programme_id) REFERENCES core.programme(programme_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payment payment_bill_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_bill_id_fkey FOREIGN KEY (bill_id) REFERENCES finance.student_bill(bill_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment payment_student_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.payment
    ADD CONSTRAINT payment_student_id_fkey FOREIGN KEY (student_id) REFERENCES people.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student_bill student_bill_academic_year_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_academic_year_id_fkey FOREIGN KEY (academic_year_id) REFERENCES core.academic_year(academic_year_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: student_bill student_bill_fee_structure_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_fee_structure_id_fkey FOREIGN KEY (fee_structure_id) REFERENCES finance.fee_structure(fee_structure_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: student_bill student_bill_student_id_fkey; Type: FK CONSTRAINT; Schema: finance; Owner: -
--

ALTER TABLE ONLY finance.student_bill
    ADD CONSTRAINT student_bill_student_id_fkey FOREIGN KEY (student_id) REFERENCES people.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lecturer lecturer_department_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.lecturer
    ADD CONSTRAINT lecturer_department_id_fkey FOREIGN KEY (department_id) REFERENCES core.department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: lecturer lecturer_person_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.lecturer
    ADD CONSTRAINT lecturer_person_id_fkey FOREIGN KEY (person_id) REFERENCES people.person(person_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: next_of_kin next_of_kin_student_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.next_of_kin
    ADD CONSTRAINT next_of_kin_student_id_fkey FOREIGN KEY (student_id) REFERENCES people.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student student_person_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.student
    ADD CONSTRAINT student_person_id_fkey FOREIGN KEY (person_id) REFERENCES people.person(person_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student student_programme_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.student
    ADD CONSTRAINT student_programme_id_fkey FOREIGN KEY (programme_id) REFERENCES core.programme(programme_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: teaching_assistant teaching_assistant_department_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_department_id_fkey FOREIGN KEY (department_id) REFERENCES core.department(department_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: teaching_assistant teaching_assistant_person_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_person_id_fkey FOREIGN KEY (person_id) REFERENCES people.person(person_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teaching_assistant teaching_assistant_student_id_fkey; Type: FK CONSTRAINT; Schema: people; Owner: -
--

ALTER TABLE ONLY people.teaching_assistant
    ADD CONSTRAINT teaching_assistant_student_id_fkey FOREIGN KEY (student_id) REFERENCES people.student(student_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict ofx0HL1aUldd9hyO4ERZxMJWrRMOoewLHEXlG5UOttmtk63Fk9ETzDXJwONIvT5

