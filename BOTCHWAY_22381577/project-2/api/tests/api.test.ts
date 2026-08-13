/**
 * End-to-end tests for the CEDS REST API.
 *
 *   npm test
 *
 * These are integration tests, not unit tests with mocks: they boot the real
 * Express app against the real PostgreSQL database built by
 * ops/project-1/database/run_all.sh. That is deliberate - the point of this
 * service is that it faithfully exposes the Project 1 database functions, and
 * only a real database can prove that.
 *
 * The suite is read-mostly. The one write it performs (registering a throwaway
 * account) is cleaned up in the teardown hook.
 */
import assert from 'node:assert/strict';
import type { AddressInfo } from 'node:net';
import { after, before, describe, it } from 'node:test';

import { createApp } from '../src/app';
import { closePool, query } from '../src/db';

let baseUrl = '';
let server: ReturnType<ReturnType<typeof createApp>['listen']>;

let adminToken = '';
let studentToken = '';
let studentId = 0;

const THROWAWAY_USERNAME = 'test.account.cpen208';

interface ApiResponse<T = unknown> {
  success: boolean;
  data: T;
  meta?: Record<string, unknown>;
  error?: { code: string; message: string; details?: unknown };
}

async function api<T = unknown>(
  path: string,
  options: RequestInit & { token?: string } = {},
): Promise<{ status: number; body: ApiResponse<T> }> {
  const { token, ...init } = options;

  const response = await fetch(`${baseUrl}${path}`, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(init.headers ?? {}),
    },
  });

  return { status: response.status, body: (await response.json()) as ApiResponse<T> };
}

before(async () => {
  // NODE_ENV=test is set by the npm script, before ../src/config is imported,
  // which is what suppresses the HTTP request logging during the run.
  const app = createApp();
  server = app.listen(0);
  await new Promise((resolve) => server.once('listening', resolve));
  baseUrl = `http://127.0.0.1:${(server.address() as AddressInfo).port}`;

  // Clear any leftover from a previous interrupted run.
  await query('DELETE FROM app.app_user WHERE username = $1', [THROWAWAY_USERNAME]);
});

after(async () => {
  await query('DELETE FROM app.app_user WHERE username = $1', [THROWAWAY_USERNAME]);
  await new Promise((resolve) => server.close(resolve));
  await closePool();
});

/* -------------------------------------------------------------------------- */

describe('service metadata', () => {
  it('serves the endpoint index without a token', async () => {
    const { status, body } = await api<{ service: string; endpoints: object }>('/api/v1');
    assert.equal(status, 200);
    assert.equal(body.success, true);
    assert.equal(body.data.service, 'CEDS REST API');
    assert.ok(body.data.endpoints);
  });

  it('reports a healthy database connection', async () => {
    const { status, body } = await api<{ status: string; students: number }>(
      '/api/v1/health',
    );
    assert.equal(status, 200);
    assert.equal(body.data.status, 'ok');
    assert.ok(body.data.students > 0, 'expected seeded student records');
  });

  it('returns a structured 404 for an unknown route', async () => {
    const { status, body } = await api('/api/v1/does-not-exist');
    assert.equal(status, 404);
    assert.equal(body.success, false);
    assert.equal(body.error?.code, 'NOT_FOUND');
  });
});

