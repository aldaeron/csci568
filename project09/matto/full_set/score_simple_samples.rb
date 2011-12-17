
require_relative "../calculate_RMSE.rb"

simple_sample_scores_handle = File.open("simple_sample_scores.txt", "w")

simple_sample_scores_handle.puts("File Number\tAll Scores Equal\tRMSE")

for i in 0..255

	puts i

    simple_sample_filename = ("simple_samples/" << i.to_s << ".txt")

	if File.exists?(simple_sample_filename)
		rmse = calculate_RMSE(simple_sample_filename, "full_solution.txt")
		simple_sample_scores_handle.puts("#{i}\t#{((i.to_f/255)*100).to_s}\t#{rmse}")
	end
end