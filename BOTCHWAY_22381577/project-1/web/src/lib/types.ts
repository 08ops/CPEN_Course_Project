/** Shapes returned by the database functions in 04_functions.sql. */

export type AppRole = 'student' | 'lecturer' | 'teaching_assistant' | 'admin';

export interface SessionUser {
  userId: number;
  username: string;
  email: string;
  role: AppRole;
  personId: number | null;
  fullName: string | null;
}

/** app.fn_user_context_json() */
export interface UserContext {
  user_id: number;
  username: string;
  email: string;
  role: AppRole;
  is_active: boolean;
  last_login_at: string | null;
  person: {
    person_id: number;
    full_name: string;
    first_name: string;
    last_name: string;
    phone: string;
  } | null;
  student: {
    student_id: number;
    student_number: string;
    level: number;
    programme: string;
    status: string;
    outstanding_balance: string | number;
  } | null;
  lecturer: {
    lecturer_id: number;
    staff_number: string;
    academic_rank: string;
  } | null;
  teaching_assistant: {
    ta_id: number;
    ta_code: string;
    ta_type: string;
  } | null;
}

/** One element of finance.fn_outstanding_fees_json() */
export interface OutstandingFeeRow {
  student_id: number;
  student_number: string;
  full_name: string;
  email: string;
  phone: string;
  programme: string;
  programme_code: string;
  level: number;
  student_status: string;
  residential_status: string;
  currency: string;
  total_billed: number;
  total_paid: number;
  outstanding_balance: number;
  percentage_paid: number;
  payment_status: 'NOT BILLED' | 'FULLY PAID' | 'NO PAYMENT' | 'PART PAID';
  last_payment_date: string | null;
  bill_count: number;
  bills: Array<{
    bill_id: number;
    bill_reference: string;
    academic_year: string;
    amount_billed: number;
    amount_paid: number;
    balance: number;
    due_date: string;
    bill_status: string;
    payments_recorded: number;
    is_overdue: boolean;
  }>;
}

/** finance.fn_student_fee_statement_json() */
export interface FeeStatement {
  student_id: number;
  student_number: string;
  full_name: string;
  programme: string;
  level: number;
  currency: string;
  total_billed: number;
  total_paid: number;
  outstanding_balance: number;
  bills: Array<{
    bill_id: number;
    bill_reference: string;
    academic_year: string;
    issued_on: string;
    due_date: string;
    status: string;
    amount_billed: number;
    amount_paid: number;
    balance: number;
    lines: Array<{ description: string; category: string; amount: number }>;
  }>;
  payments: Array<{
    payment_id: number;
    receipt_number: string;
    amount: number;
    payment_date: string;
    method: string;
    channel: string | null;
    status: string;
  }>;
}

/** academics.fn_student_enrollments_json() */
export interface EnrollmentRow {
  enrollment_id: number;
  offering_id: number;
  course_code: string;
  course_title: string;
  credit_hours: number;
  section: string;
  venue: string | null;
  meeting_days: string | null;
  start_time: string | null;
  end_time: string | null;
  semester: string;
  academic_year: string;
  status: string;
  is_retake: boolean;
  enrolled_on: string;
  final_score: number | null;
  letter_grade: string | null;
  grade_point: number | null;
  lecturer: string | null;
}

/** people.fn_student_profile_json() */
export interface StudentProfile {
  student_id: number;
  student_number: string;
  personal: Record<string, string | number | null>;
  contact: Record<string, string | null>;
  academic: Record<string, string | number | null>;
  next_of_kin: Array<Record<string, string | boolean | null>>;
  outstanding_balance: number;
}

/** app.fn_dashboard_stats_json() */
export interface DashboardStats {
  students: number;
  lecturers: number;
  teaching_assistants: number;
  courses: number;
  offerings_this_semester: number;
  enrollments: number;
  fees: {
    students_billed: number;
    total_billed: number;
    total_collected: number;
    total_outstanding: number;
    collection_rate_percent: number;
    fully_paid_students: number;
    indebted_students: number;
    generated_at: string;
  };
  generated_at: string;
}

/** academics.fn_lecturer_workload_json() */
export interface LecturerWorkload {
  lecturer_id: number;
  staff_number: string;
  full_name: string;
  academic_rank: string;
  email: string;
  department: string;
  total_courses: number;
  total_contact_hours: number;
  courses: Array<{
    assignment_id: number;
    offering_id: number;
    course_code: string;
    course_title: string;
    credit_hours: number;
    section: string;
    teaching_role: string;
    contact_hours: number;
    venue: string | null;
    meeting_days: string | null;
    semester: string;
    enrolled_count: number;
    teaching_assistants: Array<{
      ta_id: number;
      ta_code: string;
      full_name: string;
      ta_type: string;
      responsibility: string;
      weekly_hours: number;
    }>;
  }>;
}
