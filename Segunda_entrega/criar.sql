PRAGMA foreign_keys=ON;
BEGIN TRANSACTION;

drop table if exists User;
CREATE TABLE User (
    ID                  INTEGER    PRIMARY KEY AUTOINCREMENT NOT NULL,
    email               TEXT    UNIQUE NOT NULL,
    password            TEXT    CHECK (length(password) > 5),
    history_active      INTEGER CHECK (history_active = 1 OR history_active = 0) DEFAULT 1 NOT NULL,
    monthly_subscription NUMERIC CHECK (monthly_subscription >= 0) DEFAULT 0 NOT NULL,
    name                TEXT    NOT NULL
);


drop table if exists Subscribes;
CREATE TABLE Subscribes (
    ID  NUMERIC  REFERENCES User (ID) ON DELETE SET NULL
                                     ON UPDATE CASCADE,
    URL TEXT    REFERENCES Channel (URL) ON DELETE SET NULL
                                         ON UPDATE CASCADE,
    PRIMARY KEY (ID, URL)
);


drop table if exists Creation;
CREATE TABLE Creation (
    ID           INTEGER UNIQUE      REFERENCES User (ID) ON DELETE SET NULL ON UPDATE CASCADE,
    URL          TEXT PRIMARY KEY REFERENCES Channel (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    creationDate DATE NOT NULL
);

drop table if exists Channel;
CREATE TABLE Channel (
    URL                   TEXT    PRIMARY KEY ,
    userID                INTEGER REFERENCES User (ID),
    number_of_subscribers NUMERIC CHECK (number_of_subscribers > 0) NOT NULL,
    number_of_views       NUMERIC CHECK (number_of_views >= 0) NOT NULL,
    avatar                TEXT NOT NULL,
    description           TEXT,
    tagName               TEXT  REFERENCES Tag (name)
);


drop table if exists Recommended;
CREATE TABLE Recommended (
    URL1                TEXT    REFERENCES Channel (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    URL2                TEXT    REFERENCES Channel (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (URL1 <> URL2),
    PRIMARY KEY (URL1, URL2)
);


drop table if exists Comment;
CREATE TABLE Comment (
    idComment           NUMERIC PRIMARY KEY,
    idUser              INTEGER REFERENCES User (ID),
    content             text CHECK(length(content) > 0),
    number_of_likes     NUMERIC CHECK(number_of_likes >= 0),
    number_of_dislikes  NUMERIC CHECK(number_of_dislikes >= 0),
    URLAnnouncement     text REFERENCES Announcement (URL), 
    URLvideo            text REFERENCES Video (URL)
);

drop table if exists Replies;
CREATE TABLE Replies (
    idReply         NUMERIC REFERENCES Comment (idComment),
    idMainComment   NUMERIC REFERENCES Comment (idComment),
    PRIMARY KEY (idReply, idMainComment)
);

drop table if exists Announcement;
CREATE TABLE Announcement (
    URL TEXT PRIMARY KEY,
    content TEXT,
    image TEXT,
    number_of_likes NUMERIC NOT NULL DEFAULT 0,
    URLchannel text REFERENCES Channel (URL),
    CHECK((length(content) > 0) or (image<>NULL))
);

drop table if exists Commented;
CREATE TABLE Commented (
    date DATE NOT NULL,
    commentID NUMERIC PRIMARY KEY REFERENCES Comment (idComment),
    userId NUMERIC REFERENCES User (ID)
);

drop table if exists Upload;
CREATE TABLE Upload (
    date DATE,
    URLchannel text REFERENCES Channel (URL),
    URLvideo text PRIMARY KEY REFERENCES Video (URL)
);

drop table if exists AnnouncementUpload;
CREATE TABLE AnnouncementUpload (
    date DATE,
    URLchannel text REFERENCES Channel (URL),
    URLAnnouncement text PRIMARY KEY REFERENCES Announcement (URL)
);

drop table if exists Video;
CREATE TABLE Video (
    URL text PRIMARY KEY,
    duration TIME CHECK(duration > 0) NOT NULL,
    title text CHECK(length(title) > 0) NOT NULL,
    thumbnail TEXT NOT NULL,
    description text,
    tagName text REFERENCES Tag (name),
    URLchannel text REFERENCES Channel (URL)
);

drop table if exists Playlist;
CREATE TABLE Playlist (
    URL                 TEXT    PRIMARY KEY ,
    name                TEXT NOT NULL,
    ID                  NUMERIC REFERENCES User (ID)
);

drop table if exists MonetizedVideo;
CREATE TABLE MonetizedVideo (
    total_payment       INTEGER CHECK (total_payment >= 0) NOT NULL,
    URL                 TEXT    PRIMARY KEY REFERENCES Video (URL) ON DELETE SET NULL ON UPDATE CASCADE
);

drop table if exists Ad;
CREATE TABLE Ad (
    URL     TEXT    PRIMARY KEY REFERENCES Video (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    payment     NUMERIC  CHECK (payment >= 0),
    namePromotingEntity     TEXT    REFERENCES PromotingEntity (name)
);

drop table if exists PromotingEntity;
CREATE TABLE PromotingEntity (
    name    TEXT    PRIMARY KEY
);

drop table if exists Tag;
CREATE TABLE Tag (
    name    TEXT    PRIMARY KEY
);

drop table if exists NumberOfTimesViewed;
CREATE TABLE NumberOfTimesViewed (
    URLad   TEXT    REFERENCES Ad (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    URLmonetizedVideo   TEXT     REFERENCES MonetizedVideo (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    number_of_times_viewed  INTEGER   DEFAULT 0  CHECK (number_of_times_viewed >= 0) NOT NULL,
    PRIMARY KEY (URLmonetizedVideo, URLad)
);

drop table if exists ViewVideo;
CREATE TABLE ViewVideo (
    time_viewed    TIME    CHECK (time_viewed >= 0),
    reaction    INTEGER     DEFAULT 0 CHECK (reaction = 1 OR reaction = -1 OR reaction = 0),
    URL   TEXT     REFERENCES Video (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    ID  INTEGER     REFERENCES  User (ID),
    PRIMARY KEY(URL, ID)
);

drop table if exists PlaylistVideos;
CREATE TABLE PlaylistVideos (
    URLplaylist   TEXT     REFERENCES Playlist (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    URLvideo   TEXT     REFERENCES Video (URL) ON DELETE SET NULL ON UPDATE CASCADE,
    PRIMARY KEY(URLplaylist, URLvideo)
);

COMMIT;
