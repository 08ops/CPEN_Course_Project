-- =============================================================================
-- CPEN 208 : Introduction to Software Engineering  |  First Semester 2025/2026
-- Project 1 - Task 1 : Relational Database for the Computer Engineering Dept.
-- -----------------------------------------------------------------------------
-- File    : 00_create_database.sql
-- Purpose : Create the database cluster object that hosts the whole system.
-- Run as  : a role with CREATEDB privilege, connected to the `postgres` database
-- Usage   : psql -d postgres -f 00_create_database.sql
-- =============================================================================

-- Drop any previous instance so the script is safely re-runnable.
-- (Terminate other sessions first, otherwise DROP DATABASE fails.)
SELECT pg_terminate_backend(pid)
FROM   pg_stat_activity
WHERE  datname = 'cpen208_ceds'
  AND  pid <> pg_backend_pid();

DROP DATABASE IF EXISTS cpen208_ceds;

-- -----------------------------------------------------------------------------
-- CEDS = Computer Engineering Department System
-- UTF8 + a deterministic collation keeps ordering stable across machines.
-- -----------------------------------------------------------------------------
CREATE DATABASE cpen208_ceds
    WITH ENCODING     = 'UTF8'
         LC_COLLATE   = 'C'
         LC_CTYPE     = 'C'
         TEMPLATE     = template0
         CONNECTION LIMIT = -1;

COMMENT ON DATABASE cpen208_ceds IS
    'Computer Engineering Department System (CEDS) - CPEN 208 Project 1. '
    'Holds student personal information, fees & payments, course enrolment, '
    'lecturer-to-course assignment and lecturer-to-TA assignment.';
