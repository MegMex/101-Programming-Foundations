# ruby tictactoe2.rb

require 'pry'
require 'colorize'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagnals
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.red
COMPUTER_MARKER = 'O'.green
WINNNER_SCORE = 5

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize
def display_board(brd)
  system('cls')
  puts "You're #{PLAYER_MARKER}. Computer is #{COMPUTER_MARKER}."
  puts ''
  puts '1    |2    |3    '
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts '     |     |     '
  puts '-----+-----+-----'
  puts '4    |5    |6    '
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts '     |     |     '
  puts '-----+-----+-----'
  puts '7    |8    |9    '
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts '     |     |     '
  puts ''
end
# rubocop:enable Metrics/AbcSize

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}):"
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "Sorry, that's not a valid choice."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!round_winner?(brd)
end

def round_winner?(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def game_winner?(scores)
  scores.value?(WINNNER_SCORE)
end

def joinor(arr, punctuation=', ', str='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" #{str} ")
  else
    arr[-1] = "#{str} #{arr.last}"
    arr.join(punctuation)
  end
end

def tally_score(scores, winner)
  if winner == 'Player' || 'Computer'
  scores[winner] += 1
  end
  nil
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

board = ''
score = ''

loop do
  score = { 'Player' => 0, 'Computer' => 0, 'Tie' => 0 }
  board = initialize_board
  display_score(score)

  loop do
    display_board(board)
    display_score(score)

    loop do
      round_winner = ''
      loop do
        display_board(board)
        tally_score(score, round_winner)
        display_score(score)

        player_places_piece!(board)
        break if someone_won?(board) || 
                 board_full?(board) || 
                 score[:player] == 5

        computer_places_piece!(board)
        break if someone_won?(board) || 
                 board_full?(board) || 
                 score[:computer] == 5
binding.pry
        round_winner = round_winner?(board)

        if someone_won?(board)
          prompt "#{round_winner?(board)} won this round!"
        else
          prompt "It's a tie!"
        end
      end


      if game_winner?(score)
        prompt "#{winner} won the game!"
        break
      end
    end
  end

  prompt "Play again? Y/N"
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt 'Thanks for playing Tic Tac Toe! Goodbye!'
