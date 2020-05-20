CREATE TRIGGER ViewVideoTrigger
AFTER INSERT ON ViewVideo
FOR EACH ROW 
BEGIN
    UPDATE Video
    SET number_of_likes = number_of_likes + 1
    WHERE New.IDvideo = Video.ID AND New.reaction = 1;

    UPDATE MonetizedVideo
    SET total_payment = total_payment + 
    (SELECT sum(payment) 
    FROM Ad INNER JOIN 
        (SELECT IDad
        FROM PlayingAd
        WHERE IDmonetizedVideo = New.IDvideo AND PlayingAd.time < '5:00' ) AS AdsPlayed 
    ON (Ad.ID = AdsPlayed.IDad) )
    WHERE (New.IDuser IN (SELECT ID FROM User WHERE monthly_subscription < 100)) and (New.IDvideo = MonetizedVideo.ID);
END;
