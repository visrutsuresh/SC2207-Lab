-- ============================================================
-- Lab 5 — GlobalLogistics Database
-- ACDA Team 5
-- PART 3: SAMPLE DATA
-- ============================================================

-- ── Clients ──────────────────────────────────────────────────
INSERT INTO Client VALUES ('C001','Alice Tan',   '2022-01-15','AlphaCorp',    'gold');
INSERT INTO Client VALUES ('C002','Bob Lim',     '2021-06-01','BetaLogic',    'silver');
INSERT INTO Client VALUES ('C003','Carol Ng',    '2023-03-10','GammaTrade',   'platinum');
INSERT INTO Client VALUES ('C004','David Koh',   '2020-09-20','DeltaGoods',   'bronze');
INSERT INTO Client VALUES ('C005','Eve Chen',    '2022-11-05','EpsilonHub',   'gold');

-- ── Warehouses ───────────────────────────────────────────────
INSERT INTO Warehouse VALUES ('W001','12 Tanjong Pagar, Singapore',           5000,'ambient',      'high');
INSERT INTO Warehouse VALUES ('W002','8 Changi South Lane, Singapore',        3000,'refrigerated',  'medium');
INSERT INTO Warehouse VALUES ('W003','1200 Sunset Blvd, Los Angeles, USA',    4000,'ambient',       'high');
INSERT INTO Warehouse VALUES ('W004','500 Alameda St, Los Angeles, USA',      2500,'ambient',       'medium');
INSERT INTO Warehouse VALUES ('W005','99 Sukhumvit Rd, Bangkok, Thailand',    3500,'ambient',       'medium');

-- ── Zones ────────────────────────────────────────────────────
INSERT INTO Zone VALUES ('W001','receiving',    'W001-RCV');
INSERT INTO Zone VALUES ('W001','bulk storage', 'W001-BLK');
INSERT INTO Zone VALUES ('W002','picking area', 'W002-PCK');
INSERT INTO Zone VALUES ('W003','shipping dock','W003-SDK');

-- ── Products ─────────────────────────────────────────────────
INSERT INTO Product VALUES ('P001','WidgetPro X1',   'TechBrand',    50.00,'Electronics', 120.00,'high-value',           10.0, 5.0, 5.0);
INSERT INTO Product VALUES ('P002','GadgetMini Z2',  'TechBrand',    30.00,'Electronics',  75.00,'fragile',               8.0, 4.0, 4.0);
INSERT INTO Product VALUES ('P003','HeavyGizmo 500', 'IndustrialCo', 80.00,'Hardware',    180.00, NULL,                  30.0,20.0,20.0);
INSERT INTO Product VALUES ('P004','FridgePack A',   'CoolBrand',    45.00,'Food',         100.00,'temperature-controlled',15.0,10.0,10.0);
INSERT INTO Product VALUES ('P005','HazChemKit B',   'SafetyPro',    60.00,'Chemicals',    150.00,'hazardous',            20.0,15.0,10.0);

-- ── Suppliers ────────────────────────────────────────────────
INSERT INTO Supplier VALUES ('S001','China',       'SupplierAlpha',   'Net 30', 14);
INSERT INTO Supplier VALUES ('S002','Japan',       'SupplierBeta',    'Net 45', 21);
INSERT INTO Supplier VALUES ('S003','South Korea', 'SupplierGamma',   'Net 30', 10);
INSERT INTO Supplier VALUES ('S004','USA',         'SupplierDelta',   'Net 60',  7);
INSERT INTO Supplier VALUES ('S005','India',       'SupplierEpsilon', 'Net 30', 18);
INSERT INTO Supplier VALUES ('S006','Vietnam',     'SupplierZeta',    'Net 30', 12);
INSERT INTO Supplier VALUES ('S007','Philippines', 'SupplierEta',     'Net 45', 16);

