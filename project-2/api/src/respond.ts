import type { Response } from 'express';

/**
 * One JSON envelope for every successful response, so clients can rely on the
 * same shape everywhere:
 *   { "success": true, "data": ..., "meta": { ... } }
 */
export function ok<T>(
  res: Response,
  data: T,
  meta: Record<string, unknown> = {},
  status = 200,
): Response {
  const count = Array.isArray(data) ? data.length : undefined;

  return res.status(status).json({
    success: true,
    data,
    meta: {
      ...(count !== undefined ? { count } : {}),
      ...meta,
      timestamp: new Date().toISOString(),
    },
  });
}

export function created<T>(
  res: Response,
  data: T,
  meta: Record<string, unknown> = {},
): Response {
  return ok(res, data, meta, 201);
}
