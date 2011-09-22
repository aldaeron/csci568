require_relative 'similarity_metrics'

=begin
CSCI Fall 2011 Project 5
An implementation of the K-Means Clustering Algorithm
Matt O'Neal
Last Updated 2011-09-22
All code contained in this document is original, except as indicated otherwiss
=end

def k_means(data_set, stall_value, stall_type, stall_iterations, max_iterations)
	#
	# Variable Definitions Here
	#