-- ── Vehicle, Route, Staff ─────────────────────────────────────
INSERT INTO Vehicle  VALUES ('V001','truck','SGA1234A',5000.00);
INSERT INTO Vehicle  VALUES ('V002','van',  'SGB5678B',1500.00);
INSERT INTO Route    VALUES ('R001',45.5,6,'completed');
INSERT INTO Route    VALUES ('R002',30.2,4,'completed');
INSERT INTO Staff    VALUES ('ST001','full-time','2020-03-01','John Driver');
INSERT INTO Staff    VALUES ('ST002','full-time','2021-07-15','Mary Worker');
INSERT INTO Driver   VALUES ('ST001','DL-SG-001','2028-12-31','V001');
INSERT INTO Employee VALUES ('ST002','forklift operator','W001');

-- ── Purchase Orders ───────────────────────────────────────────
-- January 2025
INSERT INTO PurchaseOrder VALUES ('O001','2025-01-05','fully received', 12000.00);
INSERT INTO PurchaseOrder VALUES ('O002','2025-01-12','fully received',  8500.00);
INSERT INTO PurchaseOrder VALUES ('O003','2025-01-20','fully received',  9200.00);
INSERT INTO PurchaseOrder VALUES ('O004','2025-01-28','confirmed',       6000.00);

-- June 2025
INSERT INTO PurchaseOrder VALUES ('O005','2025-06-03','fully received', 15000.00);
INSERT INTO PurchaseOrder VALUES ('O006','2025-06-14','fully received', 11000.00);
INSERT INTO PurchaseOrder VALUES ('O007','2025-06-22','confirmed',       7500.00);

-- November 2024
INSERT INTO PurchaseOrder VALUES ('O008','2024-11-08','fully received',  5000.00);
INSERT INTO PurchaseOrder VALUES ('O009','2024-11-15','fully received',  4200.00);
INSERT INTO PurchaseOrder VALUES ('O010','2024-11-25','fully received',  9800.00);

-- August 2024
INSERT INTO PurchaseOrder VALUES ('O011','2024-08-10','fully received',  3000.00);
INSERT INTO PurchaseOrder VALUES ('O012','2024-08-22','fully received',  6500.00);

-- March 2026
INSERT INTO PurchaseOrder VALUES ('O013','2026-03-05','confirmed',       4500.00);
INSERT INTO PurchaseOrder VALUES ('O014','2026-03-18','submitted',       7000.00);

-- December 2023
INSERT INTO PurchaseOrder VALUES ('O015','2023-12-01','fully received', 20000.00);

-- ── Items ─────────────────────────────────────────────────────
INSERT INTO Item VALUES ('I001','P001'); INSERT INTO Item VALUES ('I002','P001');
INSERT INTO Item VALUES ('I003','P002'); INSERT INTO Item VALUES ('I004','P002');
INSERT INTO Item VALUES ('I005','P003'); INSERT INTO Item VALUES ('I006','P003');
INSERT INTO Item VALUES ('I007','P004'); INSERT INTO Item VALUES ('I008','P004');
INSERT INTO Item VALUES ('I009','P005'); INSERT INTO Item VALUES ('I010','P005');
INSERT INTO Item VALUES ('I011','P001'); INSERT INTO Item VALUES ('I012','P002');
INSERT INTO Item VALUES ('I013','P003'); INSERT INTO Item VALUES ('I014','P001');
INSERT INTO Item VALUES ('I015','P002'); INSERT INTO Item VALUES ('I016','P003');
INSERT INTO Item VALUES ('I017','P004'); INSERT INTO Item VALUES ('I018','P005');

-- ── ClientHasPO ───────────────────────────────────────────────
INSERT INTO ClientHasPO VALUES ('C001','O001');
INSERT INTO ClientHasPO VALUES ('C001','O002');
INSERT INTO ClientHasPO VALUES ('C002','O003');
INSERT INTO ClientHasPO VALUES ('C003','O004');
INSERT INTO ClientHasPO VALUES ('C004','O008');
INSERT INTO ClientHasPO VALUES ('C003','O005');
INSERT INTO ClientHasPO VALUES ('C005','O006');
INSERT INTO ClientHasPO VALUES ('C002','O007');
INSERT INTO ClientHasPO VALUES ('C001','O009');
INSERT INTO ClientHasPO VALUES ('C005','O010');
INSERT INTO ClientHasPO VALUES ('C004','O011');
INSERT INTO ClientHasPO VALUES ('C001','O012');
INSERT INTO ClientHasPO VALUES ('C002','O013');
INSERT INTO ClientHasPO VALUES ('C003','O014');
INSERT INTO ClientHasPO VALUES ('C005','O015');

