# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)
  puts board

  possible_moves = %i(up down left right).shuffle
  top_edge = board[:board][:height] - 1
  right_edge = board[:board][:width] - 1
  body = board[:you][:body]
  snakes = board[:board][:snakes]

  safe_move =
    possible_moves.detect do |move|
      new_position = next_move(move, board[:you][:head])
      # puts "|||||||||| after head: #{new_position}"

      !hits_a_wall?(move, top_edge, right_edge, new_position) &&
      !hits_itself?(body, new_position) &&
      !hits_snake?(snakes, new_position)
    end

  { "move": safe_move }
end

def next_move(move, head)
  next_head = head.dup
  # puts "|||||||||| move: #{move}"
  # puts "|||||||||| before head: #{head}"
  case move
  when :up then next_head[:y] += 1
  when :down then next_head[:y] -= 1
  when :left then next_head[:x] -= 1
  when :right then next_head[:x] += 1
  end

  next_head
end

def hits_a_wall?(move, top_edge, right_edge, new_position = {})
  y = new_position[:y]
  x = new_position[:x]

  # puts "########## #{move}"
  # puts "########## y = #{y} top = #{top_edge + 1}"
  # puts "########## x = #{x} right = #{right_edge + 1}"

  move == :up && y == top_edge + 1 ||
    move == :down && y == -1 ||
    move == :left && x == -1 ||
    move == :right && x == right_edge + 1
end

def hits_itself?(body, new_position = {})
  hits =
    body.detect do |coords|
      coords == new_position
    end
end

def hits_snake?(snakes, new_position = {})
  snakes.detect do |snake|
    new_position == snake
  end
end
