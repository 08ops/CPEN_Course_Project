import { redirect } from 'next/navigation';

import { DashboardNav } from '@/components/DashboardNav';
import { getCurrentUser } from '@/lib/auth';
import { initials } from '@/lib/format';

// The dashboard reads per-user data, so nothing here may be cached or
// pre-rendered at build time.
export const dynamic = 'force-dynamic';

export default async function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  // This is the authoritative session check: the Edge middleware only verified
  // that a cookie was present, this verifies it against app.user_session.
  const user = await getCurrentUser();
  if (!user) redirect('/login');

  return (
    <div className="flex min-h-screen flex-col lg:flex-row">
      <DashboardNav
        role={user.role}
        fullName={user.fullName ?? ''}
        username={user.username}
        initials={initials(user.fullName ?? user.username)}
      />
      <main className="min-w-0 flex-1 px-4 py-6 sm:px-6 lg:px-8 lg:py-8">
        {children}
      </main>
    </div>
  );
}