-- ── SupplierHasPO ─────────────────────────────────────────────
INSERT INTO SupplierHasPO VALUES ('S001','O001');
INSERT INTO SupplierHasPO VALUES ('S001','O002');
INSERT INTO SupplierHasPO VALUES ('S005','O003');
INSERT INTO SupplierHasPO VALUES ('S005','O004');
INSERT INTO SupplierHasPO VALUES ('S002','O005');
INSERT INTO SupplierHasPO VALUES ('S002','O006');
INSERT INTO SupplierHasPO VALUES ('S001','O007');
INSERT INTO SupplierHasPO VALUES ('S003','O008');
INSERT INTO SupplierHasPO VALUES ('S003','O009');
INSERT INTO SupplierHasPO VALUES ('S004','O010');
INSERT INTO SupplierHasPO VALUES ('S004','O011');
INSERT INTO SupplierHasPO VALUES ('S004','O012');
INSERT INTO SupplierHasPO VALUES ('S002','O013');
INSERT INTO SupplierHasPO VALUES ('S002','O014');
INSERT INTO SupplierHasPO VALUES ('S001','O015');

-- ── Supply ────────────────────────────────────────────────────
INSERT INTO Supply VALUES ('2024-H2','P001','S001','C001');
INSERT INTO Supply VALUES ('2024-H2','P002','S001','C001');
INSERT INTO Supply VALUES ('2024-H2','P003','S001','C002');
INSERT INTO Supply VALUES ('2025-H1','P001','S005','C003');
INSERT INTO Supply VALUES ('2025-H1','P002','S005','C003');
INSERT INTO Supply VALUES ('2025-H1','P003','S005','C004');
INSERT INTO Supply VALUES ('2025-H1','P001','S002','C005');
INSERT INTO Supply VALUES ('2024-H2','P004','S003','C002');
INSERT INTO Supply VALUES ('2025-H1','P005','S004','C004');

-- ── Shipments ─────────────────────────────────────────────────
-- column order: (Shipment_ID, ExShipDate, AccShipDate, ExArrDate, AccArrDate, OGLocation, TrackingNumber, OID)

-- to W001 (Singapore)
INSERT INTO Shipment VALUES ('SH001','2025-01-18','2025-01-20','2025-02-10','2025-02-12','Shanghai, China',      'TRK-001','O001');
INSERT INTO Shipment VALUES ('SH002','2025-01-23','2025-01-25','2025-02-15','2025-02-18','Shanghai, China',      'TRK-002','O002');
INSERT INTO Shipment VALUES ('SH003','2025-01-26','2025-01-28','2025-02-20','2025-02-22','Mumbai, India',        'TRK-003','O003');
INSERT INTO Shipment VALUES ('SH004','2025-02-03','2025-02-05','2025-02-25','2025-03-01','Mumbai, India',        'TRK-004','O004');

-- to W002 (Singapore)
INSERT INTO Shipment VALUES ('SH005','2025-06-18','2025-06-20','2025-07-10','2025-07-15','Tokyo, Japan',         'TRK-005','O005');
INSERT INTO Shipment VALUES ('SH006','2025-06-26','2025-06-28','2025-07-20','2025-07-25','Tokyo, Japan',         'TRK-006','O006');
INSERT INTO Shipment VALUES ('SH007','2025-06-29','2025-07-01','2025-07-25','2025-07-28','Seoul, South Korea',   'TRK-007','O007');

-- to W003 (Los Angeles)
INSERT INTO Shipment VALUES ('SH008','2024-11-23','2024-11-25','2024-12-20','2024-12-23','Seoul, South Korea',   'TRK-008','O008');
INSERT INTO Shipment VALUES ('SH009','2024-11-29','2024-12-01','2024-12-25','2024-12-28','Shanghai, China',      'TRK-009','O009');
INSERT INTO Shipment VALUES ('SH010','2024-08-26','2024-08-28','2024-09-15','2024-09-20','Los Angeles, USA',     'TRK-010','O010');

