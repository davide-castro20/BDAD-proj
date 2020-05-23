.mode	columns
.headers	on
.nullvalue	NULL

-- Channel with the most subscribers

SELECT ID, name 
from Channel
where(number_of_subscribers = (select max(number_of_subscribers) from Channel));