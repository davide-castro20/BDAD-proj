.mode	columns
.headers	on
.nullvalue	NULL

-- Calculates for each channel the total income and shows it by descendent order.
-- To generate income a video must be monetized. Likes and views increases income.

SELECT videoPays.IDchannel, sum(videoPays.moneyVideo) as moneyChannel -- shows the total income for each channel
FROM (
    SELECT ID, IDchannel, NumberViews*15.5 + LikeRatio*0.1 as moneyVideo -- calculates money per video
    FROM 
        (
        SELECT ID, duration, number_of_likes as LikeRatio, IDchannel, count(IDvideo) as NumberViews
        FROM (
            SELECT ID, duration, number_of_likes, IDchannel
            FROM Video
            WHERE (Video.ID IN (SELECT ID FROM MonetizedVideo))
            ) as MonetizedVids -- Get monetized videos
            LEFT OUTER JOIN
            ViewVideo
            ON(ViewVideo.IDvideo = MonetizedVids.ID) -- Get seen monetized videos
        GROUP BY MonetizedVids.ID
        )
    ) 
     as videoPays
GROUP BY videoPays.IDchannel --Group by channel
ORDER BY moneyChannel DESC;