-- to W004 (Los Angeles)
INSERT INTO Shipment VALUES ('SH011','2024-08-30','2024-09-01','2024-09-20','2024-09-25','Los Angeles, USA',     'TRK-011','O011');
INSERT INTO Shipment VALUES ('SH012','2024-09-03','2024-09-05','2024-09-25','2024-09-28','New York, USA',        'TRK-012','O012');
INSERT INTO Shipment VALUES ('SH013','2026-03-18','2026-03-20','2026-04-10','2026-04-15','Tokyo, Japan',         'TRK-013','O013');
INSERT INTO Shipment VALUES ('SH014','2026-03-26','2026-03-28','2026-04-20','2026-04-25','Mumbai, India',        'TRK-014','O014');

-- to W005 (Thailand)
INSERT INTO Shipment VALUES ('SH015','2024-01-13','2024-01-15','2024-02-01','2024-02-10','Shanghai, China',      'TRK-015','O015');

-- delayed shipments (Q7)
INSERT INTO Shipment VALUES ('SH016','2024-04-08','2024-04-10','2024-05-01','2024-12-15','Shanghai, China',      'TRK-016','O001');
INSERT INTO Shipment VALUES ('SH017','2024-04-29','2024-05-01','2024-06-01','2025-01-20','Shanghai, China',      'TRK-017','O002');
INSERT INTO Shipment VALUES ('SH018','2024-12-18','2024-12-20','2025-01-10','2025-09-05','Shanghai, China',      'TRK-018','O003');
INSERT INTO Shipment VALUES ('SH019','2024-02-08','2024-02-10','2024-03-01','2024-10-15','Mumbai, India',        'TRK-019','O005');
INSERT INTO Shipment VALUES ('SH020','2025-01-13','2025-01-15','2025-02-01','2025-09-10','Mumbai, India',        'TRK-020','O006');
INSERT INTO Shipment VALUES ('SH021','2025-02-08','2025-02-10','2025-03-01','2025-10-20','Tokyo, Japan',         'TRK-021','O007');

-- ── ShipmentToWarehouse ───────────────────────────────────────
INSERT INTO ShipmentToWarehouse VALUES ('SH001','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH002','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH016','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH017','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH018','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH003','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH004','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH019','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH020','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH005','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH006','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH013','W003');
INSERT INTO ShipmentToWarehouse VALUES ('SH014','W004');
INSERT INTO ShipmentToWarehouse VALUES ('SH021','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH007','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH008','W005');
INSERT INTO ShipmentToWarehouse VALUES ('SH015','W005');
INSERT INTO ShipmentToWarehouse VALUES ('SH009','W003');
INSERT INTO ShipmentToWarehouse VALUES ('SH010','W003');
INSERT INTO ShipmentToWarehouse VALUES ('SH011','W004');
INSERT INTO ShipmentToWarehouse VALUES ('SH012','W004');

-- ── SupplierHasShipment ───────────────────────────────────────
INSERT INTO SupplierHasShipment VALUES ('SH001','S001');
INSERT INTO SupplierHasShipment VALUES ('SH002','S001');
INSERT INTO SupplierHasShipment VALUES ('SH016','S001');
INSERT INTO SupplierHasShipment VALUES ('SH017','S001');
INSERT INTO SupplierHasShipment VALUES ('SH018','S001');
INSERT INTO SupplierHasShipment VALUES ('SH003','S005');
INSERT INTO SupplierHasShipment VALUES ('SH004','S005');
INSERT INTO SupplierHasShipment VALUES ('SH019','S005');
INSERT INTO SupplierHasShipment VALUES ('SH020','S005');
INSERT INTO SupplierHasShipment VALUES ('SH005','S002');
INSERT INTO SupplierHasShipment VALUES ('SH006','S002');
INSERT INTO SupplierHasShipment VALUES ('SH013','S002');
INSERT INTO SupplierHasShipment VALUES ('SH014','S002');
INSERT INTO SupplierHasShipment VALUES ('SH021','S002');
INSERT INTO SupplierHasShipment VALUES ('SH007','S003');
INSERT INTO SupplierHasShipment VALUES ('SH008','S003');
INSERT INTO SupplierHasShipment VALUES ('SH015','S003');
INSERT INTO SupplierHasShipment VALUES ('SH009','S004');
INSERT INTO SupplierHasShipment VALUES ('SH010','S004');
INSERT INTO SupplierHasShipment VALUES ('SH011','S004');
INSERT INTO SupplierHasShipment VALUES ('SH012','S004');

