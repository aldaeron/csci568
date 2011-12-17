require 'sqlite3'
  
users_db = SQLite3::Database.open('KDD-genre-10000.db3')

  
output_handle = File.open("genre-10000.csv","w")

genre_data_meta = users_db.prepare("SELECT * FROM Train")
genre_data_meta.columns.each do |item|
	output_handle.printf("%s,",item)
end
output_handle.seek(-1,IO::SEEK_CUR)
output_handle.printf("\n")

  
  
genre_data = users_db.execute("SELECT * FROM Train") do |row|
	row.each do |item|
		output_handle.printf("%s,",item)
	end
	output_handle.seek(-1,IO::SEEK_CUR)
	output_handle.printf("\n")
end
