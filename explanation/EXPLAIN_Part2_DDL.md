# Explanation — Lab5_Part2_DDL.sql

**SC2207/CZ2007 | ACDA Team 5**

This file creates all 23 tables that make up the GlobalLogistics database. It defines the structure of each table: column names, data types, and all constraints (primary keys, foreign keys, check constraints, etc.).

---

## What DDL Means

**DDL = Data Definition Language.** It is the part of SQL that defines the structure of the database, as opposed to DML (Data Manipulation Language) which inserts, updates, or deletes actual data.

---

## Constraint Types Used

Before going table by table, here are the constraint types you will see throughout this file:

| Constraint | What it does |
|---|---|
| `PRIMARY KEY` | Uniquely identifies each row. No two rows can have the same PK value. NULL is not allowed. |
| `NOT NULL` | The column must always have a value — it cannot be left empty. |
| `UNIQUE` | All values in this column must be distinct (like PK, but the column is not the main identifier). |
| `DEFAULT value` | If a value is not provided during INSERT, this default is used automatically. |
| `CHECK (condition)` | Rejects any row where the condition is false. Used to enforce allowed values. |
| `FOREIGN KEY ... REFERENCES` | Links this column to the primary key of another table. Prevents orphan records. |
| `ON DELETE CASCADE` | If the parent row is deleted, all child rows referencing it are automatically deleted too. |
| `ON UPDATE CASCADE` | If the parent row's PK changes, the FK in child rows is automatically updated to match. |

---

## Tables 1–4: Core Entity Tables

### 1. Client

```sql
CREATE TABLE Client (
    CID               VARCHAR(10)  NOT NULL,
    ContactPerson     VARCHAR(100) NOT NULL,
    ContractStartDate DATE         NOT NULL,
    CompanyName       VARCHAR(100) NOT NULL,
    ServiceTier       VARCHAR(10)  NOT NULL
        CHECK (ServiceTier IN ('bronze','silver','gold','platinum')),
    PRIMARY KEY (CID)
);
```

- `CID` is the client ID (e.g. `'C001'`). It is the primary key.
- `ServiceTier` can only be one of four fixed values. The `CHECK` constraint enforces this — any INSERT with a different value (e.g. `'diamond'`) will be rejected.

---

### 2. Warehouse

```sql
CREATE TABLE Warehouse (
    WID         VARCHAR(10)  NOT NULL,
    Address     VARCHAR(255) NOT NULL,
    Size        INT          NOT NULL,
    Temperature VARCHAR(20)  NOT NULL
        CHECK (Temperature IN ('ambient','refrigerated','frozen')),
    Security    VARCHAR(10)  NOT NULL
        CHECK (Security IN ('low','medium','high')),
    PRIMARY KEY (WID)
);
```

- `WID` is the warehouse ID (e.g. `'W001'`).
- Two `CHECK` constraints restrict Temperature and Security to fixed allowed values.
- `Size` is in square metres (an `INT` — no decimal places needed).

---

### 3. Zone (Weak Entity of Warehouse)

```sql
CREATE TABLE Zone (
    WID      VARCHAR(10) NOT NULL,
    Location VARCHAR(50) NOT NULL,
    Code     VARCHAR(20) NOT NULL,
    PRIMARY KEY (WID, Location),
    FOREIGN KEY (WID) REFERENCES Warehouse(WID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
```

- Zone is a **weak entity** — it cannot exist independently of a Warehouse. Its identity depends on which warehouse it belongs to.
- The primary key is **(WID, Location)** — a composite key. A zone is uniquely identified by the combination of its warehouse and its location label (e.g. W001 + "bulk storage").
- `ON DELETE CASCADE`: if a Warehouse row is deleted, all its Zones are deleted automatically.

---

### 4. Product

```sql
CREATE TABLE Product (
    PID                  VARCHAR(10)   NOT NULL,
    ...
    HandlingRequirements VARCHAR(50)
        CHECK (HandlingRequirements IN
            ('fragile','hazardous','temperature-controlled','high-value')
            OR HandlingRequirements IS NULL),
    ...
    PRIMARY KEY (PID)
);
```

- Most columns are straightforward. The interesting one is `HandlingRequirements`.
- It is **nullable** (no `NOT NULL`) — a product might not have special handling needs.
- The `CHECK` constraint uses `OR HandlingRequirements IS NULL` to allow both: a valid string from the list, or NULL. Without the `OR IS NULL` clause, NULLs would be rejected.

---

## Tables 5–6: Supplier and Supply

### 5. Supplier

```sql
CREATE TABLE Supplier (
    Supplier_ID  VARCHAR(10)  NOT NULL,
    Country      VARCHAR(100) NOT NULL,
    Name         VARCHAR(100) NOT NULL,
    PaymentTerms VARCHAR(100),
    LeadTime     INT,
    PRIMARY KEY (Supplier_ID)
);
```

- `PaymentTerms` and `LeadTime` are optional (no `NOT NULL`) — some suppliers may not have this information recorded yet.

---

