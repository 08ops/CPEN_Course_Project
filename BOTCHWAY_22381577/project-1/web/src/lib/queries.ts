import 'server-only';

/**
 * Every dashboard read goes through a stored function created in
 * 04_functions.sql. Keeping the SQL in the database (rather than embedding it
 * in React components) means the Next.js app and the Project 2 REST API run
 * exactly the same, single set of tested queries.
 */
import { callJson, query } from './db';
import type {
  DashboardStats,
  EnrollmentRow,
  FeeStatement,
  LecturerWorkload,
  OutstandingFeeRow,
  StudentProfile,
  UserContext,
} from './types';

/* -------------------------------------------------------------------------- */
/* Signed-in user                                                              */
/* -------------------------------------------------------------------------- */

export function getUserContext(userId: number): Promise<UserContext> {
  return callJson<UserContext>('app.fn_user_context_json($1)', [userId]);
}

export function getDashboardStats(): Promise<DashboardStats> {
  return callJson<DashboardStats>('app.fn_dashboard_stats_json()');
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 1 - student personal information                              */
/* -------------------------------------------------------------------------- */

export function getStudentProfile(studentId: number): Promise<StudentProfile> {
  return callJson<StudentProfile>('people.fn_student_profile_json($1)', [studentId]);
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 2 - fees                                                      */
/* -------------------------------------------------------------------------- */

export function getFeeStatement(studentId: number): Promise<FeeStatement> {
  return callJson<FeeStatement>('finance.fn_student_fee_statement_json($1)', [studentId]);
}

/** The required deliverable: outstanding fees for every student. */
export function getOutstandingFees(
  onlyIndebted = false,
): Promise<OutstandingFeeRow[]> {
  return callJson<OutstandingFeeRow[]>(
    'finance.fn_outstanding_fees_json(NULL, NULL, $1)',
    [onlyIndebted],
  );
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITY 3 - course enrolment                                          */
/* -------------------------------------------------------------------------- */

export function getStudentEnrollments(
  studentId: number,
): Promise<EnrollmentRow[]> {
  return callJson<EnrollmentRow[]>(
    'academics.fn_student_enrollments_json($1)',
    [studentId],
  );
}

export interface OfferingSummary {
  offering_id: number;
  course_code: string;
  course_title: string;
  credit_hours: number;
  level: number;
  section: string;
  venue: string | null;
  meeting_days: string | null;
  start_time: string | null;
  end_time: string | null;
  delivery_mode: string;
  capacity: number;
  semester: string;
  academic_year: string;
  enrolled_count: number;
  seats_left: number;
  lecturer_name: string | null;
}

export function getCourseCatalogue(): Promise<OfferingSummary[]> {
  return query<OfferingSummary & Record<string, unknown>>(
    `SELECT * FROM academics.v_course_offering_summary ORDER BY course_code`,
  ) as Promise<OfferingSummary[]>;
}

/* -------------------------------------------------------------------------- */
/* FUNCTIONALITIES 4 & 5 - teaching and TA assignment                          */
/* -------------------------------------------------------------------------- */

export function getLecturerWorkload(
  lecturerId: number,
): Promise<LecturerWorkload> {
  return callJson<LecturerWorkload>(
    'academics.fn_lecturer_workload_json($1)',
    [lecturerId],
  );
}

export interface TaAssignmentRow {
  ta_assignment_id: number;
  lecturer_id: number;
  lecturer: string;
  lecturer_rank: string;
  ta_id: number;
  ta_code: string;
  ta_name: string;
  ta_type: string;
  ta_email: string;
  course_code: string | null;
  course_title: string | null;
  offering_id: number | null;
  semester: string;
  academic_year: string;
  responsibility: string;
  weekly_hours: number;
  assigned_on: string;
  is_active: boolean;
}

export function getTaAssignments(): Promise<TaAssignmentRow[]> {
  return callJson<TaAssignmentRow[]>('academics.fn_ta_assignments_json()');
}

export interface AllocationRow {
  assignment_id: number;
  lecturer_name: string;
  academic_rank: string;
  course_code: string;
  course_title: string;
  teaching_role: string;
  contact_hours_per_week: number;
  semester: string;
  enrolled_students: number;
  assigned_tas: number;
  venue: string | null;
  meeting_days: string | null;
}

export function getLecturerAllocations(): Promise<AllocationRow[]> {
  return query<AllocationRow & Record<string, unknown>>(
    `SELECT assignment_id, lecturer_name, academic_rank, course_code, course_title,
            teaching_role, contact_hours_per_week, semester, enrolled_students,
            assigned_tas, venue, meeting_days
     FROM   academics.v_lecturer_course_allocation
     ORDER  BY course_code, teaching_role`,
  ) as Promise<AllocationRow[]>;
}

/* -------------------------------------------------------------------------- */
/* Student directory (staff view)                                              */
/* -------------------------------------------------------------------------- */

export interface DirectoryRow {
  student_id: number;
  student_number: string;
  full_name: string;
  email: string;
  phone: string;
  gender: string;
  programme: string;
  current_level: number;
  status: string;
  cgpa: string | null;
  residential_status: string;
}

export function getStudentDirectory(): Promise<DirectoryRow[]> {
  return query<DirectoryRow & Record<string, unknown>>(
    `SELECT student_id, student_number, full_name, email, phone, gender,
            programme, current_level, status, cgpa, residential_status
     FROM   people.v_student_directory
     ORDER  BY current_level, student_number`,
  ) as Promise<DirectoryRow[]>;
}
