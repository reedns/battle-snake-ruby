require_relative 'snake'
require_relative 'board'
require_relative 'food'

class Game
  attr_reader :head, :body, :snakes, :food, :moves, :board

  def initialize(game_data)
    @board = Board.new(game_data)

    me = Snake.new(game_data[:you])
    @head = me.head
    @body = me.body
    @snakes = board.board[:snakes].map { |coords| Snake.new(coords) }
    @food = board.board[:food].map { |coords| Food.new(coords, head) }
    @moves = %i(up down left right).shuffle
  end

  def good_move?(move, new_position)
    safe = safe?(new_position)

    food?(new_position) ||
    (towards_food?(move) && safe) ||
    safe
  end

  def safe?(new_position)
    !hits_a_wall?(new_position) &&
    !hits_itself?(new_position) &&
    !hits_snake?(new_position)
  end

  def move
    good_move =
      moves.detect do |move|
        new_position = next_move(move)
        good_move?(move, new_position)
      end

    puts "board #{board.board}"
    puts "head: #{head}"

    { "move": good_move }
  end

  def good_move(safe_moves)
    safe_moves
  end

  def next_move(move)
    next_head = head.dup
    case move
    when :up then next_head[:y] += 1
    when :down then next_head[:y] -= 1
    when :left then next_head[:x] -= 1
    when :right then next_head[:x] += 1
    end

    puts "Prev head: #{head}"
    puts "Next head: #{next_head}"
    next_head
  end

  def hits_a_wall?(new_position)
    y = new_position[:y]
    x = new_position[:x]
    puts "new positions: #{x}, #{y}"

    y > board.top || y < board.bottom || x < board.left_edge || x > board.right_edge
  end

  def hits_snake?(new_position)
    snakes.detect do |snake|
      snake.body.detect do |body|
        body == new_position
      end
    end
  end

  def hits_itself?(new_position)
    body[0..-2].detect do |coords|
      coords == new_position
    end
  end

  def food?(new_position)
    food.detect { |f| f.coords == new_position }
  end

  def towards_food?(move)
    return true if food.empty?

    closest = food.max { |f| f.manhattan_distance }
    puts "Closest: #{closest}"

    move == :up && closest.y_distance.positive? ||
    move == :down && closest.y_distance.negative? ||
    move == :right && closest.x_distance.positive? ||
    move == :left && closest.x_distance.negative?
  end
end
