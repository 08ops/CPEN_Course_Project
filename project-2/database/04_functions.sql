-- =============================================================================
-- File    : 04_functions.sql
-- Purpose : Stored functions. The headline deliverable of the brief is
--             finance.fn_outstanding_fees_json()
--           which calculates the outstanding fees for EVERY student and returns
--           a JSON ARRAY. The remaining functions encapsulate the other four
--           functionalities so that the Next.js app (Project 1 Q2) and the REST
--           API (Project 2) call the database through one tested surface rather
--           than scattering SQL through application code.
-- Usage   : psql -d cpen208_ceds -f 04_functions.sql
-- =============================================================================

SET search_path = core, people, academics, finance, app, public;

-- CREATE OR REPLACE cannot change a function's argument list - it would create
-- a second overload instead. Dropping the older signatures first keeps this
-- script re-runnable against a database built by an earlier version.
DROP FUNCTION IF EXISTS finance.fn_generate_student_bill(INTEGER, INTEGER, DATE);

-- #############################################################################
-- SECTION 1 : FEES  (FUNCTIONALITY 2)
-- #############################################################################

-- -----------------------------------------------------------------------------
-- finance.fn_student_outstanding_balance
-- Scalar helper: how much does ONE student still owe?
--   OUTSTANDING = billed - confirmed payments
-- Payments that are pending, reversed or failed deliberately do NOT count.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_student_outstanding_balance(
    p_student_id       INTEGER,
    p_academic_year_id INTEGER DEFAULT NULL   -- NULL = all academic years
)
RETURNS NUMERIC(12,2)
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION finance.fn_student_outstanding_balance(INTEGER, INTEGER) IS
    'Outstanding fee balance for one student = total billed minus confirmed payments.';

-- -----------------------------------------------------------------------------
-- *** REQUIRED DELIVERABLE ***
-- finance.fn_outstanding_fees_json
--   "Create a database function that will calculate the outstanding fees for
--    each student in your database and return the output in json array."
--
-- Returns a JSON ARRAY, one object per student, e.g.
--   [
--     {
--       "student_id": 1,
--       "student_number": "22128981",
--       "full_name": "Gideon Elorm Glago",
--       "email": "...",
--       "programme": "BSc Computer Engineering",
--       "level": 200,
--       "residential_status": "non-resident",
--       "currency": "GHS",
--       "total_billed": 8450.00,
--       "total_paid": 5000.00,
--       "outstanding_balance": 3450.00,
--       "percentage_paid": 59.17,
--       "payment_status": "PART PAID",
--       "last_payment_date": "2025-11-04",
--       "bill_count": 1,
--       "bills": [ { ...per-bill breakdown... } ]
--     }, ...
--   ]
--
-- All three parameters are optional so the no-argument call
--   SELECT finance.fn_outstanding_fees_json();
-- satisfies the brief exactly, while the API can still filter.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_outstanding_fees_json(
    p_academic_year_id INTEGER DEFAULT NULL,  -- NULL = every academic year
    p_programme_id     INTEGER DEFAULT NULL,  -- NULL = every programme
    p_only_indebted    BOOLEAN DEFAULT FALSE  -- TRUE = hide fully paid students
)
RETURNS json
LANGUAGE plpgsql
STABLE
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

COMMENT ON FUNCTION finance.fn_outstanding_fees_json(INTEGER, INTEGER, BOOLEAN) IS
    'REQUIRED DELIVERABLE: outstanding fees for each student, returned as a JSON array. '
    'Outstanding = total billed - confirmed payments. Optional filters: academic year, programme, indebted-only.';

-- -----------------------------------------------------------------------------
-- Single-student version - what the student dashboard calls.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_student_fee_statement_json(
    p_student_id INTEGER
)
RETURNS json
LANGUAGE plpgsql
STABLE
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

COMMENT ON FUNCTION finance.fn_student_fee_statement_json(INTEGER) IS
    'Full fee statement for one student: bills, their line items, and payment history, as JSON.';

