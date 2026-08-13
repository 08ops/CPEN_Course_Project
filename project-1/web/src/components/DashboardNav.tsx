'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { useState } from 'react';

import { logoutAction } from '@/app/actions';
import { Logo } from './Logo';
import type { AppRole } from '@/lib/types';

interface NavItem {
  href: string;
  label: string;
  roles: AppRole[];
}

const NAV: NavItem[] = [
  { href: '/dashboard', label: 'Overview', roles: ['student', 'lecturer', 'teaching_assistant', 'admin'] },
  { href: '/dashboard/profile', label: 'My profile', roles: ['student'] },
  { href: '/dashboard/fees', label: 'My fees', roles: ['student'] },
  { href: '/dashboard/courses', label: 'My courses', roles: ['student'] },
  { href: '/dashboard/teaching', label: 'Teaching', roles: ['lecturer', 'teaching_assistant', 'admin'] },
  { href: '/dashboard/students', label: 'Students', roles: ['lecturer', 'admin'] },
  { href: '/dashboard/outstanding-fees', label: 'Outstanding fees', roles: ['lecturer', 'admin'] },
  { href: '/dashboard/catalogue', label: 'Course catalogue', roles: ['student', 'lecturer', 'teaching_assistant', 'admin'] },
];

export function DashboardNav({
  role,
  fullName,
  username,
  initials,
}: {
  role: AppRole;
  fullName: string;
  username: string;
  initials: string;
}) {
  const pathname = usePathname();
  const [open, setOpen] = useState(false);

  const items = NAV.filter((item) => item.roles.includes(role));

  const roleLabel: Record<AppRole, string> = {
    student: 'Student',
    lecturer: 'Lecturer',
    teaching_assistant: 'Teaching assistant',
    admin: 'Administrator',
  };

  const linkClass = (href: string) => {
    const active =
      href === '/dashboard' ? pathname === href : pathname.startsWith(href);
    return [
      'block rounded-lg px-3 py-2 text-sm font-medium transition',
      active
        ? 'bg-navy-600 text-white shadow-sm'
        : 'text-slate-600 hover:bg-slate-100 dark:text-slate-300 dark:hover:bg-slate-800',
    ].join(' ');
  };

  return (
    <>
      {/* ---- top bar (mobile) ---------------------------------------------- */}
      <header className="sticky top-0 z-30 flex items-center justify-between border-b border-slate-200 bg-white/90 px-4 py-3 backdrop-blur lg:hidden dark:border-slate-800 dark:bg-slate-900/90">
        <Link href="/dashboard">
          <Logo />
        </Link>
        <button
          type="button"
          onClick={() => setOpen((v) => !v)}
          className="btn-secondary px-3 py-2"
          aria-expanded={open}
          aria-controls="mobile-nav"
        >
          {open ? 'Close' : 'Menu'}
        </button>
      </header>

      {open && (
        <nav
          id="mobile-nav"
          className="border-b border-slate-200 bg-white p-3 lg:hidden dark:border-slate-800 dark:bg-slate-900"
        >
          <ul className="space-y-1">
            {items.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={linkClass(item.href)}
                  onClick={() => setOpen(false)}
                >
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
          <form action={logoutAction} className="mt-3">
            <button type="submit" className="btn-secondary w-full">
              Sign out
            </button>
          </form>
        </nav>
      )}

      {/* ---- sidebar (desktop) ---------------------------------------------
           Sticky and exactly one viewport tall so the account panel and the
           sign-out button stay reachable however long the page content is. */}
      <aside className="hidden w-64 flex-none border-r border-slate-200 bg-white lg:sticky lg:top-0 lg:flex lg:h-screen lg:flex-col dark:border-slate-800 dark:bg-slate-900">
        <div className="border-b border-slate-200 p-5 dark:border-slate-800">
          <Link href="/dashboard">
            <Logo />
          </Link>
        </div>

        <nav className="flex-1 overflow-y-auto p-3">
          <ul className="space-y-1">
            {items.map((item) => (
              <li key={item.href}>
                <Link href={item.href} className={linkClass(item.href)}>
                  {item.label}
                </Link>
              </li>
            ))}
          </ul>
        </nav>

        <div className="border-t border-slate-200 p-4 dark:border-slate-800">
          <div className="mb-3 flex items-center gap-3">
            <span
              aria-hidden
              className="grid h-9 w-9 flex-none place-items-center rounded-full bg-navy-100 text-xs font-bold text-navy-700 dark:bg-navy-900 dark:text-navy-200"
            >
              {initials}
            </span>
            <span className="min-w-0 leading-tight">
              <span className="block truncate text-sm font-semibold text-navy-900 dark:text-white">
                {fullName || username}
              </span>
              <span className="block truncate text-xs text-slate-500 dark:text-slate-400">
                {roleLabel[role]}
              </span>
            </span>
          </div>
          <form action={logoutAction}>
            <button type="submit" className="btn-secondary w-full">
              Sign out
            </button>
          </form>
        </div>
      </aside>
    </>
  );
}
