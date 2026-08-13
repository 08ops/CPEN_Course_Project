import type { Metadata } from 'next';
import Link from 'next/link';
import { redirect } from 'next/navigation';

import { AuthShell } from '@/components/AuthShell';
import { getCurrentUser } from '@/lib/auth';
import { LoginForm } from './LoginForm';

export const metadata: Metadata = { title: 'Sign in' };

// Reads the session cookie, so it must never be statically rendered.
export const dynamic = 'force-dynamic';

export default async function LoginPage() {
  // Already signed in? Skip the form.
  if (await getCurrentUser()) redirect('/dashboard');

  return (
    <AuthShell
      title="Sign in to your account"
      subtitle="Use the credentials issued by the Department of Computer Engineering."
      footer={
        <>
          Don&apos;t have an account?{' '}
          <Link
            href="/register"
            className="font-semibold text-navy-600 hover:underline dark:text-navy-300"
          >
            Create one
          </Link>
        </>
      }
    >
      <LoginForm />

      <div className="mt-8 rounded-lg border border-dashed border-slate-300 bg-white/60 p-4 text-xs text-slate-600 dark:border-slate-700 dark:bg-slate-900/60 dark:text-slate-400">
        <p className="mb-2 font-semibold text-slate-700 dark:text-slate-300">
          Demonstration accounts (seeded by 06_seed_data.sql)
        </p>
        <ul className="space-y-1 font-mono text-[11px]">
          <li>
            <span className="text-slate-500">student</span> 22128981 /
            Password123!
          </li>
          <li>
            <span className="text-slate-500">lecturer</span> kadanquah /
            Password123!
          </li>
          <li>
            <span className="text-slate-500">admin</span> admin / Password123!
          </li>
        </ul>
      </div>
    </AuthShell>
  );
}
