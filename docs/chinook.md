# chinook

## Tables

artists
- Columns: artist_id (PK), name, country, formed_year

albums
- Columns: album_id (PK), title, artist_id (FK -> artists.artist_id), release_year, genre

tracks
- Columns: track_id (PK), name, album_id (FK -> albums.album_id), milliseconds, composer, bytes, price

## Relationships
- albums.artist_id -> artists.artist_id
- tracks.album_id -> albums.album_id
