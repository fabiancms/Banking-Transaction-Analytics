import pandas as pd
import numpy as np
import random
from pathlib import Path

# ============================================================
# CONFIGURATION
# ============================================================

SEED = 42

np.random.seed(SEED)
random.seed(SEED)

NUM_CUSTOMERS = 10_549
NUM_ACCOUNTS = 15_824
NUM_TRANSACTIONS = 306_872
NUM_BRANCHES = 15

NUM_MALE = 4_811
NUM_FEMALE = 5_738

START_DATE = "2024-01-01"
END_DATE = "2025-12-31"

PROJECT_ROOT = Path(__file__).resolve().parent.parent
DATA_DIR = PROJECT_ROOT / "data"

DATA_DIR.mkdir(exist_ok=True)


# ============================================================
# 1. ID GENERATOR
# ============================================================

def generate_unique_ids(quantity, minimum, maximum):
    """
    Generate unique numeric IDs using Python's random module.
    This avoids NumPy int32 limitations for 10-digit IDs.
    """

    ids = set()

    while len(ids) < quantity:
        ids.add(
            random.randint(minimum, maximum - 1)
        )

    return np.array(
        list(ids),
        dtype=np.int64
    )


# ============================================================
# 2. BRANCHES
# ============================================================

branch_ids = generate_unique_ids(
    NUM_BRANCHES,
    100_000,
    1_000_000
)

branch_names = [
    "Bogotá Centro",
    "Bogotá Norte",
    "Bogotá Sur",
    "Medellín Centro",
    "Medellín Poblado",
    "Cali Centro",
    "Cali Norte",
    "Barranquilla Centro",
    "Cartagena Centro",
    "Bucaramanga Centro",
    "Pereira Centro",
    "Manizales Centro",
    "Santa Marta Centro",
    "Ibagué Centro",
    "Villavicencio Centro"
]

branch_cities = [
    "Bogotá",
    "Bogotá",
    "Bogotá",
    "Medellín",
    "Medellín",
    "Cali",
    "Cali",
    "Barranquilla",
    "Cartagena",
    "Bucaramanga",
    "Pereira",
    "Manizales",
    "Santa Marta",
    "Ibagué",
    "Villavicencio"
]

branch_regions = [
    "Central",
    "Central",
    "Central",
    "Antioquia",
    "Antioquia",
    "Valle",
    "Valle",
    "Caribe",
    "Caribe",
    "Santander",
    "Eje Cafetero",
    "Eje Cafetero",
    "Caribe",
    "Tolima",
    "Orinoquía"
]

branches = pd.DataFrame({
    "branch_id": branch_ids,
    "branch_name": branch_names,
    "city": branch_cities,
    "region": branch_regions
})


# ============================================================
# 3. NAMES
# ============================================================

male_names = [
    "Juan", "Carlos", "Andrés", "Daniel", "Felipe",
    "Santiago", "David", "Sebastián", "Miguel", "Alejandro",
    "Nicolás", "Mateo", "Diego", "Luis", "Jorge",
    "Camilo", "Samuel", "Tomás", "Gabriel", "Martín",
    "Ángel", "Esteban", "Julián", "Ricardo", "Mauricio",
    "Cristian", "Oscar", "Fernando", "Manuel", "Héctor",
    "Fabián", "Iván", "Rodrigo", "Alberto", "Gustavo",
    "Eduardo", "Francisco", "Rafael", "Víctor", "Roberto",
    "Germán", "Alonso", "René", "Emilio", "Arturo",
    "Joaquín", "Leonardo", "Adrián", "Álvaro", "Hugo"
]

