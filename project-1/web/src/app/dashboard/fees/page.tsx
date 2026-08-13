import type { Metadata } from 'next';
import { redirect } from 'next/navigation';

import { EmptyState, ProgressBar, StatCard } from '@/components/StatCard';
import { getCurrentUser } from '@/lib/auth';
import { date, humanise, money, toNumber } from '@/lib/format';
import { getFeeStatement, getUserContext } from '@/lib/queries';

export const metadata: Metadata = { title: 'My fees' };
export const dynamic = 'force-dynamic';

const PAYMENT_BADGE: Record<string, string> = {
  confirmed: 'badge-green',
  pending: 'badge-amber',
  reversed: 'badge-red',
  failed: 'badge-red',
};

/** FUNCTIONALITY 2 - student fees payments. */
export default async function FeesPage() {
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  const context = await getUserContext(user.userId);

  if (!context.student) {
    return (
      <EmptyState
        title="No student record linked"
        body="Fee statements are only available for accounts linked to a student record."
      />
    );
  }

  const statement = await getFeeStatement(context.student.student_id);
  const billed = toNumber(statement.total_billed);
  const paid = toNumber(statement.total_paid);
  const outstanding = toNumber(statement.outstanding_balance);
  const pct = billed > 0 ? (paid / billed) * 100 : 0;

  return (
    <div className="space-y-8">
      <header>
        <p className="section-title">Functionality 2 · Student fees payments</p>
        <h1 className="mt-1 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
          Fee statement
        </h1>
        <p className="mt-1.5 text-sm text-slate-600 dark:text-slate-400">
          {statement.full_name} · {statement.student_number} · {statement.programme}
        </p>
      </header>

      <section className="grid gap-4 sm:grid-cols-3">
        <StatCard label="Total billed" value={money(billed)} />
        <StatCard label="Total paid" value={money(paid)} tone="green" sub="Confirmed payments only" />
        <StatCard
          label="Outstanding"
          value={money(outstanding)}
          tone={outstanding > 0 ? 'red' : 'green'}
          sub={outstanding > 0 ? 'Balance due' : 'Fully settled'}
        />
      </section>

      <section className="card card-pad">
        <ProgressBar value={pct} label="Percentage of fees paid" />
      </section>

      {/* ---- bills ---------------------------------------------------------- */}
      <section className="space-y-4">
        <h2 className="font-semibold text-navy-900 dark:text-white">Bills</h2>

        {statement.bills.length === 0 ? (
          <p className="text-sm text-slate-600 dark:text-slate-400">
            No bill has been issued for this student yet.
          </p>
        ) : (
          statement.bills.map((bill) => (
            <div key={bill.bill_id} className="card card-pad">
              <div className="flex flex-wrap items-start justify-between gap-4">
                <div>
                  <p className="font-mono text-xs text-slate-500 dark:text-slate-400">
                    {bill.bill_reference}
                  </p>
                  <p className="mt-1 font-semibold text-navy-900 dark:text-white">
                    Academic year {bill.academic_year}
                  </p>
                  <p className="mt-1 text-xs text-slate-500 dark:text-slate-400">
                    Issued {date(bill.issued_on)} · Due {date(bill.due_date)}
                  </p>
                </div>
                <span
                  className={
                    bill.status === 'paid'
                      ? 'badge-green'
                      : bill.status === 'overdue'
                        ? 'badge-red'
                        : 'badge-amber'
                  }
                >
                  {humanise(bill.status)}
                </span>
              </div>

              <div className="mt-5 table-wrap">
                <table className="table">
                  <thead>
                    <tr>
                      <th>Fee item</th>
                      <th>Category</th>
                      <th className="text-right">Amount</th>
                    </tr>
                  </thead>
                  <tbody>
                    {bill.lines.map((line, i) => (
                      <tr key={i}>
                        <td className="font-medium text-navy-900 dark:text-white">
                          {line.description}
                        </td>
                        <td>
                          <span className="badge-slate">
                            {humanise(line.category)}
                          </span>
                        </td>
                        <td className="text-right font-mono">
                          {money(line.amount)}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                  <tfoot className="bg-slate-50 dark:bg-slate-900/70">
                    <tr>
                      <td colSpan={2} className="px-4 py-3 text-right font-semibold text-navy-900 dark:text-white">
                        Total billed
                      </td>
                      <td className="px-4 py-3 text-right font-mono font-semibold text-navy-900 dark:text-white">
                        {money(bill.amount_billed)}
                      </td>
                    </tr>
                    <tr>
                      <td colSpan={2} className="px-4 py-3 text-right font-semibold text-emerald-700 dark:text-emerald-400">
                        Paid
                      </td>
                      <td className="px-4 py-3 text-right font-mono font-semibold text-emerald-700 dark:text-emerald-400">
                        {money(bill.amount_paid)}
                      </td>
                    </tr>
                    <tr>
                      <td colSpan={2} className="px-4 py-3 text-right font-bold text-red-700 dark:text-red-400">
                        Balance
                      </td>
                      <td className="px-4 py-3 text-right font-mono font-bold text-red-700 dark:text-red-400">
                        {money(bill.balance)}
                      </td>
                    </tr>
                  </tfoot>
                </table>
              </div>
            </div>
          ))
        )}
      </section>

      {/* ---- payments ------------------------------------------------------- */}
      <section>
        <h2 className="mb-4 font-semibold text-navy-900 dark:text-white">
          Payment history
        </h2>

        {statement.payments.length === 0 ? (
          <p className="text-sm text-slate-600 dark:text-slate-400">
            No payment has been recorded against this account.
          </p>
        ) : (
          <>
            <div className="table-wrap">
              <table className="table">
                <thead>
                  <tr>
                    <th>Receipt</th>
                    <th>Date</th>
                    <th>Method</th>
                    <th>Channel</th>
                    <th className="text-right">Amount</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {statement.payments.map((payment) => (
                    <tr key={payment.payment_id}>
                      <td className="font-mono text-xs">{payment.receipt_number}</td>
                      <td>{date(payment.payment_date)}</td>
                      <td>{humanise(payment.method)}</td>
                      <td>{payment.channel ?? '—'}</td>
                      <td className="text-right font-mono">{money(payment.amount)}</td>
                      <td>
                        <span className={PAYMENT_BADGE[payment.status] ?? 'badge-slate'}>
                          {humanise(payment.status)}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            <p className="mt-3 text-xs text-slate-500 dark:text-slate-400">
              Only payments with status <strong>Confirmed</strong> reduce the
              outstanding balance. Pending and reversed payments are shown for
              completeness but are excluded from the calculation.
            </p>
          </>
        )}
      </section>
    </div>
  );
}
