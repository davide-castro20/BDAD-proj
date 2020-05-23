PRAGMA foreign_keys=ON;

-- When a user subscribes a channel, it updates the channel's number of subscribers increasing the number by one.
-- In only increases the number of subscribers if the User who subscribed is not the owner of the channel they subscribed to.
-- If the user tries to subscribe to its own channel, an error occurs.

CREATE Trigger ChannelSub
AFTER INSERT ON Subscribes
FOR EACH ROW
WHEN ( 
    (SELECT userID 
    FROM Channel 
    WHERE ID = New.IDChannel) <> New.IDUser)
BEGIN
    Update Channel 
    set number_of_subscribers = number_of_subscribers+1 
    where (ID=New.IDChannel); 
END; 

CREATE Trigger SubOwnChannel
BEFORE INSERT ON Subscribes
FOR EACH ROW
WHEN ( 
    (SELECT userID 
    FROM Channel 
    WHERE ID = New.IDChannel) = New.IDUser)
BEGIN
    SELECT raise(rollback, 'User cannot subscribe to its own channel.');
END; 