female_names = [
    "Laura", "María", "Camila", "Valentina", "Carolina",
    "Sofía", "Paula", "Natalia", "Diana", "Andrea",
    "Daniela", "Gabriela", "Isabella", "Alejandra", "Juliana",
    "Sara", "Mariana", "Victoria", "Catalina", "Luciana",
    "Manuela", "Ana", "Claudia", "Patricia", "Sandra",
    "Mónica", "Adriana", "Liliana", "Marcela", "Verónica",
    "Beatriz", "Gloria", "Lorena", "Vanessa", "Tatiana",
    "Carla", "Susana", "Silvia", "Elizabeth", "Jimena",
    "Viviana", "Ángela", "Melissa", "Maribel", "Luisa",
    "Rosa", "Cecilia", "Teresa", "Yolanda", "Martha"
]

last_names = [
    "Gómez", "Rodríguez", "Martínez", "López", "García",
    "Hernández", "Pérez", "Sánchez", "Ramírez", "Torres",
    "Vargas", "Rojas", "Moreno", "Castro", "Jiménez",
    "Ruiz", "Díaz", "Mendoza", "Vega", "Ortiz",
    "Silva", "Romero", "Suárez", "Valencia", "Cárdenas",
    "Molina", "Navarro", "Guerrero", "Restrepo", "Quintero",
    "Mejía", "Salazar", "Marín", "Osorio", "Pineda",
    "Cortés", "Arias", "Gutiérrez", "Parra", "Acosta",
    "Bermúdez", "Mora", "Nieto", "Escobar", "Castaño",
    "Vélez", "Cardona", "Duque", "Montoya", "Giraldo",
    "Correa", "Zapata", "Franco", "Soto", "Mosquera",
    "Hurtado", "Beltrán", "Cabrera", "Londoño", "Barrera",
    "Espinosa", "Pardo", "Villarreal", "Márquez", "Serrano",
    "Aguirre", "Cifuentes", "Bedoya", "Palacios", "León",
    "Rincón", "Sarmiento", "Peña", "Rivera", "Maldonado",
    "Velásquez", "Bustamante", "Ocampo", "Vásquez", "Fajardo",
    "Calderón", "Benítez", "Galeano", "Coronado", "Tamayo",
    "Buitrago", "Lemus", "Arango", "Posada", "Villamizar",
    "Forero", "Cuéllar", "Tovar", "Lara", "Méndez",
    "Bohórquez", "Montero", "Patiño", "Valdés", "Santana"
]

male_middle_names = [
    "David", "Andrés", "Alejandro", "Daniel", "José",
    "Luis", "Miguel", "Antonio", "Felipe", "Eduardo",
    "Fernando", "Gabriel", "Esteban", "Julián", "Mateo",
    "Sebastián", "Juan", "Carlos", "Santiago", "Nicolás",
    "Manuel", "Ángel", "Tomás", "Jorge", "Diego"
]

female_middle_names = [
    "María", "Fernanda", "Isabel", "Sofía", "Carolina",
    "Alejandra", "Victoria", "Valentina", "Daniela", "Gabriela",
    "Andrea", "Paula", "Camila", "Natalia", "Juliana",
    "Lucía", "Manuela", "Catalina", "Laura", "Sara",
    "Diana", "Patricia", "Claudia", "Mariana", "Ana"
]


# ============================================================
# 4. CUSTOMER NAME GENERATOR
# ============================================================

def generate_unique_names(
    num_customers,
    first_names,
    middle_names,
    last_names
):
    """
    Generate unique four-part names:
    first_name + middle_name + last_name + second_last_name
    """

    names = []
    used_names = set()

    while len(names) < num_customers:

        first = random.choice(first_names)

        valid_middle_names = [
            name
            for name in middle_names
            if name != first
        ]

        middle = random.choice(
            valid_middle_names
        )

        last = random.choice(
            last_names
        )

        valid_second_last_names = [
            name
            for name in last_names
            if name != last
        ]

        second_last = random.choice(
            valid_second_last_names
        )

        full_name = (
            first,
            middle,
            last,
            second_last
        )

        if full_name not in used_names:

            used_names.add(
                full_name
            )

            names.append({
                "first_name": first,
                "middle_name": middle,
                "last_name": last,
                "second_last_name": second_last
            })

    return pd.DataFrame(names)


# ============================================================
# 5. CUSTOMER GENERATION
# ============================================================

