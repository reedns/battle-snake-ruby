class Board
  attr_reader :board, :top, :bottom, :right_edge, :left_edge

  def initialize(game_data)
    @board = game_data[:board]
    @top = board[:height]
    @right_edge = board[:width]
    @bottom = 0
    @left_edge = 0
  end
end
