import 'dotenv/config';

/**
 * Central configuration. Every environment-dependent value is read once, here,
 * so nothing else in the codebase touches process.env directly.
 */

function required(name: string, fallback?: string): string {
  const value = process.env[name] ?? fallback;
  if (!value) {
    throw new Error(
      `Missing required environment variable ${name}. Copy .env.example to .env and set it.`,
    );
  }
  return value;
}

const isProduction = process.env.NODE_ENV === 'production';

export const config = {
  env: process.env.NODE_ENV ?? 'development',
  isProduction,

  port: Number(process.env.PORT ?? 4000),

  database: {
    connectionString: process.env.DATABASE_URL,
    host: process.env.PGHOST ?? 'localhost',
    port: Number(process.env.PGPORT ?? 5432),
    user: process.env.PGUSER,
    password: process.env.PGPASSWORD,
    database: process.env.PGDATABASE ?? 'cpen208_ceds',
    maxConnections: Number(process.env.PG_POOL_MAX ?? 10),
  },

  jwt: {
    // A weak default is tolerable for a local marking run, but never in
    // production - so in production the variable is mandatory.
    secret: isProduction
      ? required('JWT_SECRET')
      : (process.env.JWT_SECRET ?? 'cpen208-development-secret-change-me'),
    expiresIn: process.env.JWT_EXPIRES_IN ?? '2h',
    issuer: 'ceds-api',
    audience: 'ceds-clients',
  },

  cors: {
    // Comma-separated list, or * for anything (development default).
    origins: (process.env.CORS_ORIGINS ?? '*')
      .split(',')
      .map((o) => o.trim())
      .filter(Boolean),
  },

  rateLimit: {
    windowMs: Number(process.env.RATE_LIMIT_WINDOW_MS ?? 15 * 60 * 1000),
    max: Number(process.env.RATE_LIMIT_MAX ?? 300),
    authMax: Number(process.env.RATE_LIMIT_AUTH_MAX ?? 20),
  },

  bcryptRounds: Number(process.env.BCRYPT_ROUNDS ?? 10),
} as const;
