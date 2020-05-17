.mode	columns
.headers	on
.nullvalue	NULL

select title, count(IDuser)
from Video inner join ViewVideo
on Video.ID=IDvideo
group by IDvideo;