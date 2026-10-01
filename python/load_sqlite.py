import sqlite3
import pandas as pd
from pathlib import Path


# ============================================================
# CONFIGURATION
# ============================================================

PROJECT_ROOT = Path(__file__).resolve().parent.parent

DATA_DIR = PROJECT_ROOT / "data"

DATABASE_PATH = PROJECT_ROOT / "banking.db"


# ============================================================
# 1. LOAD CSV FILES
# ============================================================

print("=" * 65)
print("LOADING CSV FILES INTO SQLITE")
print("=" * 65)

print("\nReading CSV files...")

branches = pd.read_csv(
    DATA_DIR / "branches.csv"
)

customers = pd.read_csv(
    DATA_DIR / "customers.csv"
)

accounts = pd.read_csv(
    DATA_DIR / "accounts.csv"
)

transactions = pd.read_csv(
    DATA_DIR / "transactions.csv"
)

print(f"Branches:       {len(branches):,}")
print(f"Customers:      {len(customers):,}")
print(f"Accounts:       {len(accounts):,}")
print(f"Transactions:   {len(transactions):,}")


# ============================================================
# 2. CREATE SQLITE CONNECTION
# ============================================================

print("\nCreating SQLite database...")

connection = sqlite3.connect(
    DATABASE_PATH
)

cursor = connection.cursor()


# ============================================================
# 3. ENABLE FOREIGN KEYS
# ============================================================

cursor.execute(
    "PRAGMA foreign_keys = ON;"
)


# ============================================================
# 4. DROP TABLES IF THEY EXIST
# ============================================================

print("Removing previous tables if they exist...")

cursor.execute(
    "DROP TABLE IF EXISTS transactions;"
)

cursor.execute(
    "DROP TABLE IF EXISTS accounts;"
)

cursor.execute(
    "DROP TABLE IF EXISTS customers;"
)

cursor.execute(
    "DROP TABLE IF EXISTS branches;"
)


# ============================================================
# 5. CREATE BRANCHES TABLE
# ============================================================

print("Creating branches table...")

cursor.execute("""
CREATE TABLE branches (
    branch_id INTEGER PRIMARY KEY,
    branch_name TEXT NOT NULL,
    city TEXT NOT NULL,
    region TEXT NOT NULL
);
""")


# ============================================================
# 6. CREATE CUSTOMERS TABLE
# ============================================================

print("Creating customers table...")

cursor.execute("""
CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    middle_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    second_last_name TEXT NOT NULL,
    gender TEXT NOT NULL,
    date_of_birth DATE NOT NULL,
    city TEXT NOT NULL,
    customer_segment TEXT NOT NULL,
    customer_since DATE NOT NULL,
    annual_income REAL NOT NULL,
    customer_status TEXT NOT NULL
);
""")


# ============================================================
# 7. CREATE ACCOUNTS TABLE
# ============================================================

print("Creating accounts table...")

cursor.execute("""
CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    branch_id INTEGER NOT NULL,
    account_type TEXT NOT NULL,
    opening_date DATE NOT NULL,
    current_balance REAL NOT NULL,
    account_status TEXT NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (branch_id)
        REFERENCES branches(branch_id)
);
""")


# ============================================================
# 8. CREATE TRANSACTIONS TABLE
# ============================================================

print("Creating transactions table...")

cursor.execute("""
CREATE TABLE transactions (
    transaction_id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL,
    transaction_date DATETIME NOT NULL,
    transaction_type TEXT NOT NULL,
    channel TEXT NOT NULL,
    amount REAL NOT NULL,
    transaction_status TEXT NOT NULL,
    merchant_category TEXT NOT NULL,

    FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);
""")


# ============================================================
# 9. INSERT DATA
# ============================================================

print("\nInserting data...")


branches.to_sql(
    "branches",
    connection,
    if_exists="append",
    index=False
)

print("✓ Branches loaded")


customers.to_sql(
    "customers",
    connection,
    if_exists="append",
    index=False
)

print("✓ Customers loaded")


accounts.to_sql(
    "accounts",
    connection,
    if_exists="append",
    index=False
)

print("✓ Accounts loaded")


transactions.to_sql(
    "transactions",
    connection,
    if_exists="append",
    index=False
)

print("✓ Transactions loaded")


# ============================================================
# 10. CREATE INDEXES
# ============================================================

print("\nCreating indexes...")


cursor.execute("""
CREATE INDEX idx_accounts_customer
ON accounts(customer_id);
""")


cursor.execute("""
CREATE INDEX idx_accounts_branch
ON accounts(branch_id);
""")


cursor.execute("""
CREATE INDEX idx_transactions_account
ON transactions(account_id);
""")


cursor.execute("""
CREATE INDEX idx_transactions_date
ON transactions(transaction_date);
""")


cursor.execute("""
CREATE INDEX idx_transactions_type
ON transactions(transaction_type);
""")


cursor.execute("""
CREATE INDEX idx_transactions_channel
ON transactions(channel);
""")


# ============================================================
# 11. COMMIT
# ============================================================

connection.commit()


# ============================================================
# 12. VALIDATION
# ============================================================

print("\nValidating database...")

tables = [
    "branches",
    "customers",
    "accounts",
    "transactions"
]

for table in tables:

    result = cursor.execute(
        f"SELECT COUNT(*) FROM {table};"
    ).fetchone()[0]

    print(
        f"{table:<15} {result:,} records"
    )


# ============================================================
# 13. FOREIGN KEY VALIDATION
# ============================================================

print("\nForeign key validation:")

foreign_keys = cursor.execute(
    "PRAGMA foreign_key_check;"
).fetchall()

if len(foreign_keys) == 0:

    print(
        "✓ No foreign key violations"
    )

else:

    print(
        "✗ Foreign key violations found:"
    )

    for error in foreign_keys:
        print(error)


# ============================================================
# 14. DATABASE SIZE
# ============================================================

connection.close()

database_size_mb = (
    DATABASE_PATH.stat().st_size
    / (1024 * 1024)
)

print("\nDatabase created:")

print(
    DATABASE_PATH
)

print(
    f"Database size: {database_size_mb:.2f} MB"
)


# ============================================================
# 15. FINAL STATUS
# ============================================================

print("\n" + "=" * 65)

if len(foreign_keys) == 0:

    print(
        "✓ SQLITE DATABASE CREATED SUCCESSFULLY"
    )

else:

    print(
        "✗ DATABASE CREATED WITH ERRORS"
    )

print("=" * 65)