describe('authentication', () => {
  it('rejects a request with no token', async () => {
    const { status, body } = await api('/api/v1/students');
    assert.equal(status, 401);
    assert.equal(body.error?.code, 'UNAUTHORISED');
  });

  it('rejects a malformed token', async () => {
    const { status } = await api('/api/v1/students', { token: 'not-a-real-token' });
    assert.equal(status, 401);
  });

  it('rejects wrong credentials without revealing whether the user exists', async () => {
    const unknownUser = await api('/api/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ username: 'nobody-here', password: 'Whatever123' }),
    });
    const wrongPassword = await api('/api/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ username: 'admin', password: 'WrongPassword123' }),
    });

    assert.equal(unknownUser.status, 401);
    assert.equal(wrongPassword.status, 401);
    assert.equal(
      unknownUser.body.error?.message,
      wrongPassword.body.error?.message,
      'both failures must return an identical message',
    );
  });

  it('validates the login body', async () => {
    const { status, body } = await api('/api/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ username: 'ab' }),
    });
    assert.equal(status, 400);
    assert.equal(body.error?.code, 'BAD_REQUEST');
    assert.ok(Array.isArray(body.error?.details));
  });

  it('issues a token to the admin account', async () => {
    const { status, body } = await api<{ token: string; user: { role: string } }>(
      '/api/v1/auth/login',
      {
        method: 'POST',
        body: JSON.stringify({ username: 'admin', password: 'Password123!' }),
      },
    );

    assert.equal(status, 200);
    assert.equal(body.data.user.role, 'admin');
    assert.ok(body.data.token.split('.').length === 3, 'expected a JWT');
    adminToken = body.data.token;
  });

  it('issues a token to a student account and resolves its context', async () => {
    const login = await api<{ token: string; user: { studentId: number } }>(
      '/api/v1/auth/login',
      {
        method: 'POST',
        body: JSON.stringify({ username: '22128981', password: 'Password123!' }),
      },
    );

    assert.equal(login.status, 200);
    studentToken = login.body.data.token;
    studentId = login.body.data.user.studentId;
    assert.ok(studentId > 0);

    const me = await api<{ role: string; student: { student_number: string } }>(
      '/api/v1/auth/me',
      { token: studentToken },
    );
    assert.equal(me.status, 200);
    assert.equal(me.body.data.role, 'student');
    assert.equal(me.body.data.student.student_number, '22128981');
  });

  it('registers a new account and rejects a duplicate username', async () => {
    const payload = {
      username: THROWAWAY_USERNAME,
      email: 'test.account.cpen208@st.ug.edu.gh',
      password: 'TestPassword1',
      role: 'student' as const,
    };

    const first = await api<{ user_id: number }>('/api/v1/auth/register', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
    assert.equal(first.status, 201);
    assert.ok(first.body.data.user_id > 0);

    const second = await api('/api/v1/auth/register', {
      method: 'POST',
      body: JSON.stringify(payload),
    });
    assert.equal(second.status, 409, 'duplicate username must be a conflict');
  });

  it('refuses a weak password', async () => {
    const { status, body } = await api('/api/v1/auth/register', {
      method: 'POST',
      body: JSON.stringify({
        username: 'weak.password.user',
        email: 'weak@st.ug.edu.gh',
        password: 'short',
      }),
    });
    assert.equal(status, 400);
    assert.ok(JSON.stringify(body.error?.details).includes('8 characters'));
  });
});

describe('functionality 1 - student personal information', () => {
  it('lists students for staff', async () => {
    const { status, body } = await api<Array<{ student_number: string }>>(
      '/api/v1/students',
      { token: adminToken },
    );
    assert.equal(status, 200);
    assert.ok(Array.isArray(body.data));
    assert.ok(body.data.length >= 30, 'expected the seeded class');
  });

  it('refuses to list students for a student account', async () => {
    const { status, body } = await api('/api/v1/students', { token: studentToken });
    assert.equal(status, 403);
    assert.equal(body.error?.code, 'FORBIDDEN');
  });

  it('returns a full profile with personal, contact and academic sections', async () => {
    const { status, body } = await api<{
      student_number: string;
      personal: Record<string, unknown>;
      contact: Record<string, unknown>;
      academic: Record<string, unknown>;
      next_of_kin: unknown[];
    }>(`/api/v1/students/${studentId}`, { token: studentToken });

    assert.equal(status, 200);
    assert.equal(body.data.student_number, '22128981');
    assert.ok(body.data.personal.full_name);
    assert.ok(body.data.contact.email);
    assert.ok(body.data.academic.programme);
    assert.ok(Array.isArray(body.data.next_of_kin));
  });

  it("stops a student reading another student's record", async () => {
    const { status, body } = await api(`/api/v1/students/${studentId + 1}`, {
      token: studentToken,
    });
    assert.equal(status, 403);
    assert.equal(body.error?.code, 'FORBIDDEN');
  });

  it('404s for a student id that does not exist', async () => {
    const { status } = await api('/api/v1/students/999999', { token: adminToken });
    assert.equal(status, 404);
  });

  it('rejects a non-numeric student id', async () => {
    const { status } = await api('/api/v1/students/abc', { token: adminToken });
    assert.equal(status, 400);
  });
});

