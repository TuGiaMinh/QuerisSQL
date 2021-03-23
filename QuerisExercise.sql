--Challenge 1:
--1.
Select distinct a.City, a.StateProvince
From [SalesLT].[Address] a
--2.
Select p1.Name
From [SalesLT].[Product] p1
where p1.Weight is not null and p1.Weight IN (
Select top 10 percent p2.Weight
From [SalesLT].[Product] p2
where p2.Weight is not null 
ORDER BY p2.Weight DESC
)
ORDER BY p1.ListPrice
--3.
Select Top 100 Weight
From [SalesLT].[Product]
Where Weight is not null and Weight not in (
Select Top 10 Weight
From [SalesLT].[Product]
Where Weight is not null
ORDER BY Weight DESC
)
ORDER BY Weight DESC
--Challenge 2
--1.
Select p.Name , p.Color, p.Size
From  [SalesLT].[Product] p
Where p.ProductModelID = 1 
--2.
Select *
From  [SalesLT].[Product] p
Where (p.color like 'Black' or  p.color like 'Red' or p.color like 'White') and (p.Size like 'S' or p.Size like 'M')
--3
Select p.ProductNumber , p.Name, p.ListPrice
From  [SalesLT].[Product] p
Where p.ProductNumber like 'BK-%'
--4
Select p.ProductNumber , p.Name, p.ListPrice
From  [SalesLT].[Product] p
Where p.ProductNumber like 'BK%-[^R]%-[0-9][0-9]'
--Challenge 3
--1.
Select c.CompanyName ,s.TotalDue
From [SalesLT].[Customer] c 
inner join [SalesLT].[SalesOrderHeader] s on c.CustomerID = s.CustomerID
--2.
Select a.AddressLine1,a.City,a.StateProvince,a.CountryRegion,a.PostalCode
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Main Office' 
--Challenge 4
--1
Select c.CompanyName, c.FirstName,c.LastName,s.SalesOrderID ,s.TotalDue
From [SalesLT].[SalesOrderHeader] s
right join [SalesLT].[Customer] c  on c.CustomerID = s.CustomerID
ORDER BY s.SalesOrderID DESC
--2
Select c.CustomerID,c.CompanyName, c.FirstName,c.LastName,c.Phone
From [SalesLT].[Customer] c
where c.CustomerID not in (
Select ca.CustomerID
From [SalesLT].[CustomerAddress] ca
)
--3
select  CustomerID, NUll as ProductID 
from [SalesLT].[Customer] as c
where c.CustomerID not in (
select distinct  h.CustomerID 
from [SalesLT].[SalesOrderHeader] as h
)
Union
select Null as CustomerID, ProductID 
from [SalesLT].[Product]  as p
where p.ProductID not in (
select distinct d.ProductID		
from [SalesLT].[SalesOrderDetail] as d
)
--Challenge 5
--1.
Select c.CompanyName,a.AddressLine1,a.City,
CASE
    WHEN ca.AddressType like 'Main Office' THEN 'Billing'
    ELSE null
END as AddressType
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Main Office' 
--2.
Select c.CompanyName,a.AddressLine1,a.City,
CASE
    WHEN ca.AddressType like 'Shipping' THEN 'Billing'
    ELSE null
END as AddressType
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Shipping' 
--3.
Select c.CompanyName,a.AddressLine1,a.City,
CASE
    WHEN ca.AddressType like 'Main Office' THEN 'Billing'
    ELSE null
