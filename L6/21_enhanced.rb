# ruby 21_enhanced.rb

SUITS = ['H', 'D', 'S', 'C']
VALUES = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
GAME_TO = 21
DEALER_STOP = GAME_TO - 4

def clear_screen
  system('clear') || system('cls')
end

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(cards)
  # cards = [['H', '3'], ['S', 'Q'], ... ]
  values = cards.map { |card| card[1] }

  sum = 0
  values.each do |value|
    if value == "A"
      sum += 11
    elsif value.to_i == 0 # J, Q, K
      sum += 10
    else
      sum += value.to_i
    end
  end

  # correct for Aces
  values.select { |value| value == "A" }.count.times do
    sum -= 10 if sum > GAME_TO
  end

  sum
end

def busted?(total)
  total > GAME_TO
end

def detect_result(player_cards, dealer_cards)
  player_total = total(player_cards)
  dealer_total = total(dealer_cards)

  if player_total > GAME_TO
    :player_busted
  elsif dealer_total > GAME_TO
    :dealer_busted
  else
    case player_total <=> dealer_total
    when -1
      :dealer
    when 1
      :player
    else
      :tie
    end
  end
end

def display_result(player_cards, dealer_cards)
  result = detect_result(player_cards, dealer_cards)

  loop do
    case result
    when :player_busted
      prompt "You busted! Dealer wins!"
    when :dealer_busted
      prompt "Dealer busted! You win!"
    when :player
      prompt "You win!"
    when :dealer
      prompt "Dealer wins!"
    when :tie
      prompt "It's a tie!"
    end

    prompt "Press Enter to continue."
    key_pressed = gets
    break if key_pressed
  end
end

def display_details(player_cards, dealer_cards, player_total, dealer_total)
  puts "============="
  prompt "Dealer has #{dealer_cards}, for a total of: #{dealer_total}"
  prompt "Player has #{player_cards}, for a total of: #{player_total}"
  puts "============="
end

def display_round_result(player_score, dealer_score)
  prompt "You: #{player_score}, Dealer: #{dealer_score}"
end

def display_game_result(player_score, dealer_score)
  puts "************"
  case player_score <=> dealer_score
  when 1
    prompt "You won the game: #{player_score} to #{dealer_score}."
  when -1
    prompt "Dealer won the game: #{dealer_score} to #{player_score}."
  end
  puts "************"
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? Y/N"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

loop do 
  player_score = 0
  dealer_score = 0
  game_score = 0

  loop do
    game_score = [player_score, dealer_score].max
    break if game_score == 5

    clear_screen
    prompt "Welcome to Twenty-One!"
    prompt "Play to 5!"
    puts "----------------"
    display_round_result(player_score, dealer_score)

    deck = initialize_deck
    player_cards = []
    dealer_cards = []

    2.times do
      player_cards << deck.pop
      dealer_cards << deck.pop
    end

    player_total = total(player_cards)
    dealer_total = total(dealer_cards)

    prompt "Dealer has #{dealer_cards[0]} and ?"
    prompt "You have: #{player_cards[0]} and #{player_cards[1]}."
    prompt "Your cards total: #{player_total}."

    loop do
      player_turn = ''

      loop do
        prompt "Would you like to (h)it or (s)tay?"
        player_turn = gets.chomp.downcase
        break if ['h', 's'].include?(player_turn)
        prompt "Sorry, must enter 'h' or 's'."
      end

      if player_turn == 'h'
        player_cards << deck.pop
        player_total = total(player_cards)
        prompt "You chose to hit!"
        prompt "Your cards are now: #{player_cards}"
        prompt "Your total is now #{player_total}"
      end

      break if player_turn == 's' || busted?(player_total)
    end

    if busted?(player_total)
      display_details(player_cards, dealer_cards, player_total, dealer_total)
      display_result(player_cards, dealer_cards)
      dealer_score += 1
      next
    else
      prompt "You stayed at #{player_total}"
    end

    prompt "Dealer turn..."

    loop do
      break if total(dealer_cards) >= DEALER_STOP

      prompt "Dealer hits!"
      dealer_cards << deck.pop
      dealer_total = total(dealer_cards)
      prompt "Dealers cards are now: #{dealer_cards} (#{dealer_total})"
    end

    if busted?(dealer_total)
      display_details(player_cards, dealer_cards, player_total, dealer_total)
      display_result(player_cards, dealer_cards)
      player_score += 1
      next
    else
      prompt "Dealer stays at #{dealer_total}"
    end

    display_details(player_cards, dealer_cards, player_total, dealer_total)

    if detect_result(player_cards, dealer_cards) == :player
      player_score += 1
    elsif detect_result(player_cards, dealer_cards) == :dealer
      dealer_score += 1
    end

    display_result(player_cards, dealer_cards)
  end

  display_game_result(player_score, dealer_score)

  break unless play_again?
end

prompt "Than you for playing Twenty-One! Good bye!"
