## ruby sum_of_digits.rb

def sum(num)
  elements = num.to_s.chars.map(&:to_i).reduce(:+)
end

puts sum(23)
puts sum(496)