import type { RequestHandler } from 'express';
import { ZodError, type ZodType } from 'zod';

import { ApiError } from '../errors';

type Source = 'body' | 'query' | 'params';

/**
 * Validate and COERCE one part of the request with a Zod schema.
 *
 * The parsed result replaces the raw input, so downstream handlers receive
 * values that are already the right type (numbers as numbers, not strings)
 * and are guaranteed to satisfy the schema.
 */
export function validate(schema: ZodType, source: Source = 'body'): RequestHandler {
  return (req, _res, next) => {
    const result = schema.safeParse(req[source]);

    if (!result.success) {
      return next(
        ApiError.badRequest(
          `Invalid request ${source}.`,
          formatZodError(result.error),
        ),
      );
    }

    // req.query and req.params are getter-only on some Express versions, so
    // assign through defineProperty rather than direct mutation.
    Object.defineProperty(req, source, {
      value: result.data,
      writable: true,
      configurable: true,
      enumerable: true,
    });

    next();
  };
}

export function formatZodError(error: ZodError): Array<{ field: string; message: string }> {
  return error.issues.map((issue) => ({
    field: issue.path.join('.') || '(root)',
    message: issue.message,
  }));
}
