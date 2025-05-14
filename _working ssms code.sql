USE AdventureWorks2022

-- Select all data from a table
--SELECT * FROM HumanResources.Employee

-- Select top 100 records from the table
--SELECT TOP(100) * FROM HumanResources.Employee

-- Select specific columns from the table
--SELECT LoginID, JobTitle, HireDate FROM HumanResources.Employee

-- Select only persons who are Marketing Assistants
--SELECT * FROM HumanResources.Employee
--WHERE JobTitle = 'Marketing Assistant'

-- Select only the employee with the id 20
--SELECT * FROM HumanResources.Employee
--WHERE BusinessEntityID = 20

-- Select only the employee with the id 20
--SELECT * FROM HumanResources.Employee
--WHERE JobTitle = 'Marketing Assistant' AND Gender = 'M'

-- Select all employees sorted by hire date
--SELECT * FROM HumanResources.Employee
--ORDER BY HireDate ASC
--ORDER BY HireDate DESC

--Select data with aliased columns
/*
SELECT
	LoginID AS [Login ID],
	JobTitle AS [Job Title],
	HireDate AS [Date of Hire]
FROM HumanResources.Employee
*/

--Select all employees and the departments they represent
/*
SELECT * FROM 
	HumanResources.Employee AS emp
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS hist ON 
		emp.BusinessEntityID = hist.BusinessEntityID
INNER JOIN
	HumanResources.Department AS dept ON
		dept.DepartmentID = hist.DepartmentID
		*/

/*
SELECT emp.JobTitle AS [Job Title], dept.Name AS [Dept Name], emp.SalariedFlag AS [Paid Employee?]  FROM 
	HumanResources.Employee AS emp
INNER JOIN 
	HumanResources.EmployeeDepartmentHistory AS hist ON 
		emp.BusinessEntityID = hist.BusinessEntityID
INNER JOIN
	HumanResources.Department AS dept ON
		dept.DepartmentID = hist.DepartmentID
GROUP BY emp.SalariedFlag, dept.Name, emp.JobTitle
ORDER BY emp.SalariedFlag DESC, dept.Name ASC, emp.JobTitle
*/

-- Select work orders, the product and their scrap reason
/*
SELECT 
    p.Name AS [Product Name],
	p.ProductNumber AS [Product Number],
	wo.WorkOrderID AS [Work Order ID],
    wo.OrderQty AS [Work Order Qty],
    wo.StockedQty AS [Stocked Qty],
    wo.ScrappedQty AS [Scrapped Qty],
    wo.StartDate AS [Start Date],
    sr.Name AS ScrapReasonName
FROM 
    Production.WorkOrder AS wo     
INNER JOIN
    Production.Product AS p ON wo.ProductID = p.ProductID
LEFT JOIN            
    Production.ScrapReason AS sr ON wo.ScrapReasonID = sr.ScrapReasonID;

*/

-- Select all customers and employees into one dataset
/*
SELECT 
    c.CustomerID AS ID,
    'Customer' AS Type,
    c.AccountNumber AS Identifier,
    c.ModifiedDate
FROM 
    Sales.Customer AS c
UNION ALL
SELECT 
    e.BusinessEntityID AS ID,
    'Employee' AS Type,
    e.LoginID AS Identifier,
    e.ModifiedDate
FROM 
    HumanResources.Employee AS e;
*/

-- Eliminate all duplicated names from the customer table
/*
SELECT DISTINCT per.FirstName, per.LastName FROM Sales.Customer AS cust
INNER JOIN person.Person AS per 
ON per.BusinessEntityID = cust.PersonID
ORDER BY per.FirstName

SELECT per.FirstName, per.LastName FROM Sales.Customer AS cust
INNER JOIN person.Person AS per 
ON per.BusinessEntityID = cust.PersonID
GROUP BY per.FirstName, per.LastName
ORDER BY per.FirstName
*/

