import psycopg2

DB_NAME = "Supply"
DB_USER = "MAV"
DB_PASSWORD = "alkash2004"
DB_HOST = "localhost"
DB_PORT = "2004"

conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cur = conn.cursor()

cur.execute("""
CREATE TABLE IF NOT EXISTS enterprise (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    activity_type VARCHAR(100),
    employees_count INT
);
""")

cur.execute("""
CREATE TABLE IF NOT EXISTS product (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2)
);
""")

cur.execute("""
CREATE TABLE IF NOT EXISTS supply (
    id SERIAL PRIMARY KEY,
    enterprise_id INT REFERENCES enterprise(id),
    product_id INT REFERENCES product(id),
    quantity INT,
    supply_date DATE
);
""")

conn.commit()
cur.close()
conn.close()

print("Tables created successfully!")
