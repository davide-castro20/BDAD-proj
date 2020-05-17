.mode	columns
.headers	on
.nullvalue	NULL

select name, title
from (User inner join Channel on User.ID=Channel.userID) inner join Video on Video.IDchannel=Channel.ID
where --TODO