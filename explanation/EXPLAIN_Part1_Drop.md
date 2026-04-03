# Explanation — Lab5_Part1_Drop.sql

**SC2207/CZ2007 | ACDA Team 5**

This file drops all 23 tables from the database so you can start fresh before re-running Parts 2, 3, and 4. Run this first whenever you want to reset everything.

---

## Why You Need a Drop Script

If you run Part 2 (CREATE TABLE) twice without dropping first, SQL Server will throw an error:

```
There is already an object named 'Client' in the database.
```

The drop script removes all existing tables so Part 2 can create them cleanly.

---

## The IF OBJECT_ID Guard

Every line in this file follows the same pattern:

```sql
IF OBJECT_ID('Client', 'U') IS NOT NULL DROP TABLE Client;
```

Breaking it down:

| Part | What it does |
|---|---|
| `IF OBJECT_ID('Client', 'U')` | Looks up whether an object named `'Client'` exists in the database. The `'U'` means "user table" (as opposed to views or system tables). |
| `IS NOT NULL` | If the lookup returns something (i.e. the table exists), this is TRUE. |
| `DROP TABLE Client` | Only runs if the condition is TRUE — drops the table. |

**Why not just write `DROP TABLE Client` directly?**  
If the table doesn't exist yet (e.g. on a brand new database), a plain `DROP TABLE` would crash with an error. The `IF OBJECT_ID` check makes the script safe to run even on a fresh database.

---

## The Drop Order Matters

Tables are dropped in a specific order — **reverse foreign key dependency order**. Here is why:

If Table B has a foreign key pointing to Table A, you cannot drop Table A while Table B still exists. SQL Server will refuse because that would break Table B's foreign key constraint.

So you must drop the "child" tables (the ones with foreign keys) **before** the "parent" tables (the ones being referenced).

### Drop order used (most dependent → least dependent)

```
Delivery                ← references Vehicle, Route, Warehouse, Shipment
SupplierHasShipment     ← references Shipment, Supplier
ShipmentToWarehouse     ← references Shipment, Warehouse
ShipItem                ← references Item, Shipment
OrderItem               ← references Item, PurchaseOrder
Stop                    ← references Route
ClientHasPO             ← references Client, PurchaseOrder
SupplierHasPO           ← references Supplier, PurchaseOrder
Shipment                ← references PurchaseOrder
Driver                  ← references Staff, Vehicle
Employee                ← references Staff, Warehouse
Supply                  ← references Product, Supplier, Client
Inventory               ← references Product, Warehouse, Client
Item                    ← references Product
Zone                    ← references Warehouse
PurchaseOrder           ← no FK to other tables in this schema
Staff                   ← no FK
Vehicle                 ← no FK
Route                   ← no FK
Supplier                ← no FK
Product                 ← no FK
Warehouse               ← no FK
Client                  ← no FK  ← dropped last
```

The base tables (Client, Warehouse, Product, Supplier, etc.) are dropped last because everything else depends on them.

---

## The PRINT at the End

```sql
PRINT 'All tables dropped successfully.';
```

This outputs a confirmation message to the results panel in Cursor. If you see this message, all 23 tables were dropped without errors.

---

## Summary

| Line count | 23 drop statements + 1 PRINT |
|---|---|
| Safe to run on empty database? | Yes — `IF OBJECT_ID` prevents errors |
| Safe to run multiple times? | Yes |
| Must run before Part 2? | Yes, if tables already exist |
