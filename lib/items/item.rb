# A class for items
class Item
  attr_reader :symbol

  @@count = 0
  def initialize
    @symbol = @@count.even? ? "\u26AA" : "\u26AB"
    @@count += 1
  end

  def to_s
    @symbol
  end
end
