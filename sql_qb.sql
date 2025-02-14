use AdventureWorks2022;

---1) find the average currency rate conversion from USD to Algerian Dinar and Australian Doller  
select * from Sales.Currency;
select * from Sales.CurrencyRate;

select cr.FromCurrencyCode,cr.ToCurrencyCode,cr.AverageRate 
from Sales.CurrencyRate as cr,
Sales.Currency as sc
where cr.ToCurrencyCode = sc.CurrencyCode
and cr.FromCurrencyCode='USD'
and cr.ToCurrencyCode in ('DZD','AUD')
---group by cr.FromCurrencyCode,cr.ToCurrencyCode,cr.AverageRate

---2)Find the products having offer on it and display product name , 
---safety Stock Level, Listprice,  and product model id, type of discount, 
---percentage of discount,  offer start date and offer end date 
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product;

select pp.Name,pp.SafetyStockLevel,pp.ListPrice,pp.ProductModelID,
so.Type,so.DiscountPct,so.StartDate,so.EndDate
from Sales.SpecialOffer as so,
Sales.SpecialOfferProduct as sop,
Production.Product as pp
where sop.ProductID = pp.ProductID
and sop.SpecialOfferID = so.SpecialOfferID

---3)create  view to display Product name and Product review 

---4)find out the vendor for product paint, Adjustable Race and blade
select* from Purchasing.ProductVendor;
select * from Purchasing.Vendor;
select * from production.product;

select pp.Name,pv.Name as vendorname  
---count(*) as quantity ---,pp.ProductID
from Purchasing.Vendor as pv,
production.product as pp,
Purchasing.ProductVendor as ppv
where (pv.BusinessEntityID = ppv.BusinessEntityID
and ppv.ProductID = pp.ProductID)
and (pp.Name like '%paint%' 
or pp.Name like '%Adjustable Race%'
or pp.name like '%Blade%')
group by pp.Name,pv.Name ;

--- 5) find product details shipped through ZY - EXPRESS 
select * from Purchasing.ShipMethod;
select * from Purchasing.PurchaseOrderHeader;
select * from Production.Product;
select * from Purchasing.PurchaseOrderDetail;

select distinct pr.ProductID ,pr.Name,sm.Name
from purchasing.ShipMethod as sm,
Purchasing.PurchaseOrderHeader  as poh,
Production.Product as pr,
Purchasing.PurchaseOrderDetail as pod
where sm.ShipMethodID=poh.ShipMethodID
and pr.ProductID = pod.ProductID
and poh.PurchaseOrderID = pod.PurchaseOrderID
and sm.Name like '%ZY%';

--- 6) find the tax amt for products where order date and ship date are on the same day 
select * from Sales.SalesOrderHeader;
select * from Purchasing.PurchaseOrderHeader;
select * from Production.Product;

select sod.TaxAmt,poh.TaxAmt,sod.OrderDate,poh.ShipDate
from Sales.SalesOrderHeader as sod,
Purchasing.PurchaseOrderHeader as poh
where sod.ShipMethodID = poh.ShipMethodID
and sod.OrderDate = poh.ShipDate;

---7)find the average days required to ship the product based on shipment type. 
select * from Sales.SalesOrderHeader;
select * from Purchasing.PurchaseOrderHeader;

select sm.Name as shipname,
AVG(datediff(day,po.OrderDate,po.ShipDate))
from Purchasing.PurchaseOrderHeader as po,
Purchasing.ShipMethod as sm
where po.ShipMethodID = sm.ShipMethodID
and po.ShipDate is not null
group by sm.name;

---8)find the name of employees working in day shift 
select * from Person.Person;
select * from HumanResources.EmployeeDepartmentHistory;
SELECT * from HumanResources.Shift;

select p.FirstName,p.LastName,s.ShiftID,s.Name 
from Person.Person as p,
HumanResources.EmployeeDepartmentHistory as ed,
HumanResources.Shift as s,
HumanResources.Employee as e
where p.BusinessEntityID = ed.BusinessEntityID
and e.BusinessEntityID = p.BusinessEntityID
and s.ShiftID = ed.ShiftID
and s.ShiftID = 1
and ed.EndDate is null

---9)based on product and product cost history find the name , service provider time and average Standardcost   
select * from Production.Product;
select * from Production.ProductCostHistory;

