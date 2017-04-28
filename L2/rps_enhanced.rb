OPTIONS = %w((r)ock (p)aper (sc)issors (l)izard (sp)ock).freeze

VALID_CHOICES = %w(r p sc l sp).freeze

WIN_CONDITIONS = %w(scp scl pr psp rl rsc lsp lp spr spsc).freeze

WINNNER_SCORE = 5

def prompt(msg)
  puts msg.to_s
end

def clear_screen
  system('cls')
end

def prompt_selection
  loop do
    prompt("Choose one: #{OPTIONS.join(', ')}")
    choice = gets.chomp.strip.downcase
    return choice if VALID_CHOICES.include?(choice)
    prompt("That's not a valid choice.")
  end
end

def sample_choice
  VALID_CHOICES.sample
end

def who_won(player, computer)
  winner = 'player' if WIN_CONDITIONS.include?(player + computer)
  winner = 'computer' if WIN_CONDITIONS.include?(computer + player)
  winner || 'tie'
end

def print_choices(player, computer)
  prompt("You chose: #{player}")
  prompt("Computer chose: #{computer}")
end

def print_result(winner)
  if winner == 'tie'
    prompt "It's a tie!"
  else
    prompt "#{winner.capitalize} wins!"
  end
end

def play_again?
  loop do
    prompt('Do you want to go again? (Y or N)')
    answer = gets.chomp.downcase.strip
    return answer if %w(y yes).include?(answer)
    return false if %w(n no).include?(answer)
    prompt('Please chose either Y or N.')
  end
end

def tally_score(scores, winner)
  scores[winner] += 1
end

def winner?(scores)
  scores.value?(WINNNER_SCORE)
end

def display_winner(scores)
  prompt("#{scores.key(5).capitalize} is the first to #{WINNNER_SCORE} wins!")
end

def display_score(scores)
  puts ''
  scores.each do |who, score|
    next if who == 'tie'
    prompt("#{who} score: #{score}")
  end
  puts ''
end

loop do
  scores = { 'player' => 0, 'computer' => 0, 'tie' => 0 }

  loop do
    player_choice = prompt_selection
    computer_choice = sample_choice

    print_choices(player_choice, computer_choice)

    winner = who_won(player_choice, computer_choice)

    print_result(winner)
    tally_score(scores, winner)
    display_score(scores)

    break if winner?(scores)
  end

  display_winner(scores)
  break unless play_again?
  clear_screen
end

prompt('Thank you for playing!')
