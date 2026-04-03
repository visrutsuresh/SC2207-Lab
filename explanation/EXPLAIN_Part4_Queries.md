# Explanation — Lab5_Part4_Queries.sql

**SC2207/CZ2007 | ACDA Team 5**

This file contains all 7 Appendix B queries. Each section below walks through the SQL for one query: what it is asking, how the SQL is structured, and what each clause does.

---

## Q1 — Top 3 Clients per Warehouse (by Dollar Value)

**The question:** For each warehouse, which clients brought in the most business (in dollar terms)? Show the top 3.

### Full SQL

```sql
WITH ClientWarehouseBusiness AS (
    SELECT
        stw.WID,
        chp.CID,
        SUM(po.Value) AS TotalBusiness
    FROM PurchaseOrder        po
    JOIN ClientHasPO         chp ON po.OID        = chp.OID
    JOIN Shipment              s  ON po.OID        = s.OID
    JOIN ShipmentToWarehouse stw  ON s.Shipment_ID = stw.Shipment_ID
    GROUP BY stw.WID, chp.CID
)
SELECT
    cwb.WID,
    cwb.CID,
    c.CompanyName,
    cwb.TotalBusiness
FROM ClientWarehouseBusiness cwb
JOIN Client c ON cwb.CID = c.CID
WHERE (
    SELECT COUNT(*)
    FROM ClientWarehouseBusiness cwb2
    WHERE cwb2.WID          = cwb.WID
      AND cwb2.TotalBusiness > cwb.TotalBusiness
) < 3
ORDER BY cwb.WID, cwb.TotalBusiness DESC;
```

### Step-by-step breakdown

**Step 1 — The CTE (`WITH ClientWarehouseBusiness AS ...`)**

A CTE (Common Table Expression) is a named temporary result set defined before the main query. Think of it as a saved sub-table you can reference by name.

This CTE computes, for every (warehouse, client) pair, the total dollar value of all POs that were shipped to that warehouse and placed by that client.

The join chain:
```
PurchaseOrder → ClientHasPO   (get which client placed each PO)
PurchaseOrder → Shipment      (get which shipments belong to each PO)
Shipment      → ShipmentToWarehouse  (get which warehouse the shipment went to)
```

`GROUP BY stw.WID, chp.CID` collapses all POs for the same (warehouse, client) pair into one row.  
`SUM(po.Value)` adds up the dollar value of all those POs.

Result of the CTE looks like:

| WID | CID | TotalBusiness |
|---|---|---|
| W001 | C001 | 20500.00 |
| W001 | C002 | 9200.00 |
| W001 | C003 | 6000.00 |
| ... | ... | ... |

**Step 2 — The outer SELECT with the correlated subquery**

The `WHERE` clause filters to only the top 3 per warehouse using a correlated subquery:

```sql
WHERE (
    SELECT COUNT(*)
    FROM ClientWarehouseBusiness cwb2
    WHERE cwb2.WID          = cwb.WID
      AND cwb2.TotalBusiness > cwb.TotalBusiness
) < 3
```

For each row in the outer query, this inner query counts: *"how many other clients in the same warehouse have a higher TotalBusiness?"*

- If 0 other clients beat you → you are rank 1 → `0 < 3` → included
- If 1 client beats you → you are rank 2 → `1 < 3` → included
- If 2 clients beat you → you are rank 3 → `2 < 3` → included
- If 3 or more clients beat you → `3 < 3` is FALSE → excluded

This is the in-syllabus alternative to `ROW_NUMBER() OVER (PARTITION BY WID ORDER BY TotalBusiness DESC)`.

**Step 3 — JOIN Client**

The CTE only has `CID`. The outer `JOIN Client c ON cwb.CID = c.CID` adds `CompanyName` to the output.

**Expected output:** Top 3 clients per warehouse, ordered by warehouse then by dollar value descending.

---

## Q2 — Singapore vs Los Angeles Total Business

**The question:** Do Singapore warehouses have more total business (in dollar value of POs shipped to them) than Los Angeles warehouses?

### Full SQL

```sql
WITH Totals AS (
    SELECT
        (
            SELECT SUM(po.Value)
            FROM PurchaseOrder        po
            JOIN Shipment            s   ON po.OID        = s.OID
            JOIN ShipmentToWarehouse stw ON s.Shipment_ID = stw.Shipment_ID
            JOIN Warehouse           w   ON stw.WID       = w.WID
            WHERE w.Address LIKE '%Singapore%'
        ) AS Singapore_Total,
        (
            SELECT SUM(po.Value)
            FROM PurchaseOrder        po
            JOIN Shipment            s   ON po.OID        = s.OID
            JOIN ShipmentToWarehouse stw ON s.Shipment_ID = stw.Shipment_ID
            JOIN Warehouse           w   ON stw.WID       = w.WID
            WHERE w.Address LIKE '%Los Angeles%'
        ) AS LosAngeles_Total
)
SELECT Singapore_Total, LosAngeles_Total,
       'Yes - Singapore warehouses have more business' AS Result
FROM Totals
WHERE Singapore_Total > LosAngeles_Total
UNION ALL
SELECT Singapore_Total, LosAngeles_Total,
       'No - Los Angeles warehouses have more or equal business'
FROM Totals
WHERE Singapore_Total <= LosAngeles_Total;
```