### 6. Supply (Supplier–Client Contract, Weak Entity)

```sql
CREATE TABLE Supply (
    Period      VARCHAR(50) NOT NULL,
    PID         VARCHAR(10) NOT NULL,
    Supplier_ID VARCHAR(10) NOT NULL,
    CID         VARCHAR(10) NOT NULL,
    PRIMARY KEY (Period, PID, Supplier_ID, CID),
    FOREIGN KEY (PID)         REFERENCES Product(PID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (CID)         REFERENCES Client(CID)
);
```

- This table records which supplier supplies which product to which client for which period (e.g. `'2024-H1'`).
- The primary key spans **all four columns** — there are no non-key attributes at all. This was flagged as "unusual" by the TA in Lab 3 feedback. It is retained here to match the Lab 3 schema. In practice, you would add a `ContractValue` or `Notes` column.
- Three foreign keys link to Product, Supplier, and Client respectively.

---

## Tables 7–8: Vehicle and Route

### 7. Vehicle

```sql
CREATE TABLE Vehicle (
    VID      VARCHAR(10)   NOT NULL,
    Type     VARCHAR(30)   NOT NULL
        CHECK (Type IN ('van','truck','refrigerated truck')),
    License  VARCHAR(20)   NOT NULL UNIQUE,
    ...
    PRIMARY KEY (VID)
);
```

- `License` has a `UNIQUE` constraint — no two vehicles can share the same license plate, but it is not the primary key (VID is).

---

### 8. Route

- Stores delivery route metadata: total distance, number of stops, and a status.
- `Status CHECK` restricts to `'planned'`, `'in progress'`, or `'completed'`.

---

## Tables 9–11: Staff Superclass and Subclasses

### 9. Staff (Superclass)

```sql
CREATE TABLE Staff (
    Staff_ID VARCHAR(10)  NOT NULL,
    Type     VARCHAR(20)  NOT NULL
        CHECK (Type IN ('full-time','part-time','contract')),
    HireDate DATE         NOT NULL,
    Name     VARCHAR(100) NOT NULL,
    PRIMARY KEY (Staff_ID)
);
```

- `Staff` is the **superclass** — it holds attributes common to all staff types.

---

### 10. Employee (Subclass of Staff)

```sql
CREATE TABLE Employee (
    Staff_ID      VARCHAR(10)  NOT NULL,
    Certification VARCHAR(100),
    WID           VARCHAR(10)  NOT NULL,
    PRIMARY KEY (Staff_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (WID)      REFERENCES Warehouse(WID)
);
```

- `Staff_ID` is both the PK *and* a FK back to Staff. This is the standard way to model a subclass in SQL: the subclass table shares the same PK as the parent.
- To create an Employee, you must first insert a row in Staff with the same `Staff_ID`.
- `WID` links the employee to the warehouse they work at.

---

### 11. Driver (Subclass of Staff)

- Same structure as Employee. `Staff_ID` is PK and FK to Staff.
- Additional columns: `LicenseNumber`, `LicenseExpiration`, and `VID` (the vehicle assigned to this driver).

---

## Tables 12–15: Orders and Items

### 12. PurchaseOrder

```sql
CREATE TABLE PurchaseOrder (
    OID       VARCHAR(10)   NOT NULL,
    OrderDate DATE          NOT NULL,
    Status    VARCHAR(20)   NOT NULL
        CHECK (Status IN (
            'draft','submitted','confirmed',
            'partially received','fully received','cancelled')),
    Value     DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (OID)
);
```

- `Value` uses `DECIMAL(12,2)` — up to 12 digits total, 2 after the decimal point. This is the correct type for money.
- `Status` has 6 allowed values representing the lifecycle of an order.

---

### 13. Item

```sql
CREATE TABLE Item (
    Item_Serial_No VARCHAR(15) NOT NULL,
    PID            VARCHAR(10) NOT NULL,
    PRIMARY KEY (Item_Serial_No),
    FOREIGN KEY (PID) REFERENCES Product(PID)
);
```

- Represents individual physical item instances (identified by serial number).
- `PID` tells you what product this item is an instance of.
- **Column rename note:** In the Lab 3 schema this was `Item_Serial#`. Renamed to `Item_Serial_No` because `#` requires bracket quoting in SQL Server, which is error-prone.

---

### 14. Inventory (Weak Entity)

```sql
CREATE TABLE Inventory (
    Inventory_Serial_No VARCHAR(15)   NOT NULL,
    PID                 VARCHAR(10)   NOT NULL,
    WID                 VARCHAR(10)   NOT NULL,
    CID                 VARCHAR(10)   NOT NULL,
    rQty  INT NOT NULL DEFAULT 0,
    hQty  INT NOT NULL DEFAULT 0,
    sQty  INT NOT NULL DEFAULT 0,
    oQty  INT NOT NULL DEFAULT 0,
    ...
    PRIMARY KEY (Inventory_Serial_No, PID, WID, CID),
    ...
);
```

