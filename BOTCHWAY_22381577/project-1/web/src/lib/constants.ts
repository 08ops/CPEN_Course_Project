/**
 * Values shared between the Edge middleware and the Node server runtime.
 *
 * This module must stay free of `server-only`, `pg` and `bcryptjs` imports:
 * middleware runs on the Edge runtime and cannot load those.
 */
export const SESSION_COOKIE = 'ceds_session';
export const APP_NAME = 'CEDS';
export const APP_LONG_NAME = 'Computer Engineering Department System';
