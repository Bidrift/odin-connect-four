require "colorize"

class Board
  def initialize(board = Array.new(6) { Array.new(7) })
    @board = board
    @length = @board.size
    @width = @board[0].size
  end

  def winner_exists?
    check_rows || check_cols || check_diag
  end

  def full?
    @board.none? { |arr| arr.any?(&:nil?) }
  end

  def display_board
    puts @width.times.reduce(String.new) { |a, v| a + v.to_s }.chars.join(" |")
    @board.each do |v|
      puts v.map { |v2| v2.nil? ? "  " : v2 }.join("|").colorize(background: :grey)
    end
  end

  def save_move(column, item)
    row_to_change = @length - @board.map { |v| v[column] }.compact.size - 1
    @board[row_to_change][column] = item
  end

  def valid_move?(move)
    move.between?(0, @width - 1) && @board[0][move].nil?
  end

  private

  def check_rows
    @board.each do |v|
      @count = 0
      @current = nil
      v.each do |value|
        update_counter(value)
        return true if @count == 4
      end
    end
    false
  end

  def check_cols
    @width.times do |v|
      @count = 0
      @current = nil
      @board.each do |value|
        update_counter(value[v])
        return true if @count == 4
      end
    end
    false
  end

  def check_diag
    @board.each_with_index do |v, row|
      v.each_with_index do |start, column|
        next if start.nil?

        return true if check_both_diagonals(start, row, column)
      end
    end
    false
  end

  def update_counter(value)
    if value.nil? || value != @current
      @count = 1
      return @current = value
    end

    @count += 1
  end

  def check_both_diagonals(start, row, column)
    @count = 0
    @current = start
    result = check_top_left(start, row, column)
    @count = 0
    @current = start
    result || check_top_right(start, row, column)
  end

  def check_top_left(start, row, column)
    return false if start.nil? || start != @current

    @count += 1
    @current = start
    return true if @count == 4

    check_top_left(@board[row + 1][column + 1], row + 1, column + 1) if (row < @length - 1) && (column < @width - 1)
  end

  def check_top_right(start, row, column)
    return false if start.nil? || start != @current

    @count += 1
    @current = start
    return true if @count == 4

    check_top_right(@board[row + 1][column - 1], row + 1, column - 1) if (row < @length - 1) && column.positive?
  end
end
