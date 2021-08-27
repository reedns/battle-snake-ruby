class Food
  attr_reader :head
  attr_accessor :coords

  def initialize(coords)
    @coords = coords
  end

  def y_distance(head)
    head[:y] - coords[:y]
  end

  def x_distance(head)
    head[:x] - coords[:x]
  end

  def manhattan_distance(head)
    y_distance(head).abs + x_distance(head).abs
  end
end
