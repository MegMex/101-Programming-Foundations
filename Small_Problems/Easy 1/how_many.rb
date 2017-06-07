def count_occurrences(array)
	result = {}

	array.each do |name| 
		result[name] = array.count(name)
	end

	result.each do |element, count|
		puts "#{element} => #{count}"
	end
end

vehicles = ['car', 'car', 'truck', 'car', 'SUV', 'truck', 'motorcycle', 'motorcycle', 'car', 'truck']

p count_occurrences(vehicles)
