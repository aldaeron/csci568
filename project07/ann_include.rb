require 'Matrix'


=begin

 This is very ragtag program.

 I suck at Ruby, which makes simple things take way longer than they should and left little time to get things working.

 This means the OO model is VERY basic.  Particularly 
   - There is no inheritance.  There are 2 node classes and 2 later classes where there should be 1 of each.
   - There is only one hidden layer and no easy way to add more.  The class methods will require major rework to use multiple hidden layers
   - The only activation function is tanh()
   - The train function can only have 1 training example
   - There is no error checking
   - There are very few comments

 My apologies - learning Ruby syntax has been more challenging than I thought and I spend a ton of time re-writing code to find and fix simple syntax errors.
 This could really be a better program if I had more time.

=end

class ANNModel
	# Class Vars
	
	def initialize(num_inputs, num_outputs, hidden_layer_size) 
		# Note that this is ONLY for a single hidden layer model.  Can make hidden an array later.
    	@input_layer = InputLayer.new(num_inputs)
    	@output_layer = SigmoidLayer.new(hidden_layer_size, num_outputs, num_outputs)
    	@hidden_layer = SigmoidLayer.new(num_inputs, num_outputs, hidden_layer_size)
	end

	def train_model(input_data_array, target_data_array, learning_rate, max_acceptable_error)
		# Note that this is ONLY for a single hidden layer model with 1 training data piece

		iteration = 0
		max_iterations = 50

		@hidden_layer.random_weights()

		output_layer_error = Array.new(@output_layer.size)
		output_layer_input_change_needed = Array.new(@output_layer.size)

		hidden_layer_error = Array.new(@hidden_layer.size)
		
		current_output_values = Array.new(@output_layer.size)
		current_output_weights = Array.new
		output_weight_change = Array.new(@hidden_layer.size) {Array.new(@output_layer.size)}

		current_output_values = self.evaluate_model(input_data_array)

current_output_values.each do |value|
puts "Iter #{iteration}: #{value}"
end

		begin 
			# For the output layer: Find the error in output and use is to find the error in the input
			for i in 0...@output_layer.size
				output_layer_error[i] = target_data_array[i] - current_output_values[i]
				output_layer_input_change_needed[i] = derivative_tanh(output_layer_error[i])
			end

			# Modify each weight based on its value
			current_output_weights = *@hidden_layer.return_output_weights()
			for i in 0...@hidden_layer.size
				for j in 0...@output_layer.size
					output_weight_change[i][j] = current_output_weights[i][j] * output_layer_error[j] * learning_rate
				end
			end

			@hidden_layer.set_output_weights(@hidden_layer.return_output_weights()-Matrix[*output_weight_change])

			iteration = iteration + 1

			current_output_values = self.evaluate_model(input_data_array)

current_output_values.each do |value|
puts "Iter #{iteration}: #{value}"
end
		end while ((iteration < max_iterations) && (output_layer_error.max > max_acceptable_error)) # Not sure if .max works properly with negative numbers

	end

	def evaluate_model(input_data_array)
		# Note that this is ONLY for a single hidden layer model.

		# For Testing - cheese some weights
		#@hidden_layer.test_weights()
		# End Testing

		if(input_data_array.size == @input_layer.size)

			# Setup inputs
			@input_layer.set_values_from_array(input_data_array)

			# Calculate Values
			@hidden_layer.calculate_output_values(@input_layer, @output_layer)

			@output_layer.calculate_outputs_from_inputs()

			return @output_layer.output_values_to_array()

		else 
			at_exit { puts "Error: Input array length incorrect.  Cannot evaluate ANN." }
			exit
		end


	end
end









class SigmoidLayer
	def initialize(num_inputs, num_outputs, layer_size)
		@layer = Array.new(layer_size) {SigmoidNode.new}
		@input_weights = Matrix.build(num_inputs,layer_size)
		@output_weights = Matrix.build(layer_size,num_outputs)
	end

	def set_values_from_array(value_array)
		for i in 0...@layer.size
			@layer[i].set_input(value_array[i])
		end
	end


	def calculate_outputs_from_inputs()
		for i in 0...@layer.size
			@layer[i].calculate_output()
		end
	end


	def input_values_to_array()
		value_array = Array.new(@layer.size)
		for i in 0...@layer.size
			value_array[i] = @layer[i].return_input()
		end
		return value_array
	end


	def output_values_to_array()
		value_array = Array.new(@layer.size)
		for i in 0...@layer.size
			value_array[i] = @layer[i].return_output()
		end
		return value_array
	end


	def set_input_weights(new_input_weights)
		@input_weights = new_input_weights
	end


	def set_output_weights(new_output_weights)
		@output_weights = new_output_weights
	end

	def return_input_weights()
		@input_weights
	end

	def return_output_weights()
		@output_weights
	end


	def test_weights()
		@input_weights = Matrix[ [0.1,0.2], [0.3,0.4], [0.5,0.6] ]
		@output_weights = Matrix[ [1,2,3], [1,2,3] ]
	end

	def random_weights()
		weight_random = Random.new()
		@input_weights = Matrix[ [weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0)], [weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0)], [weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0)] ]
		@output_weights = Matrix[ [weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0)], [weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0),weight_random.rand(-1.0..1.0)] ]
	end



	def calculate_output_values(input_layer, output_layer)
		layer_input_matrix = Matrix.row_vector(input_layer.values_to_array())
		self.set_values_from_array((layer_input_matrix*@input_weights).to_a()[0])
		calculate_outputs_from_inputs()
		output_layer.set_values_from_array((Matrix.row_vector(output_values_to_array())*@output_weights).to_a[0])
	end



	def size
		@layer.size
	end

end








class InputLayer
	def initialize(num_nodes)
		@layer = Array.new(num_nodes) {InputNode.new}
	end



	def set_values_from_array(value_array)
		for i in 0...@layer.size
			@layer[i].set_value(value_array[i])
		end
	end

	def values_to_array()
		value_array = Array.new(@layer.size)
		for i in 0...@layer.size
			value_array[i] = @layer[i].return_value()
		end
		return value_array
	end


	def size()
		@layer.size
	end
end


















class SigmoidNode
	# All nodes for this simple example have an tanh activation function Math.tanh()
	def initialize()
		@input_value = 0.0
		@output_value = 0.0
	end

	def set_input(value)
		@input_value = value
	end

	def calculate_output()
		@output_value = Math.tanh(@input_value)
	end

	def return_input()
		@input_value
	end

	def return_output()
		@output_value
	end
end









class InputNode
	def initialize()
		@node_value = 0.0
	end

	def set_value(value)
		@node_value = value
	end

	def return_value()
		@node_value
	end
end






def derivative_tanh(value)
	(1-(Math.tanh(value)**2))
end