END as AddressType
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Main Office' 
Union
Select c.CompanyName,a.AddressLine1,a.City, AddressType
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Shipping'
Order by c.CompanyName,a.AddressLine1
--Challenge 6
--1.
Select c.*
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
EXCEPT
Select c.*
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Shipping'
--2
Select c.*
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Shipping'
Intersect
Select c.*
From  [SalesLT].[CustomerAddress] ca
inner join [SalesLT].[Customer] c  on c.CustomerID = ca.CustomerID
inner join [SalesLT].[Address] a  on a.AddressID = ca.AddressID
Where ca.AddressType like 'Main Office'
--Challenge 7
--1.
Select p.ProductID,UPPER(p.Name) 'Upper Name',Round(ISNULL(p.Weight,0),0) 'ApproxWeight'
From [SalesLT].[Product] p
--2.
Select p.SellStartDate, Format(p.SellStartDate,'MMMM') as SellStartMonth, Year(p.SellStartDate) as SellStartYear
From [SalesLT].[Product] p
--3.
Select Left(p.ProductNumber,2) as ProductType
From [SalesLT].[Product] p
--4.
Select p.Size
From [SalesLT].[Product] p
where isnumeric(p.Size)=1
--Challenge 8
--1.
Select c.CompanyName,Rank() OVER( ORDER By h.[TotalDue]) as 'Rank'
From [SalesLT].[SalesOrderHeader] h
inner join [SalesLT].[Customer] c  on c.CustomerID = h.CustomerID
--2.
Select p.Name,t.Total
From [SalesLT].[Product] p
inner join(
Select Sum(d.LineTotal) Total, d.ProductID
From  [SalesLT].[SalesOrderDetail] d
Group By d.ProductID) as t on t.ProductID=p.ProductID
Order By t.Total
--3.
Select p.Name,t.Total,p.ListPrice
From [SalesLT].[Product] p
inner join(
Select Sum(d.LineTotal) Total, d.ProductID
From  [SalesLT].[SalesOrderDetail] d
Group By d.ProductID) as t on t.ProductID=p.ProductID
Where p.ListPrice>1000
Order By t.Total desc
--4
Select p.Name,t.Total,p.ListPrice
From [SalesLT].[Product] p
inner join(
Select Sum(d.LineTotal) Total, d.ProductID
From  [SalesLT].[SalesOrderDetail] d
Group By d.ProductID
Having Sum(d.LineTotal)>20000)
as t on t.ProductID=p.ProductID
Where p.ListPrice>1000
Order By t.Total desc
--Challenge 9 
--1.
Select p.ProductID,p.Name,p.ListPrice
From[SalesLT].[Product] p
Where p.ListPrice >(
Select avg(d.UnitPrice)
From [SalesLT].[SalesOrderDetail] d 
)
--2.
Select p.ProductID,p.Name,p.ListPrice
From[SalesLT].[Product] p
Where p.ProductID in (
Select p1.ProductID
From [SalesLT].[Product] p1
inner join [SalesLT].[SalesOrderDetail] d on d.ProductID=p1.ProductID
Where p1.ListPrice >=100 and d.UnitPrice <100
)
--3
Select p.ProductID,p.Name,p.ListPrice,p.[StandardCost],avg(p1.UnitPrice) as AVGUnitPrice
From[SalesLT].[Product] p
inner join [SalesLT].[SalesOrderDetail] as p1 on p1.ProductID= p.ProductID
Group by p.ProductID,p.Name,p.ListPrice,p.[StandardCost]
--4
Select p.ProductID,p.Name,p.ListPrice,p.[StandardCost],avg(p1.UnitPrice) as AVGUnitPrice
From[SalesLT].[Product] p
inner join [SalesLT].[SalesOrderDetail] as p1 on p1.ProductID= p.ProductID
Group by p.ProductID,p.Name,p.ListPrice,p.[StandardCost]
Having p.[StandardCost]> avg(p1.UnitPrice)
--Challenge 10
--1
Select c.CustomerID, c.FirstName,c.LastName,s.TotalDue
from [SalesLT].[SalesOrderHeader] s,[SalesLT].[Customer] c
Cross apply [dbo].[ufnGetCustomerInformation](c.CustomerID)
Where s.CustomerID=c.CustomerID
--2
Select c.CustomerID, c.FirstName,c.LastName,a.[AddressLine1],a.[City]
from [SalesLT].[CustomerAddress] s
inner join [SalesLT].[Customer] c on s.CustomerID=c.CustomerID
inner join [SalesLT].[Address] a on s.[AddressID]=a.[AddressID]
Cross apply [dbo].[ufnGetCustomerInformation](s.CustomerID)