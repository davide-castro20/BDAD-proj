.mode	columns
.headers	on
.nullvalue	NULL

DROP VIEW IF EXISTS VideosUser2;

CREATE TEMP VIEW IF NOT EXISTS VideosUser2 -- Videos seen by User 2
AS
    SELECT IDvideo
    FROM ViewVideo
    WHERE IDuser = 2;

-- Simulates subscribed section from youtube for user 2 but additionally removes videos already seen by the user.
-- It gets the videos from channels the user is subscribed to and which he did not see yet. Orders them by most recent.

SELECT ID, title,
  substr(reversed_date, 7,4) || '-' || 
  substr(reversed_date, 4, 2)|| '-' || -- Changes data format from dd-mm-yyyy to yyyy-mm-dd
  substr(reversed_date, 1, 2) as post_date
  FROM (
    SELECT Video.ID, Video.title, Video.uploadDate as reversed_date 
    FROM 
        (
        SELECT ID as SubscribedChannel
        FROM Channel                    -- Gets channel user 2 is subscribed to
        WHERE (ID IN (SELECT IDchannel from Subscribes where IDuser = 2 ))
        ),
        Video
    WHERE Video.IDchannel = SubscribedChannel and Video.ID NOT IN VideosUser2 -- Gets videos posted by channels user 2 is subscribed to and which the user has not seen yet
  ) 
  ORDER BY date(post_date) DESC; -- Orders by most recent