assert NUM_MALE + NUM_FEMALE == NUM_CUSTOMERS

male_customers = generate_unique_names(
    NUM_MALE,
    male_names,
    male_middle_names,
    last_names
)

female_customers = generate_unique_names(
    NUM_FEMALE,
    female_names,
    female_middle_names,
    last_names
)

male_customers["gender"] = "Male"
female_customers["gender"] = "Female"

customers = pd.concat(
    [
        male_customers,
        female_customers
    ],
    ignore_index=True
)

customers.insert(
    0,
    "customer_id",
    generate_unique_ids(
        NUM_CUSTOMERS,
        10_000_000,
        100_000_000
    )
)


# ============================================================
# 6. CUSTOMER LOCATION
# ============================================================

city_names = [
    "Bogotá",
    "Medellín",
    "Cali",
    "Barranquilla",
    "Cartagena",
    "Bucaramanga",
    "Pereira",
    "Manizales",
    "Santa Marta",
    "Ibagué",
    "Villavicencio"
]

city_probabilities = [
    0.28,
    0.22,
    0.12,
    0.08,
    0.06,
    0.05,
    0.05,
    0.04,
    0.04,
    0.03,
    0.03
]

customers["city"] = np.random.choice(
    city_names,
    size=NUM_CUSTOMERS,
    p=city_probabilities
)


# ============================================================
# 7. CUSTOMER ATTRIBUTES
# ============================================================

customers["date_of_birth"] = pd.to_datetime(
    np.random.randint(
        pd.Timestamp("1950-01-01").value // 10**9,
        pd.Timestamp("2007-12-31").value // 10**9,
        NUM_CUSTOMERS
    ),
    unit="s"
).date

customers["customer_segment"] = np.random.choice(
    [
        "Basic",
        "Standard",
        "Premium"
    ],
    size=NUM_CUSTOMERS,
    p=[
        0.55,
        0.35,
        0.10
    ]
)

customers["customer_since"] = pd.to_datetime(
    np.random.randint(
        pd.Timestamp("2020-01-01").value // 10**9,
        pd.Timestamp("2025-12-31").value // 10**9,
        NUM_CUSTOMERS
    ),
    unit="s"
).date

customers["annual_income"] = np.random.lognormal(
    mean=np.log(45_000),
    sigma=0.45,
    size=NUM_CUSTOMERS
).round(2)

premium_mask = (
    customers["customer_segment"] == "Premium"
)

customers.loc[
    premium_mask,
    "annual_income"
] *= 1.8

customers["annual_income"] = (
    customers["annual_income"]
    .round(2)
)

customers["customer_status"] = np.random.choice(
    [
        "Active",
        "Inactive"
    ],
    size=NUM_CUSTOMERS,
    p=[
        0.90,
        0.10
    ]
)


# ============================================================
# 8. ACCOUNTS
# ============================================================

account_customer_ids = list(
    customers["customer_id"]
)

additional_accounts = customers.sample(
    n=NUM_ACCOUNTS - NUM_CUSTOMERS,
    random_state=SEED
)

account_customer_ids.extend(
    additional_accounts["customer_id"].tolist()
)

accounts = pd.DataFrame({
    "account_id": generate_unique_ids(
        NUM_ACCOUNTS,
        10_000_000,
        100_000_000
    ),
    "customer_id": account_customer_ids
})


# ============================================================
# 9. ASSIGN BRANCHES TO ACCOUNTS
# ============================================================

customer_city_map = (
    customers
    .set_index("customer_id")["city"]
    .to_dict()
)

accounts["city"] = accounts[
    "customer_id"
].map(
    customer_city_map
)

city_branch_map = (
    branches
    .groupby("city")["branch_id"]
    .apply(list)
    .to_dict()
)

accounts["branch_id"] = accounts["city"].apply(
    lambda city: random.choice(
        city_branch_map[city]
    )
)


# ============================================================
# 10. ACCOUNT ATTRIBUTES
# ============================================================

