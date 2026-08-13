-- =============================================================================
-- File    : 07_verification.sql
-- Purpose : Demonstrates that every requirement in the brief is satisfied.
--           Run this after the seed script; the output is what was pasted into
--           the project report.
-- Usage   : psql -d cpen208_ceds -f 07_verification.sql
-- =============================================================================

\echo ''
\echo '################################################################'
\echo '# 1. SCHEMAS CREATED'
\echo '################################################################'
SELECT nspname AS schema_name,
       (SELECT COUNT(*) FROM pg_class c
        WHERE c.relnamespace = n.oid AND c.relkind = 'r') AS tables,
       (SELECT COUNT(*) FROM pg_class c
        WHERE c.relnamespace = n.oid AND c.relkind = 'v') AS views,
       (SELECT COUNT(*) FROM pg_proc p
        WHERE p.pronamespace = n.oid)                     AS functions
FROM   pg_namespace n
WHERE  nspname IN ('core','people','academics','finance','app')
ORDER  BY nspname;

\echo ''
\echo '################################################################'
\echo '# 2. FUNCTIONALITY 1 - STUDENT PERSONAL INFORMATION'
\echo '################################################################'
SELECT student_number, full_name, gender, age, programme_code, current_level,
       residential_status, cgpa
FROM   people.v_student_directory
ORDER  BY student_number
LIMIT  10;

\echo ''
\echo '-- Full personal record of one student, as JSON:'
SELECT jsonb_pretty(people.fn_student_profile_json(
           (SELECT student_id FROM people.student WHERE student_number = '22128981'))::jsonb);

\echo ''
\echo '################################################################'
\echo '# 3. FUNCTIONALITY 3 - COURSE ENROLLMENT'
\echo '################################################################'
SELECT course_code, course_title, semester, academic_year,
       COUNT(*) FILTER (WHERE status <> 'dropped') AS enrolled,
       COUNT(*) FILTER (WHERE status = 'dropped')  AS dropped
FROM   academics.v_enrollment_detail
GROUP  BY course_code, course_title, semester, academic_year
ORDER  BY course_code;

\echo ''
\echo '################################################################'
\echo '# 4. FUNCTIONALITY 4 - LECTURER TO COURSE ASSIGNMENT'
\echo '################################################################'
SELECT lecturer_name, academic_rank, course_code, course_title,
       teaching_role, contact_hours_per_week, enrolled_students, assigned_tas
FROM   academics.v_lecturer_course_allocation
ORDER  BY course_code, teaching_role;

\echo ''
\echo '################################################################'
\echo '# 5. FUNCTIONALITY 5 - LECTURER TO TA ASSIGNMENT'
\echo '################################################################'
SELECT lecturer_name, ta_code, ta_name, ta_type, course_code,
       weekly_hours, max_weekly_hours, responsibility
FROM   academics.v_lecturer_ta_allocation
ORDER  BY lecturer_name, ta_code;

\echo ''
\echo '################################################################'
\echo '# 6. FUNCTIONALITY 2 - STUDENT FEES PAYMENTS'
\echo '################################################################'
SELECT student_number, full_name, amount_billed, amount_paid,
       outstanding_balance, percentage_paid, bill_status, is_overdue
FROM   finance.v_student_fee_status
ORDER  BY outstanding_balance DESC, student_number
LIMIT  15;

\echo ''
\echo '################################################################'
\echo '# 7. *** REQUIRED DELIVERABLE ***'
\echo '#    finance.fn_outstanding_fees_json() - OUTSTANDING FEES FOR'
\echo '#    EACH STUDENT, RETURNED AS A JSON ARRAY'
\echo '################################################################'
\echo ''
\echo '-- 7a. Confirm the return value really is a JSON array:'
SELECT json_typeof(finance.fn_outstanding_fees_json())        AS json_type,
       json_array_length(finance.fn_outstanding_fees_json())  AS elements_in_array;