select p.ProductID,p.Name,
avg(DATEDIFF(day,pc.StartDate,pc.EndDate)),
avg(pc.standardcost) as stdcost
from Production.Product as p,
Production.ProductCostHistory as pc
where p.ProductID = pc.ProductID
group by p.ProductID,p.Name;

---10) find products with average cost more than 500
select * from Production.Product;
select * from Production.ProductCostHistory;

select p.ProductID,p.Name,
avg(p.standardcost) as stdcost
from Production.Product as p
group by p.ProductID,p.Name
having avg(p.standardcost) > 500;

---11)find the employee who worked in multiple territory
select * from Person.Person;
select * from Sales.SalesTerritory;
select * from Sales.SalesTerritoryHistory;

select p.FirstName,count(*) as cnt
from Person.Person as p,
Sales.SalesTerritory as st,
Sales.SalesTerritoryHistory as sth
where p.BusinessEntityID = sth.BusinessEntityID
and st.TerritoryID = sth.TerritoryID
group by p.FirstName
having count(*) > 1

---12)find out the Product model name,  product description for culture as Arabic 
select * from Production.ProductModel;
select * from Production.ProductModelProductDescriptionCulture;
select * from Production.ProductDescription;

select pm.Name ,pmd.ProductDescriptionID,pmd.CultureID,pd.Description
from Production.ProductModel as pm,
Production.ProductModelProductDescriptionCulture as pmd,
Production.ProductDescription as pd
where pm.ProductModelID = pmd.ProductModelID
and pd.ProductDescriptionID = pmd.ProductDescriptionID
and pmd.CultureID like '%ar%'

---13)Find first 20 employees who joined very early in the company
select top 20 p.BusinessEntityID,p.FirstName,p.LastName,HireDate 
from HumanResources.Employee as e,
Person.Person as p
where p.BusinessEntityID = e.BusinessEntityID
order by HireDate ;

--- 14)Find most trending product based on sales and purchase.
select * from Purchasing.PurchaseOrderDetail
select * from Sales.SalesOrderDetail

select pod.ProductID
from Purchasing.PurchaseOrderDetail as pod
where pod.ProductID in(select sod.ProductID,sum(orderqty)
from Sales.SalesOrderDetail as sod
group by sod.ProductID)


--- 15)display EMP name, territory name, saleslastyear salesquota and bonus 
select 
	(select firstname from Person.Person as p
	where p.BusinessEntityID = sp.BusinessEntityID) as fname,
	(select [Name] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_name,
	(select [Group] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_grp,
	(select SalesLastYear from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as sales_lastyr,
	salesquota as quota,Bonus as bonus
from Sales.SalesPerson as sp;

---16) display EMP name, territory name, saleslastyear salesquota 
---and bonus from Germany and United Kingdom 
select 
	(select firstname from Person.Person as p
	where p.BusinessEntityID = sp.BusinessEntityID) as fname,
	(select [Name] from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as territoy_name,
	(select SalesLastYear from Sales.SalesTerritory as st
	where st.TerritoryID = sp.TerritoryID) as sales_lastyr,
	salesquota as quota,Bonus as bonus
from Sales.SalesPerson as sp
where TerritoryID in
(select TerritoryID from Sales.SalesTerritory as st where Name = 'Germany' or Name = 'United Kingdom')


---17)Find all employees who worked in all North America territory 

SELECT 
(SELECT CONCAT_WS(' ', p.FirstName, p.LastName) 
FROM Person.Person p
WHERE p.BusinessEntityID = sp.BusinessEntityID)  e_name 
FROM Sales.SalesPerson sp
WHERE sp.TerritoryID IN 
(SELECT st.TerritoryID 
FROM Sales.SalesTerritory st 
WHERE st.[Group] in ('North America'));


---18)find all products in the cart 
select * from Sales.ShoppingCartItem;

select 
(select name from Production.Product as p
where p.ProductID=sc.ProductID) as prodname,
(select productnumber from Production.Product as p
where p.ProductID = sc.productid)prod
from Sales.ShoppingCartItem as sc;

---19)find all the products with special offer
select * from sales.SpecialOfferProduct
select * from Production.Product
select 
(select name from Production.Product as p
where p.ProductID=so.ProductID) as prodname,
(select productnumber from Production.Product as p
where p.ProductID = so.ProductID) as prod
from sales.SpecialOfferProduct so ;


