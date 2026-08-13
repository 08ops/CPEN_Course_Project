# Project 1 — Relational Database + Next.js 14 Application

CPEN 208 · First Semester 2025/2026 · Gideon Elorm Glago (22128981)

---

## Question 1 — the database

### Build it

```bash
cd database && ./run_all.sh
```

Requires PostgreSQL 14+ and a role that may `CREATE DATABASE`. Override the
connection with standard libpq variables if needed:

```bash
PGHOST=localhost PGPORT=5432 PGUSER=postgres ./run_all.sh
```

### What each script does

| File | Purpose |
|---|---|
| `00_create_database.sql` | Drops and creates the `cpen208_ceds` database |
| `01_schemas.sql` | 5 schemas, 14 ENUM types, 3 domains, the `updated_at` trigger function |
| `02_tables.sql` | 23 tables with primary keys, foreign keys and CHECK constraints |
| `03_indexes_triggers.sql` | 40 secondary indexes; triggers for bill totals, bill status and enrolment validation |
| `04_functions.sql` | 19 stored functions, including the required outstanding-fees function |
| `05_views.sql` | 6 reporting views, one per functionality |
| `06_seed_data.sql` | Insert scripts populating every table with the CPEN 208 class |
| `07_verification.sql` | Evidence that each requirement in the brief is satisfied |

### The required function

```sql
SELECT finance.fn_outstanding_fees_json();                 -- every student
SELECT finance.fn_outstanding_fees_json(NULL, NULL, TRUE); -- only those owing
```

Signature:

```sql
finance.fn_outstanding_fees_json(
    p_academic_year_id INTEGER DEFAULT NULL,
    p_programme_id     INTEGER DEFAULT NULL,
    p_only_indebted    BOOLEAN DEFAULT FALSE
) RETURNS json
```

`outstanding = total billed − confirmed payments`. Payments with status
`pending`, `reversed` or `failed` are deliberately excluded; the sample data
contains one of each so the exclusion is demonstrable.

### Verify it

```bash
psql -d cpen208_ceds -f 07_verification.sql
```

Section 7d cross-checks the function against the same figures computed with
plain SQL and reports the number of mismatches. The captured output is in
[`docs/verification_output.txt`](docs/verification_output.txt) — 36 students
compared, **0 mismatches**.

### Schemas

| Schema | Holds | Functionality |
|---|---|---|
| `core` | departments, programmes, academic years, semesters | reference data |
| `people` | person, student, next_of_kin, lecturer, teaching_assistant | 1 |
| `academics` | course, course_offering, enrollment, lecturer_course_assignment, lecturer_ta_assignment | 3, 4, 5 |
| `finance` | fee_structure, fee_item, student_bill, bill_line, payment | 2 |
| `app` | app_user, user_session, audit_log | web app + API |

### Backup

[`database/backup/`](database/backup) contains four `pg_dump` outputs:

| File | Restore with |
|---|---|
| `cpen208_ceds_backup.sql` | `psql -d newdb -f cpen208_ceds_backup.sql` |
| `cpen208_ceds_backup.dump` | `pg_restore -d newdb --no-owner cpen208_ceds_backup.dump` |
| `cpen208_ceds_schema_only.sql` | structure without data |
| `cpen208_ceds_data_only.sql` | data without structure |

The plain-SQL backup was restored into a scratch database and re-tested as part
of preparing this submission.

---

## Question 2 — the Next.js 14 application

```bash
cd web
cp .env.example .env.local     # then edit DATABASE_URL
npm install
npm run dev                    # http://localhost:3000
```

See [`web/README.md`](web/README.md) for the full description.

Pages: `/login`, `/register`, `/dashboard` (+ profile, fees, courses, catalogue,
students, teaching, outstanding-fees).

---

## Report

[`docs/CPEN208_Project1_Report_22128981.pdf`](docs)
