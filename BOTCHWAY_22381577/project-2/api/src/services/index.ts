/**
 * Service layer.
 *
 * Each function here is a thin, typed wrapper around ONE stored function from
 * Project 1's 04_functions.sql. The API deliberately contains no business
 * arithmetic of its own: "outstanding fees", "is this TA over their hours",
 * "is this class full" are all answered by the database, exactly as they are
 * for the Next.js application. That is what "implement the functions created
 * in Project 1" means in practice.
 */
import bcrypt from 'bcryptjs';

import { config } from '../config';
import { callJson, query, queryOne } from '../db';
import { ApiError } from '../errors';
import type { AppRole, AuthPayload } from '../middleware/auth';

/* -------------------------------------------------------------------------- */
/* Authentication                                                              */
/* -------------------------------------------------------------------------- */

interface UserRow {
  user_id: number;
  username: string;
  email: string;
  password_hash: string;
  role: AppRole;
  person_id: number | null;
  is_active: boolean;
  student_id: number | null;
  lecturer_id: number | null;
}

export async function authenticate(
  username: string,
  password: string,
): Promise<AuthPayload> {
  const user = await queryOne<UserRow>(
    `SELECT u.user_id, u.username, u.email, u.password_hash, u.role,
            u.person_id, u.is_active,
            s.student_id, l.lecturer_id
     FROM   app.app_user u
     LEFT   JOIN people.student  s ON s.person_id = u.person_id
     LEFT   JOIN people.lecturer l ON l.person_id = u.person_id
     WHERE  lower(u.username) = lower($1) OR lower(u.email) = lower($1)`,
    [username],
  );

  // Identical response for "unknown user" and "wrong password" so the endpoint
  // cannot be used to discover which accounts exist.
  if (!user) {
    await bcrypt.compare(password, '$2a$10$invalidinvalidinvalidinvalidinvalidinvalidinvalidinvalidiu');
    throw ApiError.unauthorised('Invalid username or password.');
  }

  if (!user.is_active) {
    throw ApiError.forbidden('This account has been deactivated.');
  }

  const ok = await bcrypt.compare(password, user.password_hash);
  if (!ok) {
    await query(
      `UPDATE app.app_user
       SET    failed_login_attempts = failed_login_attempts + 1
       WHERE  user_id = $1`,
      [user.user_id],
    );
    throw ApiError.unauthorised('Invalid username or password.');
  }

  await query(
    `UPDATE app.app_user
     SET    failed_login_attempts = 0, last_login_at = CURRENT_TIMESTAMP
     WHERE  user_id = $1`,
    [user.user_id],
  );

  await audit(user.user_id, 'API_LOGIN', 'app_user', String(user.user_id), {
    role: user.role,
  });

  return {
    sub: user.user_id,
    username: user.username,
    role: user.role,
    personId: user.person_id,
    studentId: user.student_id,
    lecturerId: user.lecturer_id,
  };
}

export async function registerUser(input: {
  username: string;
  email: string;
  password: string;
  role: AppRole;
  studentNumber?: string;
}) {
  let personId: number | null = null;

  if (input.studentNumber) {
    const student = await queryOne<{ person_id: number; taken: boolean }>(
      `SELECT s.person_id,
              EXISTS (SELECT 1 FROM app.app_user u WHERE u.person_id = s.person_id) AS taken
       FROM   people.student s
       WHERE  s.student_number = $1`,
      [input.studentNumber],
    );

    if (!student) {
      throw ApiError.notFound(
        `No student record found for index number ${input.studentNumber}.`,
      );
    }
    if (student.taken) {
      throw ApiError.conflict(
        'That student record already has an account linked to it.',
      );
    }
    personId = student.person_id;
  }

  const passwordHash = await bcrypt.hash(input.password, config.bcryptRounds);

  return callJson<{ user_id: number; username: string; email: string; role: string }>(
    'app.fn_register_user($1, $2, $3, $4::core.app_role_type, $5)',
    [input.username, input.email, passwordHash, input.role, personId],
  );
}

