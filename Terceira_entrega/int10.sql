.mode	columns
.headers	on
.nullvalue	NULL

DROP VIEW IF EXISTS VideosUser2;

CREATE TEMP VIEW IF NOT EXISTS VideosUser2
AS
    SELECT IDvideo
    FROM ViewVideo
    WHERE IDuser = 2;

SELECT 
  substr(reversed_date, 7,4) || '-' || 
  substr(reversed_date, 4, 2)|| '-' ||
  substr(reversed_date, 1, 2) as proper_date, 
  ID, title
  FROM (
    SELECT Video.ID, Video.title, Video.uploadDate as reversed_date 
    FROM 
        (
        SELECT ID as SubscribedChannel
        FROM Channel 
        WHERE (ID IN (SELECT IDchannel from Subscribes where IDuser = 2 ))
        ),
        Video
    WHERE Video.IDchannel = SubscribedChannel and Video.ID NOT IN VideosUser1
  ) 
  ORDER BY date(proper_date) DESC;


