require_relative 'Piece.rb'

class Board 
  attr_reader :rows
  def initialize
    @rows = Array.new(8){Array.new(8)}
    populate_board
  end 

  def [](pos)
    x,y = pos 
    rows[x][y]
  end 

  def []=(pos,val)
    x,y = pos 
    rows[x][y] = val
  end
 
  def populate_board
    (0...rows.length).each do |row| # row 0
      (0...rows[0].length).each do |col|
        if row == 0 
          place_back_row(:black, 0)
        elsif row == 1 
          self[[row,col]] = Pawn.new(:black, [row,col],self)
        elsif row == 6
          self[[row,col]] = Pawn.new(:white, [row,col],self)
        elsif row == 7 
          place_back_row(:white, 7)
        else 
          self[[row,col]] = NullPiece.instance 
        end
      end
    end 
  end 

  def place_back_row(color, row)
    self[[row,0]] = Rook.new(color, [row,0], self) 
    self[[row,1]] = Knight.new(color, [row,1], self) 
    self[[row,2]] = Bishop.new(color, [row,2], self) 
    self[[row,3]] = Queen.new(color, [row,3], self) 
    self[[row,4]] = King.new(color, [row,4], self) 
    self[[row,5]] = Bishop.new(color, [row,5], self) 
    self[[row,6]] = Knight.new(color, [row,6], self) 
    self[[row,7]] = Rook.new(color, [row,7], self) 
  end 

  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]
    raise ArgumentError.new("Invalid start position") if start_piece.nil?

    raise ArgumentError.new("Index out of bounds") unless valid_pos?(start_pos) && valid_pos?(end_pos)
    self[start_pos], self[end_pos] = NullPiece.instance, start_piece 

    start_piece.pos = end_pos
  end
  
  def valid_pos?(pos)
    !(pos[0] > 7 || pos[0] < 0 || pos[1] > 7 || pos[1] < 0)
  end
end 

board = Board.new 
# p board.rows
# p board.move_piece([1,3], [3,3])
# p board
# a = Display.new(Board.new)
# a.test_input
