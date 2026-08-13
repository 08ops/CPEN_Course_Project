/**
 * Authentication and session management.
 *
 * DESIGN
 *   * Passwords are hashed with bcrypt (cost 10). The plain password is never
 *     written to the database or to a log.
 *   * A session is a 32-byte random token given to the browser in an httpOnly
 *     cookie. Only the SHA-256 hash of that token is stored in
 *     app.user_session, so a leaked database dump cannot be replayed as a
 *     login.
 *   * Sessions are revocable (app.user_session.revoked_at) which a stateless
 *     JWT could not offer.
 *   * Repeated failed logins lock the account for 15 minutes.
 */
import 'server-only';

import { createHash, randomBytes, timingSafeEqual } from 'crypto';
import { cookies } from 'next/headers';
import bcrypt from 'bcryptjs';

import { SESSION_COOKIE } from './constants';
import { query, queryOne } from './db';
import type { AppRole, SessionUser } from './types';

export { SESSION_COOKIE };

const SESSION_TTL_DAYS = 7;
const BCRYPT_ROUNDS = 10;
const MAX_FAILED_ATTEMPTS = 5;
const LOCK_MINUTES = 15;

/* -------------------------------------------------------------------------- */
/* Password helpers                                                            */
/* -------------------------------------------------------------------------- */

export function hashPassword(plain: string): Promise<string> {
  return bcrypt.hash(plain, BCRYPT_ROUNDS);
}

export function verifyPassword(plain: string, hash: string): Promise<boolean> {
  return bcrypt.compare(plain, hash);
}

/* -------------------------------------------------------------------------- */
/* Session tokens                                                              */
/* -------------------------------------------------------------------------- */

function hashToken(token: string): string {
  return createHash('sha256').update(token).digest('hex');
}

/** Constant-time comparison, used when matching opaque tokens. */
export function safeEqual(a: string, b: string): boolean {
  const bufA = Buffer.from(a);
  const bufB = Buffer.from(b);
  if (bufA.length !== bufB.length) return false;
  return timingSafeEqual(bufA, bufB);
}

/* -------------------------------------------------------------------------- */
/* Login / logout                                                              */
/* -------------------------------------------------------------------------- */

interface UserRow {
  user_id: number;
  username: string;
  email: string;
  password_hash: string;
  role: AppRole;
  person_id: number | null;
  is_active: boolean;
  failed_login_attempts: number;
  locked_until: Date | null;
  full_name: string | null;
}

export type LoginResult =
  | { ok: true; user: SessionUser }
  | { ok: false; error: string };

/**
 * Verify credentials and, on success, start a session.
 * The identifier may be a username OR an e-mail address.
 */
export async function login(
  identifier: string,
  password: string,
  meta: { ip?: string | null; userAgent?: string | null } = {},
): Promise<LoginResult> {
  const user = await queryOne<UserRow>(
    `SELECT u.user_id, u.username, u.email, u.password_hash, u.role,
            u.person_id, u.is_active, u.failed_login_attempts, u.locked_until,
            TRIM(p.first_name || ' ' || p.last_name) AS full_name
     FROM   app.app_user u
     LEFT   JOIN people.person p ON p.person_id = u.person_id
     WHERE  lower(u.username) = lower($1) OR lower(u.email) = lower($1)`,
    [identifier],
  );

  // Always report the same message for "no such user" and "wrong password" so
  // the form cannot be used to enumerate valid accounts.
  const genericError = 'Invalid username or password.';

  if (!user) {
    // Spend roughly the same time as a real bcrypt comparison would.
    await bcrypt.compare(password, '$2a$10$invalidinvalidinvalidinvalidinvalidinvalidinvalidinvalidiu');
    return { ok: false, error: genericError };
  }

  if (!user.is_active) {
    return { ok: false, error: 'This account has been deactivated. Contact the department office.' };
  }

  if (user.locked_until && user.locked_until > new Date()) {
    return {
      ok: false,
      error: `Too many failed attempts. Try again after ${user.locked_until.toLocaleTimeString()}.`,
    };
  }

  const passwordOk = await verifyPassword(password, user.password_hash);

  if (!passwordOk) {
    const attempts = user.failed_login_attempts + 1;
    const lock = attempts >= MAX_FAILED_ATTEMPTS;

    await query(
      `UPDATE app.app_user
       SET    failed_login_attempts = $2,
              locked_until = CASE WHEN $3 THEN CURRENT_TIMESTAMP + ($4 || ' minutes')::INTERVAL
                                  ELSE locked_until END
       WHERE  user_id = $1`,
      [user.user_id, attempts, lock, LOCK_MINUTES],
    );

    await audit(user.user_id, 'LOGIN_FAILED', 'app_user', String(user.user_id), {
      attempts,
      locked: lock,
    });

    return { ok: false, error: genericError };
  }

  // Success: clear the counter and stamp the login time.
  await query(
    `UPDATE app.app_user
     SET    failed_login_attempts = 0, locked_until = NULL,
            last_login_at = CURRENT_TIMESTAMP
     WHERE  user_id = $1`,
    [user.user_id],
  );

  await createSession(user.user_id, meta);
  await audit(user.user_id, 'LOGIN', 'app_user', String(user.user_id), {
    role: user.role,
  });

  return {
    ok: true,
    user: {
      userId: user.user_id,
      username: user.username,
      email: user.email,
      role: user.role,
      personId: user.person_id,
      fullName: user.full_name,
    },
  };
}

