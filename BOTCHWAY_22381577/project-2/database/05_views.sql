-- =============================================================================
-- File    : 05_views.sql
-- Purpose : Reporting views. These give the application (and the marker) a
--           readable, joined picture of each functionality without repeating
--           six-table joins in every query.
-- Usage   : psql -d cpen208_ceds -f 05_views.sql
-- =============================================================================

SET search_path = core, people, academics, finance, app, public;

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 1 : the student register
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW people.v_student_directory AS
SELECT s.student_id,
       s.student_number,
       TRIM(pr.first_name || ' ' || COALESCE(pr.middle_name || ' ', '') || pr.last_name)
                                       AS full_name,
       pr.first_name,
       pr.last_name,
       pr.email,
       pr.phone,
       pr.gender,
       pr.date_of_birth,
       DATE_PART('year', AGE(pr.date_of_birth))::INT AS age,
       pr.nationality,
       pr.home_region,
       pg.code                          AS programme_code,
       pg.name                          AS programme,
       d.name                           AS department,
       s.current_level,
       s.status,
       s.residential_status,
       s.hall_of_residence,
       s.admission_date,
       s.cgpa
FROM   people.student  s
JOIN   people.person   pr ON pr.person_id    = s.person_id
JOIN   core.programme  pg ON pg.programme_id = s.programme_id
JOIN   core.department d  ON d.department_id = pg.department_id;

COMMENT ON VIEW people.v_student_directory IS
    'FUNCTIONALITY 1 - flattened student personal + academic information.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 2 : fee position of every student
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW finance.v_student_fee_status AS
SELECT s.student_id,
       s.student_number,
       TRIM(pr.first_name || ' ' || pr.last_name) AS full_name,
       pg.name                                    AS programme,
       s.current_level                            AS level,
       ay.name                                    AS academic_year,
       b.bill_id,
       b.bill_reference,
       b.total_amount                             AS amount_billed,
       COALESCE(pay.amount_paid, 0)               AS amount_paid,
       b.total_amount - COALESCE(pay.amount_paid, 0) AS outstanding_balance,
       CASE WHEN b.total_amount > 0
            THEN ROUND(100.0 * COALESCE(pay.amount_paid, 0) / b.total_amount, 2)
            ELSE 0 END                            AS percentage_paid,
       b.due_date,
       b.status                                   AS bill_status,
       (b.total_amount - COALESCE(pay.amount_paid, 0) > 0
        AND b.due_date < CURRENT_DATE)            AS is_overdue,
       pay.last_payment_date,
       COALESCE(pay.payment_count, 0)             AS payment_count
FROM   finance.student_bill b
JOIN   people.student  s  ON s.student_id     = b.student_id
JOIN   people.person   pr ON pr.person_id     = s.person_id
JOIN   core.programme  pg ON pg.programme_id  = s.programme_id
JOIN   core.academic_year ay ON ay.academic_year_id = b.academic_year_id
LEFT   JOIN LATERAL (
        SELECT SUM(p.amount)      AS amount_paid,
               MAX(p.payment_date) AS last_payment_date,
               COUNT(*)            AS payment_count
        FROM   finance.payment p
        WHERE  p.bill_id = b.bill_id AND p.status = 'confirmed'
) pay ON TRUE
WHERE  b.status <> 'cancelled';

COMMENT ON VIEW finance.v_student_fee_status IS
    'FUNCTIONALITY 2 - billed vs paid vs outstanding for every student bill.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 3 : who is registered for what
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW academics.v_enrollment_detail AS
SELECT e.enrollment_id,
       s.student_id,
       s.student_number,
       TRIM(pr.first_name || ' ' || pr.last_name) AS student_name,
       s.current_level                            AS student_level,
       c.course_id,
       c.course_code,
       c.title                                    AS course_title,
       c.credit_hours,
       o.offering_id,
       o.section,
       o.venue,
       o.meeting_days,
       o.start_time,
       o.end_time,
       sem.name                                   AS semester,
       ay.name                                    AS academic_year,
       e.status,
       e.is_retake,
       e.enrolled_on,
       e.final_score,
       e.letter_grade,
       e.grade_point,
       lect.lecturer_name
FROM   academics.enrollment e
JOIN   people.student s            ON s.student_id    = e.student_id
JOIN   people.person  pr           ON pr.person_id    = s.person_id
JOIN   academics.course_offering o ON o.offering_id   = e.offering_id
JOIN   academics.course c          ON c.course_id     = o.course_id
JOIN   core.semester sem           ON sem.semester_id = o.semester_id
JOIN   core.academic_year ay       ON ay.academic_year_id = sem.academic_year_id
LEFT   JOIN LATERAL (
        SELECT TRIM(COALESCE(lp.title || ' ', '') || lp.first_name || ' ' || lp.last_name)
                   AS lecturer_name
        FROM   academics.lecturer_course_assignment a
        JOIN   people.lecturer l  ON l.lecturer_id = a.lecturer_id
        JOIN   people.person   lp ON lp.person_id  = l.person_id
        WHERE  a.offering_id = o.offering_id
          AND  a.teaching_role = 'lead_lecturer' AND a.is_active
        LIMIT  1
) lect ON TRUE;

