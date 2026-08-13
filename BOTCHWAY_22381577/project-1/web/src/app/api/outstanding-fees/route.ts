import { NextResponse } from 'next/server';

import { getCurrentUser } from '@/lib/auth';
import { getOutstandingFees } from '@/lib/queries';

export const dynamic = 'force-dynamic';

/**
 * GET /api/outstanding-fees[?indebted=1]
 *
 * Returns the raw JSON array produced by finance.fn_outstanding_fees_json().
 * Staff only. Project 2 exposes the same data through a full REST service.
 */
export async function GET(request: Request) {
  const user = await getCurrentUser();

  if (!user) {
    return NextResponse.json(
      { error: 'Unauthorised', message: 'Sign in to access this resource.' },
      { status: 401 },
    );
  }

  if (user.role !== 'admin' && user.role !== 'lecturer') {
    return NextResponse.json(
      { error: 'Forbidden', message: 'This report is restricted to staff.' },
      { status: 403 },
    );
  }

  const indebted = new URL(request.url).searchParams.get('indebted') === '1';
  const data = await getOutstandingFees(indebted);

  return NextResponse.json(data);
}
