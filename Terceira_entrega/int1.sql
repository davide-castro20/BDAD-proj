.mode	columns
.headers	on
.nullvalue	NULL

-- Playlists with videos from popular tags

SELECT DISTINCT Playlists.IDplaylist AS playlistID, Playlists.name AS PlaylistName
FROM (PlaylistVideos INNER JOIN Playlist ON (Playlist.ID=PlaylistVideos.IDplaylist))
AS Playlists,
(
SELECT TagVideo.IDtag, TagVideo.IDvideo
FROM TagVideo,
    (
SELECT IDtag, trending.IDvideo, trending.timesViewed
    FROM TagVideo NATURAL JOIN
        (
SELECT viewDateFormat.IDvideo AS IDvideo, COUNT(*) AS timesViewed
        FROM ViewVideo,
            (
SELECT (substr(view_date, 7,4) || '-' ||  -- Changes date format from dd-mm-yyyy to yyyy-mm-dd
            substr(view_date, 4, 2) || '-' ||
            substr(view_date, 1, 2)) AS formatedDate, IDuser, IDvideo
            FROM ViewVideo
) AS viewDateFormat
        WHERE(viewDateFormat.formatedDate > date('now','-60 days')
            AND viewDateFormat.IDuser = ViewVideo.IDuser
            AND viewDateFormat.IDvideo=ViewVideo.IDvideo)
        GROUP BY viewDateFormat.IDvideo
) AS trending 
    ORDER BY trending.timesViewed DESC
LIMIT 3
) AS terndingTags
WHERE(terndingTags.IDtag = TagVideo.IDtag)
)
AS videoFromTags
WHERE Playlists.IDvideo = videoFromTags.IDvideo;