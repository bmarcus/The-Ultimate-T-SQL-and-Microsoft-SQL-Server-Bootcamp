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
SELECT  SUM(TotalDue) AS [Total Sales Amount], 
		AVG(TotalDue) AS [Average Sales Amount], 
		MIN(TotalDue) AS [Lowest Sales Amount], 
		MAX(TotalDue) AS [Highest Sales Amount]
FROM Sales.SalesOrderHeader