-- ── OrderItem ─────────────────────────────────────────────────
INSERT INTO OrderItem VALUES ('I001','O001','2025-02-15',120.00,50);
INSERT INTO OrderItem VALUES ('I002','O001','2025-02-15',120.00,30);
INSERT INTO OrderItem VALUES ('I003','O002','2025-02-20', 75.00,40);
INSERT INTO OrderItem VALUES ('I004','O003','2025-02-25', 75.00,60);
INSERT INTO OrderItem VALUES ('I005','O004','2025-03-05',180.00,20);
INSERT INTO OrderItem VALUES ('I006','O005','2025-07-15',180.00,35);
INSERT INTO OrderItem VALUES ('I007','O006','2025-07-25',100.00,50);
INSERT INTO OrderItem VALUES ('I008','O007','2025-08-01',100.00,40);
INSERT INTO OrderItem VALUES ('I009','O008','2024-12-25',150.00,20);
INSERT INTO OrderItem VALUES ('I010','O009','2024-12-30',150.00,25);
INSERT INTO OrderItem VALUES ('I011','O010','2024-09-20',120.00,45);
INSERT INTO OrderItem VALUES ('I012','O011','2024-09-28', 75.00,30);
INSERT INTO OrderItem VALUES ('I013','O012','2024-10-01',180.00,20);
INSERT INTO OrderItem VALUES ('I014','O013','2026-04-15',120.00,25);
INSERT INTO OrderItem VALUES ('I015','O014','2026-04-25', 75.00,60);

-- ── ShipItem ──────────────────────────────────────────────────
INSERT INTO ShipItem VALUES ('I001','SH001',50);
INSERT INTO ShipItem VALUES ('I002','SH002',30);
INSERT INTO ShipItem VALUES ('I003','SH002',40);
INSERT INTO ShipItem VALUES ('I004','SH003',60);
INSERT INTO ShipItem VALUES ('I005','SH004',20);
INSERT INTO ShipItem VALUES ('I006','SH005',35);
INSERT INTO ShipItem VALUES ('I007','SH006',50);
INSERT INTO ShipItem VALUES ('I008','SH007',40);
INSERT INTO ShipItem VALUES ('I009','SH008',20);
INSERT INTO ShipItem VALUES ('I010','SH009',25);
INSERT INTO ShipItem VALUES ('I011','SH010',45);
INSERT INTO ShipItem VALUES ('I012','SH011',30);
INSERT INTO ShipItem VALUES ('I013','SH012',20);
INSERT INTO ShipItem VALUES ('I014','SH013',25);
INSERT INTO ShipItem VALUES ('I015','SH014',60);
INSERT INTO ShipItem VALUES ('I001','SH016',10);
INSERT INTO ShipItem VALUES ('I003','SH017',10);
INSERT INTO ShipItem VALUES ('I005','SH018',10);
INSERT INTO ShipItem VALUES ('I011','SH019',15);
INSERT INTO ShipItem VALUES ('I015','SH020',15);

