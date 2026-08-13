import Link from 'next/link';
import { Logo } from './Logo';

/** Two-column shell shared by the login and registration screens. */
export function AuthShell({
  title,
  subtitle,
  children,
  footer,
}: {
  title: string;
  subtitle: string;
  children: React.ReactNode;
  footer: React.ReactNode;
}) {
  return (
    <div className="grid min-h-screen lg:grid-cols-2">
      {/* ---- brand panel ---------------------------------------------------- */}
      <aside className="relative hidden overflow-hidden bg-navy-800 p-10 text-white lg:flex lg:flex-col lg:justify-between">
        <div
          aria-hidden
          className="pointer-events-none absolute -right-24 -top-24 h-96 w-96 rounded-full bg-navy-600/50 blur-3xl"
        />
        <div
          aria-hidden
          className="pointer-events-none absolute -bottom-32 -left-20 h-96 w-96 rounded-full bg-gold-500/10 blur-3xl"
        />

        <div className="relative">
          <span className="inline-flex items-center gap-3">
            <span className="grid h-11 w-11 place-items-center rounded-xl bg-white/10 text-base font-black text-gold-300 ring-1 ring-white/20">
              UG
            </span>
            <span className="leading-tight">
              <span className="block text-base font-bold">University of Ghana</span>
              <span className="block text-sm text-navy-200">
                School of Engineering Sciences
              </span>
            </span>
          </span>
        </div>

        <div className="relative max-w-md">
          <h2 className="text-3xl font-bold leading-tight tracking-tight">
            Computer Engineering Department System
          </h2>
          <p className="mt-4 text-navy-100">
            One place for student records, fee payments, course registration and
            teaching assignment.
          </p>

          <ul className="mt-8 space-y-3 text-sm text-navy-100">
            {[
              'Personal and academic student records',
              'Fee bills, payments and outstanding balances',
              'Course registration for the current semester',
              'Lecturer-to-course and lecturer-to-TA assignment',
            ].map((item) => (
              <li key={item} className="flex items-start gap-3">
                <span
                  aria-hidden
                  className="mt-1 grid h-4 w-4 flex-none place-items-center rounded-full bg-gold-400/90 text-[10px] font-black text-navy-900"
                >
                  ✓
                </span>
                {item}
              </li>
            ))}
          </ul>
        </div>

        <p className="relative text-xs text-navy-300">
          CPEN 208 · Introduction to Software Engineering · First Semester 2025/2026
        </p>
      </aside>

      {/* ---- form panel ----------------------------------------------------- */}
      <main className="flex flex-col justify-center px-5 py-10 sm:px-10">
        <div className="mx-auto w-full max-w-md">
          <Link href="/" className="lg:hidden">
            <Logo className="mb-8" />
          </Link>

          <h1 className="text-2xl font-bold tracking-tight text-navy-900 dark:text-white">
            {title}
          </h1>
          <p className="mt-2 text-sm text-slate-600 dark:text-slate-400">
            {subtitle}
          </p>

          <div className="mt-8">{children}</div>

          <div className="mt-8 text-center text-sm text-slate-600 dark:text-slate-400">
            {footer}
          </div>
        </div>
      </main>
    </div>
  );
}
