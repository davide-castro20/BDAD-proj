.mode	columns
.headers	on
.nullvalue	NULL

SELECT Subs.IDchannel, AVG(Views.nViews+Views.userReaction+Subs.nSubs) AS popularityScore
FROM
    (
    SELECT Channel.ID, SUM(IFNULL(videoViews.nViews,0)) AS nViews, SUM(IFNULL(videoViews.userReaction,0)) AS userReaction
    FROM Channel LEFT OUTER JOIN
        (
        SELECT IDVideo, COUNT(IDuser) AS nViews, SUM(reaction) AS userReaction
        FROM ViewVideo
        GROUP BY (IDVideo)
        ) AS videoViews , Video
    WHERE(Video.ID = videoViews.IDvideo AND Video.IDchannel = Channel.ID)
    GROUP BY (Channel.ID)
    ) as Views INNER JOIN
    (
    SELECT IDchannel, COUNT(IDuser) AS nSubs
    FROM Subscribes
    GROUP BY (IDchannel)
    ) as Subs ON (Subs.IDchannel = Views.ID)
GROUP BY (Subs.IDchannel)
ORDER BY popularityScore DESC;