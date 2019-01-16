require 'Singleton'
require_relative "board.rb"
require_relative "display.rb"
module SlidingPiece
  DIAGONALS = [[-1,-1],[1,-1],[-1,1],[1,1]]
  VERTICALS = [[-1,0], [1,0], [0,-1],[0,1]]
  def moves #available moves
    result = []
    if self.move_dirs == :diagonal || self.move_dirs == :both
      DIAGONALS.each {|pos| result += steps(pos)}
    end
    if self.move_dirs == :vertical || self.move_dirs == :both
      VERTICALS.each {|pos| result += steps(pos)}
    end 
    result
  end 
  private
  def steps(dir) #helper for finding available moves
    curr_pos = [pos[0] + dir[0], pos[1] + dir[1]]
    result = []
    while board.valid_pos?(curr_pos)
      if board[curr_pos].color == @color  #is equal to curr color
        break 
      elsif !board[curr_pos].color.nil?  #is not NullPiece
        result << curr_pos
        break 
      else 
        result << curr_pos
      end 
      curr_pos =  [curr_pos[0] + dir[0], curr_pos[1] + dir[1]]
    end
    result
  end 
end 

module SteppingPiece
  KING_DIRS = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
  KNIGHT_DIRS = [[-2,-1],[-1,-2],[2,-1],[1,-2],[2,1],[1,2],[-2,1],[-1,2]]
  def moves
    curr_pos = pos
    result = []
    pos_moves = (self.is_a?(King) ? KING_DIRS : KNIGHT_DIRS)
    pos_moves.each do |pos_move| 
      next_move = [curr_pos[0] + pos_move[0], curr_pos[1] + pos_move[1]]
      next unless board.valid_pos?(next_move) # skip if out of bounds 
      result << next_move if board[next_move].color != self.color # append move if not same color
    end 
    result
  end 
end 

class Piece
  attr_reader :color, :symbol, :board
  attr_accessor :pos
  
  def initialize(color=nil, pos=nil, board=nil, symbol=nil)
    @color = color 
    @symbol = symbol
    @pos = pos
    @board = board
  end 

  def moves
  end

  def inspect 
    symbol.to_s
  end 

  def opp_color 
    @color == :white ? :black : :white
  end 
end 

class Bishop < Piece
  include SlidingPiece

  def initialize(color, pos, board)
    super(color, pos, board, :B)
  end 

  def move_dirs 
    :diagonal
  end 

end

class Rook < Piece
  include SlidingPiece

  def initialize(color, pos, board)
    super(color, pos, board, :R)
  end

  def move_dirs 
    :vertical 
  end 

end 

class Queen < Piece
  include SlidingPiece

  def initialize(color, pos, board)
    super(color, pos, board, :Q)
  end 

  def move_dirs 
    :both
  end 

end

class Knight < Piece
  include SteppingPiece

  def initialize(color, pos, board)
    super(color, pos, board, :N)
  end 
end

class King < Piece
  include SteppingPiece

  def initialize(color, pos, board)
    super(color, pos, board, :K)
  end 
end

class Pawn < Piece

  def initialize(color, pos, board)
    super(color, pos, board, :p)
  end 

  def moves 
    curr_pos = pos
    result = []
    if color == :white 
      inc, bound, start = -1,0,6 
    else 
      inc, bound, start =  1,7,1 
    end
    if color == :white 
      if pos[0] != bound && board[[pos[0]+inc, pos[1]]].color.nil?
        result << [pos[0]+inc, pos[1]]
        result << [pos[0]+inc*2, pos[1]] if pos[0] == start && board[[pos[0]+inc*2, pos[1]]].color.nil?
      end 
      if board.valid_pos?([pos[0]+inc, pos[1]-1]) && board[[pos[0]+inc, pos[1]-1]].color == opp_color
        result << [pos[0]+inc,pos[1]-1]
      end
      if board.valid_pos?([pos[0]+inc, pos[1]+1]) && board[[pos[0]+inc, pos[1]+1]].color == opp_color
        result << [pos[0]+inc,pos[1]+1]
      end 
    end
    result
  end 
end

class NullPiece < Piece
  include Singleton
  def color 
    nil 
  end 
  def symbol 
    "?"
  end 
  def opp_color
    nil 
  end
end