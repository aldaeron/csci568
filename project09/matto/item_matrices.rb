# THIS IS TOO SLOW! Plus this matrix is VERY sparse.  

# It is probably better to calculate a function later. Something like:
#   item_something(trackID_1,trackID_2)

require 'sqlite3'

 
items_db = SQLite3::Database.open('KDD-items.db3')
  
  
num_tracks = items_db.execute("SELECT * FROM Track").length

# Can't allocate this much memory!
#album_relation_matrix = Array.new(num_tracks) { Array.new(num_tracks) }
#artist_relation_matrix = Array.new(num_tracks) { Array.new(num_tracks) }
#genre_relation_matrix = Array.new(num_tracks) { Array.new(num_tracks) }
#total_relation_matrix = Array.new(num_tracks) { Array.new(num_tracks) }


album_handle = File.open("track_album_matrix.txt","w")
artist_handle = File.open("track_artist_matrix.txt","w")
genre_handle = File.open("track_genre_matrix.txt","w")
total_handle = File.open("track_total_matrix.txt","w")


genre_list_i = Array.new()
genre_list_j = Array.new()

items_db.results_as_hash = true

for i in 1..num_tracks
	puts "Item:#{i} of #{num_tracks}"
	for j in 1..num_tracks
		item_i = items_db.execute("SELECT * FROM Track WHERE ID=#{i} LIMIT 1")
		item_j = items_db.execute("SELECT * FROM Track WHERE ID=#{j} LIMIT 1")
		
		genre_list_i.clear
		genre_list_j.clear
		
		
		genre_i = items_db.execute("SELECT * FROM TrackGenreXref WHERE TrackID=#{item_i[0]["TrackID"]}") do |row|
			genre_list_i.push(row["GenreID"].to_i)
		end
		genre_j = items_db.execute("SELECT * FROM TrackGenreXref WHERE TrackID=#{item_j[0]["TrackID"]}") do |row|
			genre_list_j.push(row["GenreID"].to_i)
		end

		
		
		

		
		if(item_i[0]["AlbumID"].to_i == item_j[0]["AlbumID"].to_i)
			album_temp = 1.0
		else
			album_temp = 0.0
		end
		
		if(item_i[0]["ArtistID"].to_i == item_j[0]["ArtistID"].to_i)
			artist_temp = 1.0
		else
			artist_temp = 0.0
		end
		
		if( (genre_list_i.length + genre_list_j.length) > 0)
			genre_temp = (genre_list_i & genre_list_j).length.to_f/((genre_list_i + genre_list_j).uniq.length).to_f
		else 
			genre_temp = 0.0
		end
		
		album_handle.printf("%1.3f,",album_temp)
		artist_handle.printf("%1.3f,",artist_temp)
		genre_handle.printf("%1.3f,",genre_temp)
		total_handle.printf("%1.3f,",album_temp + artist_temp + genre_temp)
	end
	album_handle.seek(-1,IO::SEEK_CUR)
	album_handle.printf("\n")
	artist_handle.seek(-1,IO::SEEK_CUR)
	artist_handle.printf("\n")
	genre_handle.seek(-1,IO::SEEK_CUR)
	genre_handle.printf("\n")
	total_handle.seek(-1,IO::SEEK_CUR)
	total_handle.printf("\n")
end




#album_relation_matrix.each do |line|
#	line.each do |cell|
#		album_handle.printf("%1.3f,",cell)
#	end
#	album_handle.seek(-1,IO::SEEK_CUR)
#	album_handle.printf("\n")
#end
