declare @next_month_first_day date = Dateadd(month, +2, convert(date, getdate()))
declare @start_date date = cast(concat(left(@next_month_first_day, 7), '-01') as date)
declare @loan_amount float = 180000.00
declare @term_loan int = 240
declare @end_date date = Dateadd(month,  + @term_loan, @start_date)
declare @principal float = round (@loan_amount / @term_loan, 2)
declare @taux_entered float = 6.25
declare @interest_rate float = @taux_entered / 100
declare @insurance_rate float = 0.21
declare @insurance_premium float =  round (@term_loan * @insurance_rate, 2)
declare @interest float = round(@loan_amount * @interest_rate * 30/@term_loan, 2)
declare @income float = 6000.00
declare @monthly_payment float = round (@principal + @interest + @insurance_premium, 2)
declare @expenses float = 1000.00
declare @debt_to_income int
declare @currency varchar (50) = 'GBP (£)'
;

with cte as (
    select 1 as instalment, 
    @loan_amount as loan_amount, 
    @start_date as start_date
    union all
    select instalment + 1, 
    loan_amount - @principal, 
    Dateadd(month,  +1, start_date) 
    from cte
    where instalment <@term_loan and loan_amount - @principal >= 0 and Dateadd(month,  +1, start_date) < @end_date
)

select
instalment,
start_date as date,
@principal as principal, 
round(loan_amount * @interest_rate * 30/@term_loan, 2) as interest,
@insurance_premium as insurance_premium,
round (@principal + round(loan_amount * @interest_rate * 30/@term_loan, 2) + @insurance_premium, 2) as monthly_payment,
loan_amount as loan_balance,
round(@income - @expenses - round (@principal + round(loan_amount * @interest_rate * 30/@term_loan, 2) + @insurance_premium, 2), 2) as remaining_income,
@currency as currrency
from cte
option (MaxRecursion 0);
