/** Small display helpers shared across the dashboard. */

const GHS = new Intl.NumberFormat('en-GH', {
  style: 'currency',
  currency: 'GHS',
  minimumFractionDigits: 2,
});

/** node-postgres returns NUMERIC as a string to avoid float precision loss. */
export function toNumber(value: string | number | null | undefined): number {
  if (value === null || value === undefined) return 0;
  return typeof value === 'number' ? value : Number.parseFloat(value);
}

export function money(value: string | number | null | undefined): string {
  return GHS.format(toNumber(value));
}

export function percent(value: string | number | null | undefined): string {
  return `${toNumber(value).toFixed(1)}%`;
}

export function date(value: string | Date | null | undefined): string {
  if (!value) return '—';
  const d = typeof value === 'string' ? new Date(value) : value;
  if (Number.isNaN(d.getTime())) return '—';
  return d.toLocaleDateString('en-GB', {
    day: '2-digit',
    month: 'short',
    year: 'numeric',
  });
}

export function time(value: string | null | undefined): string {
  if (!value) return '—';
  // Postgres TIME arrives as 'HH:MM:SS'
  return value.slice(0, 5);
}

/** 'part_paid' -> 'Part paid' */
export function humanise(value: string | null | undefined): string {
  if (!value) return '—';
  const s = value.replace(/_/g, ' ').toLowerCase();
  return s.charAt(0).toUpperCase() + s.slice(1);
}

export function initials(fullName: string | null | undefined): string {
  if (!fullName) return '?';
  const parts = fullName.trim().split(/\s+/);
  const first = parts[0]?.[0] ?? '';
  const last = parts.length > 1 ? parts[parts.length - 1][0] : '';
  return (first + last).toUpperCase();
}
