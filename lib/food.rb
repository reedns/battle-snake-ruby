class Food
  attr_reader :coords, :head

  def initialize(coords, head)
    @coords = coords
    @head = head
  end

  def y_distance
    (head[:y] - coords[:y]).abs
  end

  def x_distance
    (head[:x] - coords[:x]).abs
  end

  def manhattan_distance
    y_distance + x_distance
  end
end
