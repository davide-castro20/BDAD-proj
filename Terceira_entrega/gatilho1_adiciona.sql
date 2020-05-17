PRAGMA foreign_keys=ON;

CREATE Trigger ChannelCreation
After insert on User
for each ROW
BEGIN
    Insert into Channel (ID, URL, userID, number_of_subscribers, number_of_views, avatar, description, tagName, creation_date)
    values (New.ID, 'bdadtube.com/' || New.name, New.ID, 0, 0, 'robohash.org/' || New.name, '', NULL, date('now'));
END;