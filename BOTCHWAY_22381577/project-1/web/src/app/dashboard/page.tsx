import type { Metadata } from 'next';
import Link from 'next/link';
import { redirect } from 'next/navigation';

import { ProgressBar, StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { money, percent, toNumber } from '@/lib/format';
import {
  getDashboardStats,
  getStudentEnrollments,
  getUserContext,
} from '@/lib/queries';

export const metadata: Metadata = { title: 'Overview' };
export const dynamic = 'force-dynamic';

export default async function DashboardPage({
  searchParams,
}: {
  searchParams: { welcome?: string };
}) {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  const [context, stats] = await Promise.all([
    getUserContext(user.userId),
    getDashboardStats(),
  ]);

  const isStudent = context.student !== null;
  const enrollments = isStudent
    ? await getStudentEnrollments(context.student!.student_id)
    : [];

  const activeCourses = enrollments.filter((e) => e.status !== 'dropped');
  const credits = activeCourses.reduce((sum, e) => sum + e.credit_hours, 0);
  const outstanding = toNumber(context.student?.outstanding_balance);

  return (
    <div className="space-y-8">
      {searchParams.welcome === '1' && (
        <div className="alert-success" role="status">
          <span aria-hidden className="mt-0.5 font-bold">
            ✓
          </span>
          <span>
            Your account was created and you are now signed in. Welcome to CEDS.
          </span>
        </div>
      )}

      <header>
        <p className="section-title">Dashboard</p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Welcome, {context.person?.first_name ?? context.username}
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          {context.student
            ? `${context.student.programme} · Level ${context.student.level} · Index ${context.student.student_number}`
            : context.lecturer
              ? `${context.lecturer.academic_rank} · Staff number ${context.lecturer.staff_number}`
              : context.teaching_assistant
                ? `Teaching assistant · ${context.teaching_assistant.ta_code}`
                : 'Departmental administrator'}
        </p>
      </header>

      {/* ---- student view ---------------------------------------------------- */}
      {isStudent && (
        <>
          <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard
              label="Outstanding fees"
              value={money(outstanding)}
              sub={outstanding > 0 ? 'Payment required' : 'Fully paid'}
              tone={outstanding > 0 ? 'red' : 'green'}
            />
            <StatCard
              label="Registered courses"
              value={activeCourses.length}
              sub={`${credits} credit hours`}
            />
            <StatCard
              label="Academic level"
              value={context.student!.level}
              sub={context.student!.status}
              tone="green"
            />
            <StatCard
              label="Semester"
              value={activeCourses[0]?.semester ?? 'First Semester'}
              sub={activeCourses[0]?.academic_year ?? '2025/2026'}
            />
          </section>

          <section className="card card-pad">
            <div className="flex flex-wrap items-center justify-between gap-3">
              <div>
                <h2 className="font-semibold text-navy-900 dark:text-white">
                  This semester at a glance
                </h2>
                <p className="mt-1 text-sm text-slate-600 dark:text-slate-400">
                  Your registered courses for {activeCourses[0]?.academic_year ?? '2025/2026'}.
                </p>
              </div>
              <Link href="/dashboard/courses" className="btn-secondary">
                View all courses
              </Link>
            </div>

            {activeCourses.length === 0 ? (
              <p className="mt-5 text-sm text-slate-600 dark:text-slate-400">
                You are not registered for any course this semester.
              </p>
            ) : (
              <ul className="mt-5 grid gap-3 sm:grid-cols-2">
                {activeCourses.slice(0, 6).map((course) => (
                  <li
                    key={course.enrollment_id}
                    className="rounded-lg border border-slate-200 p-4 dark:border-slate-800"
                  >
                    <div className="flex items-start justify-between gap-3">
                      <div className="min-w-0">
                        <p className="font-mono text-xs font-bold text-navy-600 dark:text-navy-300">
                          {course.course_code}
                        </p>
                        <p className="mt-0.5 truncate text-sm font-medium text-navy-900 dark:text-white">
                          {course.course_title}
                        </p>
                      </div>
                      <span className="badge-slate flex-none">
                        {course.credit_hours} cr
                      </span>
                    </div>
                    <p className="mt-2 truncate text-xs text-slate-500 dark:text-slate-400">
                      {course.lecturer ?? 'Lecturer to be assigned'}
                    </p>
                  </li>
                ))}
              </ul>
            )}
          </section>
        </>
      )}

      {/* ---- staff view ------------------------------------------------------ */}
      {!isStudent && (
        <>
          <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <StatCard label="Active students" value={stats.students} />
            <StatCard label="Lecturers" value={stats.lecturers} />
            <StatCard
              label="Teaching assistants"
              value={stats.teaching_assistants}
            />
            <StatCard
              label="Course registrations"
              value={stats.enrollments}
              sub={`${stats.offerings_this_semester} offerings this semester`}
            />
          </section>

          <section className="card card-pad">
            <div className="flex flex-wrap items-center justify-between gap-3">
              <div>
                <h2 className="font-semibold text-navy-900 dark:text-white">
                  Fee collection
                </h2>
                <p className="mt-1 text-sm text-slate-600 dark:text-slate-400">
                  Current academic year, across {stats.fees.students_billed}{' '}
                  billed students.
                </p>
              </div>
              <Link href="/dashboard/outstanding-fees" className="btn-secondary">
                Outstanding fees report
              </Link>
            </div>

            <div className="mt-5 grid gap-5 lg:grid-cols-3">
              <div>
                <p className="section-title">Billed</p>
                <p className="mt-1 text-xl font-bold text-navy-900 dark:text-white">
                  {money(stats.fees.total_billed)}
                </p>
              </div>
              <div>
                <p className="section-title">Collected</p>
                <p className="mt-1 text-xl font-bold text-emerald-600 dark:text-emerald-400">
                  {money(stats.fees.total_collected)}
                </p>
              </div>
              <div>
                <p className="section-title">Outstanding</p>
                <p className="mt-1 text-xl font-bold text-red-600 dark:text-red-400">
                  {money(stats.fees.total_outstanding)}
                </p>
              </div>
            </div>

            <div className="mt-6">
              <ProgressBar
                value={toNumber(stats.fees.collection_rate_percent)}
                label="Collection rate"
              />
            </div>

            <dl className="mt-6 grid gap-4 sm:grid-cols-2">
              <div className="rounded-lg bg-emerald-50 p-4 dark:bg-emerald-900/25">
                <dt className="text-xs font-semibold uppercase tracking-wide text-emerald-700 dark:text-emerald-300">
                  Fully paid
                </dt>
                <dd className="mt-1 text-lg font-bold text-emerald-800 dark:text-emerald-200">
                  {stats.fees.fully_paid_students} students
                </dd>
              </div>
              <div className="rounded-lg bg-red-50 p-4 dark:bg-red-900/25">
                <dt className="text-xs font-semibold uppercase tracking-wide text-red-700 dark:text-red-300">
                  Still owing
                </dt>
                <dd className="mt-1 text-lg font-bold text-red-800 dark:text-red-200">
                  {stats.fees.indebted_students} students
                </dd>
              </div>
            </dl>
          </section>
        </>
      )}

      <p className="text-xs text-slate-400 dark:text-slate-500">
        Figures generated {new Date(stats.generated_at).toLocaleString('en-GB')} ·
        collection rate {percent(stats.fees.collection_rate_percent)}
      </p>
    </div>
  );
}
