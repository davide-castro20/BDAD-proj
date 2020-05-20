SELECT title, Video.URL
FROM Video INNER JOIN
(
SELECT Video.URLchannel AS RecommendedChannels
FROM Video NATURAL JOIN
    (
SELECT URL
    FROM ViewVideo,
        (
SELECT ID
        FROM
            (
    SELECT * , COUNT(URL) AS C
            FROM
                (SELECT ViewVideo.URL, ID
                FROM ViewVideo
                WHERE ID <> 1) AS V1

                INNER JOIN

                (SELECT Video.URL AS VideoURL, URLchannel
                FROM ViewVideo INNER JOIN Video ON (ViewVideo.URL = Video.URL)
                WHERE ViewVideo.ID = 1) AS V2

                ON (V1.URL = V2.VideoURL)

            GROUP BY ID

)
        WHERE C > 1
) AS common
    WHERE 
    ViewVideo.ID = common.ID and URL NOT IN (SELECT URL
        FROM ViewVideo
        WHERE ID = 1)
)
) ON (Video.URLchannel = RecommendedChannels)
WHERE 
    Video.URL NOT IN (  SELECT URL
                        FROM ViewVideo
                        WHERE ID = 1    );