-- Find the number of customers
/*SELECT COUNT(per.FirstName) AS [Number] FROM Sales.Customer AS cust
INNER JOIN person.Person AS per 
ON per.BusinessEntityID = cust.PersonID
*/

-- Find the number of customers with the same first name
/*
SELECT per.FirstName, COUNT(per.FirstName) AS [Number] 
FROM Sales.Customer AS cust
INNER JOIN person.Person AS per 
ON per.BusinessEntityID = cust.PersonID
GROUP BY per.FirstName
ORDER BY per.FirstName
*/

-- Show all customers with the number of first names > 1.
/* 
SELECT per.FirstName, COUNT(per.FirstName) AS [Number] 
FROM Sales.Customer AS cust
INNER JOIN person.Person AS per 
ON per.BusinessEntityID = cust.PersonID
GROUP BY per.FirstName
HAVING COUNT(per.FirstName) > 1
ORDER BY COUNT(per.FirstName)
*/

-- Find total, average, lowest and highest amounts for sales
--SELECT  SUM(TotalDue) AS [Total Sales Amount], 
--		AVG(TotalDue) AS [Average Sales Amount], 
--		MIN(TotalDue) AS [Lowest Sales Amount], 
--		MAX(TotalDue) AS [Highest Sales Amount]
--FROM Sales.SalesOrderHeader

-- Find total, average, lowest and highest amounts of sales for each Sales Person
--SELECT 
--	p.FirstName,
--	p.LastName,
--	COUNT(soh.TotalDue) AS [Number of Sales],
--	SUM(soh.TotalDue) AS [Total Sales],
--	AVG(TotalDue) AS [Average Sales Amount], 
--	MIN(TotalDue) AS [Lowest Sales Amount], 
--	MAX(TotalDue) AS [Highest Sales Amount]
--FROM [Sales].[SalesPerson] AS s 
--INNER JOIN [Person].[Person] AS p
--	ON p.BusinessEntityID = s.BusinessEntityID
--INNER JOIN [Sales].[SalesOrderHeader] AS soh
--	ON soh.SalesPersonID = s.BusinessEntityID
--GROUP BY p.FirstName, p.LastName
--ORDER BY SUM(soh.TotalDue) DESC, p.LastName

-- Format the previous query to have a full name column and currency formatted values
--SELECT 
--	-- p.FirstName + ' ' + p.LastName,
--	CONCAT(p.FirstName, ' ', p.LastName) AS [Full Name],
--	COUNT(soh.TotalDue) AS [Number of Sales],
--	FORMAT(SUM(soh.TotalDue),'C') AS [Total Sales],
--	FORMAT(AVG(TotalDue), 'C') AS [Average Sales Amount], 
--	FORMAT(MIN(TotalDue), 'C') AS [Lowest Sales Amount], 
--	FORMAT(MAX(TotalDue), 'C') AS [Highest Sales Amount]
--FROM [Sales].[SalesPerson] AS s 
--INNER JOIN [Person].[Person] AS p
--	ON p.BusinessEntityID = s.BusinessEntityID
--INNER JOIN [Sales].[SalesOrderHeader] AS soh
--	ON soh.SalesPersonID = s.BusinessEntityID
--GROUP BY p.FirstName, p.LastName

-- Employees who have more vacation available than average
--SELECT
--	BusinessEntityID,
--	LoginID,
--	JobTitle,
--	VacationHours
--FROM HumanResources.Employee
--WHERE VacationHours > (SELECT AVG(VacationHours)
--	                   FROM HumanResources.Employee)
--ORDER BY VacationHours;

