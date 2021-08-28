require 'yaml'
require_relative 'snake'
require_relative 'board'
require_relative 'food'
require_relative 'move'
require_relative 'util/distance_calculator'

class Game
  attr_reader :head, :body, :snakes, :food, :moves, :board, :me, :other_snake_sizes

  SCORING_STRATEGIES = YAML.load_file('lib/scoring_strategies.yml')

  def initialize(game_data)
    @board = Board.new(game_data)

    @me = Snake.new(game_data[:you])
    @head = me.head
    @body = me.body
    @snakes = board.board[:snakes][1..-1]&.map { |coords| Snake.new(coords) } || []
    @food = board.board[:food].map { |coords| Food.new(coords) }
    @moves = %i(up down left right).map { |dir| Move.new(dir, head) }
    @other_snake_sizes = snakes[1..-1]&.map { |s| s.length } || []
  end

  def move
    moves.each do |move|
      new_position = move.next_move
      new_pos2 = move.next_move(new_position)

      if unsafe?(new_position)
        move.score += -1.0
        next
      end

      strategy =
        if biggest_snake? && me.health.to_i > 50
          SCORING_STRATEGIES['aggressive']
        elsif me.health.to_i < 40 || !biggest_snake?
          SCORING_STRATEGIES['find_food']
        else
          SCORING_STRATEGIES['basic']
        end

      puts "Strategy: #{strategy}"
      puts "Health: #{me.health}"
      puts "Biggest: #{biggest_snake?}"

      move.score += strategy['food'] if food?(new_position)
      move.score += strategy['space'] if !food?(new_position)
      move.score += strategy['find_small_snakes_1'] if moves_towards_objects?(move.dir, new_position, snakes)

      move.score += strategy['food_2'] if food?(new_pos2)
      move.score += strategy['space'] if !food?(new_pos2)
      move.score += strategy['towards_food_2'] if moves_towards_objects?(move.dir, new_pos2, food)
      move.score += strategy['small_snakes'] if smaller_snake_heads?(new_pos2)
      move.score += strategy['find_small_snakes_2'] if moves_towards_objects?(move.dir, new_pos2, snakes)
      move.score += strategy['possible_trap'] if other_snake_body?(new_pos2) || hits_itself?(new_pos2)
    end

    good_move = moves.sort_by { |m| -m.score }.first

    { "move": good_move.dir }
  end

  private

  def unsafe?(new_position)
    hits_a_wall?(new_position) ||
    hits_itself?(new_position) ||
    hits_snake?(new_position)
  end

  def other_snake_body?(position)
    return false if snakes.empty?

    snakes.detect { |s| s.body[1..-1] == position }
  end

  def smaller_snake_heads?(position)
    return false if snakes.empty?

    snakes.detect { |s| s.body.first == position && s.length < me.length }
  end

  def hits_a_wall?(position)
    y = position[:y]
    x = position[:x]

    y > board.top || y < board.bottom || x < board.left_edge || x > board.right_edge
  end

  def hits_snake?(position)
    return false if snakes.empty?

    snakes.detect do |snake|
      snake.body[0..-2].detect do |section|
        section == position
      end
    end
  end

  def hits_itself?(position)
    body[0..-2].detect do |coords|
      coords == position
    end
  end

  def food?(position)
    food.detect { |f| f.coords == position }
  end

  def biggest_snake?
    return true if other_snake_sizes.empty?

    me.length > other_snake_sizes.max
  end

  def moves_towards_objects?(move, position, objects = nil)
    return false if objects.empty?

    closest = objects.max { |o| Util::DistanceCalculator.new(position, o.coords).manhattan_distance }

    calculator = Util::DistanceCalculator.new(position, closest.coords)
    closest_y = calculator.y_distance
    closest_x = calculator.x_distance

    move == :up && closest_y.negative? && closest_y.abs < closest_x.abs ||
    move == :down && closest_y.positive? && closest_y.abs < closest_x.abs ||
    move == :right && closest_x.negative? && closest_y.abs > closest_x.abs||
    move == :left && closest_x.positive? && closest_y.abs > closest_x.abs
  end
end
