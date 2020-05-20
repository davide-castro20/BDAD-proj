.mode	columns
.headers	on
.nullvalue	NULL

SELECT Ad.IDPromotingEntity, PromotingEntity.name, SUM(Ad.payment * ViewedAds.TotalViews) AS TotalPayed
FROM Ad, PromotingEntity,
(
SELECT ReachedAds.AdID AS AdID , count(ReachedAds.UserID) AS TotalViews
FROM USER INNER JOIN
    (
    SELECT PlayingAd.IDad AS AdID, ViewVideo.IDuser AS UserID
    FROM MonetizedVideo INNER JOIN ViewVideo ON (MonetizedVideo.ID=ViewVideo.IDvideo), PlayingAd
    WHERE(IDmonetizedVideo = MonetizedVideo.ID AND ViewVideo.time_viewed > PlayingAd.time)
) AS  ReachedAds
    ON (ReachedAds.UserID = User.ID)
WHERE (User.monthly_subscription)
GROUP BY (ReachedAds.AdID)
) As ViewedAds
WHERE
(Ad.ID = ViewedAds.AdID AND Ad.IDPromotingEntity = PromotingEntity.ID)
GROUP BY(PromotingEntity.ID);