-- -----------------------------------------------------------------------------
-- Generate a bill for a student from the published fee structure.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_generate_student_bill(
    p_student_id       INTEGER,
    p_academic_year_id INTEGER,
    p_due_date         DATE DEFAULT NULL,   -- default: 60 days after issue
    p_issued_on        DATE DEFAULT NULL    -- default: first day of the year
)
RETURNS json
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

COMMENT ON FUNCTION finance.fn_generate_student_bill(INTEGER, INTEGER, DATE, DATE) IS
    'Creates a student bill for an academic year by copying the matching fee structure onto bill lines.';

-- -----------------------------------------------------------------------------
-- Record a fee payment. Used by the REST API (Project 2).
-- Receipt numbers come from a dedicated sequence so concurrent payments can
-- never collide on the same receipt.
-- -----------------------------------------------------------------------------
CREATE SEQUENCE IF NOT EXISTS finance.receipt_seq START 1000;

CREATE OR REPLACE FUNCTION finance.fn_record_payment(
    p_student_id     INTEGER,
    p_bill_id        INTEGER,
    p_amount         NUMERIC,
    p_method         core.payment_method_type,
    p_channel        VARCHAR DEFAULT NULL,
    p_transaction_ref VARCHAR DEFAULT NULL,
    p_received_by    VARCHAR DEFAULT 'Online Portal',
    p_payment_date   DATE DEFAULT NULL
)
RETURNS json
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

COMMENT ON FUNCTION finance.fn_record_payment IS
    'Records a confirmed fee payment against a bill and returns the receipt plus the new balance.';

