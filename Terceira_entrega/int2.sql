select IDplaylist, count(IDvideo)
from PlaylistVideos
group by IDplaylist;