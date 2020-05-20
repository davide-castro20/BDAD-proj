.mode columns
.headers ON
.nullvalue NULL

DROP VIEW IF EXISTS VideosUser35;

CREATE TEMP VIEW
IF NOT EXISTS VideosUser35
AS
SELECT IDvideo, view_date, reaction, IDuser, time_viewed
FROM ViewVideo;



SELECT ID, History.VideoID, History.VideoTitle, History.ViewDate,History.TimeViewed, 
       REPLACE(REPLACE(REPLACE(CAST(History.UserReaction AS TEXT),'1','Like'),'-L','Disl'),'0','No Reaction') AS UserReaction
FROM User INNER JOIN (
    SELECT (substr(view_date, 7,4) || '-' || 
            substr(view_date, 4, 2) || '-' ||
            substr(view_date, 1, 2)) as ViewDate, Video.title AS VideoTitle, VideosUser35.reaction AS UserReaction, IDuser,
            Video.ID as VideoID, VideosUser35.time_viewed AS TimeViewed
    FROM VideosUser35, Video
    WHERE Video.ID = VideosUser35.IDVideo
    ORDER BY (viewDate) DESC
)AS History
    ON (User.ID = History.IDuser AND User.history_active = 1)
ORDER BY User.ID, History.ViewDate DESC;