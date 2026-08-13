import { Router } from 'express';
import rateLimit from 'express-rate-limit';

import { config } from '../config';
import { requireAuth, signToken } from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { validate } from '../middleware/validate';
import { created, ok } from '../respond';
import { loginBody, registerBody } from '../schemas';
import * as service from '../services';

export const authRouter = Router();

/**
 * Credential endpoints get a much tighter rate limit than the rest of the API:
 * they are the ones worth brute-forcing.
 */
const authLimiter = rateLimit({
  windowMs: config.rateLimit.windowMs,
  max: config.rateLimit.authMax,
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    success: false,
    error: {
      code: 'TOO_MANY_REQUESTS',
      message: 'Too many authentication attempts. Please try again later.',
    },
  },
});

/**
 * POST /api/v1/auth/register
 * Create an account. Supply studentNumber to link it to an existing student.
 */
authRouter.post(
  '/register',
  authLimiter,
  validate(registerBody),
  asyncHandler(async (req, res) => {
    const result = await service.registerUser(req.body);
    created(res, result, { message: 'Account created. Sign in to obtain a token.' });
  }),
);

/**
 * POST /api/v1/auth/login
 * Exchange username/e-mail + password for a JWT.
 */
authRouter.post(
  '/login',
  authLimiter,
  validate(loginBody),
  asyncHandler(async (req, res) => {
    const payload = await service.authenticate(req.body.username, req.body.password);
    const token = signToken(payload);

    ok(res, {
      token,
      tokenType: 'Bearer',
      expiresIn: config.jwt.expiresIn,
      user: {
        userId: payload.sub,
        username: payload.username,
        role: payload.role,
        studentId: payload.studentId,
        lecturerId: payload.lecturerId,
      },
    });
  }),
);

/**
 * GET /api/v1/auth/me
 * Everything the caller's token resolves to, straight from
 * app.fn_user_context_json().
 */
authRouter.get(
  '/me',
  requireAuth,
  asyncHandler(async (req, res) => {
    ok(res, await service.getUserContext(req.auth!.sub));
  }),
);
