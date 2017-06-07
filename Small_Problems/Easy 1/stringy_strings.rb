## ruby stringy_strings.rb

def stringy(num)
  numbers = [1]

  loop do
    break if numbers.length == num

    if numbers.last == 1
      numbers << 0
    elsif numbers.last == 0
      numbers << 1
    end
  end

  numbers.join('')
end



