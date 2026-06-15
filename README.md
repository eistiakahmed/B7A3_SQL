# B7A3: Football Ticket Booking System - SQL Database Project

A complete relational database implementation for managing football match ticket bookings, featuring comprehensive SQL queries, ERD design, and database constraints.

## Project Overview

This system demonstrates advanced SQL database concepts through a real-world football ticket booking application:
- **Database Design**: Three normalized tables with proper constraints and referential integrity
- **SQL Query Techniques**: From basic filtering to complex subqueries, joins, and aggregations
- **Real-World Application**: Complete ticket booking scenarios with NULL handling and payment tracking
- **Professional ERD**: Industry-standard entity relationship diagram with cardinality

---

## Entity Relationship Diagram

### Interactive ERD Viewer
 **View the complete ERD design here:** [ERD Design (Draw.io)](https://viewer.diagrams.net/?tags=%7B%7D&lightbox=1&highlight=0000ff&edit=_blank&layers=1&nav=1&title=ERD%20Design.drawio&dark=auto#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1fY79IwmZrmaNk3UWz7L5V1dh-hek5NPI%26export%3Ddownload)

### Database Structure
```
┌─────────┐         ┌───────────┐         ┌─────────┐
│  USERS  │1       N│ BOOKINGS  │N       1│ MATCHES │
└─────────┘         └───────────┘         └─────────┘
```

### Tables Description

#### **USERS** Table
Platform users (Football Fans and Ticket Managers)

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| user_id | INTEGER | PRIMARY KEY | Unique user identifier |
| full_name | VARCHAR(100) | NOT NULL | User's full name |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Unique email address |
| role | VARCHAR(50) | CHECK IN ('Football Fan', 'Ticket Manager') | User role |
| phone_number | VARCHAR(20) | - | Contact number (optional) |

#### **MATCHES** Table
Football match events and tournament details

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| match_id | INTEGER | PRIMARY KEY | Unique match identifier |
| fixture | VARCHAR(200) | NOT NULL | Match description (e.g., "Real Madrid vs Barcelona") |
| tournament_category | VARCHAR(100) | - | League/tournament name |
| base_ticket_price | DECIMAL(10,2) | CHECK >= 0 | Standard ticket price |
| match_status | VARCHAR(50) | CHECK IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed') | Current availability |

#### **BOOKINGS** Table
Ticket purchase transactions linking users to matches

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| booking_id | INTEGER | PRIMARY KEY | Unique booking identifier |
| user_id | INTEGER | FOREIGN KEY → Users, NOT NULL | References Users table |
| match_id | INTEGER | FOREIGN KEY → Matches, NOT NULL | References Matches table |
| seat_number | VARCHAR(10) | - | Assigned seat (optional) |
| payment_status | VARCHAR(20) | CHECK IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded') | Payment state |
| total_cost | DECIMAL(10,2) | CHECK >= 0 | Final booking amount |

---


### PostgreSQL (Local Installation)

```bash
# Clone the repository
git clone https://github.com/eistiakahmed/B7A3_SQL.git
cd B7A3_SQL

# Create database
createdb football_ticket_booking

# Run schema to create tables and seed data
psql football_ticket_booking < schema.sql

# Run all queries
psql football_ticket_booking < QUERY.sql
```

---

## SQL Query Examples

### Query 1: Basic Filtering
```sql
-- Find all Champions League matches that are available
SELECT match_id, fixture, base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
  AND match_status = 'Available';
```

### Query 2: Pattern Matching
```sql
-- Search users by name pattern
SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%' OR full_name ILIKE '%Haque%';
```

### Query 3: NULL Handling
```sql
-- Find bookings with missing payment status
SELECT booking_id, user_id, match_id,
       COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;
```

### Query 4: INNER JOIN
```sql
-- Get complete booking details with user and match information
SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id;
```

### Query 5: LEFT JOIN
```sql
-- List all users with their bookings (including users without bookings)
SELECT u.user_id, u.full_name, b.booking_id
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id;
```

### Query 6: Subquery with Aggregation
```sql
-- Find bookings above average cost
SELECT booking_id, match_id, total_cost
FROM Bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings);
```

### Query 7: Pagination
```sql
-- Get 2nd most expensive matches (skip 1, limit 2)
SELECT match_id, fixture, base_ticket_price
FROM Matches
ORDER BY base_ticket_price DESC
LIMIT 2 OFFSET 1;
```

---

## SQL Concepts Demonstrated

| Concept | Schema Implementation | Query Example |
|---------|---------------------|---------------|
| **Primary Keys** | All tables | - |
| **Foreign Keys** | Bookings (user_id, match_id) | - |
| **UNIQUE Constraint** | Users.email | - |
| **CHECK Constraint** | All tables (role, status, price) | - |
| **NOT NULL Constraint** | Required fields | - |
| **NULL Handling** | - | Query 3 (IS NULL, COALESCE) |
| **INNER JOIN** | - | Query 4 |
| **LEFT JOIN** | - | Query 5 |
| **Subqueries** | - | Query 6 |
| **Aggregation** | - | Query 6 (AVG) |
| **Pattern Matching** | - | Query 2 (ILIKE) |
| **Pagination** | - | Query 7 (LIMIT, OFFSET) |
| **Sorting** | - | Query 7 (ORDER BY) |

---

## Sample Data Preview

### Users Table
| user_id | full_name | email | role | phone_number |
|---------|-----------|-------|------|--------------|
| 1 | Tanvir Rahman | tanvir@mail.com | Football Fan | +8801711111111 |
| 2 | Asif Haque | asif@mail.com | Football Fan | +8801722222222 |
| 3 | Sajjad Rahman | sajjad@mail.com | Ticket Manager | +8801733333333 |
| 4 | Jannat Ara | jannat@mail.com | Football Fan | NULL |

### Matches Table
| match_id | fixture | tournament_category | base_ticket_price | match_status |
|----------|---------|-------------------|-------------------|--------------|
| 101 | Real Madrid vs Barcelona | Champions League | 150.00 | Available |
| 102 | Man City vs Liverpool | Premier League | 120.00 | Selling Fast |
| 103 | Bayern Munich vs PSG | Champions League | 130.00 | Available |
| 104 | AC Milan vs Inter Milan | Serie A | 90.00 | Sold Out |
| 105 | Juventus vs Roma | Serie A | 80.00 | Available |

### Bookings Table
| booking_id | user_id | match_id | seat_number | payment_status | total_cost |
|------------|---------|----------|-------------|----------------|------------|
| 501 | 1 | 101 | A-12 | Confirmed | 150.00 |
| 502 | 1 | 102 | B-04 | Confirmed | 120.00 |
| 503 | 2 | 101 | A-13 | Confirmed | 150.00 |
| 504 | 2 | 101 | NULL | NULL | 150.00 |
| 505 | 3 | 102 | C-20 | Pending | 120.00 |

---

##  Video Presentation

**Watch the complete project walkthrough:** [Question Answer (Google Drive)](https://drive.google.com/file/d/1F2LXePzIpgL1R7rVeXTAP7Y9EUOzJLDj/view?usp=sharing)

## 🛠️ Troubleshooting

### Common Issues & Solutions

**Issue:** "relation does not exist"
```sql
-- Solution: Ensure schema.sql ran successfully
\dt  -- List all tables (PostgreSQL)
```

**Issue:** "column does not exist"
```sql
-- Solution: Check column names with case sensitivity
SELECT column_name FROM information_schema.columns WHERE table_name = 'users';
```

**Issue:** Foreign key constraint violations
```sql
-- Solution: Insert parent records before child records
-- Order: Users → Matches → Bookings
```


## Project Information

- **Project Name:** Football Ticket Booking System
- **Database Type:** Relational (SQL)
- **Recommended DB:** PostgreSQL
- **Language:** SQL (PSQL standard)

---

## Repository

🔗 **GitHub Repository:** [B7A3_SQL](https://github.com/eistiakahmed/B7A3_SQL.git)

---