export function getUserContext(userId: number) {
  return callJson('app.fn_user_context_json($1)', [userId]);
}

export function getDashboardStats() {
  return callJson('app.fn_dashboard_stats_json()');
}

async function audit(
  userId: number | null,
  action: string,
  entity: string | null,
  entityId: string | null,
  details: Record<string, unknown>,
): Promise<void> {
  try {
    await query(
      `INSERT INTO app.audit_log (user_id, action, entity, entity_id, details)
       VALUES ($1, $2, $3, $4, $5::jsonb)`,
      [userId, action, entity, entityId, JSON.stringify(details)],
    );
  } catch (error) {
    console.error('[audit] write failed:', error);
  }
}

export { audit };

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 1 - Student personal information                              */
/* -------------------------------------------------------------------------- */

export function listStudents(filters: {
  programmeId?: number;
  level?: number;
  search?: string;
}) {
  return callJson('people.fn_students_json($1, $2::SMALLINT, $3)', [
    filters.programmeId ?? null,
    filters.level ?? null,
    filters.search ?? null,
  ]);
}

export function getStudentProfile(studentId: number) {
  return callJson('people.fn_student_profile_json($1)', [studentId]);
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 2 - Student fees payments                                     */
/* -------------------------------------------------------------------------- */

/** THE required deliverable of Project 1, exposed over HTTP. */
export function getOutstandingFees(filters: {
  academicYearId?: number;
  programmeId?: number;
  indebtedOnly?: boolean;
}) {
  return callJson('finance.fn_outstanding_fees_json($1, $2, $3)', [
    filters.academicYearId ?? null,
    filters.programmeId ?? null,
    filters.indebtedOnly ?? false,
  ]);
}

export function getStudentFeeStatement(studentId: number) {
  return callJson('finance.fn_student_fee_statement_json($1)', [studentId]);
}

export async function getStudentOutstandingBalance(studentId: number) {
  const row = await queryOne<{ balance: string }>(
    'SELECT finance.fn_student_outstanding_balance($1) AS balance',
    [studentId],
  );
  return Number(row?.balance ?? 0);
}

export function getFeesSummary(academicYearId?: number) {
  return callJson('finance.fn_fees_summary_json($1)', [academicYearId ?? null]);
}

export function generateBill(input: {
  studentId: number;
  academicYearId: number;
  dueDate?: string;
  issuedOn?: string;
}) {
  return callJson('finance.fn_generate_student_bill($1, $2, $3, $4)', [
    input.studentId,
    input.academicYearId,
    input.dueDate ?? null,
    input.issuedOn ?? null,
  ]);
}

export function recordPayment(input: {
  studentId: number;
  billId: number;
  amount: number;
  method: string;
  channel?: string;
  transactionRef?: string;
  receivedBy?: string;
  paymentDate?: string;
}) {
  return callJson(
    `finance.fn_record_payment($1, $2, $3, $4::core.payment_method_type,
                               $5, $6, $7, $8)`,
    [
      input.studentId,
      input.billId,
      input.amount,
      input.method,
      input.channel ?? null,
      input.transactionRef ?? null,
      input.receivedBy ?? 'REST API',
      input.paymentDate ?? null,
    ],
  );
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 3 - Course enrolment                                          */
/* -------------------------------------------------------------------------- */

export function enrolStudent(studentId: number, offeringId: number, isRetake = false) {
  return callJson('academics.fn_enroll_student($1, $2, $3)', [
    studentId,
    offeringId,
    isRetake,
  ]);
}

export function dropEnrolment(studentId: number, offeringId: number) {
  return callJson('academics.fn_drop_enrollment($1, $2)', [studentId, offeringId]);
}

export function getStudentEnrolments(studentId: number, semesterId?: number) {
  return callJson('academics.fn_student_enrollments_json($1, $2)', [
    studentId,
    semesterId ?? null,
  ]);
}

export function getClassList(offeringId: number) {
  return callJson('academics.fn_class_list_json($1)', [offeringId]);
}

export function getCourseCatalogue() {
  return query(
    `SELECT * FROM academics.v_course_offering_summary ORDER BY course_code`,
  );
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 4 - Lecturer to course assignment                             */
/* -------------------------------------------------------------------------- */

export function assignLecturerToCourse(input: {
  lecturerId: number;
  offeringId: number;
  role: string;
  assignedBy?: string;
}) {
  return callJson(
    `academics.fn_assign_lecturer_to_course($1, $2, $3::core.teaching_role_type, $4)`,
    [
      input.lecturerId,
      input.offeringId,
      input.role,
      input.assignedBy ?? 'Head of Department',
    ],
  );
}

export function getLecturerWorkload(lecturerId: number, semesterId?: number) {
  return callJson('academics.fn_lecturer_workload_json($1, $2)', [
    lecturerId,
    semesterId ?? null,
  ]);
}

export function getLecturerAllocations() {
  return query(
    `SELECT * FROM academics.v_lecturer_course_allocation
     ORDER BY course_code, teaching_role`,
  );
}

export function listLecturers() {
  return query(
    `SELECT l.lecturer_id, l.staff_number,
            TRIM(COALESCE(p.title || ' ', '') || p.first_name || ' ' || p.last_name) AS full_name,
            l.academic_rank, l.specialisation, p.email, d.name AS department, l.status
     FROM   people.lecturer l
     JOIN   people.person p    ON p.person_id = l.person_id
     JOIN   core.department d  ON d.department_id = l.department_id
     ORDER  BY l.staff_number`,
  );
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 5 - Lecturer to TA assignment                                 */
/* -------------------------------------------------------------------------- */

export function assignTaToLecturer(input: {
  lecturerId: number;
  taId: number;
  semesterId: number;
  offeringId?: number;
  responsibility?: string;
  weeklyHours: number;
}) {
  return callJson(
    `academics.fn_assign_ta_to_lecturer($1, $2, $3, $4, $5, $6::SMALLINT)`,
    [
      input.lecturerId,
      input.taId,
      input.semesterId,
      input.offeringId ?? null,
      input.responsibility ?? 'Laboratory supervision and grading',
      input.weeklyHours,
    ],
  );
}

export function getTaAssignments(filters: { semesterId?: number; lecturerId?: number }) {
  return callJson('academics.fn_ta_assignments_json($1, $2)', [
    filters.semesterId ?? null,
    filters.lecturerId ?? null,
  ]);
}

export function listTeachingAssistants() {
  return query(
    `SELECT t.ta_id, t.ta_code,
            TRIM(p.first_name || ' ' || p.last_name) AS full_name,
            t.ta_type, p.email, t.max_weekly_hours, t.monthly_stipend, t.status,
            s.student_number,
            COALESCE((SELECT SUM(a.weekly_hours)
                      FROM academics.lecturer_ta_assignment a
                      WHERE a.ta_id = t.ta_id AND a.is_active), 0) AS committed_hours
     FROM   people.teaching_assistant t
     JOIN   people.person p ON p.person_id = t.person_id
     LEFT   JOIN people.student s ON s.student_id = t.student_id
     ORDER  BY t.ta_code`,
  );
}

/* -------------------------------------------------------------------------- */
/* Reference data                                                              */
/* -------------------------------------------------------------------------- */

export function listProgrammes() {
  return query(
    `SELECT pg.programme_id, pg.code, pg.name, pg.degree_award,
            pg.duration_years, d.name AS department
     FROM   core.programme pg
     JOIN   core.department d ON d.department_id = pg.department_id
     ORDER  BY pg.code`,
  );
}

export function listSemesters() {
  return query(
    `SELECT s.semester_id, s.name, s.sequence_no, s.start_date, s.end_date,
            s.is_current, ay.academic_year_id, ay.name AS academic_year
     FROM   core.semester s
     JOIN   core.academic_year ay ON ay.academic_year_id = s.academic_year_id
     ORDER  BY ay.start_date DESC, s.sequence_no`,
  );
}
