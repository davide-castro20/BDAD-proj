.mode	columns
.headers	on
.nullvalue	NULL

-- Total of duration of videos of channels

select name, sum(duration)
from Channel inner join Video on Channel.ID = Video.IDchannel
group by Channel.ID;