-- -----------------------------------------------------------------------------
-- Department-level fees summary - powers the admin dashboard cards.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION finance.fn_fees_summary_json(
    p_academic_year_id INTEGER DEFAULT NULL
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION finance.fn_fees_summary_json(INTEGER) IS
    'Aggregate fee collection statistics for the department dashboard.';

-- #############################################################################
-- SECTION 2 : STUDENT PERSONAL INFORMATION  (FUNCTIONALITY 1)
-- #############################################################################

CREATE OR REPLACE FUNCTION people.fn_student_profile_json(
    p_student_id INTEGER
)
RETURNS json
LANGUAGE plpgsql
STABLE
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

COMMENT ON FUNCTION people.fn_student_profile_json(INTEGER) IS
    'FUNCTIONALITY 1 - complete personal, contact and academic record of a student as JSON.';

CREATE OR REPLACE FUNCTION people.fn_students_json(
    p_programme_id INTEGER DEFAULT NULL,
    p_level        SMALLINT DEFAULT NULL,
    p_search       TEXT DEFAULT NULL
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION people.fn_students_json(INTEGER, SMALLINT, TEXT) IS
    'Searchable student directory as a JSON array.';

-- #############################################################################
-- SECTION 3 : COURSE ENROLMENT  (FUNCTIONALITY 3)
-- #############################################################################

CREATE OR REPLACE FUNCTION academics.fn_enroll_student(
    p_student_id  INTEGER,
    p_offering_id INTEGER,
    p_is_retake   BOOLEAN DEFAULT FALSE
)
RETURNS json
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

COMMENT ON FUNCTION academics.fn_enroll_student(INTEGER, INTEGER, BOOLEAN) IS
    'FUNCTIONALITY 3 - registers a student for a course offering.';

CREATE OR REPLACE FUNCTION academics.fn_drop_enrollment(
    p_student_id  INTEGER,
    p_offering_id INTEGER
)
RETURNS json
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

COMMENT ON FUNCTION academics.fn_drop_enrollment(INTEGER, INTEGER) IS
    'FUNCTIONALITY 3 - withdraws a student from a course offering.';

CREATE OR REPLACE FUNCTION academics.fn_student_enrollments_json(
    p_student_id  INTEGER,
    p_semester_id INTEGER DEFAULT NULL
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION academics.fn_student_enrollments_json(INTEGER, INTEGER) IS
    'FUNCTIONALITY 3 - a student''s registered courses with lecturer and timetable, as JSON.';

CREATE OR REPLACE FUNCTION academics.fn_class_list_json(
    p_offering_id INTEGER
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION academics.fn_class_list_json(INTEGER) IS
    'FUNCTIONALITY 3 - the class register for one course offering.';

-- #############################################################################
-- SECTION 4 : LECTURER TO COURSE ASSIGNMENT  (FUNCTIONALITY 4)
-- #############################################################################

CREATE OR REPLACE FUNCTION academics.fn_assign_lecturer_to_course(
    p_lecturer_id INTEGER,
    p_offering_id INTEGER,
    p_role        core.teaching_role_type DEFAULT 'lead_lecturer',
    p_assigned_by VARCHAR DEFAULT 'Head of Department'
)
RETURNS json
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

COMMENT ON FUNCTION academics.fn_assign_lecturer_to_course IS
    'FUNCTIONALITY 4 - assigns a lecturer to a course offering in a given teaching role.';

CREATE OR REPLACE FUNCTION academics.fn_lecturer_workload_json(
    p_lecturer_id INTEGER,
    p_semester_id INTEGER DEFAULT NULL
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION academics.fn_lecturer_workload_json(INTEGER, INTEGER) IS
    'FUNCTIONALITY 4 & 5 - a lecturer''s courses, contact hours and the TAs assigned to each course.';

-- #############################################################################
-- SECTION 5 : LECTURER TO TA ASSIGNMENT  (FUNCTIONALITY 5)
-- #############################################################################

CREATE OR REPLACE FUNCTION academics.fn_assign_ta_to_lecturer(
    p_lecturer_id    INTEGER,
    p_ta_id          INTEGER,
    p_semester_id    INTEGER,
    p_offering_id    INTEGER DEFAULT NULL,
    p_responsibility VARCHAR DEFAULT 'Laboratory supervision and grading',
    p_weekly_hours   SMALLINT DEFAULT 6
)
RETURNS json
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

COMMENT ON FUNCTION academics.fn_assign_ta_to_lecturer IS
    'FUNCTIONALITY 5 - assigns a teaching assistant to a lecturer, guarding the TA''s weekly hour cap.';

CREATE OR REPLACE FUNCTION academics.fn_ta_assignments_json(
    p_semester_id INTEGER DEFAULT NULL,
    p_lecturer_id INTEGER DEFAULT NULL
)
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION academics.fn_ta_assignments_json(INTEGER, INTEGER) IS
    'FUNCTIONALITY 5 - every lecturer-to-TA assignment as a JSON array.';

-- #############################################################################
-- SECTION 6 : APPLICATION / AUTH helpers used by the Next.js app and REST API
-- #############################################################################

CREATE OR REPLACE FUNCTION app.fn_register_user(
    p_username      VARCHAR,
    p_email         VARCHAR,
    p_password_hash VARCHAR,      -- bcrypt hash computed in the application
    p_role          core.app_role_type DEFAULT 'student',
    p_person_id     INTEGER DEFAULT NULL
)
RETURNS json
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

COMMENT ON FUNCTION app.fn_register_user IS
    'Creates a login account. The password is hashed by the application; the plain text never reaches the database.';

CREATE OR REPLACE FUNCTION app.fn_user_context_json(
    p_user_id INTEGER
)
RETURNS json
LANGUAGE plpgsql
STABLE
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

COMMENT ON FUNCTION app.fn_user_context_json(INTEGER) IS
    'Everything the dashboard needs about the signed-in user, resolved across role tables.';

CREATE OR REPLACE FUNCTION app.fn_dashboard_stats_json()
RETURNS json
LANGUAGE sql
STABLE
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

COMMENT ON FUNCTION app.fn_dashboard_stats_json() IS
    'Headline counters for the dashboard landing page.';
