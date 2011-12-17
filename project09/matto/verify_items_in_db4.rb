require 'sqlite3'
  
items_db = SQLite3::Database.open('KDD-items.db3')
  
log_handle = File.open("verificationLogFile4.txt","w")
  
track_handle = File.open("trackData1.txt","r")
album_handle = File.open("albumData1.txt","r")
artist_handle = File.open("artistData1.txt","r")
genre_handle = File.open("genreData1.txt","r")

  
  
global_counter = 1






# Checking the Xref tables
album_handle.rewind
query_string = "SELECT * FROM ArtistGenreXref WHERE "
counter = 1
    
while !(album_handle.eof?)

	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",3)
		
	puts "Artist #{artist_id} from Album #{album_id}"
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if( !genre_id.eql?("None") && !artist_id.eql?("None") )
				query_string = query_string << "(ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Album') OR "
				if (counter == 950)
					query_string = query_string[0..-4]
					log_handle.puts query_string
					check_value = items_db.execute(query_string).length
					if(counter == check_value)
						log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check OK!"
					else
						log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
					end
					query_string = "SELECT * FROM ArtistGenreXref WHERE "
					counter -= 950
				end
		
				counter += 1
				global_counter += 1
			end
		end
	end
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
#check_value = items_db.execute(query_string).length
#if(counter == check_value)
#	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check OK!"
#else
#	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
#end





  


# Checking the Xref tables
album_handle.rewind
query_string = "SELECT * FROM AlbumGenreXref WHERE "
counter = 1
    
while !(album_handle.eof?)

	album_id,artist_id,genre_id_string =  album_handle.readline.chomp.split("|",3)
		
	puts "Album #{album_id}"
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if( !genre_id.eql?("None")  )
				query_string = query_string << "(AlbumID='#{album_id}' AND GenreID='#{genre_id}') OR "
				if (counter == 950)
					log_handle.puts query_string
					query_string = query_string[0..-4]
					check_value = items_db.execute(query_string).length
					if(counter == check_value)
						log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check OK!"
					else
						log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
					end
					query_string = "SELECT * FROM AlbumGenreXref WHERE "
					counter -= 950
				end
		
				counter += 1
				global_counter += 1
			end
		end
	end
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
#check_value = items_db.execute(query_string).length
#if(counter == check_value)
#	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check OK!"
#else
#	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
#end






# Checking the Xref tables
track_handle.rewind
query_string = "SELECT * FROM ArtistGenreXref WHERE "
counter = 1
    
while !(track_handle.eof?)

	track_id,album_id,artist_id,genre_id_string =  track_handle.readline.chomp.split("|",4)
		
	puts "Artist #{artist_id} from Track #{track_id}"
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if( !genre_id.eql?("None") && !artist_id.eql?("None") )
				query_string = query_string << "(ArtistID='#{artist_id}' AND GenreID='#{genre_id}' AND Source='Album') OR "
				if (counter == 950)
					log_handle.puts query_string
					query_string = query_string[0..-4]
					check_value = items_db.execute(query_string).length
					if(counter == check_value)
						log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Track #{track_id} - Check OK!"
					else
						log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Track #{track_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
					end
					query_string = "SELECT * FROM ArtistGenreXref WHERE "
					counter -= 950
				end
		
				counter += 1
				global_counter += 1
			end
		end
	end
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
#check_value = items_db.execute(query_string).length
#if(counter == check_value)
#	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check OK!"
#else
#	log_handle.puts "Global Counter: #{global_counter} - Artist #{artist_id} from Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
#end





  


# Checking the Xref tables
track_handle.rewind
query_string = "SELECT * FROM TrackGenreXref WHERE "
counter = 1
    
while !(track_handle.eof?)

	track_id,album_id,artist_id,genre_id_string =  track_handle.readline.chomp.split("|",4)
		
	puts "Track #{track_id}"
	
	if genre_id_string != nil
		genre_id_list = genre_id_string.split("|")
		genre_id_list.each do |genre_id| 
			if( !genre_id.eql?("None")  )
				query_string = query_string << "(TrackID='#{track_id}' AND GenreID='#{genre_id}') OR "
				if (counter == 950)
					log_handle.puts query_string
					query_string = query_string[0..-4]
					check_value = items_db.execute(query_string).length
					if(counter == check_value)
						log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check OK!"
					else
						log_handle.puts "Global Counter: #{global_counter} - Track #{track_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
					end
					query_string = "SELECT * FROM TrackGenreXref WHERE "
					counter -= 950
				end
		
				counter += 1
				global_counter += 1
			end
		end
	end
	
end

#Last Partial Set
counter -= 1 # think we need this
query_string = query_string[0..-4]
#check_value = items_db.execute(query_string).length
#if(counter == check_value)
#	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check OK!"
#else
#	log_handle.puts "Global Counter: #{global_counter} - Album #{album_id} - Check Fail - Should have had #{counter} and did have #{check_value}"
#end