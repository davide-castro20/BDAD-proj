CREATE TEMP VIEW IF NOT EXISTS VideosUser1
AS
    SELECT URL
    FROM ViewVideo NATURAL JOIN Video
    WHERE ViewVideo.ID = 1;


SELECT URL, title 
FROM
   (SELECT URLchannel
    FROM 
    (SELECT URL
        FROM

        (SELECT ID, MAX(NumberCommonVids)
            FROM
                (SELECT ID, COUNT(URL) AS NumberCommonVids
                FROM
                    (SELECT *
                    FROM
                        (SELECT URL, ID
                        FROM ViewVideo
                        WHERE ID <> 1)

                        NATURAL JOIN VideosUser1) 
                    AS CommonVids

                GROUP BY ID)
            AS MatchedUsers) 
            
            NATURAL JOIN ViewVideo

        WHERE URL NOT IN VideosUser1)
        AS NotSeenVideos

        NATURAL JOIN Video
        
        AS InterestingChannels)

        NATURAL JOIN Video
WHERE URL NOT IN VideosUser1;