require 'sqlite3'
  
def item_type(id, items_db)
  
	if(items_db.execute("SELECT * FROM Track WHERE TrackID='#{id}'").length > 0)
		return "Track"
	else
		if(items_db.execute("SELECT * FROM Album WHERE AlbumID='#{id}'").length > 0)
			return "Album"
		else
			if(items_db.execute("SELECT * FROM Artist WHERE ArtistID='#{id}'").length > 0)
				return "Artist"
			else
				if(items_db.execute("SELECT * FROM Genre WHERE GenreID='#{id}'").length > 0)
					return "Genre"
				end
			end
		end
	end
	return "Error"
end
  
