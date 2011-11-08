require 'Matrix'


=begin

 This is very ragtag program.

 I suck at Ruby, which makes simple things take way longer than they should and left little time to get things working.

 This means the OO model is VERY basic.  Particularly 
   - There is no inheritance.  There are 2 node classes and 2 later classes where there should be 1 of each.
   - There is only one hidden layer and no easy way to add more.  The class methods will require major rework to use multiple hidden layers
   - There is no error checking
   - There are very few comments

 My apologies - learning Ruby syntax has been more challenging than I thought and I spend a ton of time re-writing code to find and fix simple syntax errors.
 This could really be a better program if I had more time.

=end

class ANNModel
	# Class Vars
	
	def initialize(num_inputs, num_outputs, hidden_layer_size) 
		# Note that this is ONLY for a single hidden layer model.  Can make hidden an array later.
    	@input_layer = ExternalLayer.new(num_inputs)
    	@output_layer = ExternalLayer.new(num_outputs)
    	@hidden_layer = HiddenLayer.new(num_inputs, num_outputs, hidden_layer_size)
	end

	def train_model(input_data_array, output_data_array)

	end

	def evaluate_model(input_data_array)
		# Note that this is ONLY for a single hidden layer model.

		# For Testing - cheese some weights
		@hidden_layer.test_weights()
		# End Testing

		if(input_data_array.size == @input_layer.size)

			# Setup inputs
			@input_layer.set_values_from_array(input_data_array)

			# Calculate Values
			@hidden_layer.calculate_output_values(@input_layer, @output_layer)


			return @output_layer.values_to_array()

		else 
			at_exit { puts "Error: Input array length incorrect.  Cannot evaluate ANN." }
			exit
		end


	end
end









class HiddenLayer
	def initialize(num_inputs, num_outputs, layer_size)
		@layer = Array.new(layer_size) {HiddenNode.new}
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



	def test_weights()
		@input_weights = Matrix[ [0.1,0.2], [0.3,0.4], [0.5,0.6] ]
		@output_weights = Matrix[ [1,2,3], [1,2,3] ]
	end



	def calculate_output_values(input_layer, output_layer)
		layer_input_matrix = Matrix.row_vector(input_layer.values_to_array())
		self.set_values_from_array((layer_input_matrix*@input_weights).to_a()[0])
		calculate_outputs_from_inputs()
		output_layer.set_values_from_array((Matrix.row_vector(output_values_to_array())*@output_weights).to_a)
	end



	def size
		@layer.size
	end

end








class ExternalLayer
	def initialize(num_nodes)
		@layer = Array.new(num_nodes) {ExternalNode.new}
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


















class HiddenNode
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









class ExternalNode
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