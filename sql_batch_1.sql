USE AdventureWorks2014

--A first 20 employees who  joined early

SELECT top 20 e.HireDate 
FROM HumanResources.Employee e
order by e.HireDate 

--B find all employees, jobtitle,card details  whose credit card expired in the month 9 and year 2009

select p.BusinessEntityID,p.FirstName,e.JobTitle,c.ExpMonth,c.ExpMonth
from HumanResources.Employee e,
Sales.CreditCard c,Person.Person p,Sales.PersonCreditCard cc
where e.BusinessEntityID=p.BusinessEntityID
and cc.CreditCardID=c.CreditCardID 
and cc.BusinessEntityID=p.BusinessEntityID and c.ExpMonth= 9
and c.ExpYear=2009

select* from Sales.CreditCard
where ExpMonth='9' and ExpYear='2009'
--NO RECORDS FOUND


--c find store addresss and contact no. based on tables 
--store and business entity check if any other table is requries
select* from Sales.Store s
select* from Person.BusinessEntity
select* from person.PersonPhone
select* from Person.BusinessEntityAddress

select pa.AddressLine1,pp.PhoneNumber
from Sales.Store as ss,
Person.Address as pa,
Person.BusinessEntityAddress as bd,
Person.PersonPhone as pp
where ss.BusinessEntityID = pp.BusinessEntityID
and pa.AddressID = bd.AddressID;


--D any employee having payment revisions from job candidate table

select * 
from HumanResources.EmployeePayHistory
where BusinessEntityID in 
(select eph.BusinessEntityID
from HumanResources.JobCandidate as j,
HumanResources.EmployeePayHistory eph
where j.BusinessEntityID = eph.BusinessEntityID);


--E CHECK COLOR WISE STANDARD COST
select distinct color,
sum(standardcost) over (partition by color) as standardcost
from Production.Product 

--F which product is purchased more

select distinct top 1 pod.ProductID,pp.Name,
sum(pod.OrderQty) over (partition by pod.ProductID) as total_orderqty
from Purchasing.PurchaseOrderDetail as pod,
Production.Product as pp
where pp.ProductID = pod.ProductID
order by total_orderqty desc;


--G find the total values of line total product having
--maximum order

select distinct p.ProductID,
sum(LineTotal) over (partition by ProductID) lnttl,
sum(orderqty) over (partition by ProductID) ordqty
from Purchasing.PurchaseOrderDetail p
order by ordqty desc

--H) which product is the oldest product as on the date (product sell start date)
select ProductID,Name,SellStartDate 
from Production.Product
order by SellStartDate;

--I) find all the employees whose salary is more than the average salary
select * from HumanResources.EmployeePayHistory

select distinct e.BusinessEntityID, p.FirstName, p.LastName, 
(select avg(rate) from HumanResources.EmployeePayHistory) avg_salary 
from HumanResources.Employee e,
Person.Person p
where e.BusinessEntityID = p.BusinessEntityID
and e.BusinessEntityID in 
(select BusinessEntityID 
from HumanResources.EmployeePayHistory 
where rate >(select avg(rate) 
from HumanResources.EmployeePayHistory))

--J) Display country region code,group average sales quota based on territory id

select distinct st.TerritoryID,st.CountryRegionCode,st.[Group],
avg(sp.salesquota) over (partition by sp.territoryid) as avg_salequota
from Sales.SalesTerritory as st,
Sales.SalesPerson as sp
where st.TerritoryID = sp.TerritoryID;


--K)Find the average age of male and female

select gender,
avg(DATEDIFF(year,BirthDate,HireDate)) as avg_age
from HumanResources.Employee
group by Gender;

--L)which product is purchased more?(purchase order details)

select ProductID,sum(orderqty) as tol_ordqty
from Purchasing.PurchaseOrderDetail
group by ProductID
order by tol_ordqty desc;

--M) check for sales person details which are working in stores(find the sales person id)

select distinct s.[Name],p.FirstName
from sales.Store as s,
Sales.SalesPerson as sp,
Person.Person as p
where s.SalesPersonID=sp.BusinessEntityID
and p.BusinessEntityID = sp.BusinessEntityID


--N)display the product name and product price and count of product cost revised (productcosthistory)

select pp.Name,th.ActualCost,count(pch.ProductID) as prod_cnt
from Production.Product as pp,
Production.ProductCostHistory as pch,
Production.TransactionHistory as th
where pp.ProductID = pch.ProductID
and th.ProductID = pp.ProductID
group by pp.name,th.ActualCost
having count(pch.ProductID) > 1

--O)check the department having more salary revision

select  edh.DepartmentID,d.Name,
count(eph.payfrequency) as payfreq
from HumanResources.EmployeePayHistory as eph,
HumanResources.EmployeeDepartmentHistory as edh,
HumanResources.Department as d
where eph.BusinessEntityID = edh.BusinessEntityID
and edh.DepartmentID = d.DepartmentID
group by edh.DepartmentID,d.Name
having count(eph.payfrequency)>1
