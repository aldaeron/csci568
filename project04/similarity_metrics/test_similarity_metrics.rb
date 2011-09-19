require_relative 'similarity_metrics'

test1 = [0,1,1,0];
test2 = [1,1,1,0];

puts "Euclidian Distance: #{euclidian_distance(test1, test2).round(2)}"
puts "SMC: #{SMC(test1, test2).round(2)}"
puts "Jaccard #{jaccard(test1, test2).round(2)}"
puts "Cosine Similarity #{cosine_similarity(test1, test2).round(2)}"
