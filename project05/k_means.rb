require_relative 'similarity_metrics'

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

		# Use the range to create a random starting point for the centroids
		for cluster_key in 0...k
			centroid[cluster_key][dimension_key] = range_min[dimension_key] + (range_max[dimension_key] - range_min[dimension_key])*rand()
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
				point_to_current_centroid_distance[data_key][cluster_key] = euclidian_distance(centroid[cluster_key],data_set[data_key])
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