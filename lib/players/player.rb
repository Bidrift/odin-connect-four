require_relative "../items/item"

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
    end
  end
end
