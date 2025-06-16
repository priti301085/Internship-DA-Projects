use mahendra;


LOAD DATA INFILE '\SUPPLY_CHAIN.csv' 
INTO TABLE supply_chain 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

commit;


# 1.Total sales(MTD;QTD;YTD)-----------------------------------------------

use mahendra;

select *from calendar;
select *from point_sale;
select*from sales;
select * from calendar c join sales s on date(c.date)=date(s.date);
select*from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number;
 
select Fiscal_Year,sum(Sales_Amount) Total_sale from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number
group by Fiscal_Year order by Fiscal_Year;
select Fiscal_Year,Fiscal_Quarter,sum(Sales_Amount) Total_sale from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number
group by Fiscal_Year,Fiscal_Quarter order by Fiscal_Year,Fiscal_Quarter;
select Fiscal_Year,monthname(c.Date) as month ,sum(Sales_Amount) Total_sale from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number
group by Fiscal_Year,monthname(c.Date) order by Fiscal_Year,monthname(c.Date);

# 2.Product Wise Sales------------------------------------------------------

select * from inventory;
select * from point_sale;
select * from inventory i join point_sale ps on i.Product_Key=ps.Product_key;

select Product_Type, sum(Sales_Amount) Total_sale from inventory i join point_sale ps on i.Product_Key=ps.Product_key group by  Product_Type order by  sum(Sales_Amount) desc ;


# 3.Sales Growth-----------------------------------------------------------

select *from calendar;
select*from point_sale;
select*from sales;
select * from calendar c join sales s on date(c.date)=date(s.date);
select*from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number;

select distinct Fiscal_Year as Year,sum(Sales_Amount),(sum(Sales_Amount) - lag(sum(Sales_Amount)) OVER (order by Fiscal_Year)) as yoy,
concat (round((sum(Sales_Amount) - lag(sum(Sales_Amount)) OVER (order by Fiscal_Year))/lag(sum(Sales_Amount)) OVER (order by Fiscal_Year) *100),"%") as "% yoy change"
 from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number 
group by Fiscal_Year order by Fiscal_Year;

# 4.Daily Sales Trend--------------------------------------------------

select*from point_sale;
select*from sales;
select * from  point_sale ps join sales s on ps.Order_Number=s.Order_Number;
select day(s.Date),sum(Sales_Amount) from  point_sale ps join sales s on ps.Order_Number=s.Order_Number group by day(s.Date) order by day(s.Date);

select distinct date(s.date),sum(Sales_Amount),(sum(Sales_Amount) - lag(sum(Sales_Amount)) OVER (order by date(s.date))) as "yoy",
concat (round((sum(Sales_Amount) - lag(sum(Sales_Amount)) OVER (order by date(s.date)))/lag(sum(Sales_Amount)) OVER (order by date(s.date)) *100),"%") as "% yoy change"
 from calendar c join sales s on date(c.date)=date(s.date) join point_sale ps on ps.Order_Number= s.Order_Number 
group by date(s.date) order by date(s.date);

# 5.State Wise Sales----------------------------------------------

select*from store;
select*from sales;
select*from point_sale;
select*from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number;
select Store_State,sum(Sales_Amount)from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number
group by Store_State order by sum(Sales_Amount) desc ;

# 6.Top 5 Stores Wise Sales----------------------------------------------

select*from store;
select*from sales;
select*from point_sale;
select*from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number;
select Store_Name,sum(Sales_Amount)from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number
group by Store_Name order by sum(Sales_Amount) desc limit 5  ;


# 7.Region Wise Sales-------------------------------------------------------------

select*from store;
select*from sales;
select*from point_sale;
select*from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number;
select Store_Region ,sum(Sales_Amount)from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number
group by Store_Region order by sum(Sales_Amount) desc ;

select distinct Store_Region,sum(Sales_Amount) OVER (PARTITION BY Store_Region) Sale_Amount,
concat(Round(sum(Sales_Amount) OVER (PARTITION BY Store_Region)/sum(Sales_Amount) OVER () *100,2),'%')  Sales_Percentage  
from store ss join sales s on ss.Store_Key= s.Store_Key join point_sale ps on ps.Order_Number= s.Order_Number order by 2 desc ;



# 8.Total Inventory----------------------------------------------------------
 
select * from inventory;
select sum(Quantity_on_Hand) as Total_Inventory from inventory;

# 9.Inventory Value------------------------------------------------------------

select * from inventory;
select sum(price) from inventory;
select round(sum(Cost_Amount),2) as inventory_value from inventory;

# 10.Over stock, Out Stock , Under stock(In-stock = Inventory in hand >= 0), (Out-of-stock = Inventory in hand <0 ),(Under-stock = Inventory in hand < Stock quantity)-----------

select count(*) from inventory ;

select product_Name, Quantity_on_Hand, 
case 
when Quantity_on_Hand >=0 then "In-stock"
when Quantity_on_Hand <=0 then "Out-of-stock"
when Quantity_on_Hand <2 then "Under-stock" 
end as STOCK from inventory;

select 
case 
when Quantity_on_Hand >=0 then "In-stock"
when Quantity_on_Hand < 0 then "Out-of-stock"
when Quantity_on_Hand <1 then "Under-stock" 
end as STOCK ,count(*) from inventory
group by 
case 
when Quantity_on_Hand >=0 then "In-stock"
when Quantity_on_Hand <0 then "Out-of-stock"
when Quantity_on_Hand <1 then "Under-stock" 
end;

select case
when Quantity_on_Hand >=2 then "In-stock"
when Quantity_on_Hand <0 then "Out-of-stock"
when Quantity_on_Hand < 2 then "Under-stock" 
end as Stock_Level,count(*) as "# of Produts" from inventory
group by 
case 
when Quantity_on_Hand >=2 then "In-stock"
when Quantity_on_Hand <0 then "Out-of-stock"
when Quantity_on_Hand <2 then "Under-stock" 
end;

# 11.Purchase Method Wise Sales-------------------------------------------------------------------------------------

select*from sales;
select*from point_sale;
select*from point_sale ps join sales s on ps.Order_Number= s.Order_Number ;
select Purchase_Method, sum(Sales_Amount)from point_sale ps join sales s on ps.Order_Number= s.Order_Number group by Purchase_Method order by sum(Sales_Amount) desc ;