### Step-by-step breakdown

**Step 1 — The CTE computes both totals**

The `WITH Totals AS (...)` block uses two scalar subqueries — one per city — to compute both totals in a single row. Each scalar subquery follows the same join chain as Q1 to connect a PO's value to the warehouse it was shipped to.

`LIKE '%Singapore%'` matches any address containing "Singapore" — so both W001 and W002 are included. Same logic for `'%Los Angeles%'`.

**Step 2 — UNION ALL with WHERE for Yes/No output**

Instead of `CASE WHEN` (not explicitly in the syllabus), the Yes/No conclusion is produced using `UNION ALL` with two `WHERE` branches:

```
Branch 1: SELECT ... WHERE Singapore_Total > LosAngeles_Total  → fires if Yes
Branch 2: SELECT ... WHERE Singapore_Total <= LosAngeles_Total → fires if No
```

Only one branch fires for a given dataset — the result is always exactly one row.

**Output:** One row, three columns — both totals and a plain-English conclusion.

| Singapore_Total | LosAngeles_Total | Result |
|---|---|---|
| 123456.00 | 45678.00 | Yes - Singapore warehouses have more business |

---

## Q3 — Top 3 Months by Purchase Order Count (Last 2 Years)

**The question:** In the last two years, which three year-month combinations had the most purchase orders created?

### Full SQL

```sql
WITH MonthlyCount AS (
    SELECT
        YEAR(OrderDate)  AS [Year],
        MONTH(OrderDate) AS [Month],
        COUNT(*)         AS PO_Count
    FROM PurchaseOrder
    WHERE OrderDate >= '2024-04-02'
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT [Year], [Month], PO_Count
FROM MonthlyCount mc
WHERE (
    SELECT COUNT(*)
    FROM MonthlyCount mc2
    WHERE mc2.PO_Count > mc.PO_Count
) < 3
ORDER BY PO_Count DESC;
```

### Step-by-step breakdown

**Step 1 — The CTE**

`WHERE OrderDate >= '2024-04-02'` filters to the last 2 years (today is 2026-04-02). The date is hardcoded because `GETDATE()` and `DATEADD()` are not in the course syllabus.

`YEAR(OrderDate)` extracts the 4-digit year from a DATE column (e.g. `2025-01-05` → `2025`).  
`MONTH(OrderDate)` extracts the month number (e.g. `2025-01-05` → `1`).

`GROUP BY YEAR(OrderDate), MONTH(OrderDate)` groups all POs that fall in the same year-month.  
`COUNT(*)` counts how many POs are in each group.

CTE result:

| Year | Month | PO_Count |
|---|---|---|
| 2024 | 8 | 2 |
| 2024 | 11 | 3 |
| 2025 | 1 | 4 |
| 2025 | 6 | 3 |
| 2026 | 3 | 2 |

**Step 2 — Top 3 via correlated subquery**

Same pattern as Q1: count how many other months have a higher PO_Count. If fewer than 3 months beat this one, it is in the top 3.

**Expected output:** Jan 2025 (4), Nov 2024 (3), Jun 2025 (3) — the tie between Nov 2024 and Jun 2025 means both appear (the query returns all tied rows at the boundary).

---

## Q4 — Average Delivery Time in Months

**The question:** On average, how many months does it take from when a purchase order is placed to when the products arrive at the warehouse?

### Full SQL

```sql
SELECT
    AVG(
        CAST(DATEDIFF(DAY, po.OrderDate, d.DelDate) AS FLOAT)
        / 30.44
    ) AS Avg_Months_Order_To_Delivery
FROM PurchaseOrder po
JOIN Shipment  s ON po.OID        = s.OID
JOIN Delivery  d ON d.Shipment_ID = s.Shipment_ID;
```

### Step-by-step breakdown

**The join chain**

```
PurchaseOrder → Shipment   (link order to its shipment)
Shipment      → Delivery   (link shipment to its physical delivery record)
```

`Delivery.DelDate` is the date the vehicle actually delivered the shipment to the warehouse. This is more precise than using `Shipment.AccArrDate` because it comes from the actual delivery record, not just the shipment arrival estimate.

