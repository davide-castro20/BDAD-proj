.mode	columns
.headers	on
.nullvalue	NULL

select title, number_of_likes, number_of_dislikes
from Video
where number_of_likes > number_of_dislikes;