---20)find all employees name,job title, card details whose 
--credit card expired in the month 11 and year as 2008 
select
(select concat_ws(' ',pp.FirstName,pp.LastName) from Person.person as pp
where pp.BusinessEntityID = pc.BusinessEntityID) as fullname,
(select JobTitle from HumanResources.Employee as e
where e.BusinessEntityID = pc.BusinessEntityID) as jobtitle,
(select concat_ws(' ',CardType,CardNumber) from Sales.CreditCard as cc
where cc.CreditCardID = pc.CreditCardID) as card
from Sales.PersonCreditCard as pc;


--- 21)Find the employee whose payment might be revised  (Hint : Employee payment history) 
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory;
select * from Sales.SalesReason

select BusinessEntityID,
count(*) as cnt
from HumanResources.EmployeePayHistory
group by BusinessEntityID
having COUNT(*) > 1;
--
select * from HumanResources.Employee
where BusinessEntityID not in (select BusinessEntityID
from HumanResources.EmployeePayHistory)

---22)Find total standard cost for the active Product. (Product cost history)
select * from Production.ProductCostHistory;
select * from Production.Product;

select pch.ProductID,sum(pp.standardcost) as total_stdcost
from Production.ProductCostHistory as pch,
Production.Product as pp
where pp.ProductID=pch.ProductID
group by pch.ProductID


---23)Find the personal details with address and address type
---(hint: Business Entiry Address , Address, Address type) 
select* from Person.Address
select * from person.AddressType
select * from Person.BusinessEntityAddress
select * from person.Person;

select concat_ws(' ',p.FirstName,p.LastName) as fullname ,adt.Name ,
CONCAT_ws(' ',pa.AddressLine1,pa.AddressLine2) as full_add
from Person.BusinessEntityAddress as ad,
person.Person as p,
Person.Address as pa,
person.AddressType as adt
where p.BusinessEntityID = ad.BusinessEntityID
and pa.AddressID = ad.AddressID
and adt.AddressTypeID = ad.AddressTypeID

--- 24) Find the name of employees working in group of North America territory 
select * from Sales.SalesTerritory;
select * from Sales.SalesTerritoryHistory
select * from HumanResources.Employee


select concat_ws(' ',p.FirstName,p.lastname) as fullname,st.[Group]
from Sales.SalesTerritory as st,
Sales.SalesTerritoryHistory as sth,
HumanResources.Employee as e,
Person.Person as p
where (st.TerritoryID = sth.TerritoryID
and e.BusinessEntityID = sth.BusinessEntityID
and p.BusinessEntityID = e.BusinessEntityID)
and st.[Group] = 'North America'


---25)Find the employee whose payment is revised for more than once 
select p.FirstName,eph.BusinessEntityID,
count(*) as cnt
from HumanResources.EmployeePayHistory as eph,
Person.Person as p,
HumanResources.Employee as e
where p.BusinessEntityID = eph.BusinessEntityID
and e.BusinessEntityID = p.BusinessEntityID
group by p.FirstName,eph.BusinessEntityID
having count(*)>1;


---26) display the personal details of  employee whose payment is revised for more than once. 
select p.FirstName,eph.BusinessEntityID,
count(*) as cnt
from HumanResources.EmployeePayHistory as eph,
Person.Person as p
where p.BusinessEntityID = eph.BusinessEntityID
group by p.FirstName,eph.BusinessEntityID
having count(*)>1;

---27) Which shelf is having maximum quantity (product inventory)
select shelf,sum(quantity) as qt
from Production.ProductInventory
group by Shelf
order by qt desc;

---28)Which shelf is using maximum bin(product inventory)
select shelf,sum(bin) as tot_bin
from Production.ProductInventory
group by Shelf
order by tot_bin desc;

---29)Which location is having minimum bin (product inventory)
select * from Production.ProductInventory

select LocationID,sum(bin) as tot_bin
from Production.ProductInventory
group by LocationID
order by tot_bin asc;

---30)Find out the product available in most of the locations (product inventory)
select * from Production.ProductInventory

select LocationID,sum(ProductID) as prod
from Production.ProductInventory
group by LocationID
order by prod desc;

---31)Which sales order is having most order quantity.
select * from Sales.SalesOrderDetail

select SalesOrderID,sum(orderqty) as tot_quant
from Sales.SalesOrderDetail
group by SalesOrderID
order by tot_quant desc;

