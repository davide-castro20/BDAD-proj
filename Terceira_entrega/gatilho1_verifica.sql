.mode	columns
.headers	on
.nullvalue	NULL

-- BEFORE

select ID, userID 
from Channel;

-- TEST

insert into User (id, email, password, history_active, monthly_subscription, name) 
values (300, 'bmulvenna0@ehow.com', 'CwiHut', 1, '1.83', 'Blake Mulvenna');

-- VERIFY

select ID, userID 
from Channel;