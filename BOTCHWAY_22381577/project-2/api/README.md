# CEDS REST API

Express + TypeScript web service over the Computer Engineering Department System
database. CPEN 208 Project 2.

---

## Run

```bash
cp .env.example .env      # set DATABASE_URL and JWT_SECRET
npm install
npm run dev               # tsx watch, http://localhost:4000
```

| Script | Does |
|---|---|
| `npm run dev` | development server with reload |
| `npm run build` | compile TypeScript to `dist/` |
| `npm start` | run the compiled build |
| `npm run typecheck` | type-check without emitting |
| `npm test` | 43 integration tests against the live database |

The service **refuses to start** if the database is unreachable — a service that
starts and then 500s on every request is worse than one that fails loudly.
In production `JWT_SECRET` is mandatory.

---

## Conventions

**Base path** `/api/v1` — versioned from day one so a future v2 can coexist.

**Every success** shares one envelope:

```json
{ "success": true, "data": ..., "meta": { "count": 36, "timestamp": "..." } }
```

**Every failure** shares another:

```json
{
  "success": false,
  "error": { "code": "CHECK_VIOLATION", "message": "..." },
  "meta": { "path": "/api/v1/...", "method": "POST", "timestamp": "..." }
}
```

**Authentication** — `POST /api/v1/auth/login` returns a JWT; send it as
`Authorization: Bearer <token>`.

---

## Endpoints

`GET /api/v1` returns this list at runtime.

### Metadata
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1` | none |
| GET | `/api/v1/health` | none |
| GET | `/api/v1/stats` | staff |

### Authentication
| Method | Path | Auth |
|---|---|---|
| POST | `/api/v1/auth/register` | none |
| POST | `/api/v1/auth/login` | none |
| GET | `/api/v1/auth/me` | any |

### Functionality 1 — student personal information
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/students` | staff |
| GET | `/api/v1/students/:studentId` | self or staff |

### Functionality 2 — student fees payments
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/fees/outstanding` | staff — **required deliverable** |
| GET | `/api/v1/fees/summary` | staff |
| GET | `/api/v1/students/:studentId/fees` | self or staff |
| GET | `/api/v1/students/:studentId/balance` | self or staff |
| POST | `/api/v1/fees/bills` | admin |
| POST | `/api/v1/fees/payments` | admin |

### Functionality 3 — course enrollment
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/enrollments/offerings` | any |
| GET | `/api/v1/enrollments/offerings/:offeringId/class-list` | staff |
| GET | `/api/v1/students/:studentId/enrollments` | self or staff |
| POST | `/api/v1/enrollments` | self or admin |
| DELETE | `/api/v1/enrollments` | self or admin |

### Functionality 4 — lecturer to course assignment
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/teaching/lecturers` | any |
| GET | `/api/v1/teaching/assignments` | any |
| GET | `/api/v1/teaching/lecturers/:lecturerId/workload` | any |
| POST | `/api/v1/teaching/assignments` | admin |

### Functionality 5 — lecturer to TA assignment
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/teaching/assistants` | any |
| GET | `/api/v1/teaching/ta-assignments` | any |
| POST | `/api/v1/teaching/ta-assignments` | admin, or the lecturer themselves |

### Reference
| Method | Path | Auth |
|---|---|---|
| GET | `/api/v1/reference/programmes` | any |
| GET | `/api/v1/reference/semesters` | any |

---

## Error translation

The stored functions raise domain errors with meaningful SQLSTATE codes.
`src/errors.ts` maps them to HTTP so a rule written once in SQL still produces
the right status code:

| SQLSTATE | Meaning | HTTP |
|---|---|---|
| `P0002` | `no_data_found` | 404 |
| `23505` | `unique_violation` | 409 |
| `23503` | foreign key violation | 409 |
| `23514` | `check_violation` | 422 |
| `22P02` | invalid input syntax | 400 |
| `08006`, `57P01` | connection failure | 503 |

Anything unmapped becomes a 500 with a generic message — internal detail is
never leaked. Stack traces appear only when `NODE_ENV` is not `production`.

---

## Security

| Control | Implementation |
|---|---|
| Transport headers | `helmet` with a strict CSP |
| CORS | explicit allow-list via `CORS_ORIGINS` |
| Rate limiting | 300 req / 15 min globally; **20** on `/auth/*` |
| Body size | capped at 100 kB |
| SQL injection | every value is a bound parameter; nothing is interpolated |
| Passwords | bcrypt cost 10, compared in constant time by the library |
| Account enumeration | unknown user and wrong password return identical responses |
| Authorisation | `requireRole` and `requireSelfOrStaff` guard every non-public route |
| Input validation | strict zod schemas — unknown keys are rejected, not ignored |

---

## Source layout

```
src/
├── index.ts              startup, DB pre-flight check, graceful shutdown
├── app.ts                Express assembly (exported so tests can boot it)
├── config.ts             all environment reading happens here
├── db.ts                 pooled pg client + callJson helper
├── errors.ts             ApiError + SQLSTATE→HTTP mapping
├── respond.ts            the success envelope
├── schemas.ts            zod request schemas
├── middleware/
│   ├── auth.ts           JWT sign/verify, requireRole, requireSelfOrStaff
│   ├── validate.ts       schema validation + coercion
│   └── errorHandler.ts   404 handler, central error handler, asyncHandler
├── routes/               one router per functionality
└── services/             one typed wrapper per database function
tests/
└── api.test.ts           43 integration tests
```

---

## Tests

```bash
npm test
```

Integration tests, not mocked unit tests: they boot the real app against the
real database, because the whole claim of this service is that it faithfully
exposes the Project 1 functions — only a real database can prove that.

They cover the success path, authentication, authorisation (students cannot read
the staff report or other students' records), validation, and — importantly —
that the database's own rules still bite through HTTP: duplicate registration
gives 409, a second lead lecturer gives 409, and over-committing a teaching
assistant gives 422.

The suite also re-derives `outstanding = billed − paid` for every row returned by
the outstanding-fees endpoint, so a regression in the SQL would fail the build.