--SELECT
--	E1.BusinessEntityID,
--	E1.LoginID,
--	E1.JobTitle,
--	E1.VacationHours,
--	Sub.[Average Vacation] --Drawn from the subquery
--FROM HumanResources.Employee AS E1
--JOIN (SELECT
--		JobTitle,
--		AVG(VacationHours) AS [Average Vacation]
--	  FROM	
--		HumanResources.Employee AS E2
--		GROUP BY JobTitle) AS Sub
--ON E1.JobTitle = Sub.JobTitle
--WHERE E1.VacationHours > Sub.[Average Vacation] AND E1.JobTitle = 'Janitor'
--ORDER BY E1.JobTitle

-- Define the CTE expression name and column list.
--WITH Sales_CTE (SalesPersonID, SalesOrderID, SalesYear)
--AS
---- Define the CTE query
--(
--	SELECT SalesPersonID, SalesOrderID, YEAR(OrderDate) AS SalesYear
--	FROM Sales.SalesOrderHeader
--	WHERE SalesPersonID IS NOT NULL
--)
---- Define the outer query referencing the CTE name.
--SELECT SalesPersonID, COUNT(SalesOrderID) AS TotalSales, SalesYear
--	FROM Sales_CTE
--	GROUP BY SalesYear, SalesPersonID;

-- Define the CTE expression name and column list.
--WITH Sales_CTE 
--AS
---- Define the CTE query.
--(
--    SELECT SalesPersonID, FirstName, SalesOrderID, YEAR(OrderDate) AS SalesYear
--    FROM Sales.SalesOrderHeader
--	INNER JOIN Person.Person
--	ON Sales.SalesOrderHeader.SalesPersonID = Person.Person.BusinessEntityID
--    WHERE SalesPersonID IS NOT NULL
--)
---- Define the outer query referencing the CTE name.
--SELECT SalesPersonID, FirstName, COUNT(SalesOrderID) AS TotalSales, SalesYear
--FROM Sales_CTE
--GROUP BY SalesYear, SalesPersonID, FirstName
--ORDER BY SalesPersonID, FirstName, SalesYear;

--using subquery
SELECT SalesOrderID,CarrierTrackingNumber, OrderQty,
	   (SELECT MAX(UnitPrice) FROM [Sales].[SalesOrderDetail]) AS UnitPrice,
	   (SELECT MIN(UnitPrice) FROM [Sales].[SalesOrderDetail]) AS UnitPrice	
FROM [Sales].[SalesOrderDetail]

-- using OVER
SELECT SalesOrderID,CarrierTrackingNumber, OrderQty,
	MAX(UnitPrice) OVER() AS MaxUnitPrice,
	MIN(UnitPrice) OVER() AS MinUnitPrice	
FROM [Sales].[SalesOrderDetail]

--partitioning the data
SELECT SalesOrderID,CarrierTrackingNumber, OrderQty,
	MAX(UnitPrice) OVER(PARTITION BY SalesOrderID) AS MaxUnitPrice,	
	MIN(UnitPrice) OVER(PARTITION BY SalesOrderID) AS MinUnitPrice
FROM [Sales].[SalesOrderDetail]

--sum by sales order
SELECT SalesOrderID,CarrierTrackingNumber, OrderQty,
	SUM(UnitPrice) OVER(PARTITION BY SalesOrderID) AS Total	
FROM [Sales].[SalesOrderDetail]

-- employees have more vacation hours than average for their job title
SELECT
  E1.BusinessEntityID,
  E1.LoginID,
  E1.JobTitle,
  E1.VacationHours,
  ROW_NUMBER() OVER( ORDER BY E1.LoginID) AS [RowCount]
FROM HumanResources.Employee E1


---Rank employee by vacation hours in the department
SELECT
  E1.BusinessEntityID,
  CONCAT(P1.FirstName, ' ', P1.LastName) AS Name,
  E1.LoginID,
  E1.JobTitle,
  E1.VacationHours,
  RANK() OVER( PARTITION BY E1.JobTitle ORDER BY VacationHours ) AS [Rank]
FROM HumanResources.Employee E1
INNER JOIN Person.Person AS P1
ON E1.BusinessEntityID = P1.BusinessEntityID

