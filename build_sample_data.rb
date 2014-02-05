def sample_data(survey, filter, question, answer, value)
  { series_1: survey, series_2: filter, question_id: question, series_3: answer, value: value }
end

data = []
(1..5).each do |s|
  (1..3).each do |f|
    (1..5).each do |a|
      data << sample_data(%{Survey #{s}}, %{Filter #{f}}, 100, a, rand(100) + 1)
    end
  end
end

puts data
require 'json'
File.open('tmpfile', 'w') do |file|
  file << data.to_json
end
