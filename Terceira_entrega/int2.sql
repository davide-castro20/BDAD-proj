.mode columns
.headers ON
.nullvalue NULL

DROP VIEW IF EXISTS VideosUsers;

CREATE TEMP VIEW    -- Video seen by users
IF NOT EXISTS VideosUsers    
AS
SELECT IDvideo, view_date, reaction, IDuser, time_viewed
FROM ViewVideo;

-- Gets the history of the users which includes the user Id, the Id and title of the video they visualized, the date, the amount of time of the video seen and the user's reaction.
-- It is ordered by user id and by the date.

SELECT ID, History.VideoID, History.VideoTitle, History.ViewDate,History.TimeViewed, 
       REPLACE( -- Replaces '0' By No Reaction
           REPLACE( -- Replaces '-L' By Disl
               REPLACE( -- Replaces '1' By Like
                   CAST(History.UserReaction AS TEXT),'1','Like'),'-L','Disl'),'0','No Reaction') AS UserReaction
FROM User INNER JOIN (
    SELECT (substr(view_date, 7,4) || '-' ||  -- Changes date format from dd-mm-yyyy to yyyy-mm-dd
            substr(view_date, 4, 2) || '-' ||
            substr(view_date, 1, 2)) as ViewDate, Video.title AS VideoTitle, VideosUsers.reaction AS UserReaction, IDuser,
            Video.ID as VideoID, VideosUsers.time_viewed AS TimeViewed
    FROM VideosUsers, Video
    WHERE Video.ID = VideosUsers.IDVideo
    ORDER BY (viewDate) DESC
)AS History -- Get history of users
    ON (User.ID = History.IDuser AND User.history_active = 1) -- Gets only users with history active
ORDER BY User.ID, History.ViewDate DESC; -- Order by most recent