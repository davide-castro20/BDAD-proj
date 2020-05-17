.mode	columns
.headers	on
.nullvalue	NULL

select idComment, content, idMainComment
from Comment left outer join Replies
on idComment=idReply;