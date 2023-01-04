declare @my_table table (type varchar (100), all_times_sales float, last_year_sales float, current_year_sales float);

insert into @my_table values (
    'units_sold', 
    (select sum(units_sold) from sales), 
    (select sum(units_sold) from sales where year(Order_Date) = year(getdate()) - 1), 
    (select sum(units_sold) from sales where year(Order_Date) = year(getdate()))
    );

insert into @my_table values (
    'total_cost', 
    (select sum(total_cost) from sales), 
    (select sum(total_cost) from sales where year(Order_Date) = year(getdate()) - 1), 
    (select sum(total_cost) from sales where year(Order_Date) = year(getdate()))
);

insert into @my_table values (
    'total_revenue', 
    (select sum(total_revenue) from sales), 
    (select sum(total_revenue) from sales where year(Order_Date) = year(getdate()) - 1), 
    (select sum(total_revenue) from sales where year(Order_Date) = year(getdate()))
);

insert into @my_table values ( 
    'total_profit', 
    (select sum(total_profit) from sales), 
    (select sum(total_profit) from sales where year(Order_Date) = year(getdate()) - 1), 
    (select sum(total_profit) from sales where year(Order_Date) = year(getdate()))
);

select type, 
round(all_times_sales, 2) as all_times_sales, 
round(last_year_sales, 2) as last_year_sales, 
round(current_year_sales, 2) as current_year_sales
from @my_table;