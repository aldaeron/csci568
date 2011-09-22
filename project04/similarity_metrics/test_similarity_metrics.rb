require_relative 'similarity_metrics'

test1 = [0,0];
test2 = [1,0];
test3 = [1,1];

puts "Euclidian Distance: #{euclidian_distance(test1, test2).round(3)}"
puts "Euclidian Distance: #{euclidian_distance(test1, test3).round(3)}"
puts "Euclidian Distance: #{euclidian_distance(test2, test3).round(3)}"

test1 = [0,0,1,1,0,0,1,1];
test2 = [1,0,1,0,1,0,1,0];

puts "SMC: #{SMC(test1, test2).round(3)}"
puts "Jaccard #{jaccard(test1, test2).round(3)}"


test1 = [-0.05,1.05,1.95,3.05,3.95,5.05,5.95,7.05,7.95];
test2 = [0,1,2,3,4,5,6,7,8];

puts "Cosine Similarity #{cosine_similarity(test1, test2).round(9)}"
puts "Pearson's R #{pearsons_r(test1, test2).round(9)}"