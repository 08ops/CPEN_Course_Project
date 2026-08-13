/**
 * Application error types and the mapping from PostgreSQL SQLSTATE codes to
 * HTTP status codes.
 *
 * The stored functions raise domain errors with meaningful SQLSTATEs
 * (no_data_found, unique_violation, check_violation ...). Translating them
 * here means a rule only ever has to be written once - in the database - and
 * the API still answers with the right status code.
 */

export class ApiError extends Error {
  readonly status: number;
  readonly code: string;
  readonly details?: unknown;

  constructor(status: number, code: string, message: string, details?: unknown) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
    this.code = code;
    this.details = details;
  }

  static badRequest(message: string, details?: unknown) {
    return new ApiError(400, 'BAD_REQUEST', message, details);
  }

  static unauthorised(message = 'Authentication is required.') {
    return new ApiError(401, 'UNAUTHORISED', message);
  }

  static forbidden(message = 'You do not have permission to do that.') {
    return new ApiError(403, 'FORBIDDEN', message);
  }

  static notFound(message = 'Resource not found.') {
    return new ApiError(404, 'NOT_FOUND', message);
  }

  static conflict(message: string) {
    return new ApiError(409, 'CONFLICT', message);
  }

  static unprocessable(message: string, details?: unknown) {
    return new ApiError(422, 'UNPROCESSABLE_ENTITY', message, details);
  }

  static internal(message = 'An unexpected error occurred.') {
    return new ApiError(500, 'INTERNAL_ERROR', message);
  }
}

interface PgError extends Error {
  code?: string;
  detail?: string;
  constraint?: string;
}

function isPgError(error: unknown): error is PgError {
  return (
    error instanceof Error &&
    typeof (error as PgError).code === 'string' &&
    /^[0-9A-Z]{5}$/.test((error as PgError).code as string)
  );
}

/**
 * SQLSTATE -> HTTP. Anything unmapped becomes a 500, which is the safe default.
 */
const SQLSTATE_MAP: Record<string, { status: number; code: string }> = {
  // Class 02 - no data
  P0002: { status: 404, code: 'NOT_FOUND' }, // no_data_found (RAISE)
  '02000': { status: 404, code: 'NOT_FOUND' },
  // Class 23 - integrity constraint violation
  '23505': { status: 409, code: 'CONFLICT' }, // unique_violation
  '23503': { status: 409, code: 'FOREIGN_KEY_VIOLATION' },
  '23502': { status: 400, code: 'NOT_NULL_VIOLATION' },
  '23514': { status: 422, code: 'CHECK_VIOLATION' },
  // Class 22 - data exception
  '22P02': { status: 400, code: 'INVALID_INPUT_SYNTAX' },
  '22003': { status: 400, code: 'NUMERIC_OUT_OF_RANGE' },
  // Connection problems
  '08000': { status: 503, code: 'DATABASE_UNAVAILABLE' },
  '08006': { status: 503, code: 'DATABASE_UNAVAILABLE' },
  '57P01': { status: 503, code: 'DATABASE_UNAVAILABLE' },
};

export function toApiError(error: unknown): ApiError {
  if (error instanceof ApiError) return error;

  if (isPgError(error)) {
    const mapped = SQLSTATE_MAP[error.code as string];

    if (mapped) {
      // The message raised by the stored function is already user-facing and
      // deliberately free of internal detail, so it is safe to pass through.
      return new ApiError(mapped.status, mapped.code, cleanPgMessage(error.message));
    }

    return new ApiError(
      500,
      'DATABASE_ERROR',
      'The database rejected the request.',
    );
  }

  if (error instanceof Error) {
    return ApiError.internal(error.message);
  }

  return ApiError.internal();
}

/** Strip the plpgsql context noise that psql appends to RAISE messages. */
function cleanPgMessage(message: string): string {
  return message.split('\nCONTEXT:')[0].trim();
}
