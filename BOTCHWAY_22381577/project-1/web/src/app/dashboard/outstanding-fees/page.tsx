import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { date, money, toNumber } from '@/lib/format';
import { getOutstandingFees } from '@/lib/queries';

export const metadata: Metadata = { title: 'Outstanding fees' };
export const dynamic = 'force-dynamic';

const STATUS_BADGE: Record<string, string> = {
  'FULLY PAID': 'badge-green',
  'PART PAID': 'badge-amber',
  'NO PAYMENT': 'badge-red',
  'NOT BILLED': 'badge-slate',
};

/**
 * The report produced by the required deliverable,
 * finance.fn_outstanding_fees_json(), rendered as a table.
 *
 * The page calls the database function and renders its JSON array directly -
 * no outstanding-balance arithmetic is repeated in JavaScript.
 */
export default async function OutstandingFeesPage({
  searchParams,
}: {
  searchParams: { indebted?: string };
}) {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  // Staff-only report.
  if (user.role !== 'admin' && user.role !== 'lecturer') {
    redirect('/dashboard');
  }

  const onlyIndebted = searchParams.indebted === '1';
  const rows = await getOutstandingFees(onlyIndebted);

  const totals = rows.reduce(
    (acc, row) => {
      acc.billed += toNumber(row.total_billed);
      acc.paid += toNumber(row.total_paid);
      acc.outstanding += toNumber(row.outstanding_balance);
      return acc;
    },
    { billed: 0, paid: 0, outstanding: 0 },
  );

  const indebted = rows.filter((r) => toNumber(r.outstanding_balance) > 0).length;

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">
          Functionality 2 · Required database function
        </p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Outstanding fees report
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          Rendered directly from{' '}
          <code className="font-mono text-xs">
            finance.fn_outstanding_fees_json()
          </code>
          , which returns one JSON object per student.
        </p>
      </header>

      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Students in report" value={rows.length} />
        <StatCard label="Total billed" value={money(totals.billed)} />
        <StatCard label="Total collected" value={money(totals.paid)} tone="green" />
        <StatCard
          label="Total outstanding"
          value={money(totals.outstanding)}
          tone="red"
          sub={`${indebted} student${indebted === 1 ? '' : 's'} still owing`}
        />
      </section>

      <div className="flex flex-wrap gap-2">
        <a
          href="/dashboard/outstanding-fees"
          className={onlyIndebted ? 'btn-secondary' : 'btn-primary'}
        >
          All students
        </a>
        <a
          href="/dashboard/outstanding-fees?indebted=1"
          className={onlyIndebted ? 'btn-primary' : 'btn-secondary'}
        >
          Indebted only
        </a>
        <a href="/api/outstanding-fees" className="btn-secondary" target="_blank">
          View raw JSON
        </a>
      </div>

      <section className="table-wrap">
        <table className="table">
          <thead>
            <tr>
              <th>Index number</th>
              <th>Name</th>
              <th>Programme</th>
              <th>Level</th>
              <th className="text-right">Billed</th>
              <th className="text-right">Paid</th>
              <th className="text-right">Outstanding</th>
              <th className="text-right">% paid</th>
              <th>Status</th>
              <th>Last payment</th>
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.student_id}>
                <td className="font-mono text-xs">{row.student_number}</td>
                <td className="font-medium text-navy-900 dark:text-white">
                  {row.full_name}
                </td>
                <td className="text-xs">{row.programme_code}</td>
                <td>{row.level}</td>
                <td className="text-right font-mono">{money(row.total_billed)}</td>
                <td className="text-right font-mono text-emerald-700 dark:text-emerald-400">
                  {money(row.total_paid)}
                </td>
                <td
                  className={`text-right font-mono font-semibold ${
                    toNumber(row.outstanding_balance) > 0
                      ? 'text-red-700 dark:text-red-400'
                      : 'text-slate-500'
                  }`}
                >
                  {money(row.outstanding_balance)}
                </td>
                <td className="text-right">{toNumber(row.percentage_paid).toFixed(1)}%</td>
                <td>
                  <span className={STATUS_BADGE[row.payment_status] ?? 'badge-slate'}>
                    {row.payment_status}
                  </span>
                </td>
                <td className="text-xs">{date(row.last_payment_date)}</td>
              </tr>
            ))}
          </tbody>
          <tfoot className="bg-slate-50 dark:bg-slate-900/70">
            <tr>
              <td colSpan={4} className="px-4 py-3 font-semibold text-navy-900 dark:text-white">
                Totals ({rows.length} students)
              </td>
              <td className="px-4 py-3 text-right font-mono font-semibold">
                {money(totals.billed)}
              </td>
              <td className="px-4 py-3 text-right font-mono font-semibold text-emerald-700 dark:text-emerald-400">
                {money(totals.paid)}
              </td>
              <td className="px-4 py-3 text-right font-mono font-bold text-red-700 dark:text-red-400">
                {money(totals.outstanding)}
              </td>
              <td colSpan={3} />
            </tr>
          </tfoot>
        </table>
      </section>
    </div>
  );
}
