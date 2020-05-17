PRAGMA foreign_keys=ON;

CREATE Trigger ChannelSub
After insert on Subscribes
for each ROW
BEGIN
    Update Channel 
    set number_of_subscribers = number_of_subscribers+1 
    where (ID=New.IDChannel);
END;