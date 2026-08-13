/**
 * Shared shape for the value returned by the auth server actions.
 *
 * This lives outside app/actions.ts on purpose: a file marked 'use server'
 * may only export async functions, so the type and the initial-state constant
 * cannot be declared there.
 */
export interface FormState {
  ok: boolean;
  /** Form-level message, e.g. "Invalid username or password." */
  message?: string;
  /** Field-level messages keyed by input name. */
  errors?: Record<string, string>;
  /** Values echoed back so the user does not have to retype the form. */
  values?: Record<string, string>;
}

export const emptyFormState: FormState = { ok: false };
