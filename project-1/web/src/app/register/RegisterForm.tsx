'use client';

import { useState } from 'react';
import { useFormState } from 'react-dom';

import { registerAction } from '@/app/actions';
import { emptyFormState } from '@/lib/formState';
import { PasswordField } from '@/components/PasswordField';
import { SubmitButton } from '@/components/SubmitButton';

const ROLES = [
  { value: 'student', label: 'Student' },
  { value: 'lecturer', label: 'Lecturer' },
  { value: 'teaching_assistant', label: 'Teaching assistant' },
] as const;

export function RegisterForm() {
  const [state, formAction] = useFormState(registerAction, emptyFormState);
  const [role, setRole] = useState<string>(state.values?.role ?? 'student');

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
        <label htmlFor="role" className="label">
          I am registering as
        </label>
        <select
          id="role"
          name="role"
          value={role}
          onChange={(e) => setRole(e.target.value)}
          className="input"
        >
          {ROLES.map((r) => (
            <option key={r.value} value={r.value}>
              {r.label}
            </option>
          ))}
        </select>
      </div>

      {role === 'student' && (
        <div>
          <label htmlFor="studentNumber" className="label">
            Index number{' '}
            <span className="font-normal text-slate-400">(optional)</span>
          </label>
          <input
            id="studentNumber"
            name="studentNumber"
            type="text"
            inputMode="numeric"
            placeholder="22128981"
            defaultValue={state.values?.studentNumber ?? ''}
            className={`input ${state.errors?.studentNumber ? 'input-error' : ''}`}
            aria-invalid={Boolean(state.errors?.studentNumber)}
          />
          {state.errors?.studentNumber ? (
            <p className="field-error">{state.errors.studentNumber}</p>
          ) : (
            <p className="hint">
              Supply your index number to link this login to your existing
              student record, so your fees and courses appear immediately.
            </p>
          )}
        </div>
      )}

      <div>
        <label htmlFor="username" className="label">
          Username
        </label>
        <input
          id="username"
          name="username"
          type="text"
          autoComplete="username"
          required
          defaultValue={state.values?.username ?? ''}
          className={`input ${state.errors?.username ? 'input-error' : ''}`}
          aria-invalid={Boolean(state.errors?.username)}
        />
        {state.errors?.username && (
          <p className="field-error">{state.errors.username}</p>
        )}
      </div>

      <div>
        <label htmlFor="email" className="label">
          E-mail address
        </label>
        <input
          id="email"
          name="email"
          type="email"
          autoComplete="email"
          required
          placeholder="name@st.ug.edu.gh"
          defaultValue={state.values?.email ?? ''}
          className={`input ${state.errors?.email ? 'input-error' : ''}`}
          aria-invalid={Boolean(state.errors?.email)}
        />
        {state.errors?.email && (
          <p className="field-error">{state.errors.email}</p>
        )}
      </div>

      <PasswordField
        id="password"
        name="password"
        label="Password"
        autoComplete="new-password"
        error={state.errors?.password}
        hint="At least 8 characters, with an upper-case letter, a lower-case letter and a digit."
      />

      <PasswordField
        id="confirmPassword"
        name="confirmPassword"
        label="Confirm password"
        autoComplete="new-password"
        error={state.errors?.confirmPassword}
      />

      <SubmitButton pendingLabel="Creating account…">
        Create account
      </SubmitButton>
    </form>
  );
}
