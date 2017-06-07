## ruby tip_calculator.rb

puts "What is the bill?"
bill = gets.chomp.to_f

puts "What is the tip percentage?"
tip_percentage = gets.chomp.to_f

tip = ((tip_percentage / 100) * bill).round(2)

puts "The tip is $#{tip}"
puts "The tip total is $#{tip + bill}"