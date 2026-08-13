import { Router } from 'express';

import {
  requireAuth,
  requireRole,
  requireSelfOrStaff,
} from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { validate } from '../middleware/validate';
import { ok } from '../respond';
import { studentIdParams, studentListQuery } from '../schemas';
import * as service from '../services';

/** FUNCTIONALITY 1 - Student personal information. */
export const studentsRouter = Router();

studentsRouter.use(requireAuth);

/**
 * GET /api/v1/students?programmeId=&level=&search=
 * Student directory. Staff only - a student has no business listing the class.
 */
studentsRouter.get(
  '/',
  requireRole('admin', 'lecturer'),
  validate(studentListQuery, 'query'),
  asyncHandler(async (req, res) => {
    const students = await service.listStudents(req.query as never);
    ok(res, students, { filters: req.query });
  }),
);

/**
 * GET /api/v1/students/:studentId
 * Full personal, contact and academic record.
 * A student may fetch only their own; staff may fetch anyone's.
 */
studentsRouter.get(
  '/:studentId',
  validate(studentIdParams, 'params'),
  requireSelfOrStaff('studentId'),
  asyncHandler(async (req, res) => {
    const profile = await service.getStudentProfile(Number(req.params.studentId));
    ok(res, profile);
  }),
);

/**
 * GET /api/v1/students/:studentId/enrollments?semesterId=
 * The student's registered courses (FUNCTIONALITY 3).
 */
studentsRouter.get(
  '/:studentId/enrollments',
  validate(studentIdParams, 'params'),
  requireSelfOrStaff('studentId'),
  asyncHandler(async (req, res) => {
    const semesterId = req.query.semesterId
      ? Number(req.query.semesterId)
      : undefined;
    const rows = await service.getStudentEnrolments(
      Number(req.params.studentId),
      semesterId,
    );
    ok(res, rows);
  }),
);

/**
 * GET /api/v1/students/:studentId/fees
 * Full fee statement: bills, line items and payment history (FUNCTIONALITY 2).
 */
studentsRouter.get(
  '/:studentId/fees',
  validate(studentIdParams, 'params'),
  requireSelfOrStaff('studentId'),
  asyncHandler(async (req, res) => {
    const statement = await service.getStudentFeeStatement(
      Number(req.params.studentId),
    );
    ok(res, statement);
  }),
);

/**
 * GET /api/v1/students/:studentId/balance
 * Just the number, for lightweight clients.
 */
studentsRouter.get(
  '/:studentId/balance',
  validate(studentIdParams, 'params'),
  requireSelfOrStaff('studentId'),
  asyncHandler(async (req, res) => {
    const studentId = Number(req.params.studentId);
    const balance = await service.getStudentOutstandingBalance(studentId);
    ok(res, { studentId, outstandingBalance: balance, currency: 'GHS' });
  }),
);