-- ── Inventory ─────────────────────────────────────────────────
INSERT INTO Inventory VALUES ('INV001','P001','W001','C001',100,500,400,50,'W001-BLK-A1','receipt',NULL);
INSERT INTO Inventory VALUES ('INV002','P002','W001','C002', 50,300,250,30,'W001-BLK-B2','receipt',NULL);
INSERT INTO Inventory VALUES ('INV003','P003','W001','C001', 80,200,150,20,'W001-BLK-C3','receipt',NULL);
INSERT INTO Inventory VALUES ('INV004','P001','W002','C003', 60,400,350,40,'W002-PCK-A1','receipt',NULL);
INSERT INTO Inventory VALUES ('INV005','P002','W002','C005', 40,180,160,20,'W002-PCK-B2','receipt',NULL);
INSERT INTO Inventory VALUES ('INV008','P003','W002','C001', 50,150,130,15,'W002-PCK-C3','receipt',NULL);
INSERT INTO Inventory VALUES ('INV006','P004','W003','C004', 30,200,180,25,'W003-SDK-A1','receipt',NULL);
INSERT INTO Inventory VALUES ('INV007','P005','W004','C003', 20,100, 90,10,'W004-BLK-A1','receipt',NULL);

-- ── Stops & Delivery ─────────────────────────────────────────
INSERT INTO Stop     VALUES (1,'R001','09:00:00','2025-02-12');
INSERT INTO Stop     VALUES (2,'R001','10:30:00','2025-02-12');
INSERT INTO Stop     VALUES (1,'R002','14:00:00','2025-07-15');
INSERT INTO Delivery VALUES ('2025-02-12','V001','R001','W001','SH001');
INSERT INTO Delivery VALUES ('2025-07-15','V002','R002','W002','SH005');

-- ── Additional Data ───────────────────────────────────────────
INSERT INTO Item VALUES ('I019','P001'); INSERT INTO Item VALUES ('I020','P002');
INSERT INTO Item VALUES ('I021','P003'); INSERT INTO Item VALUES ('I022','P001');
INSERT INTO Item VALUES ('I023','P002'); INSERT INTO Item VALUES ('I024','P003');
INSERT INTO Item VALUES ('I025','P004'); INSERT INTO Item VALUES ('I026','P005');
INSERT INTO Item VALUES ('I027','P001'); INSERT INTO Item VALUES ('I028','P002');
INSERT INTO Item VALUES ('I029','P003'); INSERT INTO Item VALUES ('I030','P004');
INSERT INTO Item VALUES ('I031','P001'); INSERT INTO Item VALUES ('I032','P002');

INSERT INTO PurchaseOrder VALUES ('O016','2025-03-10','confirmed',     8000.00);
INSERT INTO PurchaseOrder VALUES ('O017','2025-04-15','confirmed',     6500.00);
INSERT INTO PurchaseOrder VALUES ('O018','2024-10-20','fully received',7500.00);
INSERT INTO PurchaseOrder VALUES ('O019','2025-02-28','fully received',5200.00);
INSERT INTO PurchaseOrder VALUES ('O020','2025-10-05','confirmed',     9000.00);
INSERT INTO PurchaseOrder VALUES ('O021','2024-06-18','fully received',4500.00);
INSERT INTO PurchaseOrder VALUES ('O022','2025-05-22','confirmed',     7800.00);
INSERT INTO PurchaseOrder VALUES ('O023','2024-07-30','fully received',3200.00);
INSERT INTO PurchaseOrder VALUES ('O024','2026-02-14','submitted',     8600.00);
INSERT INTO PurchaseOrder VALUES ('O025','2025-12-01','confirmed',     5100.00);

INSERT INTO ClientHasPO VALUES ('C004','O016');
INSERT INTO ClientHasPO VALUES ('C005','O017');
INSERT INTO ClientHasPO VALUES ('C001','O018');
INSERT INTO ClientHasPO VALUES ('C002','O019');
INSERT INTO ClientHasPO VALUES ('C003','O020');
INSERT INTO ClientHasPO VALUES ('C002','O021');
INSERT INTO ClientHasPO VALUES ('C004','O022');
INSERT INTO ClientHasPO VALUES ('C001','O023');
INSERT INTO ClientHasPO VALUES ('C005','O024');
INSERT INTO ClientHasPO VALUES ('C003','O025');

