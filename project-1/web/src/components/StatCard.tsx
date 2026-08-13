export function StatCard({
  label,
  value,
  sub,
  tone = 'navy',
}: {
  label: string;
  value: string | number;
  sub?: string;
  tone?: 'navy' | 'green' | 'amber' | 'red';
}) {
  const tones: Record<string, string> = {
    navy: 'bg-navy-50 text-navy-700 dark:bg-navy-900/40 dark:text-navy-200',
    green: 'bg-emerald-50 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-200',
    amber: 'bg-amber-50 text-amber-700 dark:bg-amber-900/30 dark:text-amber-200',
    red: 'bg-red-50 text-red-700 dark:bg-red-900/30 dark:text-red-200',
  };

  return (
    <div className="card card-pad">
      <p className="section-title">{label}</p>
      <p className="mt-2 text-2xl font-bold tracking-tight text-navy-900 dark:text-white sm:text-3xl">
        {value}
      </p>
      {sub && (
        <p
          className={`mt-3 inline-block rounded-md px-2 py-1 text-xs font-medium ${tones[tone]}`}
        >
          {sub}
        </p>
      )}
    </div>
  );
}

/** Horizontal progress bar used for fee-payment completion. */
export function ProgressBar({
  value,
  label,
}: {
  value: number;
  label?: string;
}) {
  const pct = Math.max(0, Math.min(100, value));
  const tone =
    pct >= 100 ? 'bg-emerald-500' : pct >= 50 ? 'bg-gold-400' : 'bg-red-400';

  return (
    <div>
      {label && (
        <div className="mb-1.5 flex items-baseline justify-between text-xs text-slate-600 dark:text-slate-400">
          <span>{label}</span>
          <span className="font-semibold">{pct.toFixed(1)}%</span>
        </div>
      )}
      <div
        className="h-2 w-full overflow-hidden rounded-full bg-slate-200 dark:bg-slate-800"
        role="progressbar"
        aria-valuenow={Math.round(pct)}
        aria-valuemin={0}
        aria-valuemax={100}
      >
        <div className={`h-full rounded-full ${tone}`} style={{ width: `${pct}%` }} />
      </div>
    </div>
  );
}

export function EmptyState({ title, body }: { title: string; body: string }) {
  return (
    <div className="card card-pad text-center">
      <p className="font-semibold text-navy-900 dark:text-white">{title}</p>
      <p className="mx-auto mt-1 max-w-md text-sm text-slate-600 dark:text-slate-400">
        {body}
      </p>
    </div>
  );
}
