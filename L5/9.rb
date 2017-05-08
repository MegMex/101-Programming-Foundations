arr = [['b', 'c', 'a'], [2, 1, 3], ['blue', 'black', 'green']]

# return new array => map
# sort sub-array descending

arr.map do |sub_arr|
	sub_arr.sort! do |a,b|
		b <=> a
	end
end
p arr