UPDATE HumanResources.Employee SET VacationHours = 61
WHERE LoginID = 'adventure-works\deborah0'

---Rank employee by vacation hours in the department
SELECT
  E1.BusinessEntityID,
  E1.LoginID,
  E1.JobTitle,
  E1.VacationHours,
  DENSE_RANK() OVER( PARTITION BY E1.JobTitle ORDER BY VacationHours ) AS [Rank]
FROM HumanResources.Employee E1

-- Finding the employees with the most vacation hours for each job title
WITH CTE
AS
(
  SELECT
  E1.BusinessEntityID,
  E1.LoginID,
  E1.JobTitle,
  E1.VacationHours,
  DENSE_RANK() OVER( PARTITION BY E1.JobTitle ORDER BY VacationHours ) AS [Rank]
  FROM HumanResources.Employee E1
)
SELECT * FROM CTE where [rank]=1

/****** Script for SelectTopNRows command from SSMS  ******/
LEAD(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
LAG(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)

SELECT ProductID,Name,ProductNumber, SafetyStockLevel,
LEAD(SafetyStockLevel,5,0) OVER (ORDER BY ProductID) as NextStockLevel,
LAG(SafetyStockLevel,5,0) OVER (ORDER BY ProductID) as PrevStockLevel
FROM [Production].[Product]

-- Insert new Currency - Cayman Dollar
INSERT INTO [Sales].[Currency] 
(
	[CurrencyCode], 
	[Name],
	[ModifiedDate]
)
VALUES
(
	'KYD',
	'Cayman Dollar',
	GetDate()
)

-- Insert new Currency - Bitcoin - BTC
INSERT INTO [Sales].[Currency] 
VALUES
	('ETH', 'Ethereum',GETDATE()),
	('BCH', 'Bitcoin Cash', GETDATE()),
	('BNB', 'BNB', GETDATE()),
	('XRP', 'XRP', GETDATE())

-- PARTIAL INSERT
INSERT INTO [Sales].[Currency]
(
	[CurrencyCode], 
	[Name]
)
VALUES
(
	'LTC',
	'Litecoin'
)

-- Inserting related data
-- Insert new CountryRegionCurrency - Cayman Island
INSERT INTO sales.CountryRegionCurrency
(
	[CountryRegionCode], 
	[CurrencyCode]
)
VALUES
(	'KY', 
	'KYD'
)

-- Insert new Sales Territory - Jamaica
INSERT INTO [Sales].[SalesTerritory]
(
	[Name],
	[CountryRegionCode],
	[Group]
)
VALUES
(
	'Jamaica',
	'JM',
	'LATAM'
)

-- Insert new Sales Territory with generated rowguid - Cayman Islands
INSERT INTO [Sales].[SalesTerritory]
(
	[Name],
	[CountryRegionCode],
	[Group],
	rowguid
)
VALUES
(
	'Cayman Islands',
	'KY',
	'LATAM',
	NEWID()
)

-- SELECT INTO STATEMENTS
SELECT * INTO [Purchasing].[PurchaseOrderDetailBackup2023]
FROM [Purchasing].[PurchaseOrderDetail]

SELECT [PurchaseOrderID], EmployeeID, OrderDate, TotalDue INTO [Purchasing].[PurchaseOrders2023]
FROM [Purchasing].[PurchaseOrderHeader]

SELECT * INTO [Purchasing].[PurchaseOrderDetailNew]
FROM [Purchasing].[PurchaseOrderDetail]
WHERE 1 = 0

-- UPDATE
SELECT * FROM [Person].[Person]

UPDATE [Person].[Person]
SET Title = 'Mr.'
WHERE BusinessEntityID = 4

UPDATE [Person].[Person]
SET Title = 'Mr.', MiddleName = 'B'
WHERE BusinessEntityID = 10

--Update using join
SELECT P.FirstName, P.LastName, A.AddressLine1, A.City, P.EmailPromotion
FROM  [Person].[Person] P
INNER JOIN [Person].[BusinessEntityAddress] BE ON P.BusinessEntityID = BE.BusinessEntityID
INNER JOIN [Person].[Address] A ON BE.AddressID = A.AddressID
WHERE A.City = 'Bothell'

UPDATE [Person].[Person] SET EmailPromotion = 2
FROM  [Person].[Person]  P
INNER JOIN [Person].[BusinessEntityAddress] BE ON P.BusinessEntityID = BE.BusinessEntityID
INNER JOIN [Person].[Address] A ON BE.AddressID = A.AddressID
WHERE A.City = 'Bothell'

SELECT * FROM [Sales].[SalesPerson]
SELECT * FROM [Sales].[SalesTerritory]

--Update sales person from US region
 SELECT [BusinessEntityID],[Bonus],[CommissionPct]
 FROM [Sales].[SalesPerson] SP
 INNER JOIN [Sales].[SalesTerritory] ST ON SP.TerritoryID = ST.TerritoryID
 WHERE CountryRegionCode = 'US'

 --Update Using Join Statements
 UPDATE [Sales].[SalesPerson]
 SET Bonus += Bonus * 0.5
 FROM [Sales].[SalesPerson] SP
 INNER JOIN [Sales].[SalesTerritory] ST ON SP.TerritoryID = ST.TerritoryID
 WHERE CountryRegionCode = 'US'
 
 --Decrease bonus using CTE
 WITH CTE 
 AS
 (
    SELECT [BusinessEntityID],[Bonus],[CommissionPct]
    FROM [Sales].[SalesPerson] SP
    INNER JOIN [Sales].[SalesTerritory] ST ON SP.TerritoryID = ST.TerritoryID
    WHERE CountryRegionCode = 'US'
 )
 UPDATE CTE SET  Bonus -= Bonus * 0.75

 -- Create table from select statement
DROP TABLE [Person].[PersonDEMO];
SELECT * INTO [Person].[PersonDEMO]
FROM [Person].[Person]

-- delete all rosw in a colum
DELETE FROM [Person].[PersonDEMO]
WHERE MiddleName = 'C'

--delete a single record
DELETE FROM [Person].[Person]
WHERE Title = 'Mr.'

SELECT * FROM [Person].Person
WHERE Title = 'Mr.'

USE AdventureWorks2022
GO

-- VIEWS
CREATE VIEW [Sales].[vSalesPersonsTotal]
AS
SELECT 
	p.FirstName,
	p.LastName,
	COUNT(soh.TotalDue) [Number of Sales],
	SUM(soh.TotalDue) [Total Sales],
	AVG(TotalDue) [Average Sales Amount],
	MIN(TotalDue) [Lowest Sales Amount],
	MAX(TotalDue) [Highest Sales Amount]
FROM [Sales].[SalesPerson] s
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = s.BusinessEntityID
INNER JOIN [Sales].[SalesOrderHeader] soh ON soh.SalesPersonID = s.BusinessEntityID
GROUP BY p.FirstName, p.LastName

ALTER VIEW [Sales].[vSalesPersonsTotal]
AS
SELECT 
	p.FirstName [First Name],
	p.LastName [Last Name],
	COUNT(soh.TotalDue) [Number of Sales],
	SUM(soh.TotalDue) [Total Sales],
	AVG(TotalDue) [Average Sales Amount],
	MIN(TotalDue) [Lowest Sales Amount],
	MAX(TotalDue) [Highest Sales Amount]
FROM [Sales].[SalesPerson] s
INNER JOIN [Person].[Person] p ON p.BusinessEntityID = s.BusinessEntityID
INNER JOIN [Sales].[SalesOrderHeader] soh ON soh.SalesPersonID = s.BusinessEntityID
GROUP BY p.FirstName, p.LastName

DROP VIEW [Sales].[vSalesPersonsTotal]