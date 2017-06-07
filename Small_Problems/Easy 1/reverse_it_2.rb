## ruby reverse_it_2.rb

def reverse_words(str)
  words = []

  str.split.each do |word|
    word.reverse! if word.size >= 5
    words << word
    end

  words.join(' ')
end

puts reverse_words('Walk around the block')