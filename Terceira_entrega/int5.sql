.mode	columns
.headers	on
.nullvalue	NULL

-- Lists the top influencers of the platform. Influencers are ordered by a popularity score. 
-- This score is based on a average of the number of views of their channel + the number of likes + the number os subscribers.
-- NULL values are considered to be 0 so all channels can appear in the final result

SELECT ChannelID, AVG(IFNULL(nViews,0) + IFNULL(userReaction,0) + IFNULL(nSubs,0)) AS popularityScore -- Calculates score and considers null = 0
FROM
    (
    SELECT ChannelID, SUM(IFNULL(nViews,0)) AS nViews, SUM(IFNULL(userReaction,0)) AS userReaction
    FROM 
        (select id AS ChannelID 
        from channel) -- Gets all Channels IDs
        
        LEFT OUTER JOIN
        (
        (SELECT IDVideo, COUNT(IFNULL(IDuser,0)) AS nViews, SUM(IFNULL(reaction, 0)) AS userReaction
        FROM ViewVideo
        GROUP BY (IDVideo)
        ) AS videoViews -- Number of Views and reactions of each video
        
        NATURAL JOIN 
        
        (SELECT ID as IDVideo, IDchannel
        FROM Video) ) -- Get channels of each video

        on (ChannelID = IDchannel)

    GROUP BY (ChannelID) -- Group by Channel ID
    ) as Views 
    
    LEFT OUTER JOIN
    
    (
    SELECT IDchannel, COUNT(IFNULL(IDuser,0)) AS nSubs 
    FROM Subscribes
    GROUP BY (IDchannel)
    ) as Subs -- Number of subs of each channel
    
    ON(ChannelID = IDchannel)

GROUP BY (ChannelID) -- Group by Channel ID
ORDER BY popularityScore DESC -- ordered by popularity score
;