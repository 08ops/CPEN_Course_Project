import { Router } from 'express';

import { requireAuth, requireRole } from '../middleware/auth';
import { asyncHandler } from '../middleware/errorHandler';
import { validate } from '../middleware/validate';
import { created, ok } from '../respond';
import {
  generateBillBody,
  outstandingFeesQuery,
  recordPaymentBody,
} from '../schemas';
import * as service from '../services';

/** FUNCTIONALITY 2 - Student fees payments. */
export const feesRouter = Router();

feesRouter.use(requireAuth);

/**
 * GET /api/v1/fees/outstanding?academicYearId=&programmeId=&indebtedOnly=
 *
 * *** The headline endpoint of Project 2. ***
 * It returns, verbatim, the JSON array produced by the database function
 * required in Project 1: finance.fn_outstanding_fees_json().
 */
feesRouter.get(
  '/outstanding',
  requireRole('admin', 'lecturer'),
  validate(outstandingFeesQuery, 'query'),
  asyncHandler(async (req, res) => {
    const filters = req.query as unknown as {
      academicYearId?: number;
      programmeId?: number;
      indebtedOnly: boolean;
    };

    const rows = await service.getOutstandingFees(filters);

    ok(res, rows, {
      source: 'finance.fn_outstanding_fees_json()',
      filters,
    });
  }),
);

/**
 * GET /api/v1/fees/summary?academicYearId=
 * Aggregate collection statistics for the department.
 */
feesRouter.get(
  '/summary',
  requireRole('admin', 'lecturer'),
  asyncHandler(async (req, res) => {
    const academicYearId = req.query.academicYearId
      ? Number(req.query.academicYearId)
      : undefined;
    ok(res, await service.getFeesSummary(academicYearId), {
      source: 'finance.fn_fees_summary_json()',
    });
  }),
);

/**
 * POST /api/v1/fees/bills
 * Generate a student's bill for an academic year from the published fee
 * structure. Idempotent: a second call reports the existing bill.
 */
feesRouter.post(
  '/bills',
  requireRole('admin'),
  validate(generateBillBody),
  asyncHandler(async (req, res) => {
    const result = await service.generateBill(req.body);
    const wasCreated = (result as { created?: boolean }).created === true;

    await service.audit(
      req.auth!.sub,
      'GENERATE_BILL',
      'student_bill',
      String((result as { bill_id?: number }).bill_id ?? ''),
      req.body,
    );

    if (wasCreated) return created(res, result);
    ok(res, result);
  }),
);

/**
 * POST /api/v1/fees/payments
 * Record a confirmed fee payment and return the receipt plus the new balance.
 */
feesRouter.post(
  '/payments',
  requireRole('admin'),
  validate(recordPaymentBody),
  asyncHandler(async (req, res) => {
    const receipt = await service.recordPayment(req.body);

    await service.audit(
      req.auth!.sub,
      'RECORD_PAYMENT',
      'payment',
      String((receipt as { payment_id?: number }).payment_id ?? ''),
      { amount: req.body.amount, billId: req.body.billId },
    );

    created(res, receipt, { source: 'finance.fn_record_payment()' });
  }),
);
