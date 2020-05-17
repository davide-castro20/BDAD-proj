.mode	columns
.headers	on
.nullvalue	NULL

insert into User (id, email, password, history_active, monthly_subscription, name) values (1, 'bmulvenna0@ehow.com', 'CwiHut', 1, '1.83', 'Blake Mulvenna');
Insert into Channel (ID, URL, userID, number_of_subscribers, number_of_views, avatar, description, tagName, creation_date)
    values (1, 'bdadtube.com/Blake Mulvenna', 1, 0, 0, 'robohash.org/Blake Mulvenna', '', NULL, date('now'));

select * from Channel;

insert into Subscribes (IDUser, IDChannel) values (1, 1);

select * from Channel;