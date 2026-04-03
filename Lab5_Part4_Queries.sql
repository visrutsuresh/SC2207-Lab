-- ============================================================
-- Lab 5 — GlobalLogistics Database
-- ACDA Team 5
-- PART 4: APPENDIX B QUERIES
-- ============================================================
USE Lab5;

--Q1: Top 3 clients per warehouse (by total PO value)
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


-- Q2: Singapore vs Los Angeles total business
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


--Q3: Top 3 months by PO count (last 2 years)
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


-- Q4: Average time from order to warehouse delivery (months)
SELECT
    ROUND(AVG(
        CAST(DATEDIFF(DAY, po.OrderDate, d.DelDate) AS FLOAT)
        / 30.44
    ), 2) AS Avg_Months_Order_To_Delivery
FROM PurchaseOrder po
JOIN Shipment  s ON po.OID         = s.OID
JOIN Delivery  d ON d.Shipment_ID  = s.Shipment_ID;


--Q5: Suppliers that ship only to Singapore
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


--Q6: Suppliers not in Thailand AND shipped all Singapore products
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
    );


--Q7: Departure locations with the most delayed shipments
SELECT
    OGLocation       AS DepartureLocation,
    COUNT(*)         AS DelayCount
FROM Shipment
WHERE AccArrDate IS NOT NULL
  AND DATEDIFF(MONTH, ExArrDate, AccArrDate) > 6
GROUP BY OGLocation
ORDER BY DelayCount DESC;
