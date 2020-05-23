.mode	columns
.headers	on
.nullvalue	NULL

DROP VIEW IF EXISTS VideosUser1;

CREATE TEMP VIEW IF NOT EXISTS VideosUser1 -- Videos seen by user 1
AS
    SELECT IDvideo
    FROM ViewVideo
    WHERE IDuser = 1;

-- Reccomends videos to user 1 by finding its user match. A user match is the user who saw the most videos in common with this user.
-- After finding out the user match we get the videos seen by the user match but not by user 1. We get the channels which posted this videos and reccomend videos from this channels but still making sure we do not reccomend any video user 1 already saw.

SELECT Video.ID, title --Reccomends videos from channels
FROM
   ((SELECT IDchannel -- Gets channels which posted those videos
    FROM 
    (SELECT IDvideo
        FROM 

        (SELECT IDuser, MAX(NumberCommonVids) -- Gets User 1 Match
            FROM
                (SELECT IDuser, COUNT(IDvideo) AS NumberCommonVids -- counts videos seen in common
                FROM
                    (SELECT *
                    FROM
                        (SELECT IDvideo, IDuser -- Select videos seen by other users 
                        FROM ViewVideo
                        WHERE IDuser <> 1) 

                        NATURAL JOIN VideosUser1) 
                    AS CommonVids -- Gets videos seen in common

                GROUP BY IDuser)
            AS MatchedUsers) 
            
            NATURAL JOIN ViewVideo

        WHERE IDvideo NOT IN VideosUser1) -- Gets Videos Match user saw but user 1 did not 
        AS NotSeenVideos

        INNER JOIN Video ON (NotSeenVideos.IDvideo = Video.ID)
        )
        AS InterestingChannels)

        INNER JOIN Video ON (Video.IDchannel = InterestingChannels.IDchannel)
WHERE Video.ID NOT IN VideosUser1; -- Maskes sure videos user 1 saw do not get reccomended