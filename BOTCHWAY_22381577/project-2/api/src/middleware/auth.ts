import type { NextFunction, Request, RequestHandler, Response } from 'express';
import jwt from 'jsonwebtoken';

import { config } from '../config';
import { ApiError } from '../errors';

export type AppRole = 'student' | 'lecturer' | 'teaching_assistant' | 'admin';

export interface AuthPayload {
  sub: number; // app_user.user_id
  username: string;
  role: AppRole;
  personId: number | null;
  studentId: number | null;
  lecturerId: number | null;
}

// Attach the decoded token to the request object in a typed way.
declare global {
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace Express {
    interface Request {
      auth?: AuthPayload;
    }
  }
}

export function signToken(payload: AuthPayload): string {
  return jwt.sign(payload, config.jwt.secret, {
    expiresIn: config.jwt.expiresIn,
    issuer: config.jwt.issuer,
    audience: config.jwt.audience,
  } as jwt.SignOptions);
}

export function verifyToken(token: string): AuthPayload {
  try {
    // jwt.verify is typed as string | JwtPayload; we signed an AuthPayload, and
    // the signature check above guarantees nobody else could have produced it.
    return jwt.verify(token, config.jwt.secret, {
      issuer: config.jwt.issuer,
      audience: config.jwt.audience,
    }) as unknown as AuthPayload;
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      throw ApiError.unauthorised('Your session has expired. Please sign in again.');
    }
    throw ApiError.unauthorised('Invalid authentication token.');
  }
}

/** Require a valid Bearer token. */
export const requireAuth: RequestHandler = (req, _res, next) => {
  const header = req.headers.authorization;

  if (!header?.startsWith('Bearer ')) {
    return next(
      ApiError.unauthorised(
        'Provide a bearer token: Authorization: Bearer <token>. Obtain one from POST /api/v1/auth/login.',
      ),
    );
  }

  try {
    req.auth = verifyToken(header.slice(7).trim());
    next();
  } catch (error) {
    next(error);
  }
};

/** Require the caller to hold one of the listed roles. */
export function requireRole(...roles: AppRole[]): RequestHandler {
  return (req: Request, _res: Response, next: NextFunction) => {
    if (!req.auth) {
      return next(ApiError.unauthorised());
    }
    if (!roles.includes(req.auth.role)) {
      return next(
        ApiError.forbidden(
          `This endpoint requires one of these roles: ${roles.join(', ')}. Your role is ${req.auth.role}.`,
        ),
      );
    }
    next();
  };
}

/**
 * Students may only read their OWN record; staff may read anyone's.
 * Used on /students/:studentId and /fees/students/:studentId.
 */
export function requireSelfOrStaff(paramName = 'studentId'): RequestHandler {
  return (req, _res, next) => {
    if (!req.auth) return next(ApiError.unauthorised());

    const { role, studentId } = req.auth;

    if (role === 'admin' || role === 'lecturer') return next();

    const requested = Number(req.params[paramName]);

    if (Number.isFinite(requested) && requested === studentId) return next();

    next(
      ApiError.forbidden(
        'Students may only access their own records. Staff accounts can access any student.',
      ),
    );
  };
}
