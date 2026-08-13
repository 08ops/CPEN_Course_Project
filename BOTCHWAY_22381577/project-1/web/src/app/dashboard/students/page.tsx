import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { humanise } from '@/lib/format';
import { getStudentDirectory } from '@/lib/queries';

export const metadata: Metadata = { title: 'Students' };
export const dynamic = 'force-dynamic';

/** FUNCTIONALITY 1 - the department's student register (staff view). */
export default async function StudentsPage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');
  if (user.role !== 'admin' && user.role !== 'lecturer') redirect('/dashboard');

  const students = await getStudentDirectory();

  const byLevel = students.reduce<Record<number, number>>((acc, s) => {
    acc[s.current_level] = (acc[s.current_level] ?? 0) + 1;
    return acc;
  }, {});

  const resident = students.filter(
    (s) => s.residential_status === 'resident',
  ).length;

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">
          Functionality 1 · Student personal information
        </p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Student register
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          Department of Computer Engineering · {students.length} records
        </p>
      </header>

      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Total students" value={students.length} />
        <StatCard label="Level 200 (CPEN 208)" value={byLevel[200] ?? 0} />
        <StatCard label="Resident" value={resident} tone="green" />
        <StatCard
          label="Non-resident"
          value={students.length - resident}
          tone="amber"
        />
      </section>

      <section className="table-wrap">
        <table className="table">
          <thead>
            <tr>
              <th>Index number</th>
              <th>Name</th>
              <th>Programme</th>
              <th>Level</th>
              <th>Gender</th>
              <th>E-mail</th>
              <th>Phone</th>
              <th>Residency</th>
              <th className="text-right">CGPA</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {students.map((student) => (
              <tr key={student.student_id}>
                <td className="font-mono text-xs">{student.student_number}</td>
                <td className="font-medium text-navy-900 dark:text-white">
                  {student.full_name}
                </td>
                <td className="text-xs">{student.programme}</td>
                <td>{student.current_level}</td>
                <td className="text-xs">{student.gender}</td>
                <td className="text-xs">{student.email}</td>
                <td className="font-mono text-xs">{student.phone}</td>
                <td className="text-xs">
                  {humanise(student.residential_status)}
                </td>
                <td className="text-right font-mono">{student.cgpa ?? '—'}</td>
                <td>
                  <span
                    className={
                      student.status === 'active' ? 'badge-green' : 'badge-amber'
                    }
                  >
                    {humanise(student.status)}
                  </span>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </div>
  );
}
