require_relative 'snake'
require_relative 'board'
require_relative 'food'
require_relative 'move'

class Game
  attr_reader :head, :body, :snakes, :food, :moves, :board

  def initialize(game_data)
    @board = Board.new(game_data)

    me = Snake.new(game_data[:you])
    @head = me.head
    @body = me.body
    @snakes = board.board[:snakes].map { |coords| Snake.new(coords) }
    @food = board.board[:food].map { |coords| Food.new(coords, head) }
    @moves = %i(up down left right).map { |dir| Move.new(dir, head) }
  end

  def unsafe?(new_position)
    hits_a_wall?(new_position) ||
    hits_itself?(new_position) ||
    hits_snake?(new_position)
  end

  def move
    moves.each do |move|
      new_position = move.next_move

      if unsafe?(new_position)
        move.score += -1
        next
      end

      move.score += 2 if food?(new_position)
      move.score += 1 if towards_food?(move.dir)
    end

    good_move = moves.sort_by { |m| -m.score }.first

    puts "board #{board.board}"
    puts "head: #{head}"
    puts "move: #{good_move.score} #{good_move.dir}"

    { "move": good_move.dir }
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
    puts "Closest food: #{closest.coords}"

    move == :up && closest.y_distance.positive? ||
    move == :down && closest.y_distance.negative? ||
    move == :right && closest.x_distance.positive? ||
    move == :left && closest.x_distance.negative?
  end
end
