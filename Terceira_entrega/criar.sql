PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;

drop table if exists User;
drop table if exists Creation;
drop table if exists Channel;
drop table if exists Recommended;
drop table if exists Comment;
drop table if exists Replies;
drop table if exists Announcement;
drop table if exists Commented;
drop table if exists Upload;
drop table if exists AnnouncementUpload;
drop table if exists Video;
drop table if exists Playlist;
drop table if exists MonetizedVideo;
drop table if exists Ad;
drop table if exists PromotingEntity;
drop table if exists Tag;
drop table if exists NumberOfTimesViewed;
drop table if exists ViewVideo;
drop table if exists PlaylistVideos;


CREATE TABLE User (
    ID                  INTEGER    PRIMARY KEY ,
    email               TEXT    UNIQUE NOT NULL,
    password            TEXT    CHECK (length(password) > 5),
    history_active      INTEGER CHECK (history_active = 1 OR history_active = 0) DEFAULT 1 NOT NULL,
    monthly_subscription INTEGER CHECK (monthly_subscription >= 0) DEFAULT 0 NOT NULL,
    name                TEXT    NOT NULL
);


drop table if exists Subscribes;
CREATE TABLE Subscribes (
    IDUser  INTEGER  REFERENCES User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    IDChannel  INTEGER  REFERENCES Channel (ID) ON DELETE SET NULL
                                         ON UPDATE CASCADE,
    PRIMARY KEY (IDUser, IDChannel)
);


CREATE TABLE Channel (
    ID                    INTEGER PRIMARY KEY ,
    URL                   TEXT ,
    userID                INTEGER REFERENCES User (ID),
    number_of_subscribers INTEGER CHECK (number_of_subscribers > 0) NOT NULL,
    number_of_views       INTEGER CHECK (number_of_views >= 0) NOT NULL,
    avatar                TEXT NOT NULL,
    description           TEXT,
    tagName               TEXT  REFERENCES Tag (name),
    creation_date         DATE
);



CREATE TABLE Recommended (
    ID1                INTEGER    REFERENCES Channel (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    ID2                INTEGER    REFERENCES Channel (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (ID1 <> ID2),
    PRIMARY KEY (ID1, ID2)
);



CREATE TABLE Comment (
    idComment           INTEGER PRIMARY KEY ,
    idUser              INTEGER REFERENCES User (ID),
    content             text CHECK(length(content) > 0),
    number_of_likes     INTEGER CHECK(number_of_likes >= 0),
    number_of_dislikes  INTEGER CHECK(number_of_dislikes >= 0),
    IDAnnouncement     INTEGER REFERENCES Announcement (ID), 
    IDVideo            INTEGER REFERENCES Video (ID)
);


CREATE TABLE Replies (
    idReply         INTEGER PRIMARY KEY REFERENCES Comment (idComment),
    idMainComment   INTEGER REFERENCES Comment (idComment)
);


CREATE TABLE Announcement (
    ID  INTEGER PRIMARY KEY ,
    URL TEXT ,
    content TEXT,
    image TEXT,
    number_of_likes INTEGER NOT NULL DEFAULT 0,
    IDchannel text REFERENCES Channel (ID),
    upload_date DATE,   
    CHECK((length(content) > 0) or (image<>NULL))
);

CREATE TABLE Video (
    ID  INTEGER PRIMARY KEY ,
    URL text,
    duration TIME CHECK(duration > 0) NOT NULL,
    title text CHECK(length(title) > 0) NOT NULL,
    thumbnail TEXT NOT NULL,
    description text,
    tagName text REFERENCES Tag (name),
    IDchannel INTEGER REFERENCES Channel (ID),
    number_of_likes INTEGER NOT NULL DEFAULT 0,
    number_of_dislikes INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE Playlist (
    ID                  INTEGER PRIMARY KEY ,
    URL                 TEXT ,
    name                TEXT NOT NULL,
    IDuser                  INTEGER REFERENCES User (ID)
);


CREATE TABLE MonetizedVideo (
    total_payment       INTEGER CHECK (total_payment >= 0) NOT NULL,
    ID                 INTEGER    PRIMARY KEY REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Ad (
    ID     INTEGER  PRIMARY KEY REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    payment     INTEGER  CHECK (payment >= 0),
    namePromotingEntity     TEXT    REFERENCES PromotingEntity (name)
);


CREATE TABLE PromotingEntity (
    name    TEXT    PRIMARY KEY
);


CREATE TABLE Tag (
    name    TEXT    PRIMARY KEY
);


CREATE TABLE ViewVideo (
    time_viewed    TIME    CHECK (time_viewed >= 0),
    reaction    INTEGER     DEFAULT 0 CHECK (reaction = 1 OR reaction = -1 OR reaction = 0),
    IDvideo   INTEGER     REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    IDuser  INTEGER     REFERENCES  User (ID),
    PRIMARY KEY(IDvideo, IDuser)
);


CREATE TABLE PlaylistVideos (
    IDplaylist   INTEGER     REFERENCES Playlist (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    IDvideo   INTEGER     REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY(IDplaylist, IDvideo)
);

COMMIT;
