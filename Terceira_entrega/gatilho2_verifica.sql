.mode	columns
.headers	on
.nullvalue	NULL

--INSERTS

insert into User (id, email, password, history_active, monthly_subscription, name) 
values (100, 'gamingwiththepotato@gmail.com', 'CwiHut', 1, '1.83', 'Potato'); -- USER 100

Insert into Channel (ID, URL, userID, number_of_subscribers, number_of_views, avatar, description, creation_date)
values (100, 'bdadtube.com/Potato', 100, 0, 0, 'robohash.org/Potato', '', date('now')); -- CHANNEL OF USER 100

insert into User (id, email, password, history_active, monthly_subscription, name) 
values (101, 'gamingwiththepotato@gmail.pt', 'CwiHut', 1, '1.83', 'Gaming'); -- USER 101


-- BEFORE
select ID, userID as channelOwner, number_of_subscribers 
from Channel 
WHERE (ID = 100);


-- TEST

insert into Subscribes (IDUser, IDChannel)  -- User subscribes its own channel
values (100, 100);


-- VERIFY

SELECT *
FROM
    (select IDUser as subscriber, IDChannel 
    from Subscribes 
    WHERE (IDChannel = 100)) as Subscribed

    NATURAL JOIN

    (select ID AS IDChannel, userID as channelOwner, number_of_subscribers 
    from Channel 
    WHERE (ID = 100)) as ChannelInfo

;

-- TEST

insert into Subscribes (IDUser, IDChannel) -- User subscribes a channel from another user
values (101, 100);

-- VERIFY

SELECT *
FROM
    (select IDUser as subscriber, IDChannel 
    from Subscribes 
    WHERE (IDChannel = 100)) as Subscribed

    NATURAL JOIN

    (select ID AS IDChannel, userID as channelOwner, number_of_subscribers 
    from Channel 
    WHERE (ID = 100)) as ChannelInfo

;
