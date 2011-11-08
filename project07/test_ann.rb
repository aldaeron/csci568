require_relative 'ann_include'

tester = ANNModel.new(3,3,2)

tester_results = Array.new

tester_results = tester.evaluate_model(Array[1,1,1])

tester_results.each do |i|
	puts i
end