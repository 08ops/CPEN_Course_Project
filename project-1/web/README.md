# CEDS Web Application — Next.js 14

Project 1, Question 2: *"develop a nextjs 14 application with login, register, dashboard."*

---

## Run it

```bash
cp .env.example .env.local     # then set DATABASE_URL
npm install
npm run dev                    # http://localhost:3000
```

Production build:

```bash
npm run build && npm start
```

The database must already exist — build it first with `../database/run_all.sh`.

### Demonstration accounts

Every seeded account uses the password **`Password123!`**.

| Username | Role | Sees |
|---|---|---|
| `22128981` | Student | own profile, fees, courses |
| `22129014` | Student | a resident student with a part-paid bill |
| `kadanquah` | Lecturer | teaching load, TAs, student register, fees report |
| `admin` | Administrator | everything |

---

## Stack

| Concern | Choice | Why |
|---|---|---|
| Framework | Next.js **14.2** (App Router) | required by the brief |
| Language | TypeScript (strict) | catches shape errors against the DB at compile time |
| Styling | Tailwind CSS 3 | small component layer in `globals.css`, no UI dependency |
| Database | `pg` connection pool | direct, no ORM — the SQL already lives in the database |
| Passwords | `bcryptjs`, cost 10 | plain passwords never reach the database or a log |
| Sessions | opaque token, SHA-256 hashed in `app.user_session` | revocable, and a stolen dump cannot be replayed |
| Validation | `zod` | one schema validates on the client and the server |

---

## Routes

| Route | Access | Purpose |
|---|---|---|
| `/login` | public | sign in with username, index number or e-mail |
| `/register` | public | create an account, optionally linked to a student record |
| `/dashboard` | any signed-in user | role-aware overview |
| `/dashboard/profile` | student | **Functionality 1** — personal information |
| `/dashboard/fees` | student | **Functionality 2** — bills, line items, payment history |
| `/dashboard/courses` | student | **Functionality 3** — registered courses |
| `/dashboard/catalogue` | any | course offerings with live seat counts |
| `/dashboard/students` | staff | **Functionality 1** — the student register |
| `/dashboard/teaching` | staff | **Functionalities 4 & 5** — teaching and TA allocation |
| `/dashboard/outstanding-fees` | staff | **the required function**, rendered as a report |
| `/api/outstanding-fees` | staff | the same data as raw JSON |
| `/api/health` | public | liveness + database connectivity |

---

## How authentication works

1. **Register** — `registerAction` validates with zod, hashes the password with
   bcrypt, then calls `app.fn_register_user(...)`. Supplying an index number
   links the new login to the existing `people.person` row, so the user
   immediately sees their real fees and courses.
2. **Login** — `login()` fetches the user by username **or** e-mail, compares the
   bcrypt hash, and on success writes a session row and sets an `httpOnly`
   cookie. Five consecutive failures lock the account for 15 minutes.
3. **Session** — the browser holds a 32-byte random token; the database stores
   only its SHA-256 hash. Sessions expire after 7 days and can be revoked.
4. **Protection** — `src/middleware.ts` runs on the Edge and only checks that a
   cookie is *present*. The authoritative check is `getCurrentUser()` in
   `src/app/dashboard/layout.tsx`, which validates the token against
   `app.user_session`. A forged cookie therefore gets a redirect, not access.

Unknown username and wrong password return the identical message, so the login
form cannot be used to discover which accounts exist.

---

## Source layout

```
src/
├── middleware.ts              Edge gate for /dashboard, /login, /register
├── lib/
│   ├── constants.ts           values shared with the Edge runtime
│   ├── db.ts                  pooled pg client + json helpers
│   ├── auth.ts                login, register, sessions, audit
│   ├── queries.ts             one wrapper per database function
│   ├── validation.ts          zod schemas
│   ├── formState.ts           server-action return type
│   ├── format.ts              currency, date and label helpers
│   └── types.ts               shapes returned by the database functions
├── components/                Logo, AuthShell, DashboardNav, StatCard, …
└── app/
    ├── actions.ts             'use server' — loginAction, registerAction, logoutAction
    ├── login/  register/      auth screens
    ├── dashboard/             the eight dashboard pages
    └── api/                   route handlers
```

Every dashboard read calls a stored function from `04_functions.sql` through
`src/lib/queries.ts`. No fee arithmetic, capacity check or hour cap is
reimplemented in TypeScript.

---

## Notes

- `.env.local` is git-ignored; `.env.example` documents the variables.
- All dashboard pages set `dynamic = 'force-dynamic'` because they read the
  session cookie and per-user data.
- The session cookie sets `secure` in production. Browsers treat `http://localhost`
  as a secure context, so a local production build still works over plain HTTP.
- `src/lib/formState.ts` exists because a file marked `'use server'` may only
  export async functions — the shared state type cannot live in `actions.ts`.
