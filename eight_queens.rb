class Queens
  attr_accessor :grid, :counter, :solutions, :solution_set
  Max_queens = 8
  Available = :A
  Queened = :Q
  Endangered = :X


  def initialize(length = 4, width = 4)
    @grid = Array.new(length) {Array.new(width,Available)}
    @queen_locations = []
    @attempted_combinations = []
    @counter = 0
    @solutions = 0
    @solution_set = []
  end

  def arrange_queens
    available = find_available
    return false if available.empty?
    #puts "before until: #{@queen_locations}"
    until available.empty?
      spot = available.shift
      place_queen(spot)
      @queen_locations << spot
      @counter += 1
      if !available.empty? && !@attempted_combinations.include?(@queen_locations.sort)
        arrange_queens
      elsif @queen_locations.length == grid.length
        remove_subsets
        renders
        puts @queen_locations.to_s
        @solutions += 1
        @solution_set << @queen_locations.sort
      end

      @attempted_combinations << @queen_locations.sort unless @attempted_combinations.include?(@queen_locations.sort)
      remove_subsets
      @queen_locations.pop
      remove_queen(spot)
    end

  end

  def remove_subsets
    @queen_locations.each do |el|
      @attempted_combinations << (@queen_locations - [el]).sort
    end
  end

  def renders(grid = @grid)
    grid.each_with_index do |row, i|
      row.each_with_index do |el,j|
        if el == :Q
          print "♕ "
        elsif el == :X
          print "\e[91m☐ \e[0m"
        else
          print "\e[92m☐ \e[0m"
        end
      end
      puts ""
    end
  end

  def find_available
    available = []
    grid.each_with_index do |row, x|
      row.each_with_index { |el, y| available << [x,y] if el == Available}
    end
    available
  end

  def place_queen(position)
    row = position[0]
    col = position[1]
    endanger_row(row, Endangered)
    endanger_col(col, Endangered)
    endanger_diagonals(row,col, Endangered)
    grid[row][col] = Queened
  end
  # perhaps use danger counts
  def remove_queen(position)
    row = position[0]
    col = position[1]
    endanger_row(row, Available)
    endanger_col(col, Available)
    endanger_diagonals(row,col, Available)
    re_endanger_board
  end

  def re_endanger_board
    @queen_locations.each {|loc| place_queen(loc)}
  end

  def endanger_row(row, symbol)
    grid[row].each_index {|col| grid[row][col] = symbol}
  end

  def endanger_col(col, symbol)
    grid.each_index do |row|
      grid[row].each {grid[row][col] = symbol}
    end
  end

  def endanger_diagonals(row,col,symbol)
    track_row = row - min(row,col)
    track_col = col - min(row,col)
    topleft_to_bottomright(track_row, track_col, symbol)

    # track_row = row + max(row,col)
    # track_col = col - max(row,col)
    bottomleft_to_topright(row, col, symbol)
  end

################################################################################
  def topleft_to_bottomright(track_row, track_col, symbol)
    while track_row < grid.length && track_col < grid[0].length
      grid[track_row][track_col] = symbol
      track_row +=1
      track_col +=1
    end
  end

  def bottomleft_to_topright(track_row, track_col, symbol)

    until track_row == (grid.length - 1) || track_col == 0
      track_row +=1
      track_col -=1
    end

    while track_row >= 0 && track_col < grid[0].length
      grid[track_row][track_col] = symbol
      track_row -=1
      track_col +=1
    end
  end

  def min(a,b)
    return a if a < b
    return b
  end

  def max(a,b)
    return a if a > b
    return b
  end
end

def runner(b = 4)
  a = Time.now
  queens = Queens.new(b,b)
  queens.arrange_queens
  puts "loops #{queens.counter}"
  puts "solutions #{queens.solutions}"
  puts Time.now - a
end

runner(7)
