.mode	columns
.headers	on
.nullvalue	NULL

SELECT ID, name 
from Channel
where(number_of_subscribers = (select max(number_of_subscribers) from Channel));