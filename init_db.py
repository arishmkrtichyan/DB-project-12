import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

DB_NAME = "Supply" #поставки
DB_USER = "MAV"
DB_PASSWORD = "alkash2004"

conn = psycopg2.connect(
    dbname="postgres",
    user="postgres",
    password="alkash2004",
    host="localhost",
    port="2004"
)
conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
cur = conn.cursor()

try:
    cur.execute(f"CREATE USER {DB_USER} WITH PASSWORD '{DB_PASSWORD}';")
except psycopg2.errors.DuplicateObject:
    print(f"User {DB_USER} already exists")

try:
    cur.execute(f"CREATE DATABASE {DB_NAME} OWNER {DB_USER};")
except psycopg2.errors.DuplicateDatabase:
    print(f"Database {DB_NAME} already exists")

cur.close()
conn.close()

print(f"Database {DB_NAME} ready with owner {DB_USER}")
