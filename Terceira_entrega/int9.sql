.mode	columns
.headers	on
.nullvalue	NULL

SELECT videoPays.IDchannel, sum(videoPays.moneyVideo) as moneyChannel
FROM (
    SELECT ID, IDchannel, NumberViews*15.5 + LikeRatio*0.1 as moneyVideo
    FROM 
        (
        SELECT ID, duration, number_of_likes as LikeRatio, IDchannel, count(IDvideo) as NumberViews
        FROM (
            SELECT ID, duration, number_of_likes, IDchannel
            FROM Video
            WHERE (Video.ID IN (SELECT ID FROM MonetizedVideo))
            ) as MonetizedVids
            LEFT OUTER JOIN
            ViewVideo
            ON(ViewVideo.IDvideo = MonetizedVids.ID)
        GROUP BY MonetizedVids.ID
        )
    ) 
     as videoPays
GROUP BY videoPays.IDchannel