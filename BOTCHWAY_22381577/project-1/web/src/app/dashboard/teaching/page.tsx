import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { humanise } from '@/lib/format';
import {
  getLecturerAllocations,
  getLecturerWorkload,
  getTaAssignments,
  getUserContext,
} from '@/lib/queries';

export const metadata: Metadata = { title: 'Teaching' };
export const dynamic = 'force-dynamic';

/** FUNCTIONALITIES 4 and 5 - lecturer-to-course and lecturer-to-TA assignment. */
export default async function TeachingPage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');
  if (user.role === 'student') redirect('/dashboard');

  const context = await getUserContext(user.userId);

  const [allocations, taAssignments] = await Promise.all([
    getLecturerAllocations(),
    getTaAssignments(),
  ]);

  const workload = context.lecturer
    ? await getLecturerWorkload(context.lecturer.lecturer_id)
    : null;

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">
          Functionalities 4 &amp; 5 · Teaching assignment
        </p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Teaching &amp; assistant allocation
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          First Semester 2025/2026 · Department of Computer Engineering
        </p>
      </header>

      {/* ---- personal workload (lecturers only) ------------------------------ */}
      {workload && (
        <>
          <section className="grid gap-4 sm:grid-cols-3">
            <StatCard label="My courses" value={workload.total_courses} />
            <StatCard
              label="Contact hours / week"
              value={workload.total_contact_hours}
            />
            <StatCard
              label="Teaching assistants"
              value={workload.courses.reduce(
                (sum, c) => sum + c.teaching_assistants.length,
                0,
              )}
              tone="green"
            />
          </section>

          <section className="space-y-4">
            <h2 className="font-semibold text-navy-900 dark:text-white">
              My teaching load
            </h2>
            {workload.courses.map((course) => (
              <div key={course.assignment_id} className="card card-pad">
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <p className="font-mono text-xs font-bold text-navy-600 dark:text-navy-300">
                      {course.course_code} · Section {course.section}
                    </p>
                    <p className="mt-1 font-semibold text-navy-900 dark:text-white">
                      {course.course_title}
                    </p>
                    <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                      {course.meeting_days ?? '—'} · {course.venue ?? '—'} ·{' '}
                      {course.enrolled_count} students enrolled
                    </p>
                  </div>
                  <span
                    className={
                      course.teaching_role === 'lead_lecturer'
                        ? 'badge-navy'
                        : 'badge-slate'
                    }
                  >
                    {humanise(course.teaching_role)}
                  </span>
                </div>

                <div className="mt-4 border-t border-slate-200 pt-4 dark:border-slate-800">
                  <p className="section-title mb-2">
                    Assigned teaching assistants
                  </p>
                  {course.teaching_assistants.length === 0 ? (
                    <p className="text-sm text-slate-500 dark:text-slate-400">
                      No teaching assistant assigned to this course.
                    </p>
                  ) : (
                    <ul className="space-y-2">
                      {course.teaching_assistants.map((ta) => (
                        <li
                          key={ta.ta_id}
                          className="rounded-lg bg-slate-50 p-3 text-sm dark:bg-slate-800/60"
                        >
                          <div className="flex flex-wrap items-center gap-2">
                            <span className="font-medium text-navy-900 dark:text-white">
                              {ta.full_name}
                            </span>
                            <span className="badge-slate">{ta.ta_code}</span>
                            <span className="badge-navy">
                              {humanise(ta.ta_type)}
                            </span>
                            <span className="ml-auto text-xs text-slate-500 dark:text-slate-400">
                              {ta.weekly_hours} hrs/week
                            </span>
                          </div>
                          <p className="mt-1 text-xs text-slate-600 dark:text-slate-400">
                            {ta.responsibility}
                          </p>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </div>
            ))}
          </section>
        </>
      )}

      {/* ---- department-wide allocation ------------------------------------- */}
      <section>
        <h2 className="mb-4 font-semibold text-navy-900 dark:text-white">
          Functionality 4 · Lecturer-to-course assignment
        </h2>
        <div className="table-wrap">
          <table className="table">
            <thead>
              <tr>
                <th>Course</th>
                <th>Title</th>
                <th>Lecturer</th>
                <th>Rank</th>
                <th>Role</th>
                <th className="text-right">Hrs/wk</th>
                <th className="text-right">Students</th>
                <th className="text-right">TAs</th>
              </tr>
            </thead>
            <tbody>
              {allocations.map((row) => (
                <tr key={row.assignment_id}>
                  <td className="font-mono text-xs font-bold text-navy-600 dark:text-navy-300">
                    {row.course_code}
                  </td>
                  <td className="font-medium text-navy-900 dark:text-white">
                    {row.course_title}
                  </td>
                  <td>{row.lecturer_name}</td>
                  <td className="text-xs">{row.academic_rank}</td>
                  <td>
                    <span
                      className={
                        row.teaching_role === 'lead_lecturer'
                          ? 'badge-navy'
                          : 'badge-slate'
                      }
                    >
                      {humanise(row.teaching_role)}
                    </span>
                  </td>
                  <td className="text-right">{row.contact_hours_per_week}</td>
                  <td className="text-right">{row.enrolled_students}</td>
                  <td className="text-right">{row.assigned_tas}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </section>

      <section>
        <h2 className="mb-4 font-semibold text-navy-900 dark:text-white">
          Functionality 5 · Lecturer-to-TA assignment
        </h2>
        <div className="table-wrap">
          <table className="table">
            <thead>
              <tr>
                <th>Lecturer</th>
                <th>Teaching assistant</th>
                <th>Code</th>
                <th>Type</th>
                <th>Course</th>
                <th className="text-right">Hrs/wk</th>
                <th>Responsibility</th>
              </tr>
            </thead>
            <tbody>
              {taAssignments.map((row) => (
                <tr key={row.ta_assignment_id}>
                  <td className="font-medium text-navy-900 dark:text-white">
                    {row.lecturer}
                  </td>
                  <td>{row.ta_name}</td>
                  <td className="font-mono text-xs">{row.ta_code}</td>
                  <td>
                    <span className="badge-navy">{humanise(row.ta_type)}</span>
                  </td>
                  <td className="font-mono text-xs">{row.course_code ?? '—'}</td>
                  <td className="text-right">{row.weekly_hours}</td>
                  <td className="max-w-xs text-xs">{row.responsibility}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <p className="mt-3 text-xs text-slate-500 dark:text-slate-400">
          A TA cannot be committed beyond their contracted weekly hours — the
          check lives in{' '}
          <code className="font-mono">academics.fn_assign_ta_to_lecturer</code>.
        </p>
      </section>
    </div>
  );
}
