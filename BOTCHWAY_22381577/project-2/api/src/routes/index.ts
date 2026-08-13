import { Router } from 'express';

import { queryOne } from '../db';
import { requireAuth, requireRole } from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { ok } from '../respond';
import * as service from '../services';
import { authRouter } from './auth.routes';
import { enrolmentRouter } from './enrolment.routes';
import { feesRouter } from './fees.routes';
import { studentsRouter } from './students.routes';
import { teachingRouter } from './teaching.routes';

export const apiRouter = Router();

/* ---------------------------------------------------------------------------
 * Service metadata - unauthenticated
 * ------------------------------------------------------------------------ */

/** GET /api/v1 - self-describing index of every endpoint. */
apiRouter.get('/', (_req, res) => {
  ok(res, {
    service: 'CEDS REST API',
    description:
      'Web service over the Computer Engineering Department System database. ' +
      'CPEN 208 Project 2.',
    version: '1.0.0',
    authentication:
      'POST /api/v1/auth/login returns a JWT. Send it as: Authorization: Bearer <token>',
    endpoints: {
      meta: {
        'GET  /api/v1': 'This index',
        'GET  /api/v1/health': 'Liveness and database connectivity',
        'GET  /api/v1/stats': 'Dashboard counters (auth required)',
      },
      auth: {
        'POST /api/v1/auth/register': 'Create an account',
        'POST /api/v1/auth/login': 'Obtain a JWT',
        'GET  /api/v1/auth/me': 'Resolve the current token',
      },
      'functionality-1-student-personal-information': {
        'GET  /api/v1/students': 'Student directory (staff)',
        'GET  /api/v1/students/:studentId': 'Full personal record',
      },
      'functionality-2-student-fees-payments': {
        'GET  /api/v1/fees/outstanding':
          'REQUIRED DELIVERABLE - outstanding fees for each student as a JSON array',
        'GET  /api/v1/fees/summary': 'Department collection statistics',
        'GET  /api/v1/students/:studentId/fees': 'Full fee statement',
        'GET  /api/v1/students/:studentId/balance': 'Outstanding balance only',
        'POST /api/v1/fees/bills': 'Generate a bill from the fee structure',
        'POST /api/v1/fees/payments': 'Record a payment',
      },
      'functionality-3-course-enrollment': {
        'GET  /api/v1/enrollments/offerings': 'Course catalogue with seat counts',
        'GET  /api/v1/enrollments/offerings/:offeringId/class-list': 'Class register',
        'GET  /api/v1/students/:studentId/enrollments': "A student's courses",
        'POST /api/v1/enrollments': 'Register for a course',
        'DELETE /api/v1/enrollments': 'Withdraw from a course',
      },
      'functionality-4-lecturer-to-course-assignment': {
        'GET  /api/v1/teaching/lecturers': 'All lecturers',
        'GET  /api/v1/teaching/assignments': 'All lecturer-course allocations',
        'GET  /api/v1/teaching/lecturers/:lecturerId/workload': 'Workload with TAs',
        'POST /api/v1/teaching/assignments': 'Assign a lecturer to a course',
      },
      'functionality-5-lecturer-to-ta-assignment': {
        'GET  /api/v1/teaching/assistants': 'TA pool with committed hours',
        'GET  /api/v1/teaching/ta-assignments': 'All lecturer-TA assignments',
        'POST /api/v1/teaching/ta-assignments': 'Assign a TA to a lecturer',
      },
      reference: {
        'GET  /api/v1/reference/programmes': 'Degree programmes',
        'GET  /api/v1/reference/semesters': 'Academic calendar',
      },
    },
  });
});

/** GET /api/v1/health */
apiRouter.get(
  '/health',
  asyncHandler(async (_req, res) => {
    const row = await queryOne<{ db: string; students: number; now: Date }>(
      `SELECT current_database() AS db,
              (SELECT COUNT(*) FROM people.student)::INT AS students,
              CURRENT_TIMESTAMP AS now`,
    );

    ok(res, {
      status: 'ok',
      database: row?.db,
      students: row?.students,
      databaseTime: row?.now,
      uptimeSeconds: Math.round(process.uptime()),
    });
  }),
);

/** GET /api/v1/stats */
apiRouter.get(
  '/stats',
  requireAuth,
  requireRole('admin', 'lecturer'),
  asyncHandler(async (_req, res) => {
    ok(res, await service.getDashboardStats(), {
      source: 'app.fn_dashboard_stats_json()',
    });
  }),
);

/* ---------------------------------------------------------------------------
 * Reference data
 * ------------------------------------------------------------------------ */

const referenceRouter = Router();
referenceRouter.use(requireAuth);

referenceRouter.get(
  '/programmes',
  asyncHandler(async (_req, res) => ok(res, await service.listProgrammes())),
);

referenceRouter.get(
  '/semesters',
  asyncHandler(async (_req, res) => ok(res, await service.listSemesters())),
);

/* ---------------------------------------------------------------------------
 * Mount
 * ------------------------------------------------------------------------ */

apiRouter.use('/auth', authRouter);
apiRouter.use('/students', studentsRouter);
apiRouter.use('/fees', feesRouter);
apiRouter.use('/enrollments', enrolmentRouter);
apiRouter.use('/teaching', teachingRouter);
apiRouter.use('/reference', referenceRouter);
