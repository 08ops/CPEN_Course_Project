import { z } from 'zod';

/** Reusable primitives ---------------------------------------------------- */

/** A positive integer arriving as a URL segment or query string. */
export const idParam = z.coerce.number().int().positive();

export const paginationQuery = z.object({
  limit: z.coerce.number().int().min(1).max(500).default(100),
  offset: z.coerce.number().int().min(0).default(0),
});

/** Auth ------------------------------------------------------------------- */

export const loginBody = z.object({
  username: z.string().trim().min(3).max(120),
  password: z.string().min(1).max(200),
});

export const registerBody = z
  .object({
    username: z
      .string()
      .trim()
      .min(3)
      .max(60)
      .regex(
        /^[A-Za-z0-9._-]+$/,
        'Username may only contain letters, numbers, dots, hyphens and underscores.',
      ),
    email: z
      .string()
      .trim()
      .toLowerCase()
      .max(150)
      .regex(
        /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
        'Enter a valid e-mail address.',
      ),
    password: z
      .string()
      .min(8, 'Password must be at least 8 characters.')
      .max(72)
      .regex(/[A-Z]/, 'Password must contain an upper-case letter.')
      .regex(/[a-z]/, 'Password must contain a lower-case letter.')
      .regex(/[0-9]/, 'Password must contain a digit.'),
    role: z
      .enum(['student', 'lecturer', 'teaching_assistant', 'admin'])
      .default('student'),
    studentNumber: z.string().trim().regex(/^[0-9]{6,15}$/).optional(),
  })
  .strict();

/** Students --------------------------------------------------------------- */

export const studentListQuery = z.object({
  programmeId: z.coerce.number().int().positive().optional(),
  level: z.coerce.number().int().optional(),
  search: z.string().trim().min(1).max(80).optional(),
});

export const studentIdParams = z.object({ studentId: idParam });

/** Fees ------------------------------------------------------------------- */

export const outstandingFeesQuery = z.object({
  academicYearId: z.coerce.number().int().positive().optional(),
  programmeId: z.coerce.number().int().positive().optional(),
  indebtedOnly: z
    .union([z.boolean(), z.string()])
    .transform((v) => v === true || v === 'true' || v === '1')
    .default(false),
});

export const generateBillBody = z
  .object({
    studentId: idParam,
    academicYearId: idParam,
    dueDate: z.iso.date().optional(),
    issuedOn: z.iso.date().optional(),
  })
  .strict();

export const recordPaymentBody = z
  .object({
    studentId: idParam,
    billId: idParam,
    amount: z.coerce.number().positive().max(1_000_000),
    method: z.enum([
      'bank_transfer',
      'mobile_money',
      'cash',
      'cheque',
      'card',
      'scholarship',
    ]),
    channel: z.string().trim().max(80).optional(),
    transactionRef: z.string().trim().max(60).optional(),
    receivedBy: z.string().trim().max(120).optional(),
    paymentDate: z.iso.date().optional(),
  })
  .strict();

/** Enrolment -------------------------------------------------------------- */

export const enrolBody = z
  .object({
    studentId: idParam,
    offeringId: idParam,
    isRetake: z.boolean().default(false),
  })
  .strict();

export const dropEnrolmentBody = z
  .object({
    studentId: idParam,
    offeringId: idParam,
  })
  .strict();

export const enrolmentQuery = z.object({
  semesterId: z.coerce.number().int().positive().optional(),
});

export const offeringIdParams = z.object({ offeringId: idParam });

/** Teaching assignment ---------------------------------------------------- */

export const assignLecturerBody = z
  .object({
    lecturerId: idParam,
    offeringId: idParam,
    role: z
      .enum(['lead_lecturer', 'co_lecturer', 'guest_lecturer'])
      .default('lead_lecturer'),
    assignedBy: z.string().trim().max(120).optional(),
  })
  .strict();

export const lecturerIdParams = z.object({ lecturerId: idParam });

export const lecturerWorkloadQuery = z.object({
  semesterId: z.coerce.number().int().positive().optional(),
});

export const assignTaBody = z
  .object({
    lecturerId: idParam,
    taId: idParam,
    semesterId: idParam,
    offeringId: idParam.optional(),
    responsibility: z.string().trim().min(3).max(200).optional(),
    weeklyHours: z.coerce.number().int().min(1).max(40).default(6),
  })
  .strict();

export const taAssignmentQuery = z.object({
  semesterId: z.coerce.number().int().positive().optional(),
  lecturerId: z.coerce.number().int().positive().optional(),
});
