.mode columns
.headers ON
.nullvalue NULL

DROP VIEW IF EXISTS AdPlays;

CREATE TEMP VIEW IF NOT EXISTS AdPlays -- Ads played in Video 1 before 5:00
AS
    SELECT IDad, time 
    FROM PlayingAd 
    WHERE (PlayingAd.IDmonetizedVideo = 1 and time < '5:00');

-- BEFORE

SELECT * 
FROM
    (select ID as VideoId, number_of_likes 
    from Video 
    where Video.ID = 1)
    
    NATURAL JOIN
    
    (select ID as VideoId, total_payment 
    from MonetizedVideo 
    WHERE ID = 1) 

;

SELECT Ad.ID as AdID, payment as AdPayment, count(AdPlays.time) as TimesPlayedInVideo
    FROM Ad INNER JOIN AdPlays ON (Ad.ID = AdPlays.IDad)
    GROUP BY (AdPlays.IDad);

-- TEST

insert into ViewVideo (time_viewed, reaction, IDvideo, IDuser) values ('5:00', 1, 1, 1);

-- VERFY

SELECT * 
FROM
    (select ID as VideoId, number_of_likes 
    from Video 
    where Video.ID = 1)
    
    NATURAL JOIN
    
    (select ID as VideoId, total_payment 
    from MonetizedVideo 
    WHERE ID = 1) 

;

