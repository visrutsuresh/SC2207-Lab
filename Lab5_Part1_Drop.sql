-- ============================================================
-- Lab 5 — GlobalLogistics Database
-- ACDA Team 5
-- PART 1: DROP ALL TABLES (run this first, before any re-run)
-- ============================================================

IF OBJECT_ID('Delivery',           'U') IS NOT NULL DROP TABLE Delivery;
IF OBJECT_ID('SupplierHasShipment','U') IS NOT NULL DROP TABLE SupplierHasShipment;
IF OBJECT_ID('ShipmentToWarehouse','U') IS NOT NULL DROP TABLE ShipmentToWarehouse;
IF OBJECT_ID('ShipItem',           'U') IS NOT NULL DROP TABLE ShipItem;
IF OBJECT_ID('OrderItem',          'U') IS NOT NULL DROP TABLE OrderItem;
IF OBJECT_ID('Stop',               'U') IS NOT NULL DROP TABLE Stop;
IF OBJECT_ID('ClientHasPO',        'U') IS NOT NULL DROP TABLE ClientHasPO;
IF OBJECT_ID('SupplierHasPO',      'U') IS NOT NULL DROP TABLE SupplierHasPO;
IF OBJECT_ID('Shipment',           'U') IS NOT NULL DROP TABLE Shipment;
IF OBJECT_ID('Driver',             'U') IS NOT NULL DROP TABLE Driver;
IF OBJECT_ID('Employee',           'U') IS NOT NULL DROP TABLE Employee;
IF OBJECT_ID('Supply',             'U') IS NOT NULL DROP TABLE Supply;
IF OBJECT_ID('Inventory',          'U') IS NOT NULL DROP TABLE Inventory;
IF OBJECT_ID('Item',               'U') IS NOT NULL DROP TABLE Item;
IF OBJECT_ID('Zone',               'U') IS NOT NULL DROP TABLE Zone;
IF OBJECT_ID('PurchaseOrder',      'U') IS NOT NULL DROP TABLE PurchaseOrder;
IF OBJECT_ID('Staff',              'U') IS NOT NULL DROP TABLE Staff;
IF OBJECT_ID('Vehicle',            'U') IS NOT NULL DROP TABLE Vehicle;
IF OBJECT_ID('Route',              'U') IS NOT NULL DROP TABLE Route;
IF OBJECT_ID('Supplier',           'U') IS NOT NULL DROP TABLE Supplier;
IF OBJECT_ID('Product',            'U') IS NOT NULL DROP TABLE Product;
IF OBJECT_ID('Warehouse',          'U') IS NOT NULL DROP TABLE Warehouse;
IF OBJECT_ID('Client',             'U') IS NOT NULL DROP TABLE Client;