**Computing the time difference**

`DATEDIFF(DAY, po.OrderDate, d.DelDate)` returns the number of days between when the order was placed and when it was physically delivered. This is an MS SQL Server date function — kept because there is no pure-SQL substitute.

`CAST(... AS FLOAT)` prevents integer division so the result is decimal.

`/ 30.44` converts days to months (365.25 / 12 = 30.4375 ≈ 30.44).

**`AVG(...)`**

Averages the computed month values across all rows that have a matching Delivery record. Only shipments with a completed delivery are included.

**Expected output:** A single decimal number representing the average months from order to delivery across all 10 delivery records.

---

## Q5 — Suppliers That Only Ship to Singapore

**The question:** Which suppliers have shipped exclusively to Singapore warehouses (never to any other city)?

### Full SQL

```sql
SELECT
    s.Supplier_ID,
    s.Name    AS SupplierName,
    s.Country
FROM Supplier s
WHERE
    s.Supplier_ID IN (
        SELECT shs.Supplier_ID
        FROM SupplierHasShipment shs
        JOIN ShipmentToWarehouse stw ON shs.Shipment_ID = stw.Shipment_ID
        JOIN Warehouse           w   ON stw.WID         = w.WID
        WHERE w.Address LIKE '%Singapore%'
    )
    AND s.Supplier_ID NOT IN (
        SELECT shs.Supplier_ID
        FROM SupplierHasShipment shs
        JOIN ShipmentToWarehouse stw ON shs.Shipment_ID = stw.Shipment_ID
        JOIN Warehouse           w   ON stw.WID         = w.WID
        WHERE w.Address NOT LIKE '%Singapore%'
    );
```

### Step-by-step breakdown

This query uses two conditions combined with `AND`:

**Condition 1 — `IN` subquery (has shipped to Singapore)**

```sql
WHERE w.Address LIKE '%Singapore%'
```

This subquery finds all `Supplier_ID` values that have at least one shipment going to a Singapore warehouse. If a supplier has never shipped to Singapore at all, they are excluded here.

**Condition 2 — `NOT IN` subquery (has NOT shipped anywhere else)**

```sql
WHERE w.Address NOT LIKE '%Singapore%'
```

This subquery finds all `Supplier_ID` values that have shipped to a non-Singapore warehouse. The outer query uses `NOT IN` — so we keep only suppliers who do NOT appear in this list.

**Both together:**

A supplier is included if:
- They have at least one Singapore shipment (condition 1), AND
- They have zero non-Singapore shipments (condition 2)

**Expected output:** S001 (SupplierAlpha), S005 (SupplierEpsilon), S006 (SupplierZeta), S007 (SupplierEta) — all four ship exclusively to Singapore warehouses.

---

## Q6 — Not Thailand AND Shipped All Singapore Products (Relational Division)

**The question:** Which suppliers have never shipped to Thailand AND have shipped every product that is currently stored in Singapore warehouses?

### Full SQL

```sql
SELECT
    s.Supplier_ID,
    s.Name    AS SupplierName,
    s.Country
FROM Supplier s
WHERE
    s.Supplier_ID NOT IN (
        SELECT shs.Supplier_ID
        FROM SupplierHasShipment shs
        JOIN ShipmentToWarehouse stw ON shs.Shipment_ID = stw.Shipment_ID
        JOIN Warehouse           w   ON stw.WID         = w.WID
        WHERE w.Address LIKE '%Thailand%'
    )
    AND NOT EXISTS (
        SELECT DISTINCT inv.PID
        FROM Inventory inv
        JOIN Warehouse w ON inv.WID = w.WID
        WHERE w.Address LIKE '%Singapore%'

        EXCEPT

        SELECT DISTINCT it.PID
        FROM SupplierHasShipment shs
        JOIN ShipmentToWarehouse stw ON shs.Shipment_ID  = stw.Shipment_ID
        JOIN Warehouse           w   ON stw.WID          = w.WID
        JOIN ShipItem            si  ON shs.Shipment_ID  = si.Shipment_ID
        JOIN Item                it  ON si.Item_Serial_No = it.Item_Serial_No
        WHERE shs.Supplier_ID = s.Supplier_ID
          AND w.Address LIKE '%Singapore%'
    );
```

### Step-by-step breakdown

**Condition 1 — `NOT IN` (no Thailand shipments)**

Same pattern as Q5. This subquery returns all `Supplier_ID` values that have any shipment going to a Thailand warehouse. `NOT IN` excludes those suppliers.

This eliminates S003 (SupplierGamma) who ships to Thailand.

**Condition 2 — `NOT EXISTS` with `NOT IN` (relational division)**

