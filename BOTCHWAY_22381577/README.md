# CPEN 208 — Introduction to Software Engineering · Projects 1 & 2

**University of Ghana · College of Basic and Applied Sciences · School of Engineering Sciences**
**Department of Computer Engineering · First Semester 2025/2026**

Author: **Gideon Elorm Glago** (22128981)

---

## What this repository contains

A single system — the **Computer Engineering Department System (CEDS)** — delivered in
two parts, as set out in the two project briefs.

| Brief | Deliverable | Location |
|---|---|---|
| Project 1, Q1 | PostgreSQL relational database: schemas, tables, insert scripts, and a function returning outstanding fees as a JSON array | [`project-1/database/`](project-1/database) |
| Project 1, Q2 | Next.js 14 application with login, register and dashboard | [`project-1/web/`](project-1/web) |
| Project 1 | Database backup | [`project-1/database/backup/`](project-1/database/backup) |
| Project 1 | Report (PDF) | [`project-1/docs/`](project-1/docs) |
| Project 2 | REST API / web service implementing the Project 1 functions | [`project-2/api/`](project-2/api) |
| Project 2 | Database scripts + backup (same database) | [`project-2/database/`](project-2/database) |
| Project 2 | Report (PDF) | [`project-2/docs/`](project-2/docs) |

The five functionalities required by the brief are implemented end to end:

1. **Student personal information**
2. **Student fees payments**
3. **Course enrollment**
4. **Lecturers to course assignment**
5. **Lecturers to TA assignment**

---

## The required database function

> *"Create a database function that will calculate the outstanding fees for each student
> in your database and return the output in json array."*

```sql
SELECT finance.fn_outstanding_fees_json();
```

Returns a JSON **array**, one object per student:

```json
[
  {
    "student_id": 36,
    "student_number": "22128981",
    "full_name": "Gideon Elorm Glago",
    "programme": "BSc Computer Engineering",
    "level": 200,
    "currency": "GHS",
    "total_billed": 4470.00,
    "total_paid": 3200.00,
    "outstanding_balance": 1270.00,
    "percentage_paid": 71.59,
    "payment_status": "PART PAID",
    "last_payment_date": "2025-11-18",
    "bill_count": 1,
    "bills": [ { "bill_reference": "BILL-20252026-00036", "balance": 1270.00, "...": "..." } ]
  }
]
```

It is reached three ways, all backed by that one function:

- **SQL** — `SELECT finance.fn_outstanding_fees_json();`
- **Web app** — Dashboard → *Outstanding fees* (staff accounts)
- **REST API** — `GET /api/v1/fees/outstanding`

---

## Quick start

### Prerequisites

- PostgreSQL 14 or later (developed on 16.13)
- Node.js 18 or later (developed on 24.15)

### 1. Build the database

```bash
cd project-1/database && ./run_all.sh
```

This drops and recreates `cpen208_ceds`, creates the five schemas, all tables,
indexes, triggers, functions and views, loads the sample data, and prints a
verification report proving the outstanding-fees function is correct.

### 2. Run the Next.js 14 application (Project 1, Q2)

```bash
cd project-1/web && cp .env.example .env.local && npm install && npm run dev
```

Open <http://localhost:3000>. Demonstration accounts (all use `Password123!`):

| Username | Role |
|---|---|
| `22128981` | Student |
| `kadanquah` | Lecturer |
| `admin` | Administrator |

### 3. Run the REST API (Project 2)

```bash
cd project-2/api && cp .env.example .env && npm install && npm run dev
```

Open <http://localhost:4000/api/v1> for a self-describing index of every endpoint.

```bash
cd project-2/api && npm test
```

Runs 43 integration tests against the live database.

> Edit `.env.local` / `.env` so `DATABASE_URL` matches your PostgreSQL user
> before starting either application.

---

## Repository layout

```
ops/
├── README.md                      ← you are here
├── project-1/
│   ├── database/
│   │   ├── 00_create_database.sql     database creation
│   │   ├── 01_schemas.sql             schemas, enums, domains
│   │   ├── 02_tables.sql              all tables + constraints
│   │   ├── 03_indexes_triggers.sql    indexes, triggers, business rules
│   │   ├── 04_functions.sql           stored functions  ← required deliverable
│   │   ├── 05_views.sql               reporting views
│   │   ├── 06_seed_data.sql           insert scripts (the CPEN 208 class)
│   │   ├── 07_verification.sql        proof that every requirement is met
│   │   ├── run_all.sh                 one-command build
│   │   └── backup/                    pg_dump backups (4 formats)
│   ├── web/                           Next.js 14 app (login/register/dashboard)
│   └── docs/                          report + verification output
└── project-2/
    ├── api/                           Express + TypeScript REST service
    ├── database/                      same scripts and backup (self-contained)
    └── docs/                          report + live API transcript
```

---

## Submission checklist

Both briefs ask for the same four things per project. All are present:

| Required | Project 1 | Project 2 |
|---|---|---|
| Source code | [`project-1/web/`](project-1/web) (Next.js 14) | [`project-2/api/`](project-2/api) (REST service) |
| All scripts used to create the database | [`project-1/database/`](project-1/database) | [`project-2/database/`](project-2/database) |
| A backup of the database | [`project-1/database/backup/`](project-1/database/backup) | [`project-2/database/backup/`](project-2/database/backup) |
| A report (PDF) | [`project-1/docs/`](project-1/docs) | [`project-2/docs/`](project-2/docs) |

### Pushing to GitHub

This folder is already a git repository with the work committed. To publish it:

```bash
gh repo create cpen208-projects --private --source=. --remote=origin --push
```

Or, without the `gh` CLI — create an empty repository on github.com first, then:

```bash
git remote add origin https://github.com/<your-username>/cpen208-projects.git && git branch -M main && git push -u origin main
```

Then share the repository URL as the brief requires.

---

## Design in one paragraph

All business logic lives in the **database**, as PostgreSQL stored functions. The
Next.js application and the REST API are both thin clients over that one set of
functions — neither re-implements "what is outstanding", "is this class full", or
"is this teaching assistant over their contracted hours". That is why the two
applications can never disagree with each other, and it is what makes Project 2
genuinely *"an API that implements the functions created in Project 1"* rather
than a second, parallel implementation.

Full reasoning, the entity-relationship design, assumptions and test evidence are
in the two reports:

- [`project-1/docs/CPEN208_Project1_Report_22128981.pdf`](project-1/docs)
- [`project-2/docs/CPEN208_Project2_Report_22128981.pdf`](project-2/docs)
