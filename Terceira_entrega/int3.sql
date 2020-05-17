select name, sum(duration)
from Channel inner join Video on Channel.ID = Video.IDchannel
group by Channel.ID;
