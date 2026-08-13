'use client';

import { useFormState } from 'react-dom';

import { loginAction } from '@/app/actions';
import { emptyFormState } from '@/lib/formState';
import { PasswordField } from '@/components/PasswordField';
import { SubmitButton } from '@/components/SubmitButton';

export function LoginForm() {
  const [state, formAction] = useFormState(loginAction, emptyFormState);

  return (
    <form action={formAction} className="space-y-5" noValidate>
      {state.message && (
        <div className="alert-error" role="alert">
          <span aria-hidden className="mt-0.5 font-bold">
            !
          </span>
          <span>{state.message}</span>
        </div>
      )}

      <div>
        <label htmlFor="identifier" className="label">
          Username, index number or e-mail
        </label>
        <input
          id="identifier"
          name="identifier"
          type="text"
          autoComplete="username"
          required
          defaultValue={state.values?.identifier ?? ''}
          placeholder="22128981"
          className={`input ${state.errors?.identifier ? 'input-error' : ''}`}
          aria-invalid={Boolean(state.errors?.identifier)}
          aria-describedby={state.errors?.identifier ? 'identifier-error' : undefined}
        />
        {state.errors?.identifier && (
          <p id="identifier-error" className="field-error">
            {state.errors.identifier}
          </p>
        )}
      </div>

      <PasswordField
        id="password"
        name="password"
        label="Password"
        autoComplete="current-password"
        error={state.errors?.password}
      />

      <SubmitButton pendingLabel="Signing in…">Sign in</SubmitButton>
    </form>
  );
}
