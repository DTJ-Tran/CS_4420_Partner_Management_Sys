# CS 4420 Partner Management System

Partner and collaboration management database for the CS-4420 course at Hanoi University of Science and Technology. Includes DDL, seed data, and validation/analysis queries.

## Prerequisites
- MySQL 8.x
- User with privileges to create databases and tables

## Setup
1) Create the database and schema:
```sql
SOURCE TEAM_2_DDL.sql;
```

2) Load sample data (rerunnable; truncates tables first):
```sql
USE team_2_db_4420;
SOURCE INSERT_DATA/hust_dataset_insert.sql;
```

3) Run validation and analysis queries:
```sql
USE team_2_db_4420;
SOURCE test.sql;
```

## Key files
- `TEAM_2_DDL.sql` — creates all tables (partner, organization_unit hierarchy, affiliation, agreement, events, billing, etc.).
- `PMSDDL/` — individual DDL files by module.
- `INSERT_DATA/hust_dataset_insert.sql` — FK-safe seed data with truncation for reruns.
- `test.sql` — smoke tests, integrity checks, and basic EOY analysis queries.
- `drop_table.sql` — helper to drop tables if you need a clean rebuild.

## Authors
- Dat Tran Tien — trantiendat@gmail.com
- Nguyen Duy Duc — bachduc.june@gmail.com
- Quoc Khanh — khanhquoctnvn@gmail.com
