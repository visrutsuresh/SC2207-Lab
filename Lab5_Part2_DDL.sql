-- ============================================================
-- Lab 5 — GlobalLogistics Database
-- ACDA Team 5
-- PART 2: CREATE TABLE STATEMENTS
-- ============================================================

-- ── 1. Client ────────────────────────────────────────────────
CREATE TABLE Client (
    CID               VARCHAR(10)  NOT NULL,
    ContactPerson     VARCHAR(100) NOT NULL,
    ContractStartDate DATE         NOT NULL,
    CompanyName       VARCHAR(100) NOT NULL,
    ServiceTier       VARCHAR(10)  NOT NULL
        CHECK (ServiceTier IN ('bronze','silver','gold','platinum')),
    PRIMARY KEY (CID)
);

-- ── 2. Warehouse ─────────────────────────────────────────────
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

-- ── 3. Zone ──────────────────────────────────────────────────
CREATE TABLE Zone (
    WID      VARCHAR(10) NOT NULL,
    Location VARCHAR(50) NOT NULL,
    Code     VARCHAR(20) NOT NULL,
    PRIMARY KEY (WID, Location),
    FOREIGN KEY (WID) REFERENCES Warehouse(WID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ── 4. Product ───────────────────────────────────────────────
CREATE TABLE Product (
    PID                  VARCHAR(10)   NOT NULL,
    Name                 VARCHAR(100)  NOT NULL,
    Brand                VARCHAR(100),
    Cost                 DECIMAL(10,2) NOT NULL,
    Category             VARCHAR(50)   NOT NULL,
    Price                DECIMAL(10,2) NOT NULL,
    HandlingRequirements VARCHAR(50)
        CHECK (HandlingRequirements IN
            ('fragile','hazardous','temperature-controlled','high-value')
            OR HandlingRequirements IS NULL),
    Height DECIMAL(8,2),
    Width  DECIMAL(8,2),
    Length DECIMAL(8,2),
    PRIMARY KEY (PID)
);

-- ── 5. Supplier ──────────────────────────────────────────────
CREATE TABLE Supplier (
    Supplier_ID  VARCHAR(10)  NOT NULL,
    Country      VARCHAR(100) NOT NULL,
    Name         VARCHAR(100) NOT NULL,
    PaymentTerms VARCHAR(100),
    LeadTime     INT,
    PRIMARY KEY (Supplier_ID)
);

-- ── 6. Supply ────────────────────────────────────────────────
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

-- ── 7. Vehicle ───────────────────────────────────────────────
CREATE TABLE Vehicle (
    VID      VARCHAR(10)   NOT NULL,
    Type     VARCHAR(30)   NOT NULL
        CHECK (Type IN ('van','truck','refrigerated truck')),
    License  VARCHAR(20)   NOT NULL UNIQUE,
    Capacity DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (VID)
);

-- ── 8. Route ─────────────────────────────────────────────────
CREATE TABLE Route (
    RID           VARCHAR(10) NOT NULL,
    TotalDistance DECIMAL(10,2),
    TotalStops    INT,
    Status        VARCHAR(20) NOT NULL
        CHECK (Status IN ('planned','in progress','completed')),
    PRIMARY KEY (RID)
);

-- ── 9. Staff ─────────────────────────────────────────────────
CREATE TABLE Staff (
    Staff_ID VARCHAR(10)  NOT NULL,
    Type     VARCHAR(20)  NOT NULL
        CHECK (Type IN ('full-time','part-time','contract')),
    HireDate DATE         NOT NULL,
    Name     VARCHAR(100) NOT NULL,
    PRIMARY KEY (Staff_ID)
);

-- ── 10. Employee ─────────────────────────────────────────────
CREATE TABLE Employee (
    Staff_ID      VARCHAR(10)  NOT NULL,
    Certification VARCHAR(100),
    WID           VARCHAR(10)  NOT NULL,
    PRIMARY KEY (Staff_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (WID)      REFERENCES Warehouse(WID)
);

-- ── 11. Driver ───────────────────────────────────────────────
CREATE TABLE Driver (
    Staff_ID          VARCHAR(10) NOT NULL,
    LicenseNumber     VARCHAR(30) NOT NULL,
    LicenseExpiration DATE        NOT NULL,
    VID               VARCHAR(10) NOT NULL,
    PRIMARY KEY (Staff_ID),
    FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID),
    FOREIGN KEY (VID)      REFERENCES Vehicle(VID)
);

-- ── 12. PurchaseOrder ────────────────────────────────────────
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

-- ── 13. Item ─────────────────────────────────────────────────
CREATE TABLE Item (
    Item_Serial_No VARCHAR(15) NOT NULL,
    PID            VARCHAR(10) NOT NULL,
    PRIMARY KEY (Item_Serial_No),
    FOREIGN KEY (PID) REFERENCES Product(PID)
);

-- ── 14. Inventory ────────────────────────────────────────────
CREATE TABLE Inventory (
    Inventory_Serial_No VARCHAR(15)   NOT NULL,
    PID                 VARCHAR(10)   NOT NULL,
    WID                 VARCHAR(10)   NOT NULL,
    CID                 VARCHAR(10)   NOT NULL,
    rQty  INT           NOT NULL DEFAULT 0,
    hQty  INT           NOT NULL DEFAULT 0,
    sQty  INT           NOT NULL DEFAULT 0,
    oQty  INT           NOT NULL DEFAULT 0,
    Location  VARCHAR(50),
    Movement  VARCHAR(30)
        CHECK (Movement IN ('receipt','putaway','pick','adjustment')
               OR Movement IS NULL),
    Reasons VARCHAR(255),
    PRIMARY KEY (Inventory_Serial_No, PID, WID, CID),
    FOREIGN KEY (PID) REFERENCES Product(PID),
    FOREIGN KEY (WID) REFERENCES Warehouse(WID),
    FOREIGN KEY (CID) REFERENCES Client(CID)
);

-- ── 15. OrderItem ────────────────────────────────────────────
CREATE TABLE OrderItem (
    Item_Serial_No VARCHAR(15)   NOT NULL,
    OID            VARCHAR(10)   NOT NULL,
    ExDelDate      DATE,
    UnitPrice      DECIMAL(10,2) NOT NULL,
    OrderedQty     INT           NOT NULL,
    PRIMARY KEY (Item_Serial_No, OID),
    FOREIGN KEY (Item_Serial_No) REFERENCES Item(Item_Serial_No),
    FOREIGN KEY (OID)            REFERENCES PurchaseOrder(OID)
);

-- ── 16. Shipment ─────────────────────────────────────────────
CREATE TABLE Shipment (
    Shipment_ID    VARCHAR(10)  NOT NULL,
    ExShipDate     DATE,
    AccShipDate    DATE,
    ExArrDate      DATE,
    AccArrDate     DATE,
    OGLocation     VARCHAR(255) NOT NULL,
    TrackingNumber VARCHAR(50),
    OID            VARCHAR(10) NOT NULL,
    PRIMARY KEY (Shipment_ID),
    FOREIGN KEY (OID) REFERENCES PurchaseOrder(OID)
);

-- ── 17. ShipItem ─────────────────────────────────────────────
CREATE TABLE ShipItem (
    Item_Serial_No VARCHAR(15)   NOT NULL,
    Shipment_ID    VARCHAR(10)   NOT NULL,
    ShippedQty     INT           NOT NULL,
    PRIMARY KEY (Item_Serial_No, Shipment_ID),
    FOREIGN KEY (Item_Serial_No) REFERENCES Item(Item_Serial_No),
    FOREIGN KEY (Shipment_ID)    REFERENCES Shipment(Shipment_ID)
);

-- ── 18. Stop ─────────────────────────────────────────────────
CREATE TABLE Stop (
    Sequence   INT         NOT NULL,
    RID        VARCHAR(10) NOT NULL,
    EstArrTime VARCHAR(8),
    ActArrDate DATE,
    PRIMARY KEY (Sequence, RID),
    FOREIGN KEY (RID) REFERENCES Route(RID)
);

-- ── 19. SupplierHasPO ────────────────────────────────────────
CREATE TABLE SupplierHasPO (
    Supplier_ID VARCHAR(10) NOT NULL,
    OID         VARCHAR(10) NOT NULL,
    PRIMARY KEY (Supplier_ID, OID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID),
    FOREIGN KEY (OID)         REFERENCES PurchaseOrder(OID)
);

-- ── 20. ClientHasPO ──────────────────────────────────────────
CREATE TABLE ClientHasPO (
    CID VARCHAR(10) NOT NULL,
    OID VARCHAR(10) NOT NULL,
    PRIMARY KEY (CID, OID),
    FOREIGN KEY (CID) REFERENCES Client(CID),
    FOREIGN KEY (OID) REFERENCES PurchaseOrder(OID)
);

-- ── 21. ShipmentToWarehouse ──────────────────────────────────
CREATE TABLE ShipmentToWarehouse (
    Shipment_ID VARCHAR(10) NOT NULL,
    WID         VARCHAR(10) NOT NULL,
    PRIMARY KEY (Shipment_ID, WID),
    FOREIGN KEY (Shipment_ID) REFERENCES Shipment(Shipment_ID),
    FOREIGN KEY (WID)         REFERENCES Warehouse(WID)
);

-- ── 22. SupplierHasShipment ──────────────────────────────────
CREATE TABLE SupplierHasShipment (
    Shipment_ID VARCHAR(10) NOT NULL,
    Supplier_ID VARCHAR(10) NOT NULL,
    PRIMARY KEY (Shipment_ID, Supplier_ID),
    FOREIGN KEY (Shipment_ID) REFERENCES Shipment(Shipment_ID),
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID)
);

-- ── 23. Delivery ─────────────────────────────────────────────
CREATE TABLE Delivery (
    DelDate     DATE        NOT NULL,
    VID         VARCHAR(10) NOT NULL,
    RID         VARCHAR(10) NOT NULL,
    WID         VARCHAR(10) NOT NULL,
    Shipment_ID VARCHAR(10) NOT NULL,
    PRIMARY KEY (DelDate, VID, RID, WID, Shipment_ID),
    FOREIGN KEY (VID)         REFERENCES Vehicle(VID),
    FOREIGN KEY (RID)         REFERENCES Route(RID),
    FOREIGN KEY (WID)         REFERENCES Warehouse(WID),
    FOREIGN KEY (Shipment_ID) REFERENCES Shipment(Shipment_ID)
);

PRINT 'All 23 tables created successfully.';
