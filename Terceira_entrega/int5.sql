.mode	columns
.headers	on
.nullvalue	NULL

select ID, content, idMainComment
from Comment left outer join Replies
on ID=idReply;