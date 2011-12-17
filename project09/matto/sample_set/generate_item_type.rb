require_relative '../item_type.rb'
  
items_db = SQLite3::Database.open('KDD-items.db3')

source_handle = File.open("trainIdx1.firstLines.txt","r")
  
processed_handle = File.open("train_type.txt","w")
processed_stats_handle = File.open("train_type_stats.txt","w")
  
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
		item_type = item_type(item_id, items_db)
		if(item_type.eql?("Track"))
			track_counter += 1
		elsif(item_type.eql?("Album"))
			album_counter += 1
		elsif(item_type.eql?("Artist"))
			artist_counter += 1
		elsif(item_type.eql?("Genre"))
			genre_counter += 1
		else
			puts "Error on ID #{item_id}"
			error_counter += 1
		end
		
		processed_handle.puts("#{item_id}\t#{item_type}")
		
	end
end  
  
processed_stats_handle.puts("Track\t#{track_counter}")
processed_stats_handle.puts("Album\t#{album_counter}")
processed_stats_handle.puts("Artist\t#{artist_counter}")
processed_stats_handle.puts("Genre\t#{genre_counter}")
processed_stats_handle.puts("Error\t#{error_counter}")