# Solves for an arbitrary board of size n
# Checks winner after every move to reduce searches to 4 (row, column, two diagonals)
# example input:
# [
#   ['X', 0, 0],
#   ['O', 0, 1],
#   ['X', 1, 1],
#   ['O', 0, 2],
#   ['X', 2, 2]
# ]
# player X wins => diagonal

class TicTacToe
  attr_reader :board, :moves, :board_size, :winner

  class InvalidPositionError < StandardError; end

  def initialize(moves, board_size = 3)
    @moves = moves
    @winner = nil
    @board_size = board_size
    @board = Array.new(board_size) { Array.new(board_size, '') }
  end

  def play
    moves.each do |move|
      break unless winner.nil?

      player = move.shift
      make_move(player, move)
    end
    winner
  end

  private

  def make_move(player, position)
    raise InvalidPositionError unless valid_position?(position)

    board[position[0]][position[1]] = player
    valid_cells.delete(position)
    check_winner(player, position)
  end

  def check_winner(char, position)
    # current row check
    board_size.times do |i|
      break unless char == board[position[0]][i]

      @winner = char if i == board_size - 1
    end

    # current column check
    board_size.times do |i|
      break unless char == board[i][position[1]]

      @winner = char if i == board_size - 1
    end

    # diagonal check
    if position[0] == position[1]
      board_size.times do |i|
        break unless char == board[i][i]

        @winner = char if i == board_size - 1
      end
    end

    # reverse diagonal check
    if position[0] + position[1] == board_size - 1
      board_size.times do |i|
        break unless char == board[i][2 - i]

        @winner = char if i == board_size - 1
      end
    end
    @winner
  end

  def valid_cells
    @valid_cells ||= board.map.with_index do |row, row_idx|
      row.map.with_index { |_char, idx| [row_idx, idx] }
    end.flatten(1)
  end

  def valid_position?(position)
    valid_cells.include?(position)
  end
end



game2 =
[
  ['X',0,0],
  ['O',0,1],
  ['X',1,1],
  ['O',0,2],
]
# No winner

game3 = [
  ['X',0,0],
  ['O',0,1],
  ['X',0,1]
]
# Raise error

game4 = [
  ['X', 1, 2],
  ['O', 0, 0],
  ['X', 1, 1],
  ['O', 1, 0],
  ['X', 2, 2],
  ['O', 2, 0]
]
# player O wins => first column

game5 = [
  ['X', 1, 1],
  ['O', 0, 1],
  ['X', 1, 0],
  ['O', 2, 1],
  ['X', 1, 2],
  ['O', 0, 0]
]
# player X wins => middle row

game6 = [
  ['X', 0, 1],
  ['O', 0, 2],
  ['X', 1, 0],
  ['O', 1, 1],
  ['X', 2, 1],
  ['O', 2, 0]
]
# player O wins => anti diagonal

game = TicTacToe.new(game1, board_size = 3)
game.play
p game.board
p game.winner
