import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { EmptyState, StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { date, humanise, time } from '@/lib/format';
import { getStudentEnrollments, getUserContext } from '@/lib/queries';

export const metadata: Metadata = { title: 'My courses' };
export const dynamic = 'force-dynamic';

const STATUS_BADGE: Record<string, string> = {
  enrolled: 'badge-navy',
  completed: 'badge-green',
  failed: 'badge-red',
  dropped: 'badge-slate',
  deferred: 'badge-amber',
};

/** FUNCTIONALITY 3 - course enrolment, from the student's side. */
export default async function CoursesPage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  const context = await getUserContext(user.userId);

  if (!context.student) {
    return (
      <EmptyState
        title="No student record linked"
        body="Course registrations are only available for accounts linked to a student record."
      />
    );
  }

  const enrollments = await getStudentEnrollments(context.student.student_id);
  const active = enrollments.filter((e) => e.status !== 'dropped');
  const credits = active.reduce((sum, e) => sum + e.credit_hours, 0);

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">Functionality 3 · Course enrolment</p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          My registered courses
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          {enrollments[0]?.semester ?? 'First Semester'}{' '}
          {enrollments[0]?.academic_year ?? '2025/2026'}
        </p>
      </header>

      <section className="grid gap-4 sm:grid-cols-3">
        <StatCard label="Registered courses" value={active.length} />
        <StatCard label="Total credit hours" value={credits} />
        <StatCard
          label="Dropped"
          value={enrollments.length - active.length}
          tone="amber"
        />
      </section>

      {enrollments.length === 0 ? (
        <EmptyState
          title="No registrations"
          body="You have not registered for any course in this semester."
        />
      ) : (
        <section className="table-wrap">
          <table className="table">
            <thead>
              <tr>
                <th>Code</th>
                <th>Course</th>
                <th>Credits</th>
                <th>Lecturer</th>
                <th>Schedule</th>
                <th>Venue</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {enrollments.map((course) => (
                <tr key={course.enrollment_id}>
                  <td className="font-mono text-xs font-bold text-navy-600 dark:text-navy-300">
                    {course.course_code}
                  </td>
                  <td className="font-medium text-navy-900 dark:text-white">
                    {course.course_title}
                    {course.is_retake && (
                      <span className="ml-2 badge-amber">Retake</span>
                    )}
                  </td>
                  <td>{course.credit_hours}</td>
                  <td>{course.lecturer ?? '—'}</td>
                  <td className="whitespace-nowrap text-xs">
                    {course.meeting_days ?? '—'}
                    {course.start_time && (
                      <span className="block text-slate-500 dark:text-slate-400">
                        {time(course.start_time)} – {time(course.end_time)}
                      </span>
                    )}
                  </td>
                  <td className="text-xs">{course.venue ?? '—'}</td>
                  <td>
                    <span className={STATUS_BADGE[course.status] ?? 'badge-slate'}>
                      {humanise(course.status)}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </section>
      )}

      <p className="text-xs text-slate-500 dark:text-slate-400">
        Registration recorded on {date(enrollments[0]?.enrolled_on)}. Enrolment
        is validated in the database: a student who is not active, a class that
        is full, or a closed registration window is rejected by the
        <code className="mx-1 font-mono">academics.fn_validate_enrollment</code>
        trigger.
      </p>
    </div>
  );
}