accounts["account_type"] = np.random.choice(
    [
        "Savings",
        "Checking"
    ],
    size=NUM_ACCOUNTS,
    p=[
        0.70,
        0.30
    ]
)

accounts["opening_date"] = pd.to_datetime(
    np.random.randint(
        pd.Timestamp("2020-01-01").value // 10**9,
        pd.Timestamp("2025-12-31").value // 10**9,
        NUM_ACCOUNTS
    ),
    unit="s"
).date

accounts["current_balance"] = np.random.lognormal(
    mean=np.log(5_000),
    sigma=0.9,
    size=NUM_ACCOUNTS
).round(2)

accounts["account_status"] = np.random.choice(
    [
        "Active",
        "Closed"
    ],
    size=NUM_ACCOUNTS,
    p=[
        0.92,
        0.08
    ]
)

accounts = accounts.drop(
    columns=["city"]
)


# ============================================================
# 11. TRANSACTIONS
# ============================================================

transaction_account_ids = np.random.choice(
    accounts["account_id"].values,
    size=NUM_TRANSACTIONS
)

transactions = pd.DataFrame({

    "transaction_id": generate_unique_ids(
        NUM_TRANSACTIONS,
        1_000_000_000,
        10_000_000_000
    ),

    "account_id": transaction_account_ids,

    "transaction_date": pd.to_datetime(
        np.random.randint(
            pd.Timestamp(START_DATE).value // 10**9,
            pd.Timestamp(END_DATE).value // 10**9,
            NUM_TRANSACTIONS
        ),
        unit="s"
    ),

    "transaction_type": np.random.choice(
        [
            "Deposit",
            "Withdrawal",
            "Transfer",
            "Payment"
        ],
        size=NUM_TRANSACTIONS,
        p=[
            0.20,
            0.20,
            0.25,
            0.35
        ]
    ),

    "channel": np.random.choice(
        [
            "Online",
            "Mobile",
            "ATM",
            "Branch"
        ],
        size=NUM_TRANSACTIONS,
        p=[
            0.25,
            0.40,
            0.25,
            0.10
        ]
    ),

    "amount": np.random.lognormal(
        mean=np.log(180),
        sigma=0.9,
        size=NUM_TRANSACTIONS
    ).round(2),

    "transaction_status": np.random.choice(
        [
            "Completed",
            "Failed"
        ],
        size=NUM_TRANSACTIONS,
        p=[
            0.97,
            0.03
        ]
    ),

    "merchant_category": np.random.choice(
        [
            "Grocery",
            "Restaurants",
            "Electronics",
            "Travel",
            "Utilities",
            "Healthcare",
            "Entertainment",
            "Other"
        ],
        size=NUM_TRANSACTIONS,
        p=[
            0.18,
            0.15,
            0.08,
            0.07,
            0.15,
            0.08,
            0.09,
            0.20
        ]
    )
})


# ============================================================
# 12. SAVE CSV FILES
# ============================================================

branches.to_csv(
    DATA_DIR / "branches.csv",
    index=False
)

customers.to_csv(
    DATA_DIR / "customers.csv",
    index=False
)

accounts.to_csv(
    DATA_DIR / "accounts.csv",
    index=False
)

transactions.to_csv(
    DATA_DIR / "transactions.csv",
    index=False
)


# ============================================================
# 13. VALIDATION
# ============================================================

print("\n" + "=" * 65)
print("BANKING DATA GENERATION COMPLETED")
print("=" * 65)


# ------------------------------------------------------------
# Record counts
# ------------------------------------------------------------

print("\nRecord counts:")

print(
    f"Customers:      {len(customers):,}"
)

print(
    f"Accounts:       {len(accounts):,}"
)

print(
    f"Transactions:   {len(transactions):,}"
)

print(
    f"Branches:       {len(branches):,}"
)


# ------------------------------------------------------------
# Gender distribution
# ------------------------------------------------------------

print("\nGender distribution:")

gender_distribution = (
    customers["gender"]
    .value_counts()
    .to_frame("customers")
)