describe('functionality 2 - student fees payments', () => {
  it('returns outstanding fees as a JSON array, one object per student', async () => {
    const { status, body } = await api<
      Array<{
        student_number: string;
        total_billed: number;
        total_paid: number;
        outstanding_balance: number;
        payment_status: string;
        bills: unknown[];
      }>
    >('/api/v1/fees/outstanding', { token: adminToken });

    assert.equal(status, 200);
    assert.ok(Array.isArray(body.data), 'the payload must be an array');
    assert.ok(body.data.length > 0);
    assert.equal(body.meta?.source, 'finance.fn_outstanding_fees_json()');

    const first = body.data[0];
    for (const key of [
      'student_id',
      'student_number',
      'full_name',
      'total_billed',
      'total_paid',
      'outstanding_balance',
      'payment_status',
      'bills',
    ]) {
      assert.ok(key in first, `missing key ${key}`);
    }
  });

  it('computes outstanding = billed - paid for every row', async () => {
    const { body } = await api<
      Array<{ total_billed: number; total_paid: number; outstanding_balance: number }>
    >('/api/v1/fees/outstanding', { token: adminToken });

    for (const row of body.data) {
      const expected = Number(row.total_billed) - Number(row.total_paid);
      assert.equal(
        Number(row.outstanding_balance).toFixed(2),
        expected.toFixed(2),
        'outstanding balance must equal billed minus paid',
      );
    }
  });

  it('never reports a negative balance in the seeded data', async () => {
    const { body } = await api<Array<{ outstanding_balance: number }>>(
      '/api/v1/fees/outstanding',
      { token: adminToken },
    );
    const negatives = body.data.filter((r) => Number(r.outstanding_balance) < 0);
    assert.equal(negatives.length, 0, 'no student should be over-paid');
  });

  it('honours the indebtedOnly filter', async () => {
    const all = await api<unknown[]>('/api/v1/fees/outstanding', { token: adminToken });
    const owing = await api<Array<{ outstanding_balance: number }>>(
      '/api/v1/fees/outstanding?indebtedOnly=true',
      { token: adminToken },
    );

    assert.ok(owing.body.data.length <= all.body.data.length);
    for (const row of owing.body.data) {
      assert.ok(Number(row.outstanding_balance) > 0);
    }
  });

  it('keeps the outstanding-fees report away from students', async () => {
    const { status } = await api('/api/v1/fees/outstanding', { token: studentToken });
    assert.equal(status, 403);
  });

  it('returns a fee statement whose totals agree with the report', async () => {
    const statement = await api<{
      total_billed: number;
      total_paid: number;
      outstanding_balance: number;
      bills: unknown[];
      payments: unknown[];
    }>(`/api/v1/students/${studentId}/fees`, { token: studentToken });

    assert.equal(statement.status, 200);
    assert.ok(Array.isArray(statement.body.data.bills));
    assert.ok(Array.isArray(statement.body.data.payments));

    const balance = await api<{ outstandingBalance: number }>(
      `/api/v1/students/${studentId}/balance`,
      { token: studentToken },
    );

    assert.equal(
      Number(statement.body.data.outstanding_balance).toFixed(2),
      Number(balance.body.data.outstandingBalance).toFixed(2),
    );
  });

  it('excludes pending and reversed payments from the balance', async () => {
    // 22129027 has a pending cheque; the balance must still count it as owing.
    const rows = await query<{ student_id: string; billed: string; confirmed: string; all_money: string }>(
      `SELECT s.student_id::TEXT,
              b.total_amount::TEXT AS billed,
              COALESCE(SUM(p.amount) FILTER (WHERE p.status = 'confirmed'), 0)::TEXT AS confirmed,
              COALESCE(SUM(p.amount), 0)::TEXT AS all_money
       FROM   people.student s
       JOIN   finance.student_bill b ON b.student_id = s.student_id
       LEFT   JOIN finance.payment p ON p.bill_id = b.bill_id
       WHERE  s.student_number = '22129027'
       GROUP  BY s.student_id, b.total_amount`,
    );

    assert.equal(rows.length, 1);
    const row = rows[0];
    assert.notEqual(
      row.confirmed,
      row.all_money,
      'fixture expects a non-confirmed payment to exist',
    );

    const { body } = await api<{ outstandingBalance: number }>(
      `/api/v1/students/${row.student_id}/balance`,
      { token: adminToken },
    );

    assert.equal(
      Number(body.data.outstandingBalance).toFixed(2),
      (Number(row.billed) - Number(row.confirmed)).toFixed(2),
    );
  });

  it('returns a department fee summary', async () => {
    const { status, body } = await api<{
      total_billed: number;
      total_collected: number;
      total_outstanding: number;
      collection_rate_percent: number;
    }>('/api/v1/fees/summary', { token: adminToken });

    assert.equal(status, 200);
    assert.equal(
      Number(body.data.total_outstanding).toFixed(2),
      (Number(body.data.total_billed) - Number(body.data.total_collected)).toFixed(2),
    );
  });

  it('rejects a payment with a non-positive amount', async () => {
    const { status } = await api('/api/v1/fees/payments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({
        studentId,
        billId: 1,
        amount: -50,
        method: 'cash',
      }),
    });
    assert.equal(status, 400);
  });

  it('rejects an unknown payment method', async () => {
    const { status } = await api('/api/v1/fees/payments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({
        studentId,
        billId: 1,
        amount: 100,
        method: 'bitcoin',
      }),
    });
    assert.equal(status, 400);
  });
});

