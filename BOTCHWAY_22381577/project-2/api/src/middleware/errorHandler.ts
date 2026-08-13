import type { ErrorRequestHandler, RequestHandler } from 'express';

import { config } from '../config';
import { ApiError, toApiError } from '../errors';

/** 404 handler for paths that match no route. */
export const notFoundHandler: RequestHandler = (req, _res, next) => {
  next(
    ApiError.notFound(
      `No route matches ${req.method} ${req.originalUrl}. See GET /api/v1 for the endpoint index.`,
    ),
  );
};

/**
 * Central error handler. Every route delegates here rather than formatting its
 * own error body, so all failures share one JSON envelope.
 */
export const errorHandler: ErrorRequestHandler = (err, req, res, _next) => {
  const apiError = toApiError(err);

  if (apiError.status >= 500) {
    console.error(
      `[error] ${req.method} ${req.originalUrl} ->`,
      err instanceof Error ? err.stack : err,
    );
  }

  res.status(apiError.status).json({
    success: false,
    error: {
      code: apiError.code,
      message: apiError.message,
      ...(apiError.details ? { details: apiError.details } : {}),
    },
    // The stack is a debugging aid only; never expose it in production.
    ...(config.isProduction || !(err instanceof Error)
      ? {}
      : { stack: err.stack?.split('\n').slice(0, 4) }),
    meta: {
      path: req.originalUrl,
      method: req.method,
      timestamp: new Date().toISOString(),
    },
  });
};

/**
 * Wrap an async route handler so a rejected promise reaches errorHandler
 * instead of hanging the request. Express 4 does not do this itself.
 */
export function asyncHandler<T extends RequestHandler>(handler: T): RequestHandler {
  return (req, res, next) => {
    Promise.resolve(handler(req, res, next)).catch(next);
  };
}