---33)check if any employee from jobcandidate table is having any payment revisions
select * from HumanResources.JobCandidate;
select * from HumanResources.EmployeePayHistory;

select CONCAT_ws(' ',p.FirstName,p.LastName) as fullname,jc.BusinessEntityID
from HumanResources.Employee as e,
Person.Person as p,
HumanResources.JobCandidate as jc
where jc.BusinessEntityID =e.BusinessEntityID
and p.BusinessEntityID = e.BusinessEntityID


---34)check the department having more salary revision
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory

select dept.DepartmentID,dept.Name,
count(*) as revisions
from HumanResources.Department as dept,
HumanResources.EmployeePayHistory as eph,
HumanResources.EmployeeDepartmentHistory as edh
where dept.DepartmentID = edh.DepartmentID
and eph.BusinessEntityID = edh.BusinessEntityID
group by dept.DepartmentID,dept.Name
having count(*) >1
order by revisions desc;

---35)check the employee whose payment is not yet revised 
select * from HumanResources.Employee
where BusinessEntityID not in (select BusinessEntityID
from HumanResources.EmployeePayHistory)

---36) find the job title having more revised payments 
select e.JobTitle,
count(*) as revision
from HumanResources.Employee as e,
HumanResources.EmployeePayHistory as ph
where ph.BusinessEntityID = e.BusinessEntityID
group by e.JobTitle
having count(*) > 0
order by revision desc

---37)find the employee whose payment is revised in shortest duration (inline view)

select t2.businessEntityID, p.firstname,p.lastname,ratechangedate,
concat(year_,'.',month_,'years') as duration
from
(select t1.BusinessEntityID,t1.RateChangeDate,t1.rate_dense_rank,t1.Lagged,
datediff(month,Lagged,RateChangeDate)/12 as year_,
datediff(month,Lagged,RateChangeDate)%12 as month_
from
(select eph.RateChangeDate,eph.BusinessEntityID,
row_number()over(partition by businessentityid order by ratechangedate) as rate_dense_rank,
lag(RateChangeDate,1) over (Partition by BusinessEntityID order by ratechangedate) as Lagged
from HumanResources.EmployeePayHistory eph) as t1
where t1.rate_dense_rank > 1) as t2,PERSON.Person p
where p.BusinessEntityID=t2.BusinessEntityID
order by duration;

---38)find the colour wise count of the product (tbl: product) 
select Color,count(*) as cnt
from Production.Product
group by Color


---39)find out the product who are not in position to sell 
---(hint: check the sell start and end date) 
select  * 
from Production.Product
where SellEndDate is not null

---40) find the class wise, style wise average standard cost 
select * from production.Product;

select productid,
avg(StandardCost) over (partition by class) as classwise,
avg(StandardCost) over (partition by style) as stylewise
from production.Product;

---41) check colour wise standard cost
select distinct color,
sum(StandardCost) over (partition by color) as stdcost
from Production.Product
where color is not null

---42)find the product line wise standard cost
select * from Production.Product;

select distinct ProductLine,
sum(StandardCost) over (partition by productline) as stdcost
from Production.Product
--where ProductLine is not null

---43)Find the state wise tax rate (hint: Sales.SalesTaxRate, Person.StateProvince)
select * from Sales.SalesTaxRate;
select * from Person.StateProvince;

select tr.StateProvinceID,sp.StateProvinceCode,sp.CountryRegionCode,
sum(tr.TaxRate) over (partition  by tr.StateProvinceID) as tot_taxrate
from Sales.SalesTaxRate as tr,
Person.StateProvince as sp
where tr.StateProvinceID = sp.StateProvinceID

---44)	Find the department wise count of employees
select distinct Departmentid,
count(BusinessEntityID) over (partition by Departmentid) as emp_cnt
from HumanResources.EmployeeDepartmentHistory

select * from HumanResources.EmployeeDepartmentHistory

---45)	Find the department which is having more employees
select distinct top 1 Departmentid,
count(BusinessEntityID) over (partition by Departmentid) as emp_cnt
from HumanResources.EmployeeDepartmentHistory
order by emp_cnt desc

---46)	Find the job title having more employees
select * from HumanResources.Employee

select distinct  Jobtitle,
count(BusinessEntityID) over (partition by Jobtitle) as emp_cnt
from HumanResources.Employee
order by emp_cnt desc

