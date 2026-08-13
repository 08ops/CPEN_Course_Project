import { NextResponse } from 'next/server';

import { queryOne } from '@/lib/db';

export const dynamic = 'force-dynamic';

/** GET /api/health - liveness probe that also proves the database is reachable. */
export async function GET() {
  try {
    const row = await queryOne<{ now: Date; db: string; students: number }>(
      `SELECT CURRENT_TIMESTAMP AS now,
              current_database() AS db,
              (SELECT COUNT(*) FROM people.student)::INT AS students`,
    );

    return NextResponse.json({
      status: 'ok',
      database: row?.db,
      students: row?.students,
      timestamp: row?.now,
    });
  } catch (error) {
    return NextResponse.json(
      {
        status: 'error',
        message:
          error instanceof Error ? error.message : 'Database unreachable',
      },
      { status: 503 },
    );
  }
}
