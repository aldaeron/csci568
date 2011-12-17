require 'sqlite3'
  
users_db = SQLite3::Database.open('KDD-user-search.db3')
  
sample_input_handle = File.open("sample_validation.txt","r")
sample_output_handle = File.open("sample_blank.txt","r")
  
  
  
users_db.transaction 
  
while !(sample_input_handle.eof?)
	id,ratings_count = sample_input_handle.readline.chomp.split("|",2)
	puts "Input User: #{id}"
	ratings_count.to_i.times do
		item_id,rating,date,time = sample_input_handle.readline.chomp.split(/\t/,4)
		users_db.execute("INSERT INTO SampleUserInput (UserID,ItemID,Rating) VALUES ('#{id}','#{item_id}','#{rating}')")
	end
end

users_db.commit





users_db.transaction 
  
while !(sample_output_handle.eof?)
	id,ratings_count = sample_output_handle.readline.chomp.split("|",2)
	puts "Output User: #{id}"
	ratings_count.to_i.times do
		item_id,date,time = sample_output_handle.readline.chomp.split(/\t/,3)
		users_db.execute("INSERT INTO SampleUserOutput (UserID,ItemID) VALUES ('#{id}','#{item_id}')")
	end
end

users_db.commit