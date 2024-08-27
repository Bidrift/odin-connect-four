require_relative "database"
require "colorize"
require_relative "items/board"
require_relative "items/item"
require_relative "players/player"
require_relative "players/human"

class ConnectFour
  include Database
  def initialize(board = nil, player = nil, turn = 0)
    @board = board || create_board
    @players = player ? Array.new(2) { player } : create_players
    @turn = turn
  end

  def create_board
    @board = Board.new
  end

  def create_players
    @players = [Human.new, Human.new]
  end

  def run_game
    play_turn until over?
    show_winner
  end

  def play_turn
    puts "Choose a move based on the numbers shown on each column".colorize(:red)
    @board.display_board
    move = get_player_move(@players[@turn])
    @board.save_move(move, @players[@turn].item)
    @turn = (@turn + 1) % 2
  end

  def over?
    @board.winner_exists? || @board.full?
  end

  def get_player_move(player)
    loop do
      move = player.input.to_i
      return move if @board.valid_move?(move)

      puts "Invalid column".colorize(:red)
    end
  end

  def show_winner
    puts "Game over...".colorize(:green)
    @board.display_board
    return puts "It's a tie".colorize(:blue) unless @board.winner_exists?

    @turn = (@turn + 1) % 2
    puts "Player #{@turn} wins".colorize(:blue)
  end
end
