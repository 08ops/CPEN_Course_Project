import { createApp } from './app';
import { config } from './config';
import { closePool, queryOne } from './db';

async function main(): Promise<void> {
  // Fail fast and loudly if the database is not reachable: a service that
  // starts "successfully" and then 500s on every request is worse than one
  // that refuses to start.
  try {
    const row = await queryOne<{ db: string; students: number }>(
      `SELECT current_database() AS db,
              (SELECT COUNT(*) FROM people.student)::INT AS students`,
    );
    console.log(
      `[db] connected to "${row?.db}" (${row?.students} student records)`,
    );
  } catch (error) {
    console.error(
      '[db] FATAL - could not reach the database.\n' +
        '     Check DATABASE_URL in .env and that PostgreSQL is running.\n' +
        `     ${error instanceof Error ? error.message : String(error)}`,
    );
    process.exit(1);
  }

  const app = createApp();
  const server = app.listen(config.port, () => {
    console.log(
      `\n  CEDS REST API\n` +
        `  ------------------------------------------------\n` +
        `  environment : ${config.env}\n` +
        `  listening   : http://localhost:${config.port}\n` +
        `  endpoints   : http://localhost:${config.port}/api/v1\n` +
        `  health      : http://localhost:${config.port}/api/v1/health\n`,
    );
  });

  // Finish in-flight requests before exiting, then release the pool.
  const shutdown = (signal: string) => {
    console.log(`\n[server] ${signal} received, shutting down…`);
    server.close(async () => {
      await closePool();
      console.log('[server] closed cleanly.');
      process.exit(0);
    });
    // Do not hang forever if a connection refuses to close.
    setTimeout(() => process.exit(1), 10_000).unref();
  };

  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
}

main().catch((error) => {
  console.error('[server] failed to start:', error);
  process.exit(1);
});
