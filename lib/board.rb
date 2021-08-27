class Board
  attr_reader :board, :top, :bottom, :right_edge, :left_edge

  def initialize(game_data)
    @board = game_data[:board]
    @top = board[:height] - 1
    @right_edge = board[:width] - 1
    @bottom = 0
    @left_edge = 0
  end
end