/** Issue a session row and set the browser cookie. */
export async function createSession(
  userId: number,
  meta: { ip?: string | null; userAgent?: string | null } = {},
): Promise<void> {
  const token = randomBytes(32).toString('base64url');

  await query(
    `INSERT INTO app.user_session
        (user_id, token_hash, expires_at, ip_address, user_agent)
     VALUES ($1, $2, CURRENT_TIMESTAMP + ($3 || ' days')::INTERVAL, $4, $5)`,
    [
      userId,
      hashToken(token),
      SESSION_TTL_DAYS,
      meta.ip ?? null,
      meta.userAgent?.slice(0, 300) ?? null,
    ],
  );

  cookies().set(SESSION_COOKIE, token, {
    httpOnly: true,
    sameSite: 'lax',
    secure: process.env.NODE_ENV === 'production',
    path: '/',
    maxAge: SESSION_TTL_DAYS * 24 * 60 * 60,
  });
}

/**
 * Resolve the signed-in user from the session cookie, or null.
 * Every protected server component calls this.
 */
export async function getCurrentUser(): Promise<SessionUser | null> {
  const token = cookies().get(SESSION_COOKIE)?.value;
  if (!token) return null;

  const row = await queryOne<{
    user_id: number;
    username: string;
    email: string;
    role: AppRole;
    person_id: number | null;
    full_name: string | null;
  }>(
    `SELECT u.user_id, u.username, u.email, u.role, u.person_id,
            TRIM(p.first_name || ' ' || p.last_name) AS full_name
     FROM   app.user_session s
     JOIN   app.app_user u ON u.user_id = s.user_id
     LEFT   JOIN people.person p ON p.person_id = u.person_id
     WHERE  s.token_hash = $1
       AND  s.revoked_at IS NULL
       AND  s.expires_at > CURRENT_TIMESTAMP
       AND  u.is_active`,
    [hashToken(token)],
  );

  if (!row) return null;

  return {
    userId: row.user_id,
    username: row.username,
    email: row.email,
    role: row.role,
    personId: row.person_id,
    fullName: row.full_name,
  };
}

/** Revoke the current session and clear the cookie. */
export async function logout(): Promise<void> {
  const token = cookies().get(SESSION_COOKIE)?.value;

  if (token) {
    const revoked = await queryOne<{ user_id: number }>(
      `UPDATE app.user_session
       SET    revoked_at = CURRENT_TIMESTAMP
       WHERE  token_hash = $1 AND revoked_at IS NULL
       RETURNING user_id`,
      [hashToken(token)],
    );

    if (revoked) {
      await audit(revoked.user_id, 'LOGOUT', 'user_session', null, {});
    }
  }

  cookies().delete(SESSION_COOKIE);
}

/* -------------------------------------------------------------------------- */
/* Registration                                                                */
/* -------------------------------------------------------------------------- */

export type RegisterResult =
  | { ok: true; userId: number }
  | { ok: false; error: string };

/**
 * Create an account. If the supplied student number matches a student whose
 * record already exists, the login is linked to that person so the new user
 * immediately sees their real fees and courses.
 */
export async function register(input: {
  username: string;
  email: string;
  password: string;
  role: AppRole;
  studentNumber?: string | null;
}): Promise<RegisterResult> {
  let personId: number | null = null;

  if (input.studentNumber) {
    const student = await queryOne<{ person_id: number; taken: boolean }>(
      `SELECT s.person_id,
              EXISTS (SELECT 1 FROM app.app_user u WHERE u.person_id = s.person_id) AS taken
       FROM   people.student s
       WHERE  s.student_number = $1`,
      [input.studentNumber.trim()],
    );

    if (!student) {
      return {
        ok: false,
        error: `No student record found for index number "${input.studentNumber}". Leave the field blank to register without linking.`,
      };
    }
    if (student.taken) {
      return {
        ok: false,
        error: 'That student record already has an account. Please sign in instead.',
      };
    }
    personId = student.person_id;
  }

  const passwordHash = await hashPassword(input.password);

  try {
    // app.fn_register_user performs the uniqueness checks and writes the audit
    // row in one round trip.
    const row = await queryOne<{ result: { user_id: number } }>(
      `SELECT app.fn_register_user($1, $2, $3, $4::core.app_role_type, $5) AS result`,
      [input.username.trim(), input.email.trim().toLowerCase(), passwordHash, input.role, personId],
    );

    const userId = row?.result?.user_id;
    if (!userId) return { ok: false, error: 'Registration failed. Please try again.' };

    return { ok: true, userId };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);

    if (message.includes('already taken')) {
      return { ok: false, error: 'That username is already taken.' };
    }
    if (message.includes('already registered')) {
      return { ok: false, error: 'That e-mail address is already registered.' };
    }
    if (message.includes('app_user_username_ck')) {
      return {
        ok: false,
        error: 'Usernames may only contain letters, numbers, dots, hyphens and underscores.',
      };
    }
    if (message.includes('email_address_format')) {
      return { ok: false, error: 'Please enter a valid e-mail address.' };
    }

    console.error('[auth] register failed:', message);
    return { ok: false, error: 'Registration failed. Please try again.' };
  }
}

/* -------------------------------------------------------------------------- */
/* Audit trail                                                                 */
/* -------------------------------------------------------------------------- */

export async function audit(
  userId: number | null,
  action: string,
  entity: string | null,
  entityId: string | null,
  details: Record<string, unknown>,
): Promise<void> {
  try {
    await query(
      `INSERT INTO app.audit_log (user_id, action, entity, entity_id, details)
       VALUES ($1, $2, $3, $4, $5::jsonb)`,
      [userId, action, entity, entityId, JSON.stringify(details)],
    );
  } catch (error) {
    // Auditing must never break the request it is recording.
    console.error('[auth] audit write failed:', error);
  }
}
