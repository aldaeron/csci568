

template_handle = File.open("sample_blank.txt","r")

for i in 0..255

	template_handle.rewind

    simple_sample_filename = ("simple_samples/" << i.to_s << ".txt")

	if File.exists?(simple_sample_filename)
		File.delete(simple_sample_filename)
	end
	
	simple_sample_handle = File.open(simple_sample_filename, "w")
	
	while !(template_handle.eof?)
		id,ratings_count = template_handle.readline.chomp.split("|",2)
		simple_sample_handle.puts("#{id}|#{ratings_count}")
		ratings_count.to_i.times do
			item_id,date,time = template_handle.readline.chomp.split(/\t/,3)
			simple_sample_handle.puts("#{item_id}\t#{((i.to_f/255)*100).to_s}\t#{date}\t#{time}")
		end
	end
	
end