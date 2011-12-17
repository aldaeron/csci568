# NOT faster =(

require 'sqlite3'

items_db = SQLite3::Database.open('KDD-items.db3')

track_temp = items_db.execute("SELECT TrackID FROM Track")
album_temp = items_db.execute("SELECT AlbumID FROM Album")
artist_temp = items_db.execute("SELECT ArtistID FROM Artist")
genre_temp = items_db.execute("SELECT GenreID FROM Genre")

track_list = Array.new
track_temp.each {|id| track_list.push(id[0].to_i) }

album_list = Array.new
album_temp.each {|id| album_list.push(id[0].to_i) }

artist_list = Array.new 
artist_temp.each {|id| artist_list.push(id[0].to_i) }

genre_list = Array.new
genre_temp.each {|id| genre_list.push(id[0].to_i) }


source_handle = File.open("trainIdx1.txt","r")
  
processed_handle = File.open("train_type2.txt","w")
processed_stats_handle = File.open("train_type_stats2.txt","w")
  
track_counter = 0
album_counter = 0
artist_counter = 0
genre_counter = 0
error_counter = 0
  
while !(source_handle.eof?)
	id,ratings_count = source_handle.readline.chomp.split("|",2)
	puts "User: #{id}"
	processed_handle.puts("#{id}|#{ratings_count}")
	ratings_count.to_i.times do
		#item_id,date,time = source_handle.readline.chomp.split(/\t/,3)
		item_id,rating,date,time = source_handle.readline.chomp.split(/\t/,4)

		item_id = item_id.to_i
		
		if(track_list.include?(item_id))
			track_counter += 1
			processed_handle.puts("#{item_id}\tTrack")
		elsif(album_list.include?(item_id))
			album_counter += 1
			processed_handle.puts("#{item_id}\tAlbum")
		elsif(artist_list.include?(item_id))
			artist_counter += 1
			processed_handle.puts("#{item_id}\tArtist")
		elsif(genre_list.include?(item_id))
			genre_counter += 1
			processed_handle.puts("#{item_id}\tGenre")
		else
			puts "Error on ID #{item_id}"
			processed_handle.puts("#{item_id}\tError")
			error_counter += 1
		end
	end
end  
  
processed_stats_handle.puts("Track\t#{track_counter}")
processed_stats_handle.puts("Album\t#{album_counter}")
processed_stats_handle.puts("Artist\t#{artist_counter}")
processed_stats_handle.puts("Genre\t#{genre_counter}")
processed_stats_handle.puts("Error\t#{error_counter}")