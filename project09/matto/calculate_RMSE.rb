

def calculate_RMSE(input_file_path,solution_file_path)
	if File::readable?(input_file_path.to_s) && File::readable?(solution_file_path.to_s)	
		
		# Open results files
		input_file_handle = File.open(input_file_path.to_s)
		solution_handle = File.open(solution_file_path.to_s)
		
		
		# Init counters
		sse = 0.0
		number_ratings = 0
		
		
		while !(input_file_handle.eof?)
			input_id,input_ratings_count = input_file_handle.readline.chomp.split("|",2)
			solution_id,solution_ratings_count = solution_handle.readline.chomp.split("|",2)
	
			if(input_id == solution_id && input_ratings_count == solution_ratings_count)
				solution_ratings_count.to_i.times do
					solution_item_id,solution_score,solution_date,solution_time = solution_handle.readline.chomp.split(/\t/,4)
					input_item_id,input_score,input_date,input_time = input_file_handle.readline.chomp.split(/\t/,4)
					if(input_item_id == solution_item_id && input_date == solution_date && input_time == solution_time)
						sse += (solution_score.to_f-input_score.to_f)**2
						number_ratings += 1
					else 
						# Error Handling
					end
				end
			else 
				# Error Handling
			end
		end
		rmse = Math.sqrt(sse/number_ratings)
		return rmse
	else
		# Error Handling
		return 0.0/0.0
	end
end


# Test only
#p calculate_RMSE("sample_set/simple_samples/0.txt", "sample_set/sample_solution.txt")