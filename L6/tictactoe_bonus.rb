# ruby tictactoe_bonus.rb

require 'pry'
require 'colorize'

WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]]              # diagnals
INITIAL_MARKER = ' '.freeze
PLAYER_MARKER = 'X'.red
COMPUTER_MARKER = 'O'.green
NUM_OF_PLAYER = 2

def prompt(msg)
  puts "=> #{msg}"
end

# rubocop:disable Metrics/AbcSize, Metrics/MethodLength
def display_board(brd)
  system('cls')
  puts "Play to 5!"
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
# rubocop:enable Metrics/AbcSize, Metrics/MethodLength

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
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

def computer_pre_win?(brd, line)
  brd.values_at(*line).count(COMPUTER_MARKER) == 2 &&
    brd.values_at(*line).count(INITIAL_MARKER) == 1
end

def player_pre_win?(brd, line)
  brd.values_at(*line).count(PLAYER_MARKER) == 2 &&
    brd.values_at(*line).count(INITIAL_MARKER) == 1
end

def computer_winning_line(brd)
  WINNING_LINES.each do |line|
    return line if computer_pre_win?(brd, line)
  end
  nil
end

def computer_about_to_win?(brd)
  WINNING_LINES.each do |line|
    return true if computer_pre_win?(brd, line)
  end
  false
end

def computer_about_to_lose?(brd)
  WINNING_LINES.each do |line|
    return true if player_pre_win?(brd, line)
  end
  false
end

def stop_player_win(brd)
  WINNING_LINES.each do |line|
    return line if player_pre_win?(brd, line)
  end
  nil
end

def get_computer_square_piece(brd, line)
  square = nil
  line.each do |position|
    if brd[position].casecmp(INITIAL_MARKER).zero?
      square = position
      break
    end
  end
  square
end

def player_places_piece!(brd)
  square = ''
  loop do
    prompt "Choose a square (#{joinor(empty_squares(brd))}): "
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt "This is not a valid choice! Try again."
  end

  brd[square] = PLAYER_MARKER
end

def computer_places_piece!(brd)
  square = ''
  if computer_about_to_win?(brd)
    line = computer_winning_line(brd)
    square = get_computer_square_piece(brd, line)
  elsif computer_about_to_lose?(brd)
    line = stop_player_win(brd)
    square = get_computer_square_piece(brd, line)
  else
    square = brd[5] == INITIAL_MARKER ? 5 : empty_squares(brd).sample
  end
  brd[square] = COMPUTER_MARKER
end

def place_piece!(brd, player)
  case player
  when 0 then player_places_piece!(brd)
  when 1 then computer_places_piece!(brd)
  end
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def five_wins?(p_score, c_score)
  p_score == 5 || c_score == 5
end

def exit_game?
  answer = ''
  loop do
    prompt "Play again? (y or n)"
    answer = gets.chomp
    if %w[y n].include?(answer.downcase)
      break
    else
      prompt "Type y to play again or n to exit"
    end
  end
  !answer.casecmp('y').zero?
end

def alternate_player(player)
  (player + 1) % NUM_OF_PLAYER
end

def choose_player_going_first
  player = ''
  loop do
    prompt "Who moves first? p: Player or c: Computer"
    player = gets.chomp.downcase
    break if ['p', 'c'].include?(player)
    prompt "It's not a valid player!"
  end
  player == 'p' ? 0 : 1
end

def pause_game
  prompt "Press any key to continue..."
  gets
end

loop do
  player_score = 0
  computer_score = 0

  current_player = choose_player_going_first
  if current_player == 0
    prompt "Player goes first!"
  else
    prompt "Computer goes first"
  end

  pause_game

  loop do
    board = initialize_board

    loop do
      display_board board
      prompt "Player: #{player_score}, Computer: #{computer_score}"
      place_piece! board, current_player
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    display_board board

    if someone_won? board
      winner = detect_winner(board)
      prompt "#{winner} won!"
      winner == 'Player' ? player_score += 1 : computer_score += 1
      prompt "Score: Player has #{player_score}. Computer has #{computer_score}"
    else
      prompt "It's a tie!"
    end

    pause_game

    break if five_wins?(player_score, computer_score)
  end

  break if exit_game?
end

prompt "Thanks for playing Tic Tac Toe. Good Bye!"
