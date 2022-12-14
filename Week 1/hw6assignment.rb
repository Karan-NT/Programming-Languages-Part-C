# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

require_relative './hw6graphics'

class MyPiece < Piece
  All_My_Pieces = [
    [[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)

    rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T

    [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
    [[0, 0], [0, -1], [0, 1], [0, 2]]],

    rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L

    rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L

    rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S

    rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]), # Z

    [[[0, 0], [-1, 0], [1, 0], [2, 0], [3, 0]],
    [[0, 0], [0, -1], [0, 1], [0, 2], [0, 3]]],

    rotations([[0, 0], [-1, 0], [1, 0], [0, -1], [-1, -1]]),

    rotations([[0, 0], [1, 0], [0, -1], [0, 0]])
  ]

  Cheat_Piece = [[[0, 0], [0, 0], [0, 0], [0, 0]]]

  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  def self.cheat (board)
    MyPiece.new(Cheat_Piece, board)
  end
end

class MyBoard < Board
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
  end

  def next_piece
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil
  end

  def u_turn
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  def cheat
    if @score > 100 and !game_over? and @game.is_running?
      @current_block = MyPiece.cheat(self)
    end
  end
end

class MyTetris < Tetris
  def initialize
    @root = TetrisRoot.new
    @timer = TetrisTimer.new
    set_board
    @running = true
    key_bindings
    buttons
    run_game
  end

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings  
    @root.bind('n', proc {self.new_game})

    @root.bind('p', proc {self.pause})

    @root.bind('q', proc {exitProgram})

    @root.bind('a', proc {@board.move_left})
    @root.bind('Left', proc {@board.move_left})

    @root.bind('d', proc {@board.move_right})
    @root.bind('Right', proc {@board.move_right})

    @root.bind('s', proc {@board.rotate_clockwise})
    @root.bind('Down', proc {@board.rotate_clockwise})

    @root.bind('w', proc {@board.rotate_counter_clockwise})
    @root.bind('Up', proc {@board.rotate_counter_clockwise})

    @root.bind('u' , proc {@board.u_turn})

    @root.bind('c' , proc {@board.cheat})

    @root.bind('space' , proc {@board.drop_all_the_way})
  end
end