---47)	Check if there is mass hiring of employees on single day
select distinct HireDate,
count(BusinessEntityID) as emp_cnt --over (partition by HireDate) as emp_cnt
from HumanResources.Employee
group by HireDate
having count(BusinessEntityID) > 1
order by emp_cnt desc;

---48)	Which product is purchased more? (purchase order details)
select * from Purchasing.PurchaseOrderDetail;
select * from Production.Product;

select distinct top 1 pod.ProductID,pp.Name,
sum(pod.OrderQty) over (partition by pod.ProductID) as total_orderqty
from Purchasing.PurchaseOrderDetail as pod,
Production.Product as pp
where pp.ProductID = pod.ProductID
order by total_orderqty desc;

---49)	Find the territory wise customers count   (hint: customer)
---select * from Sales.SalesTerritory
select * from Sales.SalesTerritoryHistory
select * from Sales.Customer

select distinct territoryid,
count(CustomerID) over (partition by territoryid) as cust_cnt
from Sales.Customer

---50)	Which territory is having more customers (hint: customer)
select distinct top 1 territoryid,
count(CustomerID) over (partition by territoryid) as cust_cnt
from Sales.Customer
order by cust_cnt desc

--51.	Which territory is having more stores (hint: customer)
select * from Sales.Customer

select distinct top 1 territoryid,
count(StoreID) over (partition by territoryid) as store_cnt
from Sales.Customer
order by store_cnt desc

--52.	 Is there any person having more than one credit card (hint: PersonCreditCard)
select *
from Sales.PersonCreditCard;

select BusinessEntityID,count(Creditcardid)
from Sales.PersonCreditCard
group by BusinessEntityID
having count(Creditcardid) > 1;
--there is no person having more than one credit card

--53.	Find the product wise sale price (sales order details)
select * from Sales.SalesOrderDetail;

select distinct ProductID,
sum(UnitPrice) over (partition by productid) as salesprice
from Sales.SalesOrderDetail

--54.	Find the total values for line total product having maximum order
select * from Sales.SalesOrderDetail

select distinct linetotal,
sum(OrderQty) over (partition by linetotal) as ord
from Sales.SalesOrderDetail
order by ord desc

--55.	Calculate the age of employees
select BusinessEntityID,
DATEDIFF(year,BirthDate,HireDate) as age
from HumanResources.Employee

--56.	Calculate the year of experience of the employee based on hire date
select BusinessEntityID,
sum(DATEDIFF(year,StartDate,EndDate)) as tot_yrs_exp
from HumanResources.EmployeeDepartmentHistory
group by BusinessEntityID
having sum(DATEDIFF(year,StartDate,EndDate)) is not null

--57.	Find the age of employee at the time of joining
select e.BusinessEntityID,
DATEDIFF(year,e.BirthDate,edh.StartDate) currentage
from HumanResources.EmployeeDepartmentHistory as edh,
HumanResources.Employee as e
where edh.BusinessEntityID = e. BusinessEntityID

--58.	Find the average age of male and female
select gender,
avg(DATEDIFF(year,BirthDate,HireDate)) as avg_age
from HumanResources.Employee
group by Gender;

--59.	 Which product is the oldest product as on the date (refer  the product sell start date)
select ProductID,Name,SellStartDate 
from Production.Product
order by SellStartDate;

--60.Display the product name, standard cost, 
--and time duration for the same cost. (Product cost history)
select * from Production.ProductCostHistory
select * from Production.Product

select p.Name,p.StandardCost,pch.startdate,pch.enddate,
DATEDIFF(YEAR,pch.StartDate,pch.EndDate) as timeduration
from Production.ProductCostHistory as pch
join Production.Product as p
on p.ProductID = pch.ProductID
where pch.enddate is not null
order by p.Name,p.StandardCost

---61.	Find the purchase id where shipment is done 1 month later of order date  
select distinct PurchaseOrderID,
datediff(month,OrderDate,ShipDate) dt
from Purchasing.PurchaseOrderHeader
where datediff(month,OrderDate,ShipDate) = 1 

---62.	Find the sum of total due where shipment is done 1 month later of order date ( purchase order header)
select PurchaseOrderID,sum(TotalDue) as sumtot
from Purchasing.PurchaseOrderHeader
where datediff(month,OrderDate,ShipDate) = 1
group by PurchaseOrderID

