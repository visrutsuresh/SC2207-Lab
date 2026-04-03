# Explanation — Lab5_Part3_Data.sql

**SC2207/CZ2007 | ACDA Team 5**

This file inserts all sample data into the 23 tables. The data is not random — it is carefully engineered so that all 7 Appendix B queries return meaningful, non-empty results with predictable outputs.

---

## INSERT Syntax Used

Every INSERT follows this pattern:

```sql
INSERT INTO TableName VALUES (value1, value2, value3, ...);
```

Values must be provided in the **same order as the columns were defined** in `CREATE TABLE`. String values are wrapped in single quotes. Numbers are unquoted. NULL is written as `NULL`.

---

## Section 1: Clients (5 rows)

```sql
INSERT INTO Client VALUES ('C001','Alice Tan',   '2022-01-15','AlphaCorp',    'gold');
INSERT INTO Client VALUES ('C002','Bob Lim',     '2021-06-01','BetaLogic',    'silver');
...
```

Five clients across different service tiers. Their IDs (C001–C005) are referenced throughout the data, particularly in `ClientHasPO` which links each PO to the client who placed it.

---

## Section 2: Warehouses (5 rows)

```sql
INSERT INTO Warehouse VALUES ('W001','12 Tanjong Pagar, Singapore',         5000,'ambient','high');
INSERT INTO Warehouse VALUES ('W002','8 Changi South Lane, Singapore',      3000,'refrigerated','medium');
INSERT INTO Warehouse VALUES ('W003','1200 Sunset Blvd, Los Angeles, USA',  4000,'ambient','high');
INSERT INTO Warehouse VALUES ('W004','500 Alameda St, Los Angeles, USA',    2500,'ambient','medium');
INSERT INTO Warehouse VALUES ('W005','99 Sukhumvit Rd, Bangkok, Thailand',  3500,'ambient','medium');
```

The warehouse addresses are the key design decision here. Queries Q2, Q5, Q6 all use `LIKE '%Singapore%'`, `LIKE '%Los Angeles%'`, or `LIKE '%Thailand%'` to filter by city. The addresses are written to match these patterns exactly:

| Warehouse | City | Used in |
|---|---|---|
| W001, W002 | Singapore | Q1, Q2, Q5, Q6 |
| W003, W004 | Los Angeles | Q1, Q2 |
| W005 | Thailand (Bangkok) | Q6 exclusion |

---

## Section 3: Zones, Products, Suppliers, Vehicles, Routes, Staff

These sections insert supporting data that is required by foreign key constraints but do not directly drive query results.

**Zones** (4 rows): four storage zones inside W001, W002, W003. Used to demonstrate the Zone weak entity structure.

**Products** (5 rows — P001 to P005):
- P001, P002, P003 are critical — they are stocked in Singapore warehouses (W001, W002) in the Inventory section, which means Q6 checks whether a supplier has shipped all three to Singapore.
- P004 and P005 exist in LA and Thailand warehouses respectively.

**Suppliers** (7 rows — S001 to S007): Each supplier has a distinct routing pattern, critical for Q5 and Q6:

| Supplier | Ships to | Q5 result | Q6 result |
|---|---|---|---|
| S001 SupplierAlpha | Singapore only | Included | Included (ships P001+P002+P003) |
| S002 SupplierBeta | Singapore + Los Angeles | Excluded | Excluded (ships to LA) |
| S003 SupplierGamma | Singapore + Thailand | Excluded | Excluded (ships to Thailand) |
| S004 SupplierDelta | Los Angeles only | Excluded | Excluded |
| S005 SupplierEpsilon | Singapore only | Included | Included (ships P001+P002+P003) |
| S006 SupplierZeta | Singapore only | Included | Included (ships P001+P002+P003) |
| S007 SupplierEta | Singapore only | Included | Excluded (ships P001 only — missing P002 and P003) |

S006 and S007 were added to give Q5 four results. S007 intentionally ships only P001 so it passes Q5 but fails Q6 — this creates a clear distinction between the two queries.

---

## Section 4: Purchase Orders (27 rows)

POs are distributed across multiple months to produce specific Q3 results.

```
Q3 counts POs with OrderDate >= '2024-04-02' (last 2 years from 2026-04-02)
```

| Month | POs inserted | Count | In Q3 window? |
|---|---|---|---|
| January 2025 | O001–O004 | 4 | Yes — top month |
| June 2025 | O005–O007 | 3 | Yes — 2nd |
| November 2024 | O008–O010 | 3 | Yes — 3rd |
| August 2024 | O011–O012 | 2 | Yes — 4th (not in top 3) |
| March 2026 | O013–O014 | 2 | Yes — 5th (not in top 3) |
| December 2023 | O015 | 1 | **No — outside 2-year window** |
| March 2025 | O016 | 1 | Yes (not in top 3) |
| April 2025 | O017 | 1 | Yes (not in top 3) |
| October 2024 | O018 | 1 | Yes (not in top 3) |
| February 2025 | O019 | 1 | Yes (not in top 3) |
| October 2025 | O020 | 1 | Yes (not in top 3) |
| June 2024 | O021 | 1 | Yes (not in top 3) |
| May 2025 | O022 | 1 | Yes (not in top 3) |
| July 2024 | O023 | 1 | Yes (not in top 3) |
| February 2026 | O024 | 1 | Yes (not in top 3) |
| December 2025 | O025 | 1 | Yes (not in top 3) |
| July 2025 | O026 | 1 | Yes (not in top 3) — S006 |
| September 2025 | O027 | 1 | Yes (not in top 3) — S007 |

