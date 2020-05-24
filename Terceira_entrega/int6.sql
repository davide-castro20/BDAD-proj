.mode	columns
.headers	on
.nullvalue	NULL

DROP VIEW IF EXISTS MostViews;

-- Number of views per video 

CREATE TEMP VIEW
IF NOT EXISTS MostViews 
AS
SELECT * 
FROM (
    SELECT IDchannel, (number_of_views) as totalViews
    FROM(
        select IDchannel, IDvideo, count(IDuser) as number_of_views
        from (SELECT ID, IDchannel FROM Video) 
        inner join ViewVideo
        on ID=IDvideo
        group by IDvideo
        ORDER BY IDchannel)
    GROUP BY IDchannel
    ORDER BY number_of_views DESC
    LIMIT 2)
ORDER BY totalViews;


SELECT MV1.IDchannel as Channel1, MV2.IDchannel as Channel2, (MV1.totalViews - MV2.totalViews) as DifferenceInViews
FROM 
    (MostViews AS MV1 
    CROSS JOIN 
    MostViews AS MV2
    ON(MV1.IDchannel <> MV2.IDchannel))
LIMIT 1;