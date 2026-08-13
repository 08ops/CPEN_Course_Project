#!/usr/bin/env bash
# =============================================================================
# run_all.sh - build the CPEN 208 database from nothing, in order.
#
#   ./run_all.sh              # create + seed + verify
#   ./run_all.sh --no-verify  # create + seed only
#
# Requires: PostgreSQL 14 or later on the PATH and a role that can CREATE DATABASE.
# Override the connection with the standard libpq variables, e.g.
#   PGHOST=localhost PGPORT=5432 PGUSER=postgres ./run_all.sh
# =============================================================================
set -euo pipefail

DB_NAME="${DB_NAME:-cpen208_ceds}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Homebrew keg-only PostgreSQL is not on the default PATH on macOS.
if ! command -v psql >/dev/null 2>&1; then
    for candidate in /opt/homebrew/opt/postgresql@16/bin /usr/local/opt/postgresql@16/bin; do
        [ -d "$candidate" ] && export PATH="$candidate:$PATH"
    done
fi

command -v psql >/dev/null 2>&1 || { echo "ERROR: psql not found on PATH." >&2; exit 1; }

echo "==> PostgreSQL: $(psql --version)"
echo "==> Target database: ${DB_NAME}"
echo

run() {
    echo "----------------------------------------------------------------"
    echo "==> $2"
    echo "----------------------------------------------------------------"
    psql --set=ON_ERROR_STOP=1 -q -d "$1" -f "$HERE/$2"
    echo
}

# Step 0 runs against the maintenance database because it drops/creates ours.
run postgres    00_create_database.sql
run "$DB_NAME"  01_schemas.sql
run "$DB_NAME"  02_tables.sql
run "$DB_NAME"  03_indexes_triggers.sql
run "$DB_NAME"  04_functions.sql
run "$DB_NAME"  05_views.sql
run "$DB_NAME"  06_seed_data.sql

if [ "${1:-}" != "--no-verify" ]; then
    run "$DB_NAME" 07_verification.sql
fi

echo "================================================================"
echo "Database '${DB_NAME}' built successfully."
echo "Connect with:  psql -d ${DB_NAME}"
echo "Key function:  SELECT finance.fn_outstanding_fees_json();"
echo "================================================================"