This is the more complex condition. It implements **relational division**: "the supplier must have supplied ALL products in Singapore."

```sql
AND NOT EXISTS (
    SELECT DISTINCT inv.PID
    FROM Inventory inv
    JOIN Warehouse w ON inv.WID = w.WID
    WHERE w.Address LIKE '%Singapore%'
      AND inv.PID NOT IN (
          SELECT DISTINCT it.PID
          FROM SupplierHasShipment shs
          JOIN ShipmentToWarehouse stw ON shs.Shipment_ID  = stw.Shipment_ID
          JOIN Warehouse           w2  ON stw.WID          = w2.WID
          JOIN ShipItem            si  ON shs.Shipment_ID  = si.Shipment_ID
          JOIN Item                it  ON si.Item_Serial_No = it.Item_Serial_No
          WHERE shs.Supplier_ID = s.Supplier_ID
            AND w2.Address LIKE '%Singapore%'
      )
)
```

Reading it inside-out:

1. **Inner subquery** — finds all distinct `PID` values this supplier has shipped to Singapore warehouses (tracing SupplierHasShipment → ShipItem → Item, filtered to Singapore destinations).

2. **`NOT IN`** — filters the Singapore Inventory to products the supplier has *not* shipped there. If the supplier covers everything, this `NOT IN` returns nothing.

3. **`NOT EXISTS`** — checks if any un-covered Singapore product exists. If the `NOT IN` set is empty, `NOT EXISTS` is TRUE → supplier passes.

> **Why not EXCEPT?** `EXCEPT` inside a correlated `NOT EXISTS` subquery is not supported in SQL Server when the inner query references the outer query (`s.Supplier_ID`). The `NOT IN` approach achieves identical logic and works correctly.

**Why this is called relational division:** The query finds all suppliers X such that for every product P in Singapore Inventory, X has shipped P. This "for every" pattern is the relational equivalent of division.

**Expected output:** S001, S005, S006 — all three ship to Singapore only and cover P001, P002, P003. S007 is excluded because it only shipped P001.

---

## Q7 — Departure Locations with Most Delays

**The question:** Which departure locations (origin cities) have the highest count of delayed shipments, where a delay means the actual arrival was more than 6 months after the expected arrival?

### Full SQL

```sql
SELECT
    OGLocation       AS DepartureLocation,
    COUNT(*)         AS DelayCount
FROM Shipment
WHERE AcShippedDate IS NOT NULL
  AND DATEDIFF(MONTH, ExShippedDate, AcShippedDate) > 6
GROUP BY OGLocation
ORDER BY DelayCount DESC;
```

### Step-by-step breakdown

**`WHERE AcShippedDate IS NOT NULL`**

A shipment that hasn't arrived yet has no actual arrival date. You can't measure its delay, so it is excluded.

**`DATEDIFF(MONTH, ExShippedDate, AcShippedDate) > 6`**

`DATEDIFF(MONTH, start, end)` returns the number of calendar months between two dates. If the actual arrival is more than 6 calendar months after the expected arrival, this condition is TRUE — the shipment is delayed.

This is an MS SQL Server date function kept because there is no pure-SQL substitute for this comparison.

**`GROUP BY OGLocation`**

Groups all delayed shipments by their departure city. `COUNT(*)` counts how many delayed shipments originated from each city.

**`ORDER BY DelayCount DESC`**

Sorts results from most delays to fewest — the location with the most delays appears first.

**Expected output:**

| DepartureLocation | DelayCount |
|---|---|
| Shanghai, China | 3 |
| Mumbai, India | 2 |
| Tokyo, Japan | 1 |

---

## Quick Reference: Syllabus Constructs Used per Query

| Query | Key constructs |
|---|---|
| Q1 | `WITH` (CTE), `SUM`, `GROUP BY`, correlated subquery, `COUNT`, `JOIN`, `ORDER BY` |
| Q2 | Scalar subquery in SELECT, `SUM`, `JOIN`, `LIKE` |
| Q3 | `WITH` (CTE), `YEAR()`, `MONTH()`, `COUNT`, `GROUP BY`, correlated subquery |
| Q4 | `AVG`, `JOIN`, `IS NOT NULL`, `DATEDIFF`*, `CAST`* |
| Q5 | `IN`, `NOT IN`, nested subquery, `JOIN`, `LIKE` |
| Q6 | `NOT IN`, `NOT EXISTS`, `EXCEPT`, `JOIN`, `LIKE` |
| Q7 | `COUNT`, `GROUP BY`, `ORDER BY`, `IS NOT NULL`, `DATEDIFF`* |

*Not explicitly in SC2207 lecture notes — kept because no substitute exists. See `SYLLABUS_RULES.md`.
