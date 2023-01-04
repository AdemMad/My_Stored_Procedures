create proc my_proc_2
@dimension varchar (100) = 'month',
@measure varchar (100) = 'units_sold'

as
begin
exec(
'declare @table table (
Region varchar (50) ,
Country varchar (50) ,
product varchar (50), 
Sales_Channel   varchar (50), 
Order_Priority varchar (50) ,
Order_Date  varchar (50),
year as year(order_date),
month as datename(month ,order_date),
day as month(order_date),
Order_ID int    ,
Ship_Date   varchar (50),
Units_Sold int  ,
Unit_Price  float,
Unit_Cost   float,
Total_Revenue   float,
Total_Cost  float,
Total_Profit float
)
insert into @table
select Region,  Country,    Item_Type as product,   Sales_Channel,  Order_Priority, Order_Date, Order_ID, Ship_Date ,Units_Sold ,Unit_Price ,Unit_Cost  ,Total_Revenue  ,Total_Cost ,Total_Profit
from sales
select '+@dimension+' as '+@dimension+', round(sum('+@measure+'), 2) as '+@measure+'
from  @table
group by '+@dimension+'
');
end
;

exec my_proc_2 'month', 'units_sold'