describe('functionality 3 - course enrollment', () => {
  it('lists course offerings with seat availability', async () => {
    const { status, body } = await api<
      Array<{ course_code: string; capacity: number; enrolled_count: number; seats_left: number }>
    >('/api/v1/enrollments/offerings', { token: studentToken });

    assert.equal(status, 200);
    assert.ok(body.data.length > 0);
    for (const o of body.data) {
      assert.equal(
        Number(o.seats_left),
        Number(o.capacity) - Number(o.enrolled_count),
        'seats_left must equal capacity minus enrolled',
      );
    }
  });

  it("returns a student's registered courses", async () => {
    const { status, body } = await api<Array<{ course_code: string; status: string }>>(
      `/api/v1/students/${studentId}/enrollments`,
      { token: studentToken },
    );

    assert.equal(status, 200);
    assert.ok(body.data.length > 0);
    assert.ok(
      body.data.some((e) => e.course_code === 'CPEN 208'),
      'the sample class is registered for CPEN 208',
    );
  });

  it('returns a class list for staff', async () => {
    const offerings = await api<Array<{ offering_id: number; course_code: string }>>(
      '/api/v1/enrollments/offerings',
      { token: adminToken },
    );
    const cpen208 = offerings.body.data.find((o) => o.course_code === 'CPEN 208');
    assert.ok(cpen208, 'CPEN 208 offering must exist');

    const { status, body } = await api<{
      course_code: string;
      students: unknown[];
      enrolled_count: number;
    }>(`/api/v1/enrollments/offerings/${cpen208.offering_id}/class-list`, {
      token: adminToken,
    });

    assert.equal(status, 200);
    assert.equal(body.data.course_code, 'CPEN 208');
    assert.equal(body.data.students.length, Number(body.data.enrolled_count));
  });

  it('refuses a duplicate registration', async () => {
    const enrolments = await api<Array<{ offering_id: number }>>(
      `/api/v1/students/${studentId}/enrollments`,
      { token: studentToken },
    );
    const existing = enrolments.body.data[0];

    const { status, body } = await api('/api/v1/enrollments', {
      method: 'POST',
      token: studentToken,
      body: JSON.stringify({ studentId, offeringId: existing.offering_id }),
    });

    assert.equal(status, 409);
    assert.equal(body.error?.code, 'CONFLICT');
  });

  it('stops a student registering somebody else', async () => {
    const { status } = await api('/api/v1/enrollments', {
      method: 'POST',
      token: studentToken,
      body: JSON.stringify({ studentId: studentId + 1, offeringId: 1 }),
    });
    assert.equal(status, 403);
  });

  it('rejects an unknown field in the body', async () => {
    const { status } = await api('/api/v1/enrollments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({ studentId, offeringId: 1, sneaky: 'value' }),
    });
    assert.equal(status, 400, 'schemas are strict, so extra keys are rejected');
  });
});

describe('functionality 4 - lecturer to course assignment', () => {
  it('lists lecturers', async () => {
    const { status, body } = await api<Array<{ staff_number: string }>>(
      '/api/v1/teaching/lecturers',
      { token: adminToken },
    );
    assert.equal(status, 200);
    assert.ok(body.data.length >= 5);
  });

  it('lists lecturer-course allocations', async () => {
    const { status, body } = await api<
      Array<{ course_code: string; teaching_role: string; lecturer_name: string }>
    >('/api/v1/teaching/assignments', { token: adminToken });

    assert.equal(status, 200);
    assert.ok(
      body.data.some(
        (a) => a.course_code === 'CPEN 208' && a.teaching_role === 'lead_lecturer',
      ),
      'CPEN 208 must have a lead lecturer',
    );
  });

  it('returns a lecturer workload including nested TAs', async () => {
    const lecturers = await api<Array<{ lecturer_id: number; staff_number: string }>>(
      '/api/v1/teaching/lecturers',
      { token: adminToken },
    );
    const danquah = lecturers.body.data.find((l) => l.staff_number === 'CPEN/2015/041');
    assert.ok(danquah);

    const { status, body } = await api<{
      total_courses: number;
      courses: Array<{ course_code: string; teaching_assistants: unknown[] }>;
    }>(`/api/v1/teaching/lecturers/${danquah.lecturer_id}/workload`, {
      token: adminToken,
    });

    assert.equal(status, 200);
    assert.ok(body.data.total_courses > 0);

    const cpen208 = body.data.courses.find((c) => c.course_code === 'CPEN 208');
    assert.ok(cpen208, 'the CPEN 208 lecturer must teach CPEN 208');
    assert.ok(
      cpen208.teaching_assistants.length >= 2,
      'CPEN 208 has two teaching assistants in the sample data',
    );
  });

  it('refuses to give an offering a second lead lecturer', async () => {
    const lecturers = await api<Array<{ lecturer_id: number; staff_number: string }>>(
      '/api/v1/teaching/lecturers',
      { token: adminToken },
    );
    const other = lecturers.body.data.find((l) => l.staff_number === 'CPEN/2021/104');
    const offerings = await api<Array<{ offering_id: number; course_code: string }>>(
      '/api/v1/enrollments/offerings',
      { token: adminToken },
    );
    const cpen208 = offerings.body.data.find((o) => o.course_code === 'CPEN 208');
    assert.ok(other && cpen208);

    const { status } = await api('/api/v1/teaching/assignments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({
        lecturerId: other.lecturer_id,
        offeringId: cpen208.offering_id,
        role: 'lead_lecturer',
      }),
    });

    assert.equal(status, 409, 'only one lead lecturer per offering is allowed');
  });

  it('only lets an admin create teaching assignments', async () => {
    const { status } = await api('/api/v1/teaching/assignments', {
      method: 'POST',
      token: studentToken,
      body: JSON.stringify({ lecturerId: 1, offeringId: 1, role: 'co_lecturer' }),
    });
    assert.equal(status, 403);
  });
});

