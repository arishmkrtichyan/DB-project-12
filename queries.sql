-- PostgreSQL Query Examples
-- Comprehensive collection of all main query types

-- ============================================
-- 1. CREATE TABLE
-- ============================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- 2. INSERT - Add new records
-- ============================================
-- Single insert
INSERT INTO users (username, email)
VALUES ('john_doe', 'john@example.com');

-- Multiple inserts
INSERT INTO users (username, email)
VALUES 
    ('jane_smith', 'jane@example.com'),
    ('bob_johnson', 'bob@example.com'),
    ('alice_wonder', 'alice@example.com');

-- Insert with all fields
INSERT INTO posts (user_id, title, content)
VALUES (1, 'My First Post', 'This is the content of my first post');

-- ============================================
-- 3. SELECT - Query data
-- ============================================
-- Select all columns from a table
SELECT * FROM users;

-- Select specific columns
SELECT username, email FROM users;

-- Select with WHERE clause
SELECT * FROM users WHERE username = 'john_doe';

-- Select with ORDER BY
SELECT * FROM users ORDER BY created_at DESC;

-- Select with LIMIT
SELECT * FROM users ORDER BY created_at DESC LIMIT 10;

-- Select with JOIN
SELECT u.username, p.title, p.created_at
FROM users u
INNER JOIN posts p ON u.id = p.user_id
ORDER BY p.created_at DESC;

-- Select with aggregate functions
SELECT COUNT(*) as total_users FROM users;

SELECT COUNT(DISTINCT user_id) as active_users FROM posts;

SELECT u.username, COUNT(p.id) as post_count
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username
HAVING COUNT(p.id) > 0;

-- Select with DISTINCT
SELECT DISTINCT user_id FROM posts;

-- Select with subquery
SELECT * FROM users 
WHERE id IN (SELECT user_id FROM posts);

-- ============================================
-- 4. UPDATE - Modify existing records
-- ============================================
-- Update single record
UPDATE users 
SET email = 'newemail@example.com' 
WHERE username = 'john_doe';

-- Update multiple records
UPDATE posts 
SET updated_at = CURRENT_TIMESTAMP 
WHERE user_id = 1;

-- Update with calculation
UPDATE users 
SET username = UPPER(username) 
WHERE id > 0;

-- ============================================
-- 5. DELETE - Remove records
-- ============================================
-- Delete specific record
DELETE FROM posts 
WHERE id = 1;

-- Delete multiple records
DELETE FROM posts 
WHERE user_id = 2;

-- Delete with subquery
DELETE FROM posts 
WHERE user_id IN (SELECT id FROM users WHERE username = 'bob_johnson');

-- ============================================
-- 6. ALTER TABLE - Modify table structure
-- ============================================
-- Add column
ALTER TABLE users 
ADD COLUMN phone_number VARCHAR(15);

-- Drop column
ALTER TABLE users 
DROP COLUMN phone_number;

-- Rename column
ALTER TABLE users 
RENAME COLUMN created_at TO registration_date;

-- Change column type
ALTER TABLE users 
ALTER COLUMN email TYPE VARCHAR(255);

-- Add constraint
ALTER TABLE posts 
ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES users(id);

-- ============================================
-- 7. DROP TABLE - Remove entire table
-- ============================================
-- Drop single table
DROP TABLE IF EXISTS posts;

-- Drop multiple tables
DROP TABLE IF EXISTS posts, users;

-- ============================================
-- 8. CREATE INDEX - Improve query performance
-- ============================================
CREATE INDEX idx_users_email ON users(email);

CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Drop index
DROP INDEX IF EXISTS idx_users_email;

-- ============================================
-- 9. TRANSACTIONS - Multiple operations
-- ============================================
BEGIN;
    INSERT INTO users (username, email) VALUES ('transaction_user', 'trans@example.com');
    INSERT INTO posts (user_id, title) VALUES (1, 'New Post');
COMMIT;

-- With rollback
BEGIN;
    UPDATE users SET email = 'bulk@example.com';
    -- ROLLBACK; -- Uncomment to undo changes
COMMIT;

-- ============================================
-- 10. VIEWS - Virtual tables
-- ============================================
CREATE VIEW user_post_summary AS
SELECT 
    u.id,
    u.username,
    COUNT(p.id) as total_posts
FROM users u
LEFT JOIN posts p ON u.id = p.user_id
GROUP BY u.id, u.username;

-- Query the view
SELECT * FROM user_post_summary;

-- Drop view
DROP VIEW IF EXISTS user_post_summary;

-- ============================================
-- 11. UPSERT - Insert or Update
-- ============================================
INSERT INTO users (username, email)
VALUES ('john_doe', 'john.updated@example.com')
ON CONFLICT (username)
DO UPDATE SET email = EXCLUDED.email;

-- ============================================
-- 12. COMMON TABLE EXPRESSION (CTE)
-- ============================================
WITH user_posts AS (
    SELECT user_id, COUNT(*) as post_count
    FROM posts
    GROUP BY user_id
)
SELECT u.username, up.post_count
FROM users u
LEFT JOIN user_posts up ON u.id = up.user_id
ORDER BY up.post_count DESC;

-- ============================================
-- 13. WINDOW FUNCTIONS
-- ============================================
SELECT 
    username,
    created_at,
    ROW_NUMBER() OVER (ORDER BY created_at) as registration_order,
    RANK() OVER (ORDER BY created_at) as registration_rank
FROM users;

-- ============================================
-- 14. CASE STATEMENT
-- ============================================
SELECT 
    username,
    CASE 
        WHEN id <= 2 THEN 'Early User'
        WHEN id <= 4 THEN 'Regular User'
        ELSE 'New User'
    END as user_category
FROM users;

-- ============================================
-- 15. FUNCTIONS & OPERATIONS
-- ============================================
-- String functions
SELECT 
    UPPER(username) as upper_name,
    LOWER(email) as lower_email,
    LENGTH(username) as name_length,
    SUBSTRING(email, 1, 5) as email_start
FROM users;

-- Date functions
SELECT 
    username,
    created_at,
    CURRENT_DATE - DATE(created_at) as days_since_registration
FROM users;

-- Aggregate functions with WHERE
SELECT 
    COUNT(*) as total_posts,
    AVG(CHAR_LENGTH(content)) as avg_content_length,
    MAX(created_at) as latest_post
FROM posts
WHERE user_id = 1;
