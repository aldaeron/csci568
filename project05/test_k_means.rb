require_relative 'k_means'

# Test K Means function with Iris dataset

iris_data_handle = File.open("iris.csv", "r")

data_set_string = Hash.new
data_set = Hash.new
normalized_data_set = Hash.new
data_title = Hash.new
data_type = Hash.new
data_size = 0

range_min = Hash.new
range_max = Hash.new
range = Hash.new

cluster_point_list = Hash.new
cluster_centroid_list = Hash.new
cluster_SSE_list = Hash.new
cluster_SSB_list = Hash.new
cluster_density_list = Hash.new

output_file_pointer = File.open("test.txt", "w")



data_title = iris_data_handle.readline.strip.split(",")
data_type = iris_data_handle.readline.strip.split(",")



iris_data_handle.each {|line|
	data_set_string[data_size] = line.strip.split(",")
	data_set[data_size] = Hash.new
	normalized_data_set[data_size] = Hash.new
	data_size += 1
}



data_dimension = data_type.size

for data_key,data_record in data_set_string
	dimension_key = 0
	for data_value in data_record
		data_set[data_key][dimension_key] = data_value.to_f
		dimension_key += 1
	end
end


# Preprocess the data.  For now assume there are no extreme outliers
# In the future look at St Dev and Mean and possibly use DBScan to get rid of outliers
for dimension_key in 0...data_dimension
	# Find the data range for each dimension
	range_min[dimension_key] = Float::MAX
	range_max[dimension_key] = -1*Float::MAX
	for data_key in 0...data_size
		if data_set[data_key][dimension_key] < range_min[dimension_key]
			range_min[dimension_key] = data_set[data_key][dimension_key]
		end
		if data_set[data_key][dimension_key] > range_max[dimension_key]
			range_max[dimension_key] = data_set[data_key][dimension_key]
		end
	end
	range[dimension_key] = range_max[dimension_key] - range_min[dimension_key]
end

# Scale data in all dimensions to [0,1]
for dimension_key in 0...data_dimension
	for data_key in 0...data_size
		normalized_data_set[data_key][dimension_key] = (data_set[data_key][dimension_key] - range_min[dimension_key])/range[dimension_key]
	end
end





k_min = 2;
k_max = 9;
iteration_max = 150;





output_file_pointer.printf("START-DATA-SET\n")
output_file_pointer.printf("NUM-DIMENSIONS:#{data_dimension}\n")
output_file_pointer.printf("NUM-DATA-POINTS:#{data_size}\n")
output_file_pointer.printf("K-MIN:#{k_min}\n")
output_file_pointer.printf("K-MAX:#{k_max}\n")
output_file_pointer.printf("ITERATION-MAX:#{iteration_max}\n")
for data_key in 0...data_size
	output_file_pointer.printf("DATA-POINT:#{data_key}:")
	for dimension_key in 0...data_dimension
		output_file_pointer.printf("#{data_set[data_key][dimension_key]},")
	end
	output_file_pointer.seek(-1, IO::SEEK_CUR) # Gets rid of the extra comma
	output_file_pointer.printf("\n")
end
for dimension_key in 0...data_dimension
	output_file_pointer.printf("DIMENSION-LABEL:#{dimension_key}:#{data_title[dimension_key]}\n")
end
output_file_pointer.printf("END-DATA-SET\n")

# IS DENSITY CALCULATED CORRECTLY???  
# DOES NOT USE RANGE, LOOKS IN NORMALIZED SPACE

for k in k_min..k_max
	for iteration in 0...iteration_max
		cluster_point_list, cluster_centroid_list, cluster_SSE_list, cluster_SSB_list, cluster_density_list, convergence_iteration, convergence_condition, convergence_info = k_means_normalized(k, normalized_data_set, data_size, data_dimension, 0, 0, 0, 100)
		# This is not "blocking" well, need to read more of the Ruby book
		#for i in 0...k
		#	for j in 0...data_dimension
		#		cluster_centroid_list[i][j] = range_min[i] + (range[i]*cluster_centroid_list[i][j])
		#	end
		#end
		output_file_pointer.printf("START-ITERATION\n")
		output_file_pointer.printf("K:#{k}:ITERATION:#{iteration}\n")
		output_file_pointer.printf("CONVERGENCE-METHOD:#{convergence_condition}\n")
		output_file_pointer.printf("CONVERGENCE-ITERATION:#{convergence_iteration}\n")
		output_file_pointer.printf("CONVERGENCE-INFO:#{convergence_info}\n")
		for i in 0...k
			output_file_pointer.printf("CLUSTER-START:#{i}\n")
			output_file_pointer.printf("CLUSTER-POINT_LIST:")
			for j in 0...cluster_point_list[i].length
				output_file_pointer.printf("#{cluster_point_list[i][j]},")
			end
			output_file_pointer.seek(-1, IO::SEEK_CUR) # Gets rid of the extra comma
			output_file_pointer.printf("\n")

			output_file_pointer.printf("CLUSTER-CENTROID_LIST:")
			for j in 0...data_dimension
				output_file_pointer.printf("#{cluster_centroid_list[i][j]},")
			end
			output_file_pointer.seek(-1, IO::SEEK_CUR) # Gets rid of the extra comma
			output_file_pointer.printf("\n")


			output_file_pointer.printf("CLUSTER-SSE:#{cluster_SSE_list[i]}\n");
			output_file_pointer.printf("CLUSTER-SSB:#{cluster_SSB_list[i]}\n");
			output_file_pointer.printf("CLUSTER-Density:#{cluster_density_list[i]}\n");
			output_file_pointer.printf("CLUSTER-END\n")
		end
		output_file_pointer.printf("END-ITERATION\n")
	end
end

# For later for removing columns that we don't care about
# For now do it manually
#for i in 0...data_type.size
#	puts "|#{data_type[i]}|"
#	if !(data_type[i] == "crap")
#		puts "#{data_title}"
#		puts "#{data_type}"
#		data_title.delete(i)
#		data_type.delete(i)
#		for j in 0...data_set.size
#			data_set.delete(j)
#		end
#	end
#end





# Printout data - LOOKS GOOD!
#puts data_title
#puts data_type
#for key,hash in data_set
#	puts "#{key}, "
#	for stuff in hash
#		puts "#{stuff}, "
#	end
#end
	