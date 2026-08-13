/**
 * PostgreSQL connection pool.
 *
 * A single pool is shared by the whole application. In development Next.js
 * hot-reloads modules on every edit, which would otherwise leak a new pool
 * (and a new set of TCP connections) on each reload, so the pool is cached on
 * globalThis.
 */
import { Pool, type PoolClient, type QueryResultRow } from 'pg';

declare global {
  // eslint-disable-next-line no-var
  var __cedsPool: Pool | undefined;
}

function createPool(): Pool {
  const connectionString = process.env.DATABASE_URL;

  const pool = new Pool(
    connectionString
      ? { connectionString, max: 10, idleTimeoutMillis: 30_000 }
      : {
          host: process.env.PGHOST ?? 'localhost',
          port: Number(process.env.PGPORT ?? 5432),
          user: process.env.PGUSER,
          password: process.env.PGPASSWORD,
          database: process.env.PGDATABASE ?? 'cpen208_ceds',
          max: 10,
          idleTimeoutMillis: 30_000,
        },
  );

  // An idle client erroring (e.g. the database restarted) must not take the
  // Node process down with it.
  pool.on('error', (err) => {
    console.error('[db] idle client error:', err.message);
  });

  return pool;
}

export const pool: Pool = global.__cedsPool ?? createPool();

if (process.env.NODE_ENV !== 'production') {
  global.__cedsPool = pool;
}

/** Run a parameterised query and return the rows. */
export async function query<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T[]> {
  const result = await pool.query<T>(text, params);
  return result.rows;
}

/** Run a query expected to return at most one row. */
export async function queryOne<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T | null> {
  const rows = await query<T>(text, params);
  return rows[0] ?? null;
}

/**
 * Call a database function that returns JSON and hand back the parsed value.
 * The node-postgres driver already parses `json`/`jsonb` columns, so the value
 * arrives as a JavaScript object.
 */
export async function callJson<T>(
  fnCall: string,
  params: unknown[] = [],
): Promise<T> {
  const row = await queryOne<{ result: T }>(
    `SELECT ${fnCall} AS result`,
    params,
  );
  return (row?.result ?? null) as T;
}

/** Run several statements inside one transaction. */
export async function transaction<T>(
  fn: (client: PoolClient) => Promise<T>,
): Promise<T> {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const result = await fn(client);
    await client.query('COMMIT');
    return result;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}
