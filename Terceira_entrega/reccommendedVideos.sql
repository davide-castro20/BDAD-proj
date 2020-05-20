DROP VIEW IF EXISTS VideosUser1;

CREATE TEMP VIEW IF NOT EXISTS VideosUser1
AS
    SELECT IDvideo
    FROM ViewVideo
    WHERE IDuser = 1;


SELECT Video.ID, title 
FROM
   ((SELECT IDchannel
    FROM 
    (SELECT IDvideo
        FROM 

        (SELECT IDuser, MAX(NumberCommonVids)
            FROM
                (SELECT IDuser, COUNT(IDvideo) AS NumberCommonVids
                FROM
                    (SELECT *
                    FROM
                        (SELECT IDvideo, IDuser
                        FROM ViewVideo
                        WHERE IDuser <> 1) as Wow

                        NATURAL JOIN VideosUser1) 
                    AS CommonVids

                GROUP BY IDuser)
            AS MatchedUsers) 
            
            NATURAL JOIN ViewVideo

        WHERE IDvideo NOT IN VideosUser1)
        AS NotSeenVideos

        INNER JOIN Video ON (NotSeenVideos.IDvideo = Video.ID)
        )
        AS InterestingChannels)

        INNER JOIN Video ON (Video.IDchannel = InterestingChannels.IDchannel)
WHERE Video.ID NOT IN VideosUser1;