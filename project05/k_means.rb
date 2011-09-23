

=begin
CSCI Fall 2011 Project 5
An implementation of the K-Means Clustering Algorithm
Matt O'Neal
Last Updated 2011-09-22
All code contained in this document is original, except as indicated otherwiss
=end

def k_means(k, data_set, data_size, data_dimension, stall_value, stall_type, stall_iterations, max_iterations)
	#
	# Variable Definitions Here
	#

	
	range_min = Hash.new
	range_max = Hash.new
	range = Hash.new

	centroid = Hash.new
	point_to_current_centroid_distance = Hash.new
	points_current_cluster = Hash.new

	centroid_running_sum = Hash.new
	centroid_num_points = Hash.new


	for cluster_key in 0...k
		centroid[cluster_key] = Hash.new
		centroid_running_sum[cluster_key] = Hash.new
	end

	for data_key in 0...data_size
		point_to_current_centroid_distance[data_key] = Hash.new
	end
	


	
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

		# Use the range to create a random starting point for the centroids
		for cluster_key in 0...k
			centroid[cluster_key][dimension_key] = range_min[dimension_key] + range[dimension_key]*rand()
		end
	end
		

	iteration = 1

	while (iteration <= max_iterations) do

		puts centroid
		puts " "
		puts " "

		# Calculate the distance between each point and each centroid
		for data_key in 0...data_size
			for cluster_key in 0...k
				point_to_current_centroid_distance[data_key][cluster_key] = range_normalized_euclidian_distance(centroid[cluster_key],data_set[data_key],range)
			end
		end

		# Assign each point to a cluster
		for data_key in 0...data_size
			# There should be a better way to do a minimum, but I don't know it
			min_distance = Float::MAX
			for cluster_key in 0...k
				if point_to_current_centroid_distance[data_key][cluster_key] < min_distance
					min_distance = point_to_current_centroid_distance[data_key][cluster_key]
					points_current_cluster[data_key] = cluster_key
				end
			end
		end

		# Recalculate the centroids
		# Reset the running sum in each dimension
		for cluster_key in 0...k
			for dimension_key in 0...data_dimension
				centroid_running_sum[cluster_key][dimension_key] = 0.0
			end
			centroid_num_points[cluster_key] = 0.0
		end
		# Sum up each centroid's point values and number of points
		for data_key in 0...data_size
			for dimension_key in 0...data_dimension
				centroid_running_sum[points_current_cluster[data_key]][dimension_key] += data_set[data_key][dimension_key]
			end
			centroid_num_points[points_current_cluster[data_key]] += 1.0
		end
		# Find the new centroid by dividing the sum by the number of points
		for cluster_key in 0...k
			for dimension_key in 0...data_dimension
				centroid[cluster_key][dimension_key] = centroid_running_sum[cluster_key][dimension_key]/centroid_num_points[cluster_key]
			end
		end


		

		iteration += 1

	end

end



def range_normalized_euclidian_distance(point1, point2, range)
	# START Error Checking
	if !point1.length || !point2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'range_normalized_euclidian_distance'" }
		exit
	end
	if (point1.length != point2.length)
		at_exit { puts "Error: Points are not the same dimensional length in function 'range_normalized_euclidian_distance'" }
		exit
	end
	if !range.length
		at_exit { puts "Error: The range is not defined in function 'range_normalized_euclidian_distance'" }
		exit
	end
	if (range.length != point1.length)
		at_exit { puts "Error: The range is not the same dimensional length as the points in function 'range_normalized_euclidian_distance'" }
		exit
	end
	# END Error Checking

	# START algorithm implementation
	running_sum = 0.0;
	for i in 0...point1.size
		running_sum += ((point1[i] - point2[i])/range[i]) ** 2
	end
	Math.sqrt(running_sum);
	# END algorithm implementation
end