
=begin 
This is my first Ruby program!
It is a collection of useful data mining similarity metrics
=end

def dot_product(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'dot_product'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'dot_product'" }
		exit
	end
	running_sum = 0.0;
	for i in 0...vector1.size
		running_sum += (vector1[i] * vector2[i])
	end
	running_sum
end


def euclidian_distance(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'euclidian_distance'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'euclidian_distance'" }
		exit
	end
	running_sum = 0.0;
	for i in 0...vector1.size
		running_sum += (vector1[i] - vector2[i]) ** 2
	end
	Math.sqrt(running_sum);
end

def SMC(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'SMC'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'SMC'" }
		exit
	end
	numerator = 0.0;
	for i in 0...vector1.size
		if(vector1[i] == vector2[i])
			numerator += 1;
		end
	end
	(numerator / vector1.size)
end

def jaccard(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'jaccard'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'jaccard'" }
		exit
	end
	numerator = 0.0;
	denominator = 0.0;
	for i in 0...vector1.size
		if( (vector1[i] != 0) || (vector2[i] != 0) )
			denominator += 1;
			if(vector1[i] == vector2[i])
				numerator += 1;
			end
		end
	end
	if denominator.abs < 1e-12 
		return 0
	end
	(numerator / denominator)
end

def cosine_similarity(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'cosine_similarity'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'cosine_similarity'" }
		exit
	end
	numerator = dot_product(vector1, vector2);
	denominator = dot_product(vector1, vector1) * dot_product(vector2, vector2);
	if denominator.abs < 1e-12 
		return 0
	end
	(numerator / denominator)
end

def pearsons_r(vector1, vector2)
	if !vector1.length || !vector2.length
		at_exit { puts "Error: One or more vectors have length zero in function 'pearsons_r'" }
		exit
	end
	if (vector1.length != vector2.length)
		at_exit { puts "Error: Vectors are not the same length in function 'pearsons_r'" }
		exit
	end

	# Using Equations from http://en.wikipedia.org/wiki/Pearson_product-moment_correlation_coefficient	
	# Yes, wikipedia is in fact the BEST SOURCE EVER
	# The book uses one minus the value returned below for whatever reason
	# I am using the values from my research code for now
	
	sum12 = sum1 = sum11 = sum2 = sum22 = 0.0;
	for i in 0...vector1.size
		sum12 += (vector1[i] * vector2[i]); 
    	sum1 += vector1[i];
    	sum11 += vector1[i] ** 2;
    	sum2 += vector2[i];
    	sum22 += vector2[i] ** 2; 
	end

    numerator = (vector1.size*sum12) - (sum1*sum2);
 	denominator = Math.sqrt(  ((vector1.size*sum11) - (sum1*sum1)) * ((vector1.size*sum22) - (sum2*sum2)) );

	if denominator.abs < 1e-12 
		return 0
	end
	(numerator / denominator)
end


