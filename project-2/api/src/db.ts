import { Pool, type PoolClient, type QueryResultRow } from 'pg';

import { config } from './config';

/**
 * One shared connection pool for the whole service.
 *
 * The API is a thin transport layer: every read and write is delegated to a
 * stored function created in Project 1 (04_functions.sql). That keeps the
 * business rules in exactly one place, shared with the Next.js application.
 */
export const pool = new Pool(
  config.database.connectionString
    ? {
        connectionString: config.database.connectionString,
        max: config.database.maxConnections,
      }
    : {
        host: config.database.host,
        port: config.database.port,
        user: config.database.user,
        password: config.database.password,
        database: config.database.database,
        max: config.database.maxConnections,
      },
);

pool.on('error', (err) => {
  console.error('[db] unexpected idle client error:', err.message);
});

export async function query<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T[]> {
  const result = await pool.query<T>(text, params);
  return result.rows;
}

export async function queryOne<T extends QueryResultRow = QueryResultRow>(
  text: string,
  params: unknown[] = [],
): Promise<T | null> {
  const rows = await query<T>(text, params);
  return rows[0] ?? null;
}

/**
 * Invoke a database function that returns JSON.
 * `fnCall` is a fragment such as 'finance.fn_outstanding_fees_json($1,$2,$3)';
 * the placeholders keep the call parameterised, so nothing is interpolated.
 */
export async function callJson<T>(
  fnCall: string,
  params: unknown[] = [],
): Promise<T> {
  const row = await queryOne<{ result: T }>(`SELECT ${fnCall} AS result`, params);
  return (row?.result ?? null) as T;
}

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

export async function closePool(): Promise<void> {
  await pool.end();
}
