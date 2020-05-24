.mode	columns
.headers	on
.nullvalue	NULL

-- Channels with positive number of likes

select ID, content, IFNULL(idMainComment, '--') AS InResponseTo
from Comment left outer join Replies
on ID=idReply
ORDER BY InResponseTo DESC;