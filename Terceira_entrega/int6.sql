.mode	columns
.headers	on
.nullvalue	NULL

-- Number of views per video 

select title, count(IDuser) as number_of_views
from Video inner join ViewVideo
on Video.ID=IDvideo
group by IDvideo;