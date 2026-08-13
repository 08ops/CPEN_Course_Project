'use client';

import { useFormStatus } from 'react-dom';

/**
 * Submit button that disables itself and shows a spinner while the server
 * action is in flight. useFormStatus must live in a child of the <form>,
 * which is why this is its own component.
 */
export function SubmitButton({
  children,
  pendingLabel = 'Please wait…',
  className = 'btn-primary w-full',
}: {
  children: React.ReactNode;
  pendingLabel?: string;
  className?: string;
}) {
  const { pending } = useFormStatus();

  return (
    <button type="submit" className={className} disabled={pending} aria-busy={pending}>
      {pending && (
        <svg
          className="h-4 w-4 animate-spin"
          viewBox="0 0 24 24"
          fill="none"
          aria-hidden
        >
          <circle
            className="opacity-25"
            cx="12"
            cy="12"
            r="10"
            stroke="currentColor"
            strokeWidth="4"
          />
          <path
            className="opacity-75"
            fill="currentColor"
            d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"
          />
        </svg>
      )}
      {pending ? pendingLabel : children}
    </button>
  );
}
