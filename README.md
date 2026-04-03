# SC2207-Lab
## How to Run — Lab 5 SQL on MS SQL Server

**SC2207/CZ2007 | ACDA Team 5**

This guide covers two setups:
- **Option A — NTU Lab Server**: use this during the actual lab session on the NTU server.
- **Option B — Local Docker**: use this to test on your own laptop before the lab.

---

# Option A — NTU Lab Server

This guide walks you through running the SQL files using the **MySQL extension (cweijan) in Cursor IDE** against the NTU lab server, and explains how to prepare the Lab 5 submission.

---

## Step 0 — Prerequisites

### Install the MySQL extension in Cursor

1. Open Cursor.
2. Go to the Extensions panel (`Cmd+Shift+X`).
3. Search for **MySQL** by **cweijan**.
4. Click **Install**.

> **Note:** You must be on the NTU campus network or NTU VPN for the server address to be reachable.

---

## Step 1 — Connect to the NTU Server

1. Click the database icon in the Cursor sidebar (the MySQL extension panel).
2. Click **Create Connection**.
3. Select **SQL Server** from the Server Type row.
4. Fill in:

| Field | Value |
|---|---|
| Host | `10.96.189.36` |
| Port | `1433` |
| Username | `ecds2g1` *(replace `g1` with your group number, e.g. `ecds2g2`)* |
| Password | `P@ssw0rd!` |

5. Click **Connect**. The connection will appear in the left panel.

---

## Step 2 — Create Your Database

1. Open a new SQL file: **File → New File**, save it as `setup.sql`.
2. Paste and run the following:

```sql
CREATE DATABASE Lab5_ACDA_Team5;
GO
USE Lab5_ACDA_Team5;
GO
```

3. To run: press `Ctrl+Shift+E` (or right-click → **Execute Query**).
4. Results appear in a panel at the bottom. You should see `Commands completed successfully`.

> **Tip:** Every time you open a new `.sql` file, add `USE Lab5_ACDA_Team5;` at the top before running, so queries target the right database.

---

## Step 3 — Run the SQL Files in Order

Open each file in Cursor (`Ctrl+O` / `Cmd+O`) and execute with `Ctrl+Shift+E`.

Run them in this exact order:

### 3a. Part 1 — Drop Tables
**`Lab5_Part1_Drop.sql`**

- Removes any leftover tables from a previous run.
- Safe to run even on a fresh database — all drops are guarded with `IF OBJECT_ID(...)`.
- Press `Ctrl+Shift+E` to execute.

### 3b. Part 2 — Create Tables (DDL)
**`Lab5_Part2_DDL.sql`**

- Creates all 23 tables with correct primary keys, foreign keys, and CHECK constraints.
- Press `Ctrl+Shift+E` to execute.
- You should see `All 23 tables created successfully.` in the results panel.

### 3c. Part 3 — Insert Sample Data
**`Lab5_Part3_Data.sql`**

- Populates all tables with sample data designed for the 7 queries.
- Press `Ctrl+Shift+E` to execute.
- You should see `All sample data inserted successfully.`

### 3d. Part 4 — Run Queries
**`Lab5_Part4_Queries.sql`**

- Contains all 7 Appendix B queries.
- You can run the entire file with `Ctrl+Shift+E`, **or** highlight just one query and press `Ctrl+Shift+E` to run only that query.
- To highlight: click and drag to select the query text, then press `Ctrl+Shift+E`.

---

## Step 4 — View Table Contents (for PDF printout)

The lab requires "a printout of all table records." Run SELECT statements for each table:

```sql
USE Lab5_ACDA_Team5;
GO
SELECT * FROM Client;
SELECT * FROM Warehouse;
SELECT * FROM Product;
-- ... (repeat for each table)
```

Results appear in the bottom panel. You can page through them there.

---

## Step 5 — Prepare the PDF (Lab 5 Submission)

The lab requires a single PDF containing:

1. **SQL DDL commands** — paste the content of `Lab5_Part2_DDL.sql`
2. **SQL queries + output** — for each of the 7 queries:
   - Paste the SQL statement
   - Show the output results table
   - Add 1–2 sentences explaining how the output is obtained
3. **Printout of all table records** — copy-paste of `SELECT * FROM TableName` for every table
4. **Description of any additional effort** — note design decisions, assumptions, etc.

**Label the PDF as:** `Lab5_ACDA_TeamY.pdf` where Y is your team number.

### How to copy query output from Cursor

