import { Router } from 'express';

import { ApiError } from '../errors';
import { requireAuth, requireRole } from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { validate } from '../middleware/validate';
import { created, ok } from '../respond';
import { dropEnrolmentBody, enrolBody, offeringIdParams } from '../schemas';
import * as service from '../services';

/** FUNCTIONALITY 3 - Course enrolment. */
export const enrolmentRouter = Router();

enrolmentRouter.use(requireAuth);

/**
 * GET /api/v1/enrollments/offerings
 * The course catalogue for the current semester, with live seat counts.
 */
enrolmentRouter.get(
  '/offerings',
  asyncHandler(async (_req, res) => {
    ok(res, await service.getCourseCatalogue());
  }),
);

/**
 * GET /api/v1/enrollments/offerings/:offeringId/class-list
 * The register for one offering. Staff only.
 */
enrolmentRouter.get(
  '/offerings/:offeringId/class-list',
  requireRole('admin', 'lecturer', 'teaching_assistant'),
  validate(offeringIdParams, 'params'),
  asyncHandler(async (req, res) => {
    const list = await service.getClassList(Number(req.params.offeringId));
    if (!list) throw ApiError.notFound('That course offering does not exist.');
    ok(res, list, { source: 'academics.fn_class_list_json()' });
  }),
);

/**
 * POST /api/v1/enrollments
 * Register a student for a course offering.
 *
 * A student may only enrol themselves; staff may enrol anyone. All the hard
 * rules - class full, registration closed, student not active, duplicate
 * registration - are enforced by the database, not here.
 */
enrolmentRouter.post(
  '/',
  validate(enrolBody),
  asyncHandler(async (req, res) => {
    const { studentId, offeringId, isRetake } = req.body;
    const { role, studentId: ownStudentId, sub } = req.auth!;

    if (role === 'student' && studentId !== ownStudentId) {
      throw ApiError.forbidden('You may only register yourself for a course.');
    }
    if (role === 'teaching_assistant') {
      throw ApiError.forbidden('Teaching assistants cannot register students.');
    }

    const result = await service.enrolStudent(studentId, offeringId, isRetake);
    await service.audit(sub, 'ENROL', 'enrollment', null, { studentId, offeringId });

    created(res, result, { source: 'academics.fn_enroll_student()' });
  }),
);

/**
 * DELETE /api/v1/enrollments
 * Withdraw from a course. The row is retained with status 'dropped' rather
 * than deleted, so the registration history stays auditable.
 */
enrolmentRouter.delete(
  '/',
  validate(dropEnrolmentBody),
  asyncHandler(async (req, res) => {
    const { studentId, offeringId } = req.body;
    const { role, studentId: ownStudentId, sub } = req.auth!;

    if (role === 'student' && studentId !== ownStudentId) {
      throw ApiError.forbidden('You may only withdraw yourself from a course.');
    }
    if (role === 'teaching_assistant') {
      throw ApiError.forbidden('Teaching assistants cannot withdraw students.');
    }

    const result = await service.dropEnrolment(studentId, offeringId);
    await service.audit(sub, 'DROP_ENROLMENT', 'enrollment', null, {
      studentId,
      offeringId,
    });

    ok(res, result, { source: 'academics.fn_drop_enrollment()' });
  }),
);