INSERT INTO SupplierHasPO VALUES ('S001','O016');
INSERT INTO SupplierHasPO VALUES ('S005','O017');
INSERT INTO SupplierHasPO VALUES ('S003','O018');
INSERT INTO SupplierHasPO VALUES ('S003','O019');
INSERT INTO SupplierHasPO VALUES ('S002','O020');
INSERT INTO SupplierHasPO VALUES ('S004','O021');
INSERT INTO SupplierHasPO VALUES ('S004','O022');
INSERT INTO SupplierHasPO VALUES ('S004','O023');
INSERT INTO SupplierHasPO VALUES ('S001','O024');
INSERT INTO SupplierHasPO VALUES ('S002','O025');

INSERT INTO Shipment VALUES ('SH022','2025-03-08','2025-03-10','2025-03-28','2025-03-30','Shanghai, China',    'TRK-022','O016');
INSERT INTO Shipment VALUES ('SH023','2025-04-13','2025-04-15','2025-05-05','2025-05-07','Mumbai, India',      'TRK-023','O017');
INSERT INTO Shipment VALUES ('SH024','2024-10-18','2024-10-20','2024-11-05','2024-11-08','Seoul, South Korea', 'TRK-024','O018');
INSERT INTO Shipment VALUES ('SH025','2025-02-26','2025-02-28','2025-03-15','2025-03-18','Seoul, South Korea', 'TRK-025','O019');
INSERT INTO Shipment VALUES ('SH026','2025-10-03','2025-10-05','2025-10-20','2025-10-22','Tokyo, Japan',       'TRK-026','O020');
INSERT INTO Shipment VALUES ('SH027','2024-06-16','2024-06-18','2024-07-05','2024-07-08','Los Angeles, USA',   'TRK-027','O021');
INSERT INTO Shipment VALUES ('SH028','2025-05-20','2025-05-22','2025-06-05','2025-06-08','Los Angeles, USA',   'TRK-028','O022');
INSERT INTO Shipment VALUES ('SH029','2024-07-28','2024-07-30','2024-08-15','2024-08-18','New York, USA',      'TRK-029','O023');
INSERT INTO Shipment VALUES ('SH030','2026-02-12','2026-02-14','2026-03-01','2026-03-03','Shanghai, China',    'TRK-030','O024');
INSERT INTO Shipment VALUES ('SH031','2025-11-29','2025-12-01','2025-12-18','2025-12-20','Tokyo, Japan',       'TRK-031','O025');

INSERT INTO ShipmentToWarehouse VALUES ('SH022','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH023','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH024','W005');
INSERT INTO ShipmentToWarehouse VALUES ('SH025','W005');
INSERT INTO ShipmentToWarehouse VALUES ('SH026','W002');
INSERT INTO ShipmentToWarehouse VALUES ('SH027','W003');
INSERT INTO ShipmentToWarehouse VALUES ('SH028','W004');
INSERT INTO ShipmentToWarehouse VALUES ('SH029','W003');
INSERT INTO ShipmentToWarehouse VALUES ('SH030','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH031','W004');

INSERT INTO SupplierHasShipment VALUES ('SH022','S001');
INSERT INTO SupplierHasShipment VALUES ('SH023','S005');
INSERT INTO SupplierHasShipment VALUES ('SH024','S003');
INSERT INTO SupplierHasShipment VALUES ('SH025','S003');
INSERT INTO SupplierHasShipment VALUES ('SH026','S002');
INSERT INTO SupplierHasShipment VALUES ('SH027','S004');
INSERT INTO SupplierHasShipment VALUES ('SH028','S004');
INSERT INTO SupplierHasShipment VALUES ('SH029','S004');
INSERT INTO SupplierHasShipment VALUES ('SH030','S001');
INSERT INTO SupplierHasShipment VALUES ('SH031','S002');

INSERT INTO ShipItem VALUES ('I019','SH022',20);
INSERT INTO ShipItem VALUES ('I020','SH022',15);
INSERT INTO ShipItem VALUES ('I021','SH022',10);
INSERT INTO ShipItem VALUES ('I022','SH023',25);
INSERT INTO ShipItem VALUES ('I023','SH023',20);
INSERT INTO ShipItem VALUES ('I024','SH023',12);
INSERT INTO ShipItem VALUES ('I025','SH024',18);
INSERT INTO ShipItem VALUES ('I026','SH025',22);
INSERT INTO ShipItem VALUES ('I027','SH026',30);
INSERT INTO ShipItem VALUES ('I028','SH027',25);
INSERT INTO ShipItem VALUES ('I029','SH028',15);
INSERT INTO ShipItem VALUES ('I030','SH029',20);
INSERT INTO ShipItem VALUES ('I031','SH030',18);
INSERT INTO ShipItem VALUES ('I032','SH031',14);

