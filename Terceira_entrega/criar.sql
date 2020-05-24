PRAGMA foreign_keys=ON;

drop table if exists User;
drop table if exists Channel;
drop table if exists Recommended;
drop table if exists Comment;
drop table if exists Replies;
drop table if exists Announcement;
drop table if exists Upload;
drop table if exists Video;
drop table if exists Playlist;
drop table if exists MonetizedVideo;
drop table if exists Ad;
drop table if exists PromotingEntity;
drop table if exists Tag;
drop table if exists TagVideo;
drop table if exists TagChannel;
drop table if exists ViewVideo;
drop table if exists PlaylistVideos;
drop table if exists Subscribes;
drop table if exists PlayingAd;



CREATE TABLE User (
    ID                  INTEGER    PRIMARY KEY ,
    email               TEXT    UNIQUE NOT NULL,
    name                TEXT    NOT NULL,
    password            TEXT    CHECK (length(password) > 5),
    history_active      INTEGER CHECK (history_active = 1 OR history_active = 0) DEFAULT 1 NOT NULL,
    monthly_subscription INTEGER CHECK (monthly_subscription >= 0) DEFAULT 0 NOT NULL
);


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
    userID                INTEGER REFERENCES User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    number_of_subscribers INTEGER CHECK (number_of_subscribers >= 0) NOT NULL,
    number_of_views       INTEGER CHECK (number_of_views >= 0) NOT NULL,
    avatar                TEXT NOT NULL,
    channel_art           TEXT,
    description           TEXT,
    creation_date         DATE
);



CREATE TABLE Recommended (
    ID1                INTEGER    REFERENCES Channel (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    ID2                INTEGER    REFERENCES Channel (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (ID1 <> ID2),
    PRIMARY KEY (ID1, ID2)
);


CREATE TABLE Comment (
    ID           INTEGER PRIMARY KEY ,
    content             text CHECK(length(content) > 0),
    number_of_likes     INTEGER CHECK(number_of_likes >= 0),
    number_of_dislikes  INTEGER CHECK(number_of_dislikes >= 0),
    date                DATE,
    IDannouncement     INTEGER REFERENCES Announcement (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE DEFAULT NULL, 
    IDvideo            INTEGER REFERENCES Video (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE DEFAULT NULL,
    IDuser              INTEGER REFERENCES User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    CHECK((IDannouncement = NULL and IDvideo <> NULL) or (IDvideo = NULL and IDannouncement <> NULL))
);


CREATE TABLE Replies (
    IDReply         INTEGER PRIMARY KEY REFERENCES Comment (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    IDMainComment   INTEGER REFERENCES Comment (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE
);


CREATE TABLE Announcement (
    ID  INTEGER PRIMARY KEY ,
    URL TEXT ,
    content TEXT,
    image TEXT,
    number_of_likes INTEGER NOT NULL DEFAULT 0,
    IDchannel text REFERENCES Channel (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
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
    IDchannel INTEGER REFERENCES Channel (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    number_of_likes INTEGER NOT NULL DEFAULT 0,
    number_of_dislikes INTEGER NOT NULL DEFAULT 0,
    uploadDate  TEXT
);

CREATE TABLE Playlist (
    ID                  INTEGER PRIMARY KEY ,
    URL                 TEXT ,
    name                TEXT NOT NULL,
    IDuser                  INTEGER REFERENCES User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE
);


CREATE TABLE MonetizedVideo (
    total_payment       INTEGER CHECK (total_payment >= 0) NOT NULL,
    ID                 INTEGER    PRIMARY KEY REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE
);


CREATE TABLE Ad (
    ID     INTEGER  PRIMARY KEY REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    payment     INTEGER  CHECK (payment >= 0),
    IDPromotingEntity     INTEGER    REFERENCES PromotingEntity (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE
);


CREATE TABLE PromotingEntity (
    ID      INTEGER PRIMARY KEY,
    name    TEXT
);


CREATE TABLE Tag (
    ID      INTEGER PRIMARY KEY,
    name    TEXT UNIQUE
);

CREATE TABLE TagVideo (
    IDvideo INTEGER REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE, 
    IDtag   INTEGER REFERENCES Tag (ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE TagChannel (
    IDchannel INTEGER REFERENCES Channel (ID) ON DELETE SET NULL ON UPDATE CASCADE, 
    IDtag   INTEGER REFERENCES Tag (ID) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE ViewVideo (
    time_viewed    TIME    CHECK (time_viewed >= 0),
    reaction    INTEGER     DEFAULT 0 CHECK (reaction = 1 OR reaction = -1 OR reaction = 0),
    view_date   DATE,
    IDvideo   INTEGER     REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    IDuser  INTEGER     REFERENCES  User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    PRIMARY KEY(IDvideo, IDuser)
);


CREATE TABLE PlaylistVideos (
    IDplaylist   INTEGER     REFERENCES Playlist (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    IDvideo   INTEGER     REFERENCES Video (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY(IDplaylist, IDvideo)
);

create table PlayingAd (
	IDad INTEGER REFERENCES Ad(ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
	IDmonetizedVideo INTEGER REFERENCES MonetizedVideo(ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE, 
	time TIME,
    PRIMARY KEY(IDad, IDmonetizedVideo, time)
);