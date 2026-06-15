-- =========================================================================
-- FOOTBALL TICKET BOOKING SYSTEM - SQL QUERIES
-- Description: 7 queries demonstrating various SQL concepts
-- Concepts: WHERE, LIKE, NULL handling, INNER JOIN, LEFT JOIN, Subqueries, Pagination
-- =========================================================================

-- Run schema.sql first to create tables and insert data
-- \i schema.sql  -- PostgreSQL command to run from this file

-- =========================================================================
-- QUERY 1: Basic Filtering with WHERE
-- Concepts: SELECT, WHERE, AND
-- Task: Retrieve all upcoming Champions League matches with 'Available' status
-- =========================================================================

SELECT match_id, fixture, base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';

-- Expected Output:
-- match_id | fixture              | base_ticket_price
-- ---------+----------------------+------------------
-- 101      | Real Madrid vs ...   | 150.00
-- 103      | Bayern Munich vs PSG | 130.00


-- =========================================================================
-- QUERY 2: Pattern Matching with LIKE/ILIKE
-- Concepts: LIKE, ILIKE, OR
-- Task: Search for users with names starting with 'Tanvir' or containing 'Haque'
-- =========================================================================

-- PostgreSQL version (case-insensitive with ILIKE):
SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%' OR full_name ILIKE '%Haque%';

-- MySQL version (case-insensitive with LIKE):
-- SELECT user_id, full_name, email
-- FROM Users
-- WHERE full_name LIKE 'Tanvir%' OR full_name LIKE '%Haque%';

-- SQLite/Standard SQL version (using LOWER):
-- SELECT user_id, full_name, email
-- FROM Users
-- WHERE LOWER(full_name) LIKE LOWER('Tanvir%')
--    OR LOWER(full_name) LIKE LOWER('%Haque%');

-- Expected Output:
-- user_id | full_name     | email
---------+---------------+------------------
-- 1       | Tanvir Rahman | tanvir@mail.com
-- 2       | Asif Haque    | asif@mail.com


-- =========================================================================
-- QUERY 3: NULL Handling with COALESCE
-- Concepts: IS NULL, COALESCE
-- Task: Retrieve bookings with missing payment status, replace NULL with 'Action Required'
-- =========================================================================

SELECT booking_id, user_id, match_id,
       COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;

-- Expected Output:
-- booking_id | user_id | match_id | systematic_status
-----------+---------+----------+-------------------
-- 504        | 2       | 101      | Action Required


-- =========================================================================
-- QUERY 4: INNER JOIN - Combine Related Tables
-- Concepts: INNER JOIN, Table Aliases
-- Task: Retrieve booking details with user names and match fixtures
-- =========================================================================

SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id;

-- Expected Output:
-- booking_id | full_name      | fixture                  | total_cost
-----------+----------------+--------------------------+-----------
-- 501        | Tanvir Rahman  | Real Madrid vs Barcelona| 150.00
-- 502        | Tanvir Rahman  | Man City vs Liverpool    | 120.00
-- 503        | Asif Haque     | Real Madrid vs Barcelona| 150.00
-- 504        | Asif Haque     | Real Madrid vs Barcelona| 150.00
-- 505        | Sajjad Rahman  | Man City vs Liverpool    | 120.00


-- =========================================================================
-- QUERY 5: LEFT JOIN - Include All Records from Left Table
-- Concepts: LEFT JOIN, Handling NULLs
-- Task: List all users and their booking IDs, including users with no bookings
-- =========================================================================

SELECT u.user_id, u.full_name, b.booking_id
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;

-- Expected Output:
-- user_id | full_name      | booking_id
---------+----------------+------------
-- 1       | Tanvir Rahman  | 501
-- 1       | Tanvir Rahman  | 502
-- 2       | Asif Haque     | 503
-- 2       | Asif Haque     | 504
-- 3       | Sajjad Rahman  | 505
-- 4       | Jannat Ara     | NULL


-- =========================================================================
-- QUERY 6: Subquery with Aggregation
-- Concepts: Subquery, AVG(), WHERE with aggregate
-- Task: Find bookings where total cost is higher than the average cost
-- =========================================================================

SELECT booking_id, match_id, total_cost
FROM Bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings);

-- Expected Output:
-- booking_id | match_id | total_cost
-----------+----------+-----------
-- 501        | 101      | 150.00
-- 503        | 101      | 150.00
-- 504        | 101      | 150.00


-- =========================================================================
-- QUERY 7: Pagination with LIMIT and OFFSET
-- Concepts: ORDER BY, LIMIT, OFFSET
-- Task: Get the 2nd and 3rd most expensive matches (skip the highest)
-- =========================================================================

SELECT match_id, fixture, base_ticket_price
FROM Matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;

-- Expected Output:
-- match_id | fixture              | base_ticket_price
---------+----------------------+------------------
-- 103      | Bayern Munich vs PSG | 130.00
-- 102      | Man City vs Liverpool| 120.00


-- =========================================================================
-- BONUS: Additional Useful Queries for Testing/Understanding
-- =========================================================================

-- View all tables structure:
-- \d Users
-- \d Matches
-- \d Bookings

-- Count bookings by match:
SELECT m.fixture, COUNT(b.booking_id) as total_bookings
FROM Matches m
LEFT JOIN Bookings b ON m.match_id = b.match_id
GROUP BY m.match_id, m.fixture
ORDER BY total_bookings DESC;

-- Find users who haven't booked any tickets:
SELECT u.user_id, u.full_name, u.email
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
WHERE b.booking_id IS NULL;

-- Total revenue by match:
SELECT m.fixture, SUM(b.total_cost) as revenue
FROM Matches m
INNER JOIN Bookings b ON m.match_id = b.match_id
WHERE b.payment_status = 'Confirmed'
GROUP BY m.match_id, m.fixture
ORDER BY revenue DESC;

-- Users with multiple bookings:
SELECT u.user_id, u.full_name, COUNT(b.booking_id) as booking_count
FROM Users u
INNER JOIN Bookings b ON u.user_id = b.user_id
GROUP BY u.user_id, u.full_name
HAVING COUNT(b.booking_id) > 1
ORDER BY booking_count DESC;
