.mode	columns
.headers	on
.nullvalue	NULL

-- Channels with positive number of likes

select title, number_of_likes, number_of_dislikes
from Video
where number_of_likes > number_of_dislikes;