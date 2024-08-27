require_relative "../items/item"
require "colorize"

# A class for a player in the game
class Player
  attr_reader :item

  def initialize
    @item = Item.new
  end

  def input
    loop do
      input = gets.chomp
      return input if input.match?(/^\d$/)

      puts "Invalid input".colorize(:red)
    end
  end
end
