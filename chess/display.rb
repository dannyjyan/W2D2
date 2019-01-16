require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb'
class Display 
    attr_reader :board, :cursor
    def initialize(board)
      @board = Board.new
      @cursor = Cursor.new([0,5],board)
    end 

    def render
      # puts @cursor.cursor_pos
      board.rows.each_with_index do |row, x|
        curr_row = row.map { |p| p.inspect }
        curr_row.each_with_index do |sq, y|
          if @cursor.cursor_pos == [x,y]
            print sq.colorize(:background => @cursor.color) + " "
          else
            print sq+ " "
          end
        end
        print "\n"
      end
      puts "-------------------------"

        # if @cursor.cursor_pos[0] == x
        #   curr_row[@cursor.cursor_pos[1]].colorize(:blue)
        # end
        # puts curr_row.join(" ")
    end 

    def test_input 
      while true 
        self.render
        @cursor.get_input
      end
    end 

  end

  