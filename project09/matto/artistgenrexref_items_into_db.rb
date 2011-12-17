require 'sqlite3'
  
items_db = SQLite3::Database.open('KDD-items.db3')
  
  
track_handle = File.open("trackData1.txt","r")
  
while !(track_handle.eof?)
	track_id,album_id,artist_id,genre_id_string =  track_handle.readline.chomp.split("|",4)
		
	puts "Track #{track_id}"	
		
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(!genre_id.eql?("None"))
				if(!artist_id.eql?("None"))				
					if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Track'").length == 0)
						items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Track')")
					end
				end
			end
		end
	end
end

  
  
album_handle = File.open("albumData1.txt","r")

 
while !(album_handle.eof?)
	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",3)
	
	puts "Album #{album_id}"
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(!genre_id.eql?("None"))
				if(!artist_id.eql?("None"))
					if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Album'").length == 0)
						items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Album')")
					end	
				end
			end
		end
	end
end
  