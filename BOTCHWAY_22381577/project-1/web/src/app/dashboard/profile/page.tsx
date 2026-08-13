import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { EmptyState } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { date, humanise, money } from '@/lib/format';
import { getStudentProfile, getUserContext } from '@/lib/queries';

export const metadata: Metadata = { title: 'My profile' };
export const dynamic = 'force-dynamic';

function Field({ label, value }: { label: string; value: unknown }) {
  const text =
    value === null || value === undefined || value === ''
      ? '—'
      : String(value);
  return (
    <div>
      <dt className="text-xs font-semibold uppercase tracking-wide text-slate-500 dark:text-slate-400">
        {label}
      </dt>
      <dd className="mt-1 text-sm text-navy-900 dark:text-slate-100">{text}</dd>
    </div>
  );
}

/** FUNCTIONALITY 1 - student personal information. */
export default async function ProfilePage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  const context = await getUserContext(user.userId);

  if (!context.student) {
    return (
      <EmptyState
        title="No student record linked"
        body="This account is not linked to a student record, so there is no personal profile to display. Students should register with their index number to link the two."
      />
    );
  }

  const profile = await getStudentProfile(context.student.student_id);
  const p = profile.personal;
  const c = profile.contact;
  const a = profile.academic;

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">Functionality 1 · Student personal information</p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          {String(p.full_name)}
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          Index number {profile.student_number} · {String(a.programme)}
        </p>
      </header>

      <section className="card card-pad">
        <h2 className="mb-5 font-semibold text-navy-900 dark:text-white">
          Personal details
        </h2>
        <dl className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          <Field label="First name" value={p.first_name} />
          <Field label="Middle name" value={p.middle_name} />
          <Field label="Last name" value={p.last_name} />
          <Field label="Date of birth" value={date(p.date_of_birth as string)} />
          <Field label="Age" value={p.age} />
          <Field label="Gender" value={p.gender} />
          <Field label="Marital status" value={p.marital_status} />
          <Field label="Nationality" value={p.nationality} />
          <Field label="Home region" value={p.home_region} />
          <Field label="Ghana Card number" value={p.national_id} />
        </dl>
      </section>

      <section className="card card-pad">
        <h2 className="mb-5 font-semibold text-navy-900 dark:text-white">
          Contact details
        </h2>
        <dl className="grid gap-5 sm:grid-cols-2">
          <Field label="E-mail" value={c.email} />
          <Field label="Phone" value={c.phone} />
          <Field label="Alternate phone" value={c.alt_phone} />
          <Field label="Postal address" value={c.postal_address} />
          <Field label="Residential address" value={c.residential_address} />
        </dl>
      </section>

      <section className="card card-pad">
        <h2 className="mb-5 font-semibold text-navy-900 dark:text-white">
          Academic record
        </h2>
        <dl className="grid gap-5 sm:grid-cols-2 lg:grid-cols-3">
          <Field label="Programme" value={a.programme} />
          <Field label="Department" value={a.department} />
          <Field label="Level" value={a.level} />
          <Field label="Status" value={humanise(a.status as string)} />
          <Field label="Admission date" value={date(a.admission_date as string)} />
          <Field
            label="Expected completion"
            value={date(a.expected_completion as string)}
          />
          <Field label="Entry qualification" value={a.entry_qualification} />
          <Field label="CGPA" value={a.cgpa} />
          <Field
            label="Residential status"
            value={humanise(a.residential_status as string)}
          />
          <Field label="Hall of residence" value={a.hall_of_residence} />
          <Field
            label="Outstanding fees"
            value={money(profile.outstanding_balance)}
          />
        </dl>
      </section>

      <section className="card card-pad">
        <h2 className="mb-5 font-semibold text-navy-900 dark:text-white">
          Next of kin
        </h2>
        {profile.next_of_kin.length === 0 ? (
          <p className="text-sm text-slate-600 dark:text-slate-400">
            No emergency contact has been recorded.
          </p>
        ) : (
          <div className="table-wrap">
            <table className="table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Relationship</th>
                  <th>Phone</th>
                  <th>E-mail</th>
                  <th>Occupation</th>
                  <th>Primary</th>
                </tr>
              </thead>
              <tbody>
                {profile.next_of_kin.map((kin, i) => (
                  <tr key={i}>
                    <td className="font-medium text-navy-900 dark:text-white">
                      {String(kin.full_name)}
                    </td>
                    <td>{String(kin.relationship)}</td>
                    <td className="font-mono text-xs">{String(kin.phone)}</td>
                    <td>{kin.email ? String(kin.email) : '—'}</td>
                    <td>{kin.occupation ? String(kin.occupation) : '—'}</td>
                    <td>
                      {kin.is_primary ? (
                        <span className="badge-green">Primary</span>
                      ) : (
                        <span className="badge-slate">Secondary</span>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </div>
  );
}
