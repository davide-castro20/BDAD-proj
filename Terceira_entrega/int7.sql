.mode	columns
.headers	on
.nullvalue	NULL

-- Show total payment of Promoting Entities which got their ads played and viewed.
-- To get the payment it sums the price of the ad which played in monetized videos viwed by users who got to see the ad in the video before they stopped watching.


SELECT Ad.IDPromotingEntity, PromotingEntity.name, SUM(Ad.payment * ViewedAds.TotalViews) AS TotalPayed
FROM Ad, PromotingEntity, -- Get promoting Entities
(
    SELECT ReachedAds.AdID AS AdID , count(IDuser) AS TotalViews
    FROM 
        (Select ID, monthly_subscription 
        FROM USER) as users -- Get Users
    
        INNER JOIN 

        (
        SELECT PlayingAd.IDad AS AdID, IDuser
        FROM 
            (SELECT ID 
            FROM MonetizedVideo) as monetizedVideos -- Get monetized videos'ids

            INNER JOIN 

            (SELECT IDvideo, time_viewed, IDuser
            FROM ViewVideo) as views -- Get time_viewed and users'ids
            
            ON (monetizedVideos.ID=views.IDvideo), PlayingAd -- Get Time and video's Ids where Ads played

        WHERE((PlayingAd.IDmonetizedVideo = IDvideo) AND (time_viewed > PlayingAd.time)) -- Make sure user saw it
        ) AS  ReachedAds

        ON (ReachedAds.IDuser = users.ID)

    WHERE (monthly_subscription = 0) -- Users who pay do not see ads
    GROUP BY (ReachedAds.AdID) -- Order by Ads id
) As ViewedAds

WHERE
(Ad.ID = ViewedAds.AdID AND Ad.IDPromotingEntity = PromotingEntity.ID)
GROUP BY(PromotingEntity.ID);