INSERT INTO OrderItem VALUES ('I019','O016','2025-04-05',120.00,20);
INSERT INTO OrderItem VALUES ('I022','O017','2025-05-10', 75.00,25);
INSERT INTO OrderItem VALUES ('I025','O018','2024-11-10',100.00,18);
INSERT INTO OrderItem VALUES ('I026','O019','2025-03-20',150.00,22);
INSERT INTO OrderItem VALUES ('I027','O020','2025-10-25',120.00,30);
INSERT INTO OrderItem VALUES ('I028','O021','2024-07-10', 75.00,25);
INSERT INTO OrderItem VALUES ('I029','O022','2025-06-10',180.00,15);
INSERT INTO OrderItem VALUES ('I030','O023','2024-08-20',100.00,20);
INSERT INTO OrderItem VALUES ('I031','O024','2026-03-05',120.00,18);
INSERT INTO OrderItem VALUES ('I032','O025','2025-12-25', 75.00,14);

-- ── S006 and S007 ─────────────────────────────────────────────
INSERT INTO Item VALUES ('I033','P001'); INSERT INTO Item VALUES ('I034','P002');
INSERT INTO Item VALUES ('I035','P003'); INSERT INTO Item VALUES ('I036','P001');

INSERT INTO PurchaseOrder VALUES ('O026','2025-07-12','fully received',11500.00);
INSERT INTO PurchaseOrder VALUES ('O027','2025-09-08','confirmed',       6800.00);

INSERT INTO ClientHasPO VALUES ('C003','O026');
INSERT INTO ClientHasPO VALUES ('C004','O027');

INSERT INTO SupplierHasPO VALUES ('S006','O026');
INSERT INTO SupplierHasPO VALUES ('S007','O027');

INSERT INTO Shipment VALUES ('SH032','2025-07-10','2025-07-12','2025-07-30','2025-08-01','Ho Chi Minh City, Vietnam','TRK-032','O026');
INSERT INTO Shipment VALUES ('SH033','2025-09-06','2025-09-08','2025-09-25','2025-09-27','Manila, Philippines',       'TRK-033','O027');

INSERT INTO ShipmentToWarehouse VALUES ('SH032','W001');
INSERT INTO ShipmentToWarehouse VALUES ('SH033','W002');

INSERT INTO SupplierHasShipment VALUES ('SH032','S006');
INSERT INTO SupplierHasShipment VALUES ('SH033','S007');

INSERT INTO ShipItem VALUES ('I033','SH032',20);
INSERT INTO ShipItem VALUES ('I034','SH032',15);
INSERT INTO ShipItem VALUES ('I035','SH032',10);
INSERT INTO ShipItem VALUES ('I036','SH033',30);

INSERT INTO OrderItem VALUES ('I033','O026','2025-08-05',120.00,20);
INSERT INTO OrderItem VALUES ('I036','O027','2025-10-01',120.00,30);

INSERT INTO Delivery VALUES ('2025-03-30','V001','R001','W001','SH022');
INSERT INTO Delivery VALUES ('2025-05-07','V002','R002','W001','SH023');
INSERT INTO Delivery VALUES ('2024-11-08','V001','R001','W005','SH024');
INSERT INTO Delivery VALUES ('2025-03-18','V002','R002','W005','SH025');
INSERT INTO Delivery VALUES ('2025-10-22','V001','R001','W002','SH026');
INSERT INTO Delivery VALUES ('2024-07-08','V002','R002','W003','SH027');
INSERT INTO Delivery VALUES ('2025-06-08','V001','R001','W004','SH028');
INSERT INTO Delivery VALUES ('2024-08-18','V002','R002','W003','SH029');

PRINT 'All sample data inserted successfully.';
