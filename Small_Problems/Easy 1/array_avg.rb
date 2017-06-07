## ruby array_avg.rb

def average(array)
  array.inject(0) { |sum, el| sum + el } / array.size
end

puts average([1, 5, 87, 45, 8, 8])
puts average([9, 47, 23, 95, 16, 52])