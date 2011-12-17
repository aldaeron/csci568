require 'sqlite3'
  
users_db = SQLite3::Database.open('KDD-user-search.db3')
  
train_handle = File.open("trainIdx1.txt","r")
  
  
  
users_db.transaction 
  
while !(train_handle.eof?)
	id,ratings_count = train_handle.readline.chomp.split("|",2)
	puts "User: #{id}"
	ratings_count.to_i.times do
		item_id,rating,date,time = train_handle.readline.chomp.split(/\t/,4)
		users_db.execute("INSERT INTO Train (UserID,ItemID,Rating) VALUES ('#{id}','#{item_id}','#{rating}')")
	end
end

users_db.commit