\echo ''
\echo '-- 7b. The first two elements of the array, pretty printed:'
SELECT jsonb_pretty(
         (SELECT jsonb_agg(e)
          FROM   jsonb_array_elements(finance.fn_outstanding_fees_json()::jsonb)
                 WITH ORDINALITY AS t(e, ord)
          WHERE  ord <= 2));

\echo ''
\echo '-- 7c. The array flattened back into rows, to prove the numbers add up:'
SELECT e->>'student_number'                       AS student_number,
       e->>'full_name'                            AS full_name,
       (e->>'total_billed')::NUMERIC              AS billed,
       (e->>'total_paid')::NUMERIC                AS paid,
       (e->>'outstanding_balance')::NUMERIC       AS outstanding,
       e->>'payment_status'                       AS status
FROM   json_array_elements(finance.fn_outstanding_fees_json()) AS e
ORDER  BY (e->>'outstanding_balance')::NUMERIC DESC
LIMIT  15;

\echo ''
\echo '-- 7d. Independent cross-check: the same figures computed with plain SQL.'
\echo '--     A zero difference proves the function is correct.'
WITH from_function AS (
    SELECT (e->>'student_id')::INT              AS student_id,
           (e->>'outstanding_balance')::NUMERIC AS fn_outstanding
    FROM   json_array_elements(finance.fn_outstanding_fees_json()) AS e
),
from_plain_sql AS (
    SELECT s.student_id,
           COALESCE(SUM(b.total_amount), 0)
         - COALESCE(SUM((SELECT SUM(p.amount) FROM finance.payment p
                         WHERE p.bill_id = b.bill_id AND p.status = 'confirmed')), 0)
               AS sql_outstanding
    FROM   people.student s
    LEFT   JOIN finance.student_bill b
           ON b.student_id = s.student_id AND b.status <> 'cancelled'
    GROUP  BY s.student_id
)
SELECT COUNT(*)                                                   AS students_compared,
       COUNT(*) FILTER (WHERE f.fn_outstanding <> p.sql_outstanding) AS mismatches,
       COALESCE(SUM(ABS(f.fn_outstanding - p.sql_outstanding)), 0)   AS total_difference
FROM   from_function f
JOIN   from_plain_sql p USING (student_id);

\echo ''
\echo '-- 7e. Filtered call - indebted students only:'
SELECT json_array_length(finance.fn_outstanding_fees_json(NULL, NULL, TRUE))
           AS students_still_owing;

\echo ''
\echo '-- 7f. Proof that pending and reversed payments are excluded:'
SELECT s.student_number,
       p.receipt_number, p.amount, p.status,
       finance.fn_student_outstanding_balance(s.student_id) AS outstanding_balance
FROM   finance.payment p
JOIN   people.student s ON s.student_id = p.student_id
WHERE  p.status IN ('pending','reversed')
ORDER  BY p.receipt_number;

\echo ''
\echo '################################################################'
\echo '# 8. DEPARTMENT FEE SUMMARY'
\echo '################################################################'
SELECT jsonb_pretty(finance.fn_fees_summary_json()::jsonb);

\echo ''
\echo '################################################################'
\echo '# 9. REFERENTIAL INTEGRITY - every FK resolves, no orphans'
\echo '################################################################'
SELECT conrelid::regclass AS child_table,
       COUNT(*)           AS foreign_keys
FROM   pg_constraint
WHERE  contype = 'f'
  AND  connamespace IN (
        SELECT oid FROM pg_namespace
        WHERE nspname IN ('core','people','academics','finance','app'))
GROUP  BY conrelid::regclass
ORDER  BY 1;

\echo ''
\echo '################################################################'
\echo '# 10. ALL STORED FUNCTIONS IN THE DATABASE'
\echo '################################################################'
SELECT n.nspname || '.' || p.proname                    AS function_name,
       pg_get_function_result(p.oid)                    AS returns
FROM   pg_proc p
JOIN   pg_namespace n ON n.oid = p.pronamespace
WHERE  n.nspname IN ('core','people','academics','finance','app')
ORDER  BY 1;
