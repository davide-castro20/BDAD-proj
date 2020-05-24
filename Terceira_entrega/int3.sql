.mode	columns
.headers	on
.nullvalue	NULL


SELECT *
FROM(
    select name, sum(duration) as totalTime
    from 
    User INNER JOIN
    (Channel inner join Video on Channel.ID = Video.IDchannel) as Channels
    ON (User.ID = Channels.userID)
    group by Channel.ID
    ORDER BY name
)
WHERE name LIKE '%a%';