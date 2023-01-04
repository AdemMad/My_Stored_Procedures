--Login, View Balance--

SET NOCOUNT ON;

declare @email nvarchar (100) = 'ademmad@email.com'
declare @password nvarchar (100) = 'V%!cE&H223'
declare @users table (
    user_no int identity (1,1) unique, 
    email nvarchar (100), 
    password nvarchar (100), 
    balance money
    )
insert into @users values (@email, @password, 5467.88)
declare @entered_email nvarchar (100) = 'ademmad@email.com'
declare @entered_password nvarchar (100) = 'V%!cE&H223'

if @entered_email in (select email from @users) and @entered_password in (select password from @users)
    begin
        select balance
        from @users
        where email = @email and password = @password
    end
else
print('email or password not found');