The additional POs (O016–O027) are each in distinct months so none of them disturb the top 3. The top 3 months remain Jan 2025 (4), Jun 2025 (3), Nov 2024 (3).

O015 (December 2023) is intentionally placed outside the `>= '2024-04-02'` cutoff so Q3 does not count it.

The PO `Value` column is also carefully set to produce specific Q1 results (top 3 clients per warehouse — see Section 7 below).

---

## Section 5: Items (36 rows)

```sql
INSERT INTO Item VALUES ('I001','P001');
INSERT INTO Item VALUES ('I002','P001');
INSERT INTO Item VALUES ('I003','P002');
...
```

Each row is an individual physical item instance with a unique serial number. `I001` and `I002` are both instances of product P001 (WidgetPro X1). These serial numbers are referenced by `OrderItem` and `ShipItem` to link individual items to orders and shipments.

---

## Section 6: ClientHasPO and SupplierHasPO

### ClientHasPO

Links each purchase order to the client who placed it. This is how Q1 connects a PO's dollar value to a client within a warehouse.

```
O001 ($12,000) → C001 → shipped to W001
O002 ($8,500)  → C001 → shipped to W001
  → C001's total for W001 = $20,500  (top client at W001)
```

The values are set so each warehouse has a clear top-3 ranking:

| Warehouse | Rank 1 | Rank 2 | Rank 3 |
|---|---|---|---|
| W001 | C001 ($20,500) | C002 ($16,700) | C005 ($15,100) |
| W002 | C003 ($21,000) | C005 ($11,000) | C002 ($7,500) |
| W003 | C005 ($9,800) | C001 ($7,400) | C002 ($4,500) |
| W004 | C003 ($14,100) | C001 ($6,500) | C004 ($3,000) |
| W005 | C005 ($20,000) | C001 ($7,500) | C002 ($5,200) |

Earlier versions had W001 with only 2 clients and W005 with only 2 clients. The additional data (O016–O019) added C004 and C005 to W001 and C001 and C002 to W005, giving all 5 warehouses a proper top-3.

### SupplierHasPO

Links each PO to the supplier fulfilling it. This determines which supplier's shipments are connected to which POs, and therefore which warehouses they serve.

---

## Section 7: Shipments (33 rows — SH001 to SH033)

This is the most complex section. Shipments are grouped by destination warehouse and by purpose.

Each Shipment row now has **4 date columns**:

| Column | Meaning |
|---|---|
| `ExShipDate` | Planned date to leave origin |
| `AccShipDate` | Date it actually left origin |
| `ExArrDate` | Expected arrival at destination warehouse |
| `AccArrDate` | Actual arrival at destination warehouse |

```sql
-- Column order: (Shipment_ID, ExShipDate, AccShipDate, ExArrDate, AccArrDate, OGLocation, TrackingNumber, OID)
INSERT INTO Shipment VALUES ('SH001','2025-01-18','2025-01-20','2025-02-10','2025-02-12','Shanghai, China','TRK-001','O001');
```

### Normal shipments (SH001–SH014)

On-time shipments going to each warehouse. The gap between `ExArrDate` and `AccArrDate` is only a few days — well within the 6-month delay threshold.

### Old Thailand shipment (SH015)

S003's shipment to W005 (Thailand). Establishes that S003 has shipped to Thailand, so S003 is correctly excluded from Q5 and Q6.

### Delayed shipments (SH016–SH021)

Engineered to have `AccArrDate` more than 6 months after `ExArrDate`, triggering Q7's delay condition:

| Shipment | OGLocation | ExArrDate | AccArrDate | Delay |
|---|---|---|---|---|
| SH016 | Shanghai, China | 2024-05-01 | 2024-12-15 | ~7 months |
| SH017 | Shanghai, China | 2024-06-01 | 2025-01-20 | ~7.5 months |
| SH018 | Shanghai, China | 2025-01-10 | 2025-09-05 | ~8 months |
| SH019 | Mumbai, India | 2024-03-01 | 2024-10-15 | ~7.5 months |
| SH020 | Mumbai, India | 2025-02-01 | 2025-09-10 | ~7 months |
| SH021 | Tokyo, Japan | 2025-03-01 | 2025-10-20 | ~7.5 months |

Q7 expected result: Shanghai (3), Mumbai (2), Tokyo (1).

### Additional shipments (SH022–SH033)

