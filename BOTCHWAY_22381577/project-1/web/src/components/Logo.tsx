export function Logo({ className = '' }: { className?: string }) {
  return (
    <span className={`inline-flex items-center gap-2.5 ${className}`}>
      <span
        aria-hidden
        className="grid h-9 w-9 place-items-center rounded-lg bg-navy-600 text-sm font-black text-gold-300 shadow-sm"
      >
        UG
      </span>
      <span className="leading-tight">
        <span className="block text-sm font-bold tracking-tight text-navy-900 dark:text-white">
          CEDS
        </span>
        <span className="block text-[11px] text-slate-500 dark:text-slate-400">
          Computer Engineering Dept.
        </span>
      </span>
    </span>
  );
}
