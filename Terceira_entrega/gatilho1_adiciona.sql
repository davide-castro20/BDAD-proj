PRAGMA foreign_keys=ON;

--Automatically creates the channel of the user with default values when the user account is created.

CREATE Trigger ChannelCreation
After insert on User
for each ROW
BEGIN
    Insert into Channel (ID, URL, userID, number_of_subscribers, number_of_views, avatar, description, creation_date)
    values (New.ID, 'bdadtube.com/' || New.name, New.ID, 0, 0, 'robohash.org/' || New.name, '', date('now'));
END;