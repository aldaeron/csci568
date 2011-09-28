

=begin
CSCI Fall 2011 Project 5
An implementation of the K-Means Clustering Algorithm
Matt O'Neal
Last Updated 2011-09-26
All code contained in this document is original, except as indicated otherwise
=end

def k_means_normalized(k, data_set, data_size, data_dimension, stall_value, stall_type, stall_iterations, max_iterations)
	#
	# Variable Definitions Here
	#

	

	centroid = Hash.new
	point_to_current_centroid_distance = Hash.new
	points_current_cluster = Hash.new
	cluster_current_points = Hash.new
	cluster_current_points_distance = Hash.new
	points_last_cluster = Hash.new

	centroid_running_sum = Hash.new
	centroid_num_points = Hash.new

	cluster_SSE = Hash.new
	cluster_SSB = Hash.new
	cluster_density = Hash.new


	# Initialize hashes
	for cluster_key in 0...k
		centroid[cluster_key] = Hash.new
		centroid_running_sum[cluster_key] = Hash.new
		cluster_current_points[cluster_key] = Hash.new
		cluster_current_points_distance[cluster_key] = Hash.new
	end

	for data_key in 0...data_size
		point_to_current_centroid_distance[data_key] = Hash.new
	end
	


	# Initialize the centroids
	for dimension_key in 0...data_dimension
		# Every dimension is range [0,1]
		# Picking a random point from the list of points does not seem to be working for now so just pick random numbers for each dimension
		for cluster_key in 0...k
			centroid[cluster_key][dimension_key] = rand()
		end
	end
		

	iteration = 1
	loop_flag = true

	while loop_flag do


# NAN Centroid CLUSTERS BLOW THIS UP ALGORITHM UP


		# Calculate the distance between each point and each centroid
		for data_key in 0...data_size
			for cluster_key in 0...k
				point_to_current_centroid_distance[data_key][cluster_key] = euclidian_distance_normalized(centroid[cluster_key],data_set[data_key])
			end
		end

		# Reset the cluster lists
		for cluster_key in 0...k
			cluster_current_points[cluster_key].clear
			cluster_current_points_distance[cluster_key].clear
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
			cluster_current_points[points_current_cluster[data_key]][cluster_current_points[points_current_cluster[data_key]].length] = data_key
			cluster_current_points_distance[points_current_cluster[data_key]][cluster_current_points_distance[points_current_cluster[data_key]].length] = point_to_current_centroid_distance[data_key][points_current_cluster[data_key]]
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



		# Check and see if we should stop looping
		if (iteration >= max_iterations) 
			termination_condition = "Max Iterations"
			loop_flag = false
		elsif points_last_cluster == points_current_cluster
			termination_condition = "Converged"
			loop_flag = false
		# MISSING AN ELSIF HERE FOR STALL CRITERIA
		end



		for cluster_key in 0...k
			if cluster_current_points[cluster_key].empty?
				# Empty cluster.  Re-randomize.  
				# There are other ways to find a new centroid like picking a random point or choosing the farthest point from the existing centroid
				# I have seen runs where there are 8 bad random location picks in a row so for now pick a rancom point to use instead of a random point.
				# But using a random point is not working right.  Need to generate a random number then use it for the hash indicies.
				#centroid[cluster_key] = data_set[rand(data_size)]  THIS IS A BAD WAY TO DO THIS.  NEED A HASH COPY (if it exists) or a single random number with is used as a hash index
				for dimension_key in 0...data_dimension
					centroid[cluster_key][dimension_key] = rand()
				end
				# Can't stop looping if there are empty clusters
				loop_flag = true
			end
		end

		


		if loop_flag
			# We will still be looping
			# Increment the iteration
			iteration += 1
			# Keep track of which points belong to which cluster in the last iteration for convergence
			points_last_cluster.update(points_current_cluster)
		else
			# We are done looping, calcluate metrics on each cluster and record the termination iteration
			termination_iteration = iteration
		end

		termination_info = ""

	end
	
	cluster_SSE, cluster_SSB, cluster_density = k_means_normalized_metrics(k, data_set, data_size, data_dimension, cluster_current_points, cluster_current_points_distance, centroid)
	
	return cluster_current_points, centroid, cluster_SSE, cluster_SSB, cluster_density, iteration, termination_condition, termination_info
end


def euclidian_distance_normalized(point1, point2)
	# START Error Checking
	if !point1.length || !point2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'normalized_euclidian_distance'" }
		exit
	end
	if (point1.length != point2.length)
		at_exit { puts "Error: Points are not the same dimensional length in function 'normalized_euclidian_distance'" }
		exit
	end
	# END Error Checking

	# START algorithm implementation
	running_sum = 0.0;
	for i in 0...point1.size
		running_sum += ((point1[i] - point2[i])) ** 2
	end
	Math.sqrt(running_sum)
	# END algorithm implementation
end


def k_means_normalized_metrics(k, data_set, data_size, data_dimension, cluster_set, cluster_set_distance, cluster_centroid_set)
	cluster_SSE = Hash.new
	# I am defining SSB as the centroid to centrod distance to the closest cluster.  We want a max value for SSB 
	# This definition does not take number of points per cluster into account
	cluster_SSB = Hash.new
	cluster_density = Hash.new
	cluster_farthest_point = Hash.new
	

	for cluster_key in 0...k
		cluster_SSE[cluster_key] = 0.0
		cluster_SSB[cluster_key] = Float::MAX
		cluster_farthest_point[cluster_key] = 0.0

		for cluster_data_key in 0...cluster_set_distance[cluster_key].length
			cluster_SSE[cluster_key] += cluster_set_distance[cluster_key][cluster_data_key] ** 2
			if(cluster_set_distance[cluster_key][cluster_data_key] > cluster_farthest_point[cluster_key])
				cluster_farthest_point[cluster_key] = cluster_set_distance[cluster_key][cluster_data_key]
			end
		end
		for closest_cluster_key in 0...k
			if cluster_key != closest_cluster_key
				current_cluster_to_cluster_distance = euclidian_distance_normalized(cluster_centroid_set[cluster_key], cluster_centroid_set[closest_cluster_key])
				if current_cluster_to_cluster_distance < cluster_SSB[cluster_key]
					cluster_SSB[cluster_key] = current_cluster_to_cluster_distance
				end
			end
		end
		cluster_SSE[cluster_key] /= (2.0*cluster_set_distance[cluster_key].length)
		cluster_density[cluster_key] = (Math::PI * (cluster_farthest_point[cluster_key] ** 2)) / cluster_set_distance[cluster_key].length
	end

	return cluster_SSE, cluster_SSB, cluster_density
end


def euclidian_distance_non_normalized(point1, point2, range)
	# START Error Checking
	if !point1.length || !point2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'non_normalized_euclidian_distance'" }
		exit
	end
	if (point1.length != point2.length)
		at_exit { puts "Error: Points are not the same dimensional length in function 'non_normalized_euclidian_distance'" }
		exit
	end
	if !range.length
		at_exit { puts "Error: The range is not defined in function 'non_normalized_euclidian_distance'" }
		exit
	end
	if (range.length != point1.length)
		at_exit { puts "Error: The range is not the same dimensional length as the points in function 'non_normalized_euclidian_distance'" }
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