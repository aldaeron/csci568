require 'sqlite3'
  
items_db = SQLite3::Database.open('KDD-items.db3')
  
log_handle = File.open("verificationLogFile2.txt","w")
  
track_handle = File.open("trackData1.txt","r")
album_handle = File.open("albumData1.txt","r")
artist_handle = File.open("artistData1.txt","r")
genre_handle = File.open("genreData1.txt","r")

  
  
global_counter = 1



  
genre_handle.rewind
query_string = "SELECT * FROM Genre WHERE "
counter = 1
    
while !(genre_handle.eof?)

	genre_id =  genre_handle.readline.chomp
		
	puts "Genre #{genre_id}"			
		
	query_string = query_string << "(GenreID='#{genre_id}') OR "
	
	if (counter == 950)
		query_string = query_string[0..-4]
		check_value = items_db.execute(query_string).length
		if(counter == check_value)
			log_handle.puts "Global Counter: #{global_counter} - Genre #{genre_id} - Check OK!"
		else
			log_handle.puts "Global Counter: #{global_counter} - Genre #{genre_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
		end
		query_string = "SELECT * FROM Genre WHERE "
		counter -= 950
	end
		
	counter += 1
	global_counter += 1
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
check_value = items_db.execute(query_string).length
if(counter == check_value)
	log_handle.puts "Global Counter: #{global_counter} - Genre #{genre_id} - Check OK!"
else
	log_handle.puts "Global Counter: #{global_counter} - Genre #{genre_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
end






# Not checking the Xref tables
artist_handle.rewind
query_string = "SELECT * FROM Artist WHERE "
counter = 1
    
while !(artist_handle.eof?)

	artist_id =  artist_handle.readline.chomp
		
	puts "Artist #{artist_id}"
	
	query_string = query_string << "(ArtistID='#{artist_id}') OR "
	
	if (counter == 950)
		query_string = query_string[0..-4]
		check_value = items_db.execute(query_string).length
		if(counter == check_value)
			log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} - Check OK!"
		else
			log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
		end
		query_string = "SELECT * FROM Artist WHERE "
		counter -= 950
	end
		
	counter += 1
	global_counter += 1
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
check_value = items_db.execute(query_string).length
if(counter == check_value)
	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} - Check OK!"
else
	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
end






# Not checking the Xref tables
album_handle.rewind
query_string = "SELECT * FROM Album WHERE "
counter = 1
    
while !(album_handle.eof?)

	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",3)
	
	if(artist_id.eql?("None"))
		artist_id_none_removed = -1
	else
		artist_id_none_removed = artist_id
	end
		
	puts "Album #{album_id}"
	
	query_string = query_string << "(AlbumID='#{album_id}' AND ArtistID='#{artist_id_none_removed}') OR "
	
	if (counter == 950)
		query_string = query_string[0..-4]
		check_value = items_db.execute(query_string).length
		if(counter == check_value)
			log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check OK!"
		else
			log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
		end
		query_string = "SELECT * FROM Album WHERE "
		counter -= 950
	end
		
	counter += 1
	global_counter += 1
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
check_value = items_db.execute(query_string).length
if(counter == check_value)
	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check OK!"
else
	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
end






# Not checking the Xref tables
track_handle.rewind
query_string = "SELECT * FROM Track WHERE "
counter = 1
    
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
	
	query_string = query_string << "(TrackID='#{track_id}' AND AlbumID='#{album_id_none_removed}' AND ArtistID='#{artist_id_none_removed}') OR "
	
	if (counter == 950)
		query_string = query_string[0..-4]
		check_value = items_db.execute(query_string).length
		if(counter == check_value)
			log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check OK!"
		else
			log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
		end
		query_string = "SELECT * FROM Track WHERE "
		counter -= 950
	end
		
	counter += 1
	global_counter += 1
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
check_value = items_db.execute(query_string).length
if(counter == check_value)
	log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check OK!"
else
	log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
end