describe('functionality 5 - lecturer to TA assignment', () => {
  it('lists teaching assistants with their committed hours', async () => {
    const { status, body } = await api<
      Array<{ ta_code: string; max_weekly_hours: number; committed_hours: string }>
    >('/api/v1/teaching/assistants', { token: adminToken });

    assert.equal(status, 200);
    assert.ok(body.data.length >= 4);

    for (const ta of body.data) {
      assert.ok(
        Number(ta.committed_hours) <= Number(ta.max_weekly_hours),
        `${ta.ta_code} is committed beyond its contracted hours`,
      );
    }
  });

  it('lists lecturer-TA assignments', async () => {
    const { status, body } = await api<
      Array<{ lecturer: string; ta_name: string; course_code: string; weekly_hours: number }>
    >('/api/v1/teaching/ta-assignments', { token: adminToken });

    assert.equal(status, 200);
    assert.ok(body.data.length > 0);
    assert.ok(body.data.some((a) => a.course_code === 'CPEN 208'));
  });

  it('refuses an assignment that would exceed the TA weekly hour cap', async () => {
    const tas = await api<Array<{ ta_id: number; ta_code: string }>>(
      '/api/v1/teaching/assistants',
      { token: adminToken },
    );
    const lecturers = await api<Array<{ lecturer_id: number; staff_number: string }>>(
      '/api/v1/teaching/lecturers',
      { token: adminToken },
    );
    const semesters = await api<Array<{ semester_id: number; is_current: boolean }>>(
      '/api/v1/reference/semesters',
      { token: adminToken },
    );

    const ta = tas.body.data.find((t) => t.ta_code === 'TA/2025/003');
    const lecturer = lecturers.body.data.find((l) => l.staff_number === 'CPEN/2019/083');
    const semester = semesters.body.data.find((s) => s.is_current);
    assert.ok(ta && lecturer && semester);

    const { status, body } = await api('/api/v1/teaching/ta-assignments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({
        lecturerId: lecturer.lecturer_id,
        taId: ta.ta_id,
        semesterId: semester.semester_id,
        weeklyHours: 40, // TA/2025/003 is contracted for 12
      }),
    });

    assert.equal(status, 422, 'the database hour cap must reject this');
    assert.ok(/maximum/i.test(body.error?.message ?? ''));
  });

  it('rejects weeklyHours outside the accepted range', async () => {
    const { status } = await api('/api/v1/teaching/ta-assignments', {
      method: 'POST',
      token: adminToken,
      body: JSON.stringify({
        lecturerId: 1,
        taId: 1,
        semesterId: 1,
        weeklyHours: 500,
      }),
    });
    assert.equal(status, 400);
  });
});

describe('reference data', () => {
  it('lists programmes and semesters', async () => {
    const programmes = await api<unknown[]>('/api/v1/reference/programmes', {
      token: studentToken,
    });
    const semesters = await api<Array<{ is_current: boolean }>>(
      '/api/v1/reference/semesters',
      { token: studentToken },
    );

    assert.equal(programmes.status, 200);
    assert.ok(programmes.body.data.length > 0);
    assert.ok(semesters.body.data.some((s) => s.is_current));
  });
});
