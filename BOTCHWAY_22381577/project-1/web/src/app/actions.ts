'use server';

/**
 * Server Actions for authentication.
 *
 * Next.js 14 server actions run only on the server, so the database pool and
 * the bcrypt hashing never reach the browser bundle. Each action returns a
 * plain object that the client component renders with useFormState.
 */
import { redirect } from 'next/navigation';
import { headers } from 'next/headers';

import { login, logout as destroySession, register } from '@/lib/auth';
import type { FormState } from '@/lib/formState';
import { fieldErrors, loginSchema, registerSchema } from '@/lib/validation';
import type { AppRole } from '@/lib/types';

function clientMeta() {
  const h = headers();
  const forwarded = h.get('x-forwarded-for');
  return {
    ip: forwarded ? forwarded.split(',')[0].trim() : null,
    userAgent: h.get('user-agent'),
  };
}

/* -------------------------------------------------------------------------- */
/* Login                                                                       */
/* -------------------------------------------------------------------------- */

export async function loginAction(
  _prev: FormState,
  formData: FormData,
): Promise<FormState> {
  const raw = {
    identifier: String(formData.get('identifier') ?? ''),
    password: String(formData.get('password') ?? ''),
  };

  const parsed = loginSchema.safeParse(raw);
  if (!parsed.success) {
    return {
      ok: false,
      errors: fieldErrors(parsed.error),
      values: { identifier: raw.identifier },
    };
  }

  const result = await login(
    parsed.data.identifier,
    parsed.data.password,
    clientMeta(),
  );

  if (!result.ok) {
    return {
      ok: false,
      message: result.error,
      values: { identifier: raw.identifier },
    };
  }

  // redirect() throws a special error that Next.js catches, so it must be
  // called outside any try/catch.
  redirect('/dashboard');
}

/* -------------------------------------------------------------------------- */
/* Registration                                                                */
/* -------------------------------------------------------------------------- */

export async function registerAction(
  _prev: FormState,
  formData: FormData,
): Promise<FormState> {
  const raw = {
    username: String(formData.get('username') ?? ''),
    email: String(formData.get('email') ?? ''),
    password: String(formData.get('password') ?? ''),
    confirmPassword: String(formData.get('confirmPassword') ?? ''),
    role: String(formData.get('role') ?? 'student'),
    studentNumber: String(formData.get('studentNumber') ?? ''),
  };

  const keep = {
    username: raw.username,
    email: raw.email,
    role: raw.role,
    studentNumber: raw.studentNumber,
  };

  const parsed = registerSchema.safeParse(raw);
  if (!parsed.success) {
    return { ok: false, errors: fieldErrors(parsed.error), values: keep };
  }

  const result = await register({
    username: parsed.data.username,
    email: parsed.data.email,
    password: parsed.data.password,
    role: parsed.data.role as AppRole,
    studentNumber: parsed.data.studentNumber || null,
  });

  if (!result.ok) {
    return { ok: false, message: result.error, values: keep };
  }

  // Sign the new user straight in rather than making them type it all again.
  await login(parsed.data.username, parsed.data.password, clientMeta());

  redirect('/dashboard?welcome=1');
}

/* -------------------------------------------------------------------------- */
/* Logout                                                                      */
/* -------------------------------------------------------------------------- */

export async function logoutAction(): Promise<void> {
  await destroySession();
  redirect('/login');
}
