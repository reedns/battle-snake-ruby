require_relative 'snake'
require_relative 'board'
require_relative 'food'
require_relative 'move'

class Game
  attr_reader :head, :body, :snakes, :food, :moves, :board, :me

  def initialize(game_data)
    @board = Board.new(game_data)

    @me = Snake.new(game_data[:you])
    @head = me.head
    @body = me.body
    @snakes = board.board[:snakes].map { |coords| Snake.new(coords) }
    @food = board.board[:food].map { |coords| Food.new(coords) }
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
      new_pos2 = move.next_move(new_position)

      if unsafe?(new_position)
        move.score += -1.0
        next
      end

      move.score += 0.5 if food?(new_position)
      move.score += 0.2 if towards_food?(move.dir, new_position)

      move.score += 0.3 if food?(new_pos2)
      move.score += 0.2 if towards_food?(move.dir, new_pos2)
      move.score += 0.5 if smaller_snake_heads?(new_pos2)
      move.score -= 0.5 if other_snake_body?(new_pos2)
    end

    good_move = moves.sort_by { |m| -m.score }.first

    puts "board #{board.board}"
    puts "head: #{head}"
    puts "move: #{good_move.score} #{good_move.dir}"

    { "move": good_move.dir }
  end

  def other_snake_body?(position)
    snakes.detect { |s| s.body[1..-1] == position }
  end

  def smaller_snake_heads?(position)
    snakes.detect { |s| s.body.first == position && s.length < me.length }
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

  def towards_food?(move, new_position)
    return false if food.empty?

    closest = food.max { |f| f.manhattan_distance(head) }
    puts "Closest food: #{closest.coords}"

    move == :up && closest.y_distance(head).negative? ||
    move == :down && closest.y_distance(head).positive? ||
    move == :right && closest.x_distance(head).negative? ||
    move == :left && closest.x_distance(head).positive?
  end
end