COMMENT ON VIEW academics.v_enrollment_detail IS
    'FUNCTIONALITY 3 - every enrolment joined to student, course, semester and lead lecturer.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 4 : teaching allocation
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW academics.v_lecturer_course_allocation AS
SELECT a.assignment_id,
       l.lecturer_id,
       l.staff_number,
       TRIM(COALESCE(lp.title || ' ', '') || lp.first_name || ' ' || lp.last_name)
                                        AS lecturer_name,
       l.academic_rank,
       lp.email                         AS lecturer_email,
       d.name                           AS department,
       c.course_code,
       c.title                          AS course_title,
       c.credit_hours,
       o.offering_id,
       o.section,
       o.venue,
       o.meeting_days,
       sem.name                         AS semester,
       ay.name                          AS academic_year,
       a.teaching_role,
       a.contact_hours_per_week,
       a.assigned_on,
       a.is_active,
       (SELECT COUNT(*) FROM academics.enrollment e
        WHERE e.offering_id = o.offering_id AND e.status <> 'dropped') AS enrolled_students,
       (SELECT COUNT(*) FROM academics.lecturer_ta_assignment t
        WHERE t.offering_id = o.offering_id AND t.lecturer_id = l.lecturer_id
          AND t.is_active)                                             AS assigned_tas
FROM   academics.lecturer_course_assignment a
JOIN   people.lecturer l           ON l.lecturer_id   = a.lecturer_id
JOIN   people.person   lp          ON lp.person_id    = l.person_id
JOIN   core.department d           ON d.department_id = l.department_id
JOIN   academics.course_offering o  ON o.offering_id  = a.offering_id
JOIN   academics.course c           ON c.course_id    = o.course_id
JOIN   core.semester sem            ON sem.semester_id = o.semester_id
JOIN   core.academic_year ay        ON ay.academic_year_id = sem.academic_year_id;

COMMENT ON VIEW academics.v_lecturer_course_allocation IS
    'FUNCTIONALITY 4 - which lecturer teaches which offering, with class size and TA count.';

-- ---------------------------------------------------------------------------
-- FUNCTIONALITY 5 : TA deployment
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW academics.v_lecturer_ta_allocation AS
SELECT lta.ta_assignment_id,
       l.lecturer_id,
       TRIM(COALESCE(lp.title || ' ', '') || lp.first_name || ' ' || lp.last_name)
                                        AS lecturer_name,
       l.academic_rank,
       t.ta_id,
       t.ta_code,
       TRIM(tp.first_name || ' ' || tp.last_name) AS ta_name,
       tp.email                         AS ta_email,
       t.ta_type,
       st.student_number                AS ta_student_number,
       c.course_code,
       c.title                          AS course_title,
       lta.offering_id,
       sem.name                         AS semester,
       ay.name                          AS academic_year,
       lta.responsibility,
       lta.weekly_hours,
       t.max_weekly_hours,
       lta.assigned_on,
       lta.is_active
FROM   academics.lecturer_ta_assignment lta
JOIN   people.lecturer l  ON l.lecturer_id = lta.lecturer_id
JOIN   people.person   lp ON lp.person_id  = l.person_id
JOIN   people.teaching_assistant t ON t.ta_id = lta.ta_id
JOIN   people.person   tp ON tp.person_id  = t.person_id
LEFT   JOIN people.student st ON st.student_id = t.student_id
JOIN   core.semester sem  ON sem.semester_id = lta.semester_id
JOIN   core.academic_year ay ON ay.academic_year_id = sem.academic_year_id
LEFT   JOIN academics.course_offering o ON o.offering_id = lta.offering_id
LEFT   JOIN academics.course c          ON c.course_id   = o.course_id;

COMMENT ON VIEW academics.v_lecturer_ta_allocation IS
    'FUNCTIONALITY 5 - teaching assistants mapped to the lecturers and courses they support.';

-- ---------------------------------------------------------------------------
-- Course offering summary - used by the course catalogue screen
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW academics.v_course_offering_summary AS
SELECT o.offering_id,
       c.course_code,
       c.title            AS course_title,
       c.credit_hours,
       c.level,
       o.section,
       o.venue,
       o.meeting_days,
       o.start_time,
       o.end_time,
       o.delivery_mode,
       o.capacity,
       sem.name           AS semester,
       ay.name            AS academic_year,
       o.is_open_for_registration,
       (SELECT COUNT(*) FROM academics.enrollment e
        WHERE e.offering_id = o.offering_id AND e.status <> 'dropped') AS enrolled_count,
       o.capacity - (SELECT COUNT(*) FROM academics.enrollment e
                     WHERE e.offering_id = o.offering_id AND e.status <> 'dropped') AS seats_left,
       lect.lecturer_name
FROM   academics.course_offering o
JOIN   academics.course c    ON c.course_id     = o.course_id
JOIN   core.semester sem     ON sem.semester_id = o.semester_id
JOIN   core.academic_year ay ON ay.academic_year_id = sem.academic_year_id
LEFT   JOIN LATERAL (
        SELECT TRIM(COALESCE(lp.title || ' ', '') || lp.first_name || ' ' || lp.last_name)
                   AS lecturer_name
        FROM   academics.lecturer_course_assignment a
        JOIN   people.lecturer l  ON l.lecturer_id = a.lecturer_id
        JOIN   people.person   lp ON lp.person_id  = l.person_id
        WHERE  a.offering_id = o.offering_id
          AND  a.teaching_role = 'lead_lecturer' AND a.is_active
        LIMIT  1
) lect ON TRUE;

COMMENT ON VIEW academics.v_course_offering_summary IS
    'Course catalogue for a semester with live seat availability.';
