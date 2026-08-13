-- =============================================================================
-- File    : 03_indexes_triggers.sql
-- Purpose : Secondary indexes for the queries the application actually runs,
--           plus the updated_at triggers and the bill-total integrity trigger.
-- Usage   : psql -d cpen208_ceds -f 03_indexes_triggers.sql
-- -----------------------------------------------------------------------------
-- NOTE: PostgreSQL already creates an index for every PRIMARY KEY and UNIQUE
--       constraint, so only FOREIGN KEY columns and frequent filter/sort
--       columns are indexed here. Indexing everything would slow down writes
--       for no benefit.
-- =============================================================================

SET search_path = core, people, academics, finance, app, public;

-- ---------------------------------------------------------------------------
-- core
-- ---------------------------------------------------------------------------
CREATE INDEX programme_department_ix    ON core.programme (department_id);
CREATE INDEX semester_year_ix           ON core.semester  (academic_year_id);

-- ---------------------------------------------------------------------------
-- people
-- ---------------------------------------------------------------------------
-- Name search on the students list page.
CREATE INDEX person_last_first_ix       ON people.person (lower(last_name), lower(first_name));
CREATE INDEX student_programme_ix       ON people.student (programme_id);
CREATE INDEX student_level_status_ix    ON people.student (current_level, status);
CREATE INDEX student_person_ix          ON people.student (person_id);
CREATE INDEX next_of_kin_student_ix     ON people.next_of_kin (student_id);
CREATE INDEX lecturer_department_ix     ON people.lecturer (department_id);
CREATE INDEX lecturer_person_ix         ON people.lecturer (person_id);
CREATE INDEX ta_department_ix           ON people.teaching_assistant (department_id);
CREATE INDEX ta_person_ix               ON people.teaching_assistant (person_id);

-- ---------------------------------------------------------------------------
-- academics
-- ---------------------------------------------------------------------------
CREATE INDEX course_department_ix       ON academics.course (department_id);
CREATE INDEX course_level_ix            ON academics.course (level) WHERE is_active;
CREATE INDEX offering_course_ix         ON academics.course_offering (course_id);
CREATE INDEX offering_semester_ix       ON academics.course_offering (semester_id);

-- The class list for one offering, and the timetable for one student:
CREATE INDEX enrollment_student_ix      ON academics.enrollment (student_id);
CREATE INDEX enrollment_offering_ix     ON academics.enrollment (offering_id);
CREATE INDEX enrollment_status_ix       ON academics.enrollment (status);

CREATE INDEX lca_lecturer_ix            ON academics.lecturer_course_assignment (lecturer_id);
CREATE INDEX lca_offering_ix            ON academics.lecturer_course_assignment (offering_id);

CREATE INDEX lta_lecturer_ix            ON academics.lecturer_ta_assignment (lecturer_id);
CREATE INDEX lta_ta_ix                  ON academics.lecturer_ta_assignment (ta_id);
CREATE INDEX lta_offering_ix            ON academics.lecturer_ta_assignment (offering_id);
CREATE INDEX lta_semester_ix            ON academics.lecturer_ta_assignment (semester_id);

-- ---------------------------------------------------------------------------
-- finance  - these carry the outstanding-fees calculation, so they matter most
-- ---------------------------------------------------------------------------
CREATE INDEX fee_structure_programme_ix ON finance.fee_structure (programme_id, academic_year_id);
CREATE INDEX fee_item_structure_ix      ON finance.fee_item (fee_structure_id);
CREATE INDEX bill_student_ix            ON finance.student_bill (student_id);
CREATE INDEX bill_year_ix               ON finance.student_bill (academic_year_id);
CREATE INDEX bill_status_ix             ON finance.student_bill (status);
CREATE INDEX bill_line_bill_ix          ON finance.bill_line (bill_id);
CREATE INDEX payment_student_ix         ON finance.payment (student_id);
CREATE INDEX payment_bill_ix            ON finance.payment (bill_id);
CREATE INDEX payment_date_ix            ON finance.payment (payment_date DESC);
-- Partial index: the outstanding-fees function only ever sums CONFIRMED money.
CREATE INDEX payment_confirmed_ix       ON finance.payment (bill_id, amount)
                                        WHERE status = 'confirmed';

