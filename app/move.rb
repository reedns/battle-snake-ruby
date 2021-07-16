# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)
  puts board

  possible_moves = %i(up down left right)
  top_edge = board[:board][:height] - 1
  right_edge = board[:board][:width] - 1
  body = board[:you][:body]

  safe_move =
    possible_moves.detect do |move|
      new_position = next_move(move, board[:you][:head])

      !hits_a_wall?(move, top_edge, right_edge, new_position) &&
      !hits_itself?(move, body, new_position)
    end

  { "move": safe_move }
end

def next_move(move, head)
  next_head = head.dup
  puts "|||||||||| move: #{move}"
  puts "|||||||||| before head: #{head}"
  case move
  when :up then next_head[:y] += 1
  when :down then next_head[:y] -= 1
  when :left then next_head[:x] -= 1
  when :right then next_head[:x] += 1
  end

  puts "|||||||||| after head: #{next_head}"
  next_head
end

def hits_a_wall?(move, top_edge, right_edge, new_position = {})
  y = new_position[:y]
  x = new_position[:x]

  puts "########## #{move}"
  puts "########## y = #{y} top = #{top_edge + 1}"
  puts "########## x = #{x} right = #{right_edge + 1}"


  move == :up && y == top_edge + 1 ||
    move == :down && y == -1 ||
    move == :left && x == -1 ||
    move == :right && x == right_edge + 1
end

def hits_itself?(move, body, new_position = {})
  y = new_position[:y]
  x = new_position[:x]

  hits =
    body.detect do |coords|
      puts "********** #{move}"
      puts "********** y = #{y} seg = #{coords}"
      puts "********** x = #{x} seg = #{coords}"
      case move
      when :up, :down
        y == coords[:y]
      when :left, :right
        x == coords[:x]
      end
    end

  puts "********** hits: #{hits}"
  !!hits
end