Added to give all warehouses enough clients for Q1 and to provide Delivery records for Q4:
- SH022 (S001→W001), SH023 (S005→W001), SH030 (S001→W001) — add clients to W001
- SH024, SH025 (S003→W005) — add clients to W005
- SH026 (S002→W002), SH027–SH029, SH031 (S004→W003/W004) — general coverage
- SH032 (S006→W001), SH033 (S007→W002) — new Singapore-only suppliers

---

## Section 8: ShipmentToWarehouse and SupplierHasShipment

### ShipmentToWarehouse

Routes each shipment to its destination warehouse(s). This is the table that Q2, Q5, Q6 use to determine which city a shipment ends up in.

```sql
INSERT INTO ShipmentToWarehouse VALUES ('SH001','W001');  -- SH001 goes to Singapore
INSERT INTO ShipmentToWarehouse VALUES ('SH013','W003');  -- SH013 goes to Los Angeles
```

The routing is consistent with the supplier routing design:
- S001's shipments all go to W001 or W002 (Singapore only)
- S003's shipments go to both W001 (Singapore) and W005 (Thailand)
- S004's shipments only go to W003 and W004 (LA only)

### SupplierHasShipment

Links each shipment to the supplier responsible for it. This is the table Q5 and Q6 start from when checking which warehouses a supplier has shipped to.

---

## Section 9: OrderItem and ShipItem

### OrderItem

Links physical items to the purchase orders they belong to. Each row records the item serial number, which order it's in, expected delivery date, unit price, and quantity ordered.

### ShipItem

Links physical items to their shipments. Records which items are inside each shipment and the shipped quantity. The `ExArrDate` column was removed — arrival dates are now held at the Shipment level.

```sql
-- New format (no date column):
INSERT INTO ShipItem VALUES ('I001','SH001',50);
```

**Critical rows for Q6** — these establish which suppliers have shipped all Singapore products (P001, P002, P003):

| Supplier | Shipment | Items | Products covered |
|---|---|---|---|
| S001 | SH016, SH017, SH018 | I001, I003, I005 | P001, P002, P003 ✓ |
| S001 | SH022 | I019, I020, I021 | P001, P002, P003 ✓ |
| S005 | SH019, SH020 | I011, I015 | P001, P002 only |
| S005 | SH023 | I022, I023, I024 | P001, P002, P003 ✓ (fixes P003 gap) |
| S006 | SH032 | I033, I034, I035 | P001, P002, P003 ✓ |
| S007 | SH033 | I036 | P001 only — fails Q6 |

S005 previously only shipped P001 and P002 to Singapore. SH023 (the new S005 shipment to W001) adds P003 via I024, so S005 now correctly passes Q6.

---

## Section 10: Inventory

Tracks what products are currently stocked in each warehouse.

```sql
-- Singapore:
INSERT INTO Inventory VALUES ('INV001','P001','W001','C001',100,500,400,50,...);
INSERT INTO Inventory VALUES ('INV002','P002','W001','C002', 50,300,250,30,...);
INSERT INTO Inventory VALUES ('INV003','P003','W001','C001', 80,200,150,20,...);
INSERT INTO Inventory VALUES ('INV004','P001','W002','C003', 60,400,350,40,...);
INSERT INTO Inventory VALUES ('INV005','P002','W002','C005', 40,180,160,20,...);
INSERT INTO Inventory VALUES ('INV008','P003','W002','C001', 50,150,130,15,...);
```

Products P001, P002, and P003 are stocked in Singapore warehouses W001 and W002. This is what Q6 uses as "Set A" — the full set of products in Singapore that every qualifying supplier must have shipped.

---

## Section 11: Stops, Delivery, and PRINT

**Stops**: A few route stops to satisfy FK constraints on Route.

**Delivery**: 10 delivery records linking vehicles, routes, warehouses, and shipments. The column was renamed from `Date` to `DelDate` to avoid using a SQL reserved keyword. Q4 uses `DelDate` to measure time from order placement to physical delivery.

```sql
-- Column order: (DelDate, VID, RID, WID, Shipment_ID)
INSERT INTO Delivery VALUES ('2025-02-12','V001','R001','W001','SH001');
```

**PRINT**: `'All sample data inserted successfully.'` — confirms the file ran without errors.

---

## Summary: What Each Section Enables

| Section | Tables populated | Drives query |
|---|---|---|
| Clients, Warehouses | Client, Warehouse | Q1, Q2, Q5, Q6 |
| Products | Product | Q6 (Singapore product set) |
| Suppliers | Supplier | Q5, Q6 |
| Purchase Orders | PurchaseOrder | Q1, Q2, Q3, Q4 |
| ClientHasPO | ClientHasPO | Q1 (dollar value per client per warehouse) |
| Shipments (normal) | Shipment | Q1, Q2, Q4 |
| Shipments (delayed) | Shipment | Q7 |
| ShipmentToWarehouse | ShipmentToWarehouse | Q2, Q5, Q6 |
| SupplierHasShipment | SupplierHasShipment | Q5, Q6 |
| ShipItem + Items | ShipItem, Item | Q6 (product coverage check) |
| Inventory | Inventory | Q6 (Singapore product set) |