gender_distribution["percentage"] = (
    gender_distribution["customers"]
    / NUM_CUSTOMERS
    * 100
).round(2)

print(
    gender_distribution
)


# ------------------------------------------------------------
# City distribution
# ------------------------------------------------------------

print("\nCity distribution:")

city_distribution = (
    customers["city"]
    .value_counts()
    .to_frame("customers")
)

city_distribution["percentage"] = (
    city_distribution["customers"]
    / NUM_CUSTOMERS
    * 100
).round(2)

print(
    city_distribution
)


# ------------------------------------------------------------
# ID validation
# ------------------------------------------------------------

print("\nID validation:")

print(
    "Customer IDs unique:",
    customers["customer_id"].is_unique
)

print(
    "Account IDs unique:",
    accounts["account_id"].is_unique
)

print(
    "Transaction IDs unique:",
    transactions["transaction_id"].is_unique
)

print(
    "Branch IDs unique:",
    branches["branch_id"].is_unique
)


# ------------------------------------------------------------
# ID digit validation
# ------------------------------------------------------------

print("\nID digit validation:")

customer_id_valid = (
    customers["customer_id"]
    .astype(str)
    .str.len()
    .eq(8)
    .all()
)

account_id_valid = (
    accounts["account_id"]
    .astype(str)
    .str.len()
    .eq(8)
    .all()
)

transaction_id_valid = (
    transactions["transaction_id"]
    .astype(str)
    .str.len()
    .eq(10)
    .all()
)

branch_id_valid = (
    branches["branch_id"]
    .astype(str)
    .str.len()
    .eq(6)
    .all()
)

print(
    "Customer IDs 8 digits:",
    customer_id_valid
)

print(
    "Account IDs 8 digits:",
    account_id_valid
)

print(
    "Transaction IDs 10 digits:",
    transaction_id_valid
)

print(
    "Branch IDs 6 digits:",
    branch_id_valid
)


# ------------------------------------------------------------
# Referential integrity
# ------------------------------------------------------------

print("\nReferential integrity:")

customer_fk_valid = (
    accounts["customer_id"]
    .isin(customers["customer_id"])
    .all()
)

branch_fk_valid = (
    accounts["branch_id"]
    .isin(branches["branch_id"])
    .all()
)

account_fk_valid = (
    transactions["account_id"]
    .isin(accounts["account_id"])
    .all()
)

print(
    "Accounts -> Customers:",
    customer_fk_valid
)

print(
    "Accounts -> Branches:",
    branch_fk_valid
)

print(
    "Transactions -> Accounts:",
    account_fk_valid
)


# ------------------------------------------------------------
# Transaction date range
# ------------------------------------------------------------

print("\nTransaction date range:")

print(
    "Minimum date:",
    transactions["transaction_date"].min()
)

print(
    "Maximum date:",
    transactions["transaction_date"].max()
)


# ------------------------------------------------------------
# Final status
# ------------------------------------------------------------

all_valid = all([
    len(customers) == NUM_CUSTOMERS,
    len(accounts) == NUM_ACCOUNTS,
    len(transactions) == NUM_TRANSACTIONS,
    len(branches) == NUM_BRANCHES,

    customers["customer_id"].is_unique,
    accounts["account_id"].is_unique,
    transactions["transaction_id"].is_unique,
    branches["branch_id"].is_unique,

    customer_id_valid,
    account_id_valid,
    transaction_id_valid,
    branch_id_valid,

    customer_fk_valid,
    branch_fk_valid,
    account_fk_valid
])

print("\nOverall validation:")

if all_valid:
    print("✓ DATASET VALIDATION PASSED")
else:
    print("✗ DATASET VALIDATION FAILED")


# ------------------------------------------------------------
# Files
# ------------------------------------------------------------

print("\nFiles created:")

print("✓ data/branches.csv")
print("✓ data/customers.csv")
print("✓ data/accounts.csv")
print("✓ data/transactions.csv")

print("\n" + "=" * 65)