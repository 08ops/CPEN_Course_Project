import type { Metadata } from 'next';
import Link from 'next/link';
import { redirect } from 'next/navigation';

import { AuthShell } from '@/components/AuthShell';
import { getCurrentUser } from '@/lib/auth';
import { RegisterForm } from './RegisterForm';

export const metadata: Metadata = { title: 'Create an account' };

export const dynamic = 'force-dynamic';

export default async function RegisterPage() {
  if (await getCurrentUser()) redirect('/dashboard');

  return (
    <AuthShell
      title="Create your account"
      subtitle="Register to view your records, fees and course registration."
      footer={
        <>
          Already have an account?{' '}
          <Link
            href="/login"
            className="font-semibold text-navy-600 hover:underline dark:text-navy-300"
          >
            Sign in
          </Link>
        </>
      }
    >
      <RegisterForm />
    </AuthShell>
  );
}
