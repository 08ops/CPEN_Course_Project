import { Router } from 'express';

import { ApiError } from '../errors';
import { requireAuth, requireRole } from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { validate } from '../middleware/validate';
import { created, ok } from '../respond';
import {
  assignLecturerBody,
  assignTaBody,
  lecturerIdParams,
  lecturerWorkloadQuery,
  taAssignmentQuery,
} from '../schemas';
import * as service from '../services';

/** FUNCTIONALITIES 4 and 5 - lecturer-to-course and lecturer-to-TA assignment. */
export const teachingRouter = Router();

teachingRouter.use(requireAuth);

/* ---------------------------------------------------------------------------
 * FUNCTIONALITY 4 - Lecturers
 * ------------------------------------------------------------------------ */

/** GET /api/v1/teaching/lecturers */
teachingRouter.get(
  '/lecturers',
  asyncHandler(async (_req, res) => {
    ok(res, await service.listLecturers());
  }),
);

/** GET /api/v1/teaching/assignments - every lecturer-to-course allocation. */
teachingRouter.get(
  '/assignments',
  asyncHandler(async (_req, res) => {
    ok(res, await service.getLecturerAllocations(), {
      source: 'academics.v_lecturer_course_allocation',
    });
  }),
);

/**
 * GET /api/v1/teaching/lecturers/:lecturerId/workload?semesterId=
 * A lecturer's courses, contact hours and the TAs attached to each course.
 */
teachingRouter.get(
  '/lecturers/:lecturerId/workload',
  validate(lecturerIdParams, 'params'),
  validate(lecturerWorkloadQuery, 'query'),
  asyncHandler(async (req, res) => {
    const lecturerId = Number(req.params.lecturerId);
    const semesterId = (req.query as { semesterId?: number }).semesterId;

    const workload = await service.getLecturerWorkload(lecturerId, semesterId);
    if (!workload) throw ApiError.notFound('That lecturer does not exist.');

    ok(res, workload, { source: 'academics.fn_lecturer_workload_json()' });
  }),
);

/**
 * POST /api/v1/teaching/assignments
 * Assign a lecturer to a course offering.
 * The "one lead lecturer per offering" rule is enforced in the database.
 */
teachingRouter.post(
  '/assignments',
  requireRole('admin'),
  validate(assignLecturerBody),
  asyncHandler(async (req, res) => {
    const result = await service.assignLecturerToCourse(req.body);

    await service.audit(
      req.auth!.sub,
      'ASSIGN_LECTURER',
      'lecturer_course_assignment',
      String((result as { assignment_id?: number }).assignment_id ?? ''),
      req.body,
    );

    created(res, result, {
      source: 'academics.fn_assign_lecturer_to_course()',
    });
  }),
);

/* ---------------------------------------------------------------------------
 * FUNCTIONALITY 5 - Teaching assistants
 * ------------------------------------------------------------------------ */

/** GET /api/v1/teaching/assistants - the TA pool with committed hours. */
teachingRouter.get(
  '/assistants',
  asyncHandler(async (_req, res) => {
    ok(res, await service.listTeachingAssistants());
  }),
);

/** GET /api/v1/teaching/ta-assignments?semesterId=&lecturerId= */
teachingRouter.get(
  '/ta-assignments',
  validate(taAssignmentQuery, 'query'),
  asyncHandler(async (req, res) => {
    const filters = req.query as { semesterId?: number; lecturerId?: number };
    ok(res, await service.getTaAssignments(filters), {
      source: 'academics.fn_ta_assignments_json()',
      filters,
    });
  }),
);

/**
 * POST /api/v1/teaching/ta-assignments
 * Assign a teaching assistant to a lecturer.
 *
 * The database refuses the assignment when it would push the TA past their
 * contracted weekly hours, or when the lecturer does not actually teach the
 * offering. Those errors surface here as 422 / 409.
 */
teachingRouter.post(
  '/ta-assignments',
  requireRole('admin', 'lecturer'),
  validate(assignTaBody),
  asyncHandler(async (req, res) => {
    // A lecturer may only attach a TA to themselves.
    if (
      req.auth!.role === 'lecturer' &&
      req.auth!.lecturerId !== req.body.lecturerId
    ) {
      throw ApiError.forbidden(
        'Lecturers may only assign teaching assistants to their own courses.',
      );
    }

    const result = await service.assignTaToLecturer(req.body);

    await service.audit(
      req.auth!.sub,
      'ASSIGN_TA',
      'lecturer_ta_assignment',
      String((result as { ta_assignment_id?: number }).ta_assignment_id ?? ''),
      req.body,
    );

    created(res, result, { source: 'academics.fn_assign_ta_to_lecturer()' });
  }),
);