-- ---------------------------------------------------------------------------
-- app
-- ---------------------------------------------------------------------------
CREATE INDEX app_user_role_ix           ON app.app_user (role) WHERE is_active;
CREATE INDEX app_user_person_ix         ON app.app_user (person_id);
CREATE INDEX session_user_ix            ON app.user_session (user_id);
-- Look-ups of live sessions only.
CREATE INDEX session_live_ix            ON app.user_session (expires_at)
                                        WHERE revoked_at IS NULL;
CREATE INDEX audit_user_time_ix         ON app.audit_log (user_id, occurred_at DESC);
CREATE INDEX audit_action_ix            ON app.audit_log (action);

-- =============================================================================
-- updated_at TRIGGERS
-- Applied to every table that carries an updated_at column.
-- =============================================================================

DO $$
DECLARE
    t RECORD;
BEGIN
    FOR t IN
        SELECT c.table_schema, c.table_name
        FROM   information_schema.columns c
        JOIN   information_schema.tables tb
               ON tb.table_schema = c.table_schema
              AND tb.table_name   = c.table_name
              AND tb.table_type   = 'BASE TABLE'
        WHERE  c.column_name = 'updated_at'
          AND  c.table_schema IN ('core','people','academics','finance','app')
    LOOP
        EXECUTE format(
            'CREATE TRIGGER %I BEFORE UPDATE ON %I.%I
             FOR EACH ROW EXECUTE FUNCTION core.fn_set_updated_at()',
            't_' || t.table_name || '_set_updated_at',
            t.table_schema, t.table_name
        );
    END LOOP;
END;
$$;

-- =============================================================================
-- BILL TOTAL INTEGRITY
-- student_bill.total_amount is a deliberate, maintained denormalisation: the
-- outstanding-fees report reads it constantly, so recomputing SUM(bill_line)
-- on every read would be wasteful. This trigger guarantees it never drifts
-- away from the sum of its lines.
-- =============================================================================

CREATE OR REPLACE FUNCTION finance.fn_refresh_bill_total()
RETURNS TRIGGER
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

COMMENT ON FUNCTION finance.fn_refresh_bill_total() IS
    'Keeps student_bill.total_amount equal to the sum of its bill_line rows.';

CREATE TRIGGER t_bill_line_refresh_total
AFTER INSERT OR UPDATE OR DELETE ON finance.bill_line
FOR EACH ROW EXECUTE FUNCTION finance.fn_refresh_bill_total();

-- =============================================================================
-- BILL STATUS MAINTENANCE
-- Whenever money is received (or reversed) the bill status is recalculated so
-- that 'issued' / 'part_paid' / 'paid' / 'overdue' is always truthful.
-- =============================================================================

CREATE OR REPLACE FUNCTION finance.fn_refresh_bill_status()
RETURNS TRIGGER
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

COMMENT ON FUNCTION finance.fn_refresh_bill_status() IS
    'Recalculates student_bill.status from confirmed payments and the due date.';

CREATE TRIGGER t_payment_refresh_bill_status
AFTER INSERT OR UPDATE OR DELETE ON finance.payment
FOR EACH ROW EXECUTE FUNCTION finance.fn_refresh_bill_status();

-- =============================================================================
-- ENROLMENT GUARDS
-- Business rules that a CHECK constraint cannot express because they need to
-- look at other rows.
-- =============================================================================

CREATE OR REPLACE FUNCTION academics.fn_validate_enrollment()
RETURNS TRIGGER
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

COMMENT ON FUNCTION academics.fn_validate_enrollment() IS
    'Blocks registration when the student is inactive, registration is closed, or the class is full.';

CREATE TRIGGER t_enrollment_validate
BEFORE INSERT ON academics.enrollment
FOR EACH ROW EXECUTE FUNCTION academics.fn_validate_enrollment();
