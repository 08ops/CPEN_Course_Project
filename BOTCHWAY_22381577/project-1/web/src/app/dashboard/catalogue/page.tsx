import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { ProgressBar } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { humanise, time } from '@/lib/format';
import { getCourseCatalogue } from '@/lib/queries';

export const metadata: Metadata = { title: 'Course catalogue' };
export const dynamic = 'force-dynamic';

/** FUNCTIONALITY 3 - courses on offer this semester, with live seat counts. */
export default async function CataloguePage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  const offerings = await getCourseCatalogue();

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">Functionality 3 · Course offerings</p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Course catalogue
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          {offerings[0]?.semester ?? 'First Semester'}{' '}
          {offerings[0]?.academic_year ?? '2025/2026'} · {offerings.length}{' '}
          offerings
        </p>
      </header>

      <section className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {offerings.map((offering) => {
          const fill =
            offering.capacity > 0
              ? (offering.enrolled_count / offering.capacity) * 100
              : 0;

          return (
            <article key={offering.offering_id} className="card card-pad">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="font-mono text-xs font-bold text-navy-600 dark:text-navy-300">
                    {offering.course_code}
                  </p>
                  <h2 className="mt-1 font-semibold text-navy-900 dark:text-white">
                    {offering.course_title}
                  </h2>
                </div>
                <span className="badge-slate flex-none">
                  {offering.credit_hours} cr
                </span>
              </div>

              <dl className="mt-4 space-y-1.5 text-xs text-slate-600 dark:text-slate-400">
                <div className="flex justify-between gap-3">
                  <dt>Lecturer</dt>
                  <dd className="text-right font-medium text-slate-800 dark:text-slate-200">
                    {offering.lecturer_name ?? 'To be assigned'}
                  </dd>
                </div>
                <div className="flex justify-between gap-3">
                  <dt>Schedule</dt>
                  <dd className="text-right">
                    {offering.meeting_days ?? '—'}
                    {offering.start_time &&
                      ` · ${time(offering.start_time)}–${time(offering.end_time)}`}
                  </dd>
                </div>
                <div className="flex justify-between gap-3">
                  <dt>Venue</dt>
                  <dd className="text-right">{offering.venue ?? '—'}</dd>
                </div>
                <div className="flex justify-between gap-3">
                  <dt>Mode</dt>
                  <dd className="text-right">
                    {humanise(offering.delivery_mode)}
                  </dd>
                </div>
                <div className="flex justify-between gap-3">
                  <dt>Level</dt>
                  <dd className="text-right">{offering.level}</dd>
                </div>
              </dl>

              <div className="mt-4">
                <ProgressBar
                  value={fill}
                  label={`${offering.enrolled_count} of ${offering.capacity} seats taken`}
                />
                <p className="mt-2 text-xs text-slate-500 dark:text-slate-400">
                  {offering.seats_left} seat
                  {offering.seats_left === 1 ? '' : 's'} remaining
                </p>
              </div>
            </article>
          );
        })}
      </section>
    </div>
  );
}
