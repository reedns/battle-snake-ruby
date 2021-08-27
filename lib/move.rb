class Move
  attr_reader :dir, :head
  attr_accessor :score

  def initialize(dir, head)
    @dir = dir
    @head = head
    @score = 0.0
  end

  def next_move(start_head = head)
    next_head = start_head.dup
    case dir
    when :up then next_head[:y] += 1
    when :down then next_head[:y] -= 1
    when :left then next_head[:x] -= 1
    when :right then next_head[:x] += 1
    end

    next_head
  end
end
