# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)
  # puts board

  possible_moves = %i(up down left right)
  top_edge = board[:board][:height] - 1
  right_edge = board[:board][:width] - 1
  head = board[:you][:head]
  body = board[:you][:body]

  safe_move =
    possible_moves.detect do |move|
      new_position = next_move(move, head)

      !hits_a_wall?(move, top_edge, right_edge, new_position) &&
      !hits_itself?(move, body, new_position)
    end

  { "move": safe_move }
end

def next_move(move, head)
  case move
  when :up then head[:y] += 1
  when :down then head[:y] -= 1
  when :left then head[:x] -= 1
  when :right then head[:x] += 1
  end

  head
end

def hits_a_wall?(move, top_edge, right_edge, new_position = {})
  y = new_position[:y]
  x = new_position[:x]

  move == :up && y >= top_edge ||
    move == :down && y <= 0 ||
    move == :left && x <= 0 ||
    move == :right && x >= right_edge
end

def hits_itself?(move, body, new_position = {})
  y = new_position[:y]
  x = new_position[:x]

  hits =
    body.detect do |coords|
      case move
      when :up, :down
        y == coords[:y]
      when :left, :right
        x == coords[:x]
      end
    end

  hits
end
