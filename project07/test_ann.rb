require_relative 'ann_include'

tester = ANNModel.new(3,3,2)

tester.train_model(Array[1.0,0.25,-0.5], Array[1.0,-1.0,0.0], 0.1, 0.1)

#tester_results = Array.new

#tester_results = tester.evaluate_model(Array[1,1,1])

#tester_results.each do |i|
#	puts i
#end