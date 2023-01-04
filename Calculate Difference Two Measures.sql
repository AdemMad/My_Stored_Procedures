create proc my_proc
@year_1 int,
@year_2 int

as
begin
declare @dimension varchar (50) = 'item_type'
declare @measure varchar (50) = 'units_sold'
declare @measure_alias varchar (50) = @dimension
declare @function varchar (50) = 'count'
set @measure_alias = case
                        when @function = 'count' then concat(replace(@measure_alias, @measure_alias, 'number_of_'), @dimension)
                        else @measure
                    end

if @year_1 > @year_2
    begin
        print(concat('Error - ', @year_1, ' is greater than ', @year_2, ' - start date has to be less than end_date'))
        set nocount on
        set noexec on
    end

exec( 
'declare @tab table ('+@dimension+' varchar (100), '+@measure+' float)
insert into @tab '+
'select '+@dimension+', '+@function+'('+@measure+') as '+@measure+'
from sales
where year(order_date) = '+@year_1+ '
group by '+@dimension+ ' 

declare @tab2 table ('+@dimension+' varchar (100), '+@measure+' float)
insert into @tab2 '+
'select '+@dimension+', '+@function+'('+@measure+') as '+@measure+'
from sales
where year(order_date) = '+@year_2+ '
group by '+@dimension+ ' 

select a.'+@dimension+', a.'+@measure+' as '+@measure_alias+'_'+@year_1+' , b.'+@measure+' as '+@measure_alias+'_'+@year_2+
', case when b.'+@measure+' - a.'+@measure+' > 0 then concat (''+'', b.'+@measure+' - a.'+@measure+')
else cast (b.'+@measure+' - a.'+@measure+' as varchar (50))
end as number_difference,
case when a.'+@measure+' < b.'+@measure+' then cast(concat(round((((a.'+@measure+'/b.'+@measure+') * 100) - 100) * -1, 0), ''%'') as varchar (50))
else cast(concat(round((((b.'+@measure+'/a.'+@measure+') * 100) - 100), 0), ''%'') as varchar (50)) end as percentage_difference ' + 
'from @tab a
left join @tab2 b on a.'+@dimension+'=b.'+@dimension+
' order by round((((a.'+@measure+'/b.'+@measure+') * 100) - 100) * -1, 0) desc' 
)
;
end

exec my_proc 2013, 2017
