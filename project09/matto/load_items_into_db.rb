require 'sqlite3'
  
items_db = SQLite3::Database.open('KDD-items.db3')
  
  
track_handle = File.open("trackData1.txt","r")
  
items_db.transaction 
  
while !(track_handle.eof?)
	track_id,album_id,artist_id,genre_id_string =  track_handle.readline.chomp.split("|",4)
		
	if(album_id.eql?("None"))
		album_id_none_removed = -1
	else
		album_id_none_removed = album_id
	end
	
	if(artist_id.eql?("None"))
		artist_id_none_removed = -1
	else
		artist_id_none_removed = artist_id
	end
		
	puts "Track #{track_id}"
		
	#if(items_db.execute("SELECT * FROM Track WHERE ID='#{track_id}'").length == 0)
		items_db.execute("INSERT INTO Track (TrackID,AlbumID,ArtistID) VALUES ('#{track_id}','#{album_id_none_removed}','#{artist_id_none_removed}')")
	#end
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(!genre_id.eql?("None"))
				#if(items_db.execute("SELECT * FROM TrackGenreXref WHERE TrackID='#{track_id}' AND GenreID='#{genre_id}'").length == 0)
					items_db.execute("INSERT INTO TrackGenreXref (TrackID,GenreID) VALUES ('#{track_id}','#{genre_id}')")
				#end
				#if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Track'").length == 0)
				if(!artist_id.eql?("None"))				
					#items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Track')")
				end
				#end
			end
		end
	end
end

items_db.commit

  
  
album_handle = File.open("albumData1.txt","r")

items_db.transaction 
  
while !(album_handle.eof?)
	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",3)
	
	if(artist_id.eql?("None"))
		artist_id_none_removed = -1
	else
		artist_id_none_removed = artist_id
	end
		
	puts "Album #{album_id}"
		
	#if(items_db.execute("SELECT * FROM Album WHERE ID='#{album_id}'").length == 0)
		items_db.execute("INSERT INTO Album (AlbumID,ArtistID) VALUES ('#{album_id}','#{artist_id_none_removed}')")
	#end
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(!genre_id.eql?("None"))
				#if(items_db.execute("SELECT * FROM AlbumGenreXref WHERE AlbumID='#{album_id}' AND GenreID='#{genre_id}'").length == 0)
					items_db.execute("INSERT INTO AlbumGenreXref (AlbumID,GenreID) VALUES ('#{album_id}','#{genre_id}')")
				#end
				#if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Album'").length == 0)
				if(!artist_id.eql?("None"))
					#items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Album')")
				end	
				#end
			end
		end
	end
  end
  
items_db.commit  
  

artist_handle = File.open("artistData1.txt","r")

items_db.transaction 
  
while !(artist_handle.eof?)
	artist_id =  artist_handle.readline.chomp
		
	puts "Artist #{artist_id}"	
		
	#if(items_db.execute("SELECT * FROM Artist WHERE ID='#{artist_id}'").length == 0)
		items_db.execute("INSERT INTO Artist (ArtistID) VALUES ('#{artist_id}')")
	#end
end

items_db.commit



genre_handle = File.open("genreData1.txt","r")

items_db.transaction 
  
while !(genre_handle.eof?)
	genre_id =  genre_handle.readline.chomp
		
	puts "Genre #{genre_id}"		
		
	#if(items_db.execute("SELECT * FROM Genra WHERE ID='#{genre_id}'").length == 0)
		items_db.execute("INSERT INTO Genre (GenreID) VALUES ('#{genre_id}')")
	#end
end

items_db.commit