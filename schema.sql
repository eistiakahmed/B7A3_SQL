-- =========================================================================
-- FOOTBALL TICKET BOOKING SYSTEM - DATABASE SETUP
-- Description: Creates tables, constraints, and seeds sample data
-- Database: PostgreSQL (compatible with minor adjustments for MySQL/SQLite)
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
-- Note: Drop in reverse order of dependencies to avoid FK errors
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
-- Stores all administrative staff and customers who use the platform
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number VARCHAR(20)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
-- Catalogs tournament events, stadium logistics, and baseline ticket inventory
CREATE TABLE Matches (
    match_id INTEGER PRIMARY KEY,
    fixture VARCHAR(200) NOT NULL,
    tournament_category VARCHAR(100),
    base_ticket_price DECIMAL(10, 2) CHECK (base_ticket_price >= 0),
    match_status VARCHAR(50) CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
-- Records individual ticket purchases linking users to matches
CREATE TABLE Bookings (
    booking_id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    match_id INTEGER NOT NULL,
    seat_number VARCHAR(10),
    payment_status VARCHAR(20) CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')),
    total_cost DECIMAL(10, 2) CHECK (total_cost >= 0),

    -- Foreign Keys (Referential Integrity)
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (match_id) REFERENCES Matches(match_id)
);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA
-- =========================================================================

-- Insert Users
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- Insert Matches
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- Insert Bookings
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================================================
-- VERIFICATION QUERIES (Optional - to verify data insertion)
-- =========================================================================

-- Verify Users table
SELECT 'Users table:' AS table_name;
SELECT * FROM Users;

-- Verify Matches table
SELECT 'Matches table:' AS table_name;
SELECT * FROM Matches;

-- Verify Bookings table
SELECT 'Bookings table:' AS table_name;
SELECT * FROM Bookings;
