/**
 * Input validation for the login and registration forms.
 *
 * Validation runs on the server (inside the server action) as well as in the
 * browser, because client-side checks are a convenience for the user, never a
 * security control.
 */
import { z } from 'zod';

const EMAIL_RE = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

export const loginSchema = z.object({
  identifier: z
    .string()
    .trim()
    .min(3, 'Enter your username, index number or e-mail address.')
    .max(120, 'That value is too long.'),
  password: z.string().min(1, 'Enter your password.'),
});

export const registerSchema = z
  .object({
    username: z
      .string()
      .trim()
      .min(3, 'Username must be at least 3 characters.')
      .max(60, 'Username must be at most 60 characters.')
      .regex(
        /^[A-Za-z0-9._-]+$/,
        'Username may only contain letters, numbers, dots, hyphens and underscores.',
      ),
    email: z
      .string()
      .trim()
      .toLowerCase()
      .max(150, 'E-mail address is too long.')
      .regex(EMAIL_RE, 'Enter a valid e-mail address.'),
    password: z
      .string()
      .min(8, 'Password must be at least 8 characters.')
      .max(72, 'Password must be at most 72 characters.')
      .regex(/[A-Z]/, 'Password must contain an upper-case letter.')
      .regex(/[a-z]/, 'Password must contain a lower-case letter.')
      .regex(/[0-9]/, 'Password must contain a digit.'),
    confirmPassword: z.string(),
    role: z.enum(['student', 'lecturer', 'teaching_assistant']),
    studentNumber: z
      .string()
      .trim()
      .regex(/^[0-9]{6,15}$/, 'Index number must be 6-15 digits.')
      .optional()
      .or(z.literal('')),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: 'The two passwords do not match.',
    path: ['confirmPassword'],
  });

export type LoginInput = z.infer<typeof loginSchema>;
export type RegisterInput = z.infer<typeof registerSchema>;

/** Flatten a ZodError into { field: firstMessage } for rendering next to inputs. */
export function fieldErrors(error: z.ZodError): Record<string, string> {
  const out: Record<string, string> = {};
  for (const issue of error.issues) {
    const key = String(issue.path[0] ?? '_form');
    if (!out[key]) out[key] = issue.message;
  }
  return out;
}
