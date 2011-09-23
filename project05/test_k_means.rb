require_relative 'k_means'

# Test K Means function with Iris dataset

iris_data_handle = File.open("iris.csv", "r")

data_set_string = Hash.new
data_set = Hash.new
data_title = Hash.new
data_type = Hash.new
data_size = 0

data_title = iris_data_handle.readline.strip.split(",")
data_type = iris_data_handle.readline.strip.split(",")



iris_data_handle.each {|line|
	data_set_string[data_size] = line.strip.split(",")
	data_set[data_size] = Hash.new
	data_size += 1
}



data_dimension = data_type.size

k = 3

for data_key,data_record in data_set_string
	dimension_key = 0
	for data_value in data_record
		data_set[data_key][dimension_key] = data_value.to_f
		dimension_key += 1
	end
end


k_means(k, data_set, data_size, data_dimension, 0, 0, 0, 100)

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
	