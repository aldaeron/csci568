require 'sqlite3'
  
items_db = SQLite3::Database.open('KDD-items.db3')
  
log_handle = File.open("verificationLogFile.txt","w")
  
track_handle = File.open("trackData1.txt","r")
  

  
while !(track_handle.eof?)
	track_id,album_id,artist_id,genre_id_string =  track_handle.readline.chomp.split("|",4)
		
	puts "Track #{track_id}"
		
	if(items_db.execute("SELECT * FROM Track WHERE TrackID='#{track_id}'").length == 0)
		#items_db.execute("INSERT INTO Track (TrackID,AlbumID,ArtistID) VALUES ('#{track_id}','#{album_id}','#{artist_id}')")
		log_handle.puts "Track #{track_id} was NOT in Track table"
		puts "Track #{track_id} was NOT in Track table"
	else
		#puts "Track #{track_id} verified in Track table"
	end
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(items_db.execute("SELECT * FROM TrackGenreXref WHERE TrackID='#{track_id}' AND GenreID='#{genre_id}'").length == 0)
				#items_db.execute("INSERT INTO TrackGenreXref (TrackID,GenreID) VALUES ('#{track_id}','#{genre_id}')")
				log_handle.puts "Track #{track_id} & Genre #{genre_id} was NOT in TrackGenreXref table"
				puts "Track #{track_id} & Genre #{genre_id} was NOT in TrackGenreXref table"
			else
				#puts "Track #{track_id} & Genre #{genre_id} verified in TrackGenreXref table"
			end
			
			if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}'").length == 0)
				#items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Track')")
				log_handle.puts "Artist #{artist_id} & Genre #{genre_id} was NOT in ArtistGenreXref table"
				puts "Artist #{artist_id} & Genre #{genre_id} was NOT in ArtistGenreXref table"
			else
				#puts "Artist #{artist_id} & Genre #{genre_id} verified in ArtistGenreXref table"
			end
		end
	end
end



  
  
album_handle = File.open("albumData1.txt","r")
  
while !(album_handle.eof?)
	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",4)
		
	puts "Album #{album_id}"
		
	if(items_db.execute("SELECT * FROM Album WHERE AlbumID='#{album_id}'").length == 0)
		#items_db.execute("INSERT INTO Album (AlbumID,ArtistID) VALUES ('#{album_id}','#{artist_id}')")
		log_handle.puts "Album #{album_id} was NOT in Album table"
		puts "Album #{album_id} was NOT in Album table"
	else
		#puts "Album #{album_id} verified in Album table"
	end
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if(items_db.execute("SELECT * FROM AlbumGenreXref WHERE AlbumID='#{album_id}' AND GenreID='#{genre_id}'").length == 0)
				#items_db.execute("INSERT INTO AlbumGenreXref (AlbumID,GenreID) VALUES ('#{album_id}','#{genre_id}')")
				log_handle.puts "Album #{album_id} & Genre #{genre_id} was NOT in AlbumGenreXref table"
				puts "Album #{album_id} & Genre #{genre_id} was NOT in AlbumGenreXref table"
			else
				#puts "Album #{album_id} & Genre #{genre_id} verified in AlbumGenreXref table"
			end
			
			
			if(items_db.execute("SELECT * FROM ArtistGenreXref WHERE ArtistID='#{artist_id}' AND GenreID='#{genre_id}'").length == 0)
				#items_db.execute("INSERT INTO ArtistGenreXref (ArtistID,GenreID,Source) VALUES ('#{artist_id}','#{genre_id}','Album')")
				log_handle.puts "Artist #{artist_id} & Genre #{genre_id} was NOT in ArtistGenreXref table"
				puts "Artist #{artist_id} & Genre #{genre_id} was NOT in ArtistGenreXref table"
			else
				#puts "Artist #{artist_id} & Genre #{genre_id} verified in ArtistGenreXref table"
			end
		end
	end
  end
  

  

artist_handle = File.open("artistData1.txt","r") 
  
while !(artist_handle.eof?)
	artist_id =  artist_handle.readline.chomp
		
	puts "Artist #{artist_id}"	
		
	if(items_db.execute("SELECT * FROM Artist WHERE ArtistID='#{artist_id}'").length == 0)
		#items_db.execute("INSERT INTO Album (ArtistID) VALUES ('#{artist_id}')")
		log_handle.puts "Artist #{artist_id} was NOT in Artist table"
		puts "Artist #{artist_id} was NOT in Artist table"
	else
		#puts "Artist #{artist_id} verified in Artist table"
	end
end





genre_handle = File.open("genreData1.txt","r") 
  
while !(genre_handle.eof?)
	genre_id =  genre_handle.readline.chomp
		
	puts "Genre #{genre_id}"		
		
	if(items_db.execute("SELECT * FROM Genre WHERE GenreID='#{genre_id}'").length == 0)
		#items_db.execute("INSERT INTO Genre (GenreID) VALUES ('#{genre_id}')")
		log_handle.puts "Genre #{genre_id} was NOT in Genre table"
		puts "Genre #{genre_id} was NOT in Genre table"
	else
		#puts "Genre #{genre_id} verified in Genre table"
	end
end