- Tracks stock levels for a specific product, in a specific warehouse, belonging to a specific client.
- The four `Qty` columns use `DEFAULT 0` so they don't need to be explicitly set to zero on every INSERT.
- `rQty` = reorder quantity, `hQty` = on-hand, `sQty` = available for sale, `oQty` = reserved (pending orders).

---

### 15. OrderItem (Subclass / Weak Entity)

- Links an individual Item (by `Item_Serial_No`) to a PurchaseOrder (by `OID`).
- Composite PK: `(Item_Serial_No, OID)` — the same item can appear in multiple orders, and each order has multiple items.

---

## Tables 16–17: Shipments

### 16. Shipment

```sql
CREATE TABLE Shipment (
    Shipment_ID    VARCHAR(10)  NOT NULL,
    ExShipDate     DATE,                   -- expected ship date from origin
    AccShipDate    DATE,                   -- actual ship date from origin
    ExArrDate      DATE,                   -- expected arrival date
    AccArrDate     DATE,                   -- actual arrival date
    OGLocation     VARCHAR(255) NOT NULL,
    TrackingNumber VARCHAR(50),
    OID            VARCHAR(10) NOT NULL,
    PRIMARY KEY (Shipment_ID),
    FOREIGN KEY (OID) REFERENCES PurchaseOrder(OID)
);
```

- Four date columns track the full shipment lifecycle. All are nullable — a shipment in transit won't have `AccArrDate` yet.
- The distinction between ship dates and arrival dates allows queries to measure both departure punctuality and delivery punctuality separately.

| Column | Meaning |
|---|---|
| `ExShipDate` | Planned date to leave origin |
| `AccShipDate` | Date it actually left origin |
| `ExArrDate` | Expected arrival at destination warehouse — used in Q7 delay check |
| `AccArrDate` | Actual arrival at destination warehouse — used in Q7 delay check |

- `OGLocation` is the departure city/country (e.g. `'Shanghai, China'`). Used as the grouping key in Q7.

---

### 17. ShipItem (Subclass / Weak Entity)

- Links an individual Item to a Shipment. Composite PK: `(Item_Serial_No, Shipment_ID)`.
- `ExArrDate` was removed — all arrival date information is now held at the Shipment level, which is more consistent since a shipment arrives as a whole unit.

---

## Tables 18–19: Routes and Deliveries

### 18. Stop (Weak Entity of Route)

- Represents a single stop on a route. Composite PK: `(Sequence, RID)`.
- `Sequence` is the stop number (1, 2, 3...) within the route.
- `ON DELETE CASCADE` on the Route FK — if a route is deleted, all its stops go with it.

---

### 19. Delivery (Weak Entity)

```sql
CREATE TABLE Delivery (
    DelDate     DATE        NOT NULL,
    VID         VARCHAR(10) NOT NULL,
    RID         VARCHAR(10) NOT NULL,
    WID         VARCHAR(10) NOT NULL,
    Shipment_ID VARCHAR(10) NOT NULL,
    PRIMARY KEY (DelDate, VID, RID, WID, Shipment_ID),
    ...
);
```

- Records that a specific vehicle + route + warehouse combination was used to deliver a specific shipment on a specific date.
- `DelDate` is the actual delivery date — used in Q4 to measure time from order placement to physical delivery.
- Renamed from `Date` to `DelDate` to avoid using a SQL reserved keyword as a column name.
- The PK spans all 5 columns — another all-key table flagged by the TA. Retained from Lab 3. In practice a surrogate `DeliveryID` would be cleaner.

---

## Tables 20–23: Many-to-Many Junction Tables

### 20. SupplierHasPO

A supplier can be associated with multiple purchase orders, and a PO can involve multiple suppliers. This table records those links.

```sql
PRIMARY KEY (Supplier_ID, OID)
FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
FOREIGN KEY (OID)         REFERENCES PurchaseOrder(OID)
```

### 21. ClientHasPO

Same pattern — a client can have many POs, a PO can be shared by multiple clients (consolidated orders).

### 22. ShipmentToWarehouse

A shipment can be routed to multiple warehouses, and a warehouse receives many shipments.

### 23. SupplierHasShipment

Links suppliers to the shipments they are responsible for.

---

## The PRINT at the End

```sql
PRINT 'All 23 tables created successfully.';
```

If you see this in the Cursor results panel, all 23 `CREATE TABLE` statements completed without error.

---

## Summary Table

| Tables | Type | Key feature |
|---|---|---|
| Client, Warehouse, Product, Supplier, Vehicle, Route, Staff, PurchaseOrder | Strong entities | Single-column PK |
| Zone, Inventory, Supply, Stop, Delivery | Weak entities | Composite PK, FK with CASCADE |
| Employee, Driver | Subclasses of Staff | Staff_ID is both PK and FK to Staff |
| Item, OrderItem, ShipItem | Item-level entities | Serial-number based PK |
| Shipment | Core transaction | Three nullable date columns |
| SupplierHasPO, ClientHasPO, ShipmentToWarehouse, SupplierHasShipment | M:M junctions | PK = both FK columns combined |
