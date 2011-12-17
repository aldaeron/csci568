require 'sqlite3'
  
users_db = SQLite3::Database.open('KDD-user-search.db3')
  
full_input_handle = File.open("full_validation.txt","r")
full_output_handle = File.open("full_blank.txt","r")
  
  
  
users_db.transaction 
  
while !(full_input_handle.eof?)
	id,ratings_count = full_input_handle.readline.chomp.split("|",2)
	puts "Input User: #{id}"
	ratings_count.to_i.times do
		item_id,rating,date,time = full_input_handle.readline.chomp.split(/\t/,4)
		users_db.execute("INSERT INTO FullUserInput (UserID,ItemID,Rating) VALUES ('#{id}','#{item_id}','#{rating}')")
	end
end

users_db.commit





users_db.transaction 
  
while !(full_output_handle.eof?)
	id,ratings_count = full_output_handle.readline.chomp.split("|",2)
	puts "Output User: #{id}"
	ratings_count.to_i.times do
		item_id,date,time = full_output_handle.readline.chomp.split(/\t/,3)
		users_db.execute("INSERT INTO FullUserOutput (UserID,ItemID) VALUES ('#{id}','#{item_id}')")
	end
end

users_db.commit