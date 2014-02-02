# Pseudocode
# Classes(objects): Sudoku, Small_Square, Board
# =======================================Sudoku Class =========================================================
require 'debugger'
class Sudoku
  def initialize(game_string)
    @game_string = game_string
    @myboard = Board.new(game_string)
    puts @myboard.show_me
    solve!
    puts @myboard.show_me
  end

  def solve!
    until @myboard.puzzle.select {|array| !array.select{ |cell| cell == 0 }.empty? }.empty? # method will run until there are no things to soilved
      current_counter = spaces_to_fill_in.to_i
      @myboard.puzzle.each_with_index do |row, r_i|
        row.each_with_index do |element, c_i|
          current_cell = Small_Square.new(@myboard, r_i, c_i)
          next if current_cell.value != 0
          guesses_array = possibilities(current_cell)
          if guesses_array.length == 1
            final_option = guesses_array[0]
            @myboard.puzzle[r_i][c_i] = final_option
          end
        end
      end
      spaces = spaces_to_fill_in
      updated_counter = spaces
      if current_counter == updated_counter
        multi_guesssing # starts multi guessing method
      end
    end
    @myboard.puzzle
  end

  def spaces_to_fill_in
    counter = 0
    @myboard.puzzle.each_with_index do |row, r_i|
      row.each_with_index do |element, c_i|
        current_cell = Small_Square.new(@myboard, r_i, c_i)
        if current_cell.value == 0
          counter += 1
        end
      end
    end
    return counter
  end

  def multi_guessing(cell, row_index, col_index, array) # this should solve for ranges of more than 1
    until  @myboard.puzzle.select {|array| !array.select{ |cell| cell == 1 }.empty? }.empty?
      # debugger
      array << 1
      if array.length == 2

      elsif array.length > 2
        # multi_guessing(cell, row_index, col_index, array)
      end
    end
  end

  # def solve!
  #   until @myboard.puzzle.select {|array| !array.select{ |cell| cell == 0 }.empty? }.empty? # method will run until there are no things to soilved
  #     current_counter = spaces_to_fill_in.to_i
  #     check_all_rows
  #     spaces = spaces_to_fill_in
  #     updated_counter = spaces
  #     if current_counter == updated_counter
  #       multi_guesssing() # starts multi guessing method
  #     end
  #   end
  #   @myboard.puzzle
  # end

  # def check_all_rows
  #   @myboard.puzzle.each_with_index do |row, r_i|
  #     check_all_cells(row, r_i)
  #   end
  #   @myboard.puzzle
  # end

  # def check_all_cells(row, row_index)
  #   row.each_with_index do |element, c_i|
  #     current_cell = Small_Square.new(@myboard, row_index, c_i)
  #     next if current_cell.value != 0
  #     solve_for_1(current_cell, row_index, c_i)
  #   end
  # end

  # def solve_for_1(cell, row_index, col_index)
  #   guesses_array = possibilities(cell)
  #   if guesses_array.length == 1
  #     final_option = guesses_array[0]
  #     @myboard.puzzle[row_index][col_index] = final_option
  #   end
  #   @myboard.puzzle
  # end

  def possibilities(cell) # will return  an array of potential guesses
    combined = cell.row + cell.column + cell.group
    guesses = [0,1,2,3,4,5,6,7,8,9]
    possible_array = guesses - combined
    possible_array
  end

  def board
    @myboard.show_me
  end
end

# ==========================================Small Square Class======================================================
class Small_Square
  attr_reader :row, :column
  attr_accessor :value
  def initialize(myboard, row_coord, col_coord)
    @row, @column, @row_coord, @col_coord = [], [], row_coord, col_coord
    @my_board = myboard.puzzle
    @value = @my_board[row_coord][col_coord]
  end
  def row
     return @row = @my_board[@row_coord]
  end
  def column
    @my_board.each_with_index do |row, row_index|
      @column << @my_board[row_index][@col_coord]
    end
    @column
  end
  def group
    box_coord = [@row_coord/3, @col_coord/3]
    box_array = []
    @my_board.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        if box_coord == [row_index/3, col_index/3]
          box_array << @my_board[row_index][col_index]
        end
      end
    end
    box_array
  end
  def position # position from the entire board # be friends with board
    position =[@row_coord, @col_coord]
    position
  end
end
# ===========================================New Board Class =====================================================
class Board
  attr_accessor :string, :puzzle
  def initialize(string)
    @string = string
    @puzzle = []
    get_board
  end
  def get_board
    temp_array = @string.split('').map! {|pos| pos.to_i }
    temp_array = temp_array.each_slice(9).to_a
    @puzzle = temp_array
  end
  def show_me
    final_string = "         Your Sudoku Puzzle\n-----------------------------------\n"
    @puzzle.each_with_index do |row, row_index|
      final_string << "|"
      row.each_with_index do |element, element_index|
        if element != 0
          final_string << " #{element} "
        elsif element == 0
          final_string << " _ "
        end
        final_string << " |" if element_index%3 == 2
      end
      final_string << "\n"
      final_string << "-----------------------------------\n" if row_index%3 == 2
    end
    final_string
  end
end
# ========================================Assert Method========================================================
def assert_equal(actual, expected)
    if actual == expected
      return true
    else
      raise "expected was #{expected} but actual was #{actual}"
    end
end

# ============================================Driver Code====================================================
game_string = File.readlines('sample.txt').first.chomp
game = Sudoku.new(game_string)