---63.	 Find the average difference in due date and ship date 
--based on  online order flag
select *from sales.SalesOrderHeader

select avg(datediff(day ,ShipDate,DueDate)) as avg_due_ship_diff , OnlineOrderFlag
from sales.SalesOrderHeader
group by OnlineOrderFlag;

---64.	Display business entity id, marital status, gender, vacationhr, average vacation based on marital status
select BusinessEntityID,MaritalStatus,gender, VacationHours,
            avg(vacationhours) over (partition by maritalstatus) vac_based_on_marital_status
from HumanResources.Employee

---65.	Display business entity id, marital status, gender, vacationhr, average vacation based on gender
select BusinessEntityID,MaritalStatus,gender, VacationHours,
      AVG(vacationhours) over (partition by gender) gender_wise_vacc
from HumanResources.Employee

---66.	Display business entity id, marital status, gender, vacationhr, average vacation based on organizational level
select BusinessEntityID,MaritalStatus,gender, VacationHours,
      avg(vacationhours) over (partition by organizationlevel)
from HumanResources.Employee

---67.	Display entity id, hire date, department name and department wise count of employee and count based on organizational level in each dept
select  OrganizationLevel , d.DepartmentID,
      count(e.BusinessEntityID)  over (partition by d.departmentid ) dept_wise_emp,
      count(d.DepartmentID) over (partition by organizationlevel) org_wise_depart
from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory h
on h.BusinessEntityID=e.BusinessEntityID
join HumanResources.Department d
on h.DepartmentID= d.DepartmentID

---68.	Display department name, average sick leave and sick leave per department
select d.Name AS DepartmentName ,
            avg( e.SickLeaveHours) over (partition by d.departmentid) sickleaves ,
       sum( e.SickLeaveHours) over ( partition by d.DepartmentID) avg_sick_leaves
from  HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory h
on h.BusinessEntityID=e.BusinessEntityID
join HumanResources.Department d
on h.DepartmentID= d.DepartmentID  

---69.	Display the employee details first name, last name,  with total count of various shift done by the person and shifts count per department
select CONCAT_WS(' ',p.firstname, p.lastname),
            h.shiftid, d.name d_name, s.name shift_name,
            count(s.ShiftID) over (partition by d.name) dpt_count
      from Person.Person p
join  HumanResources.EmployeeDepartmentHistory h
on p.BusinessEntityID = h.BusinessEntityID
join HumanResources.Department d
on d.DepartmentID = h.DepartmentID
join HumanResources.Shift s
on s.shiftid = h.shiftid  


---70.	Display country region code, group average sales quota based on territory id
select  distinct(t.TerritoryID),t.CountryRegionCode ,
t.[Group],avg(p.SalesQuota) over (partition by p.territoryId)
from sales.SalesPerson p
join  Sales.SalesTerritory t
on t.TerritoryID = p.TerritoryID

---71.	Display special offer description, category and avg(discount pct) per the category
select s.[description],s.Category,s.DiscountPct,
            avg(s.discountpct) over (partition by s.category) avg_disc_per_cat
from  sales.SpecialOffer s

---72.	Display special offer description, category and avg(discount pct) per the month
select s.[description],s.Category,s.DiscountPct,s.startdate,
            avg(s.discountpct) over (partition by MONTH(startdate)) avg_disc_per_month
from  sales.SpecialOffer s

---73.	Display special offer description, category and avg(discount pct) per the year
select s.[description],s.Category,s.DiscountPct,s.startdate,
            avg(s.discountpct) over (partition by year(startdate)) avg_disc_per_yr
from  sales.SpecialOffer s

---74.	Display special offer description, category and avg(discount pct) per the type
select s.[description],s.Category,s.DiscountPct,s.[type],
            avg(s.discountpct) over (partition by s.[type]) avg_disc_per_month
from  sales.SpecialOffer s

---75.	Using rank and dense rand find territory wise top sales person
select p.firstname,sth.TerritoryID,
sum(p.FirstName) over (partition by sth.territoryid),
rank() over (order by p.FirstName) as rankper,
dense_rank() over (order by p.FirstName) as denserankper
from Sales.SalesTerritoryHistory as sth,
Sales.SalesPerson as sp,
Person.Person as p
where sp.BusinessEntityID = sth.BusinessEntityID
and p.BusinessEntityID = sp.BusinessEntityID
