require 'sqlite3'
require_relative '../item_type.rb'
  
users_db = SQLite3::Database.open('KDD-genre-sample.db3')
items_db = SQLite3::Database.open('KDD-items.db3')
  
input_handle = File.open("sample_train.txt","r")
output_handle = File.open("sample_genre_rollup.txt","w")
  
  
num_genres = items_db.execute("SELECT * FROM Genre").length


genre_running_totals_list = Hash.new
genre_counter_list = Hash.new

users_db.transaction
  
while !(input_handle.eof?)
	id,ratings_count = input_handle.readline.chomp.split("|",2)
	
	genre_running_totals_list.clear
	genre_counter_list.clear
	
	puts "User: #{id}"
	ratings_count.to_i.times do
		item_id,rating,date,time = input_handle.readline.chomp.split(/\t/,4)
		item_type = item_type(item_id, items_db)
		if(item_type.eql?("Track"))
			query_string = "SELECT DISTINCT Genre.ID FROM Genre,TrackGenreXref WHERE TrackGenreXref.TrackID='#{item_id}' AND TrackGenreXref.GenreID=Genre.GenreID ORDER BY Genre.ID ASC "
			genre_list = items_db.execute(query_string)
		elsif(item_type.eql?("Album"))
			query_string = "SELECT DISTINCT Genre.ID FROM Genre,AlbumGenreXref WHERE AlbumGenreXref.AlbumID='#{item_id}' AND AlbumGenreXref.GenreID=Genre.GenreID ORDER BY Genre.ID ASC "
			genre_list = items_db.execute(query_string)
		elsif(item_type.eql?("Artist"))
			query_string = "SELECT DISTINCT Genre.ID FROM Genre,ArtistGenreXref WHERE ArtistGenreXref.ArtistID='#{item_id}' AND ArtistGenreXref.GenreID=Genre.GenreID ORDER BY Genre.ID ASC"
			genre_list = items_db.execute(query_string)
		elsif(item_type.eql?("Genre"))
			query_string = "SELECT DISTINCT Genre.ID FROM Genre WHERE GenreID='#{item_id}' ORDER BY Genre.ID ASC "
			genre_list = items_db.execute(query_string)
		else
			puts "Error on ID #{item_id}"
		end
		
		genre_list = genre_list.flatten
		
		genre_list.each do |genre_id|
			if(genre_running_totals_list[genre_id])
				genre_running_totals_list[genre_id] += rating.to_i
			else
				genre_running_totals_list[genre_id] = rating.to_i
			end
			
			if(genre_counter_list[genre_id])
				genre_counter_list[genre_id] += 1
			else
				genre_counter_list[genre_id] = 1
			end
		end		
	end
	
	
	
	
	
	query_string = "INSERT INTO Train (TrainUserID,"
		
	genre_running_totals_list.each do |genre_id, running_total|
		query_string << "Genre#{genre_id},"
	end
		
	query_string = query_string[0...-1]
		
	query_string << ") VALUES ('#{id}',"
		
	genre_running_totals_list.each do |genre_id, running_total|
		query_string << "'#{running_total.to_f/genre_counter_list[genre_id]}',"
	end
		
	query_string = query_string[0...-1]
		
	query_string << ")"
		
	users_db.execute(query_string)
end

users_db.commit