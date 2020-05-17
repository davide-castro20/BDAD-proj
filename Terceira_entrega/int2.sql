.mode	columns
.headers	on
.nullvalue	NULL

select IDplaylist, count(IDvideo)
from PlaylistVideos
group by IDplaylist;