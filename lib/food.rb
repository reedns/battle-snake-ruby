class Food
  attr_reader :coords, :head

  def initialize(coords, head)
    @coords = coords
    @head = head
  end

  def y_distance
    head[:y] - coords[:y]
  end

  def x_distance
    head[:x] - coords[:x]
  end

  def manhattan_distance
    y_distance.abs + x_distance.abs
  end
end