**Option A — Copy from results grid:**
1. Run the query so results appear in the bottom panel.
2. Click any cell in the results, then `Ctrl+A` to select all rows.
3. Right-click → **Save Results as CSV** or **Copy with Headers**.
4. Paste into Word or Google Docs, then export as PDF.

**Option B — Save as JSON or CSV:**
1. In the results panel, click the **Save as CSV** icon (top-right of the results pane).
2. Open the CSV in Excel, format it, then export as PDF.

**Option C — Screenshot:**
- For short result sets, a screenshot of the results panel is acceptable. Make sure all columns and rows are visible before screenshotting.

---

## Step 6 — Screen Recordings (mp4)

The lab requires a screen recording (≤30 seconds) for each query:

**What to show in each recording:**
1. Show the SQL query highlighted in Cursor
2. Press `Ctrl+Shift+E` to execute
3. Show the results panel with results visible
4. File name: `Lab5_ACDA_TeamY_Q1.mp4`, `...Q2.mp4`, etc.

**Tools for screen recording:**
- **Windows 11/10**: `Win + G` opens Xbox Game Bar → click Record button
- **Mac**: `Cmd + Shift + 5`

**Tips:**
- Zoom in (`Ctrl+` in Cursor) so the SQL text is readable in the recording
- Highlight just that one query before pressing `Ctrl+Shift+E` so only that query runs
- The 30-second limit is tight — have the query pre-selected before starting the recording

---

## Step 7 — Zip and Submit

1. Combine the PDF and all 7 mp4 files into a single ZIP file.
2. Label the ZIP: `Lab5_ACDA_TeamY.zip`
3. Submit to NTULearn for your lab group **at the end of the Lab 5 session**.

---

## Common Errors and Fixes

| Error | Cause | Fix |
|---|---|---|
| Connection timeout / cannot connect | Not on NTU network | Connect to NTU VPN first |
| `Login failed for user 'ecds2g1'` | Wrong group number | Use `ecds2gX` where X is your group |
| `There is already an object named 'Client'` | Tables already exist | Run Part 1 (Drop) first, then Part 2 again |
| `The INSERT statement conflicted with the FOREIGN KEY constraint` | Running Part 3 before Part 2 | Always run in order: Part 1 → 2 → 3 → 4 |
| `Invalid object name 'PurchaseOrder'` | Wrong database selected | Add `USE Lab5_ACDA_Team5;` at the top of the file |
| Query returns empty results | Data issue or wrong DB | Verify Part 3 ran successfully; check you're in the right DB |
| Extension says "No connection" | Profile not selected | Click the status bar at the bottom and select `NTU-Lab5` |

---

## Quick Reference — Re-running Everything from Scratch

If something went wrong and you want to start completely fresh:

```sql
USE master;
GO
DROP DATABASE IF EXISTS Lab5_ACDA_Team5;
GO
CREATE DATABASE Lab5_ACDA_Team5;
GO
USE Lab5_ACDA_Team5;
GO
```

Then run Parts 2, 3, and 4.

---

---

# Option B — Local Docker (Testing on Your Own Laptop)

Use this to test everything locally before the lab session. Requires Docker Desktop installed on your Mac.

---

## Step 1 — Start the SQL Server Container

Run this once in your terminal (or ask Claude Code to run it for you):

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=P@ssw0rd123!" \
  -p 1433:1433 --name sqlserver \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

To verify it's running:
```bash
docker ps --filter "name=sqlserver"
```

You should see `sqlserver` with status `Up`.

> **Note:** Docker Desktop must be open and running (whale icon in menu bar) before this works.

---

## Step 2 — Connect in Cursor

1. Click the database icon in the Cursor sidebar (MySQL extension panel).
2. Click **Create Connection**.
3. Select **SQL Server** from the Server Type row.
4. Fill in:

| Field | Value |
|---|---|
| Host | `localhost` |
| Port | `1433` |
| Username | `sa` |
| Password | `P@ssw0rd123!` |

5. Click **Connect**.

---

## Step 3 — Create a Test Database

In the SQL editor, run:

```sql
CREATE DATABASE Lab5_ACDA_Team5;
```

Then select `Lab5_ACDA_Team5` as the active database before running the lab files.

---

## Step 4 — Run the SQL Files in Order

Same as Option A — run Part 1 → Part 2 → Part 3 → Part 4 in order.

---

## Step 5 — Stop the Container When Done

When you're finished testing, stop the container to free up resources:

```bash
docker stop sqlserver
```

To start it again next time (without re-downloading):

```bash
docker start sqlserver
```

To delete it entirely:

```bash
docker stop sqlserver && docker rm sqlserver
```

