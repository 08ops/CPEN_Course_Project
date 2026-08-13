# Project 2 — REST API / Web Service

CPEN 208 · First Semester 2025/2026 · Gideon Elorm Glago (22128981)

> *"Develop an API/web service that implements the functions you created in Project 1."*

---

## Contents

| Path | Deliverable |
|---|---|
| [`api/`](api) | Source code of the web service (Express + TypeScript) |
| [`database/`](database) | All scripts used to create the database |
| [`database/backup/`](database/backup) | Database backup, four formats |
| [`docs/`](docs) | Report (PDF) and a live transcript of the API answering requests |

`database/` is a copy of `../project-1/database/` so this project is
self-contained, as the brief requires. It is the **same** database — build it
once and both projects use it.

---

## Run it

```bash
# 1. build the database (skip if Project 1 already did this)
cd database && ./run_all.sh

# 2. start the service
cd ../api
cp .env.example .env      # then set DATABASE_URL and JWT_SECRET
npm install
npm run dev               # http://localhost:4000
```

```bash
# 3. run the test suite (43 integration tests against the live database)
npm test
```

Open <http://localhost:4000/api/v1> for a self-describing index of every endpoint.

---

## The point of this service

Project 1 put the business rules in the **database**, as stored functions.
Project 2 does not re-implement any of them. Every endpoint is a thin, validated,
authorised wrapper around one of those functions:

| Endpoint | Database function |
|---|---|
| `GET /api/v1/fees/outstanding` | `finance.fn_outstanding_fees_json()` |
| `GET /api/v1/students/:id` | `people.fn_student_profile_json()` |
| `GET /api/v1/students/:id/fees` | `finance.fn_student_fee_statement_json()` |
| `POST /api/v1/fees/payments` | `finance.fn_record_payment()` |
| `POST /api/v1/enrollments` | `academics.fn_enroll_student()` |
| `POST /api/v1/teaching/assignments` | `academics.fn_assign_lecturer_to_course()` |
| `POST /api/v1/teaching/ta-assignments` | `academics.fn_assign_ta_to_lecturer()` |

Consequence: a rule such as *"a teaching assistant may not exceed their
contracted weekly hours"* is written **once**, in SQL, and is enforced
identically whether the caller is `psql`, the Next.js dashboard, or an HTTP
client. The API's job is transport, validation, authentication and error
translation — not arithmetic.

---

## Quick demonstration

```bash
# obtain a token
TOKEN=$(curl -s -X POST http://localhost:4000/api/v1/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"username":"admin","password":"Password123!"}' | jq -r .data.token)

# the required deliverable, over HTTP
curl -s http://localhost:4000/api/v1/fees/outstanding \
  -H "Authorization: Bearer $TOKEN" | jq '.data | length, .[0]'
```

A captured transcript of exactly this — including the authorisation and
validation failures — is in
[`docs/api_demo_output.txt`](docs/api_demo_output.txt).

---

## Report

[`docs/CPEN208_Project2_Report_22128981.pdf`](docs)
