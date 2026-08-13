import { NextResponse, type NextRequest } from 'next/server';

import { SESSION_COOKIE } from '@/lib/constants';

/**
 * Edge middleware - a cheap first gate only.
 *
 * Middleware runs on the Edge runtime, which cannot open a TCP connection to
 * PostgreSQL, so it can only check that a session cookie is PRESENT. The
 * authoritative check (is the token real, unexpired and unrevoked?) happens in
 * the dashboard layout via getCurrentUser(), which does query the database.
 * Presenting a forged cookie therefore gets you a redirect back to /login, not
 * access.
 */
export function middleware(request: NextRequest) {
  const hasSession = Boolean(request.cookies.get(SESSION_COOKIE)?.value);
  const { pathname, search } = request.nextUrl;

  if (pathname.startsWith('/dashboard') && !hasSession) {
    const url = request.nextUrl.clone();
    url.pathname = '/login';
    url.search = '';
    // Remember where the user was heading so we can return them after login.
    if (pathname !== '/dashboard') {
      url.searchParams.set('next', pathname + search);
    }
    return NextResponse.redirect(url);
  }

  if ((pathname === '/login' || pathname === '/register') && hasSession) {
    const url = request.nextUrl.clone();
    url.pathname = '/dashboard';
    url.search = '';
    return NextResponse.redirect(url);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*', '/login', '/register'],
};
