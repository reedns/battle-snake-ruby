# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)
  puts board

  # Choose a random direction to move in
  possible_moves = ["up", "down", "left", "right"]
  game = board[:game]
  top_edge = game.dig(:board, :height) - 1
  right_edge = game.dig(:board, :width) - 1
  head_coords = game.dig(:you, :head)

  safe_moves = []

  move =
    possible_moves.each do |move|
      new_position = next_move(move)

      unless hits_a_wall?(move, top_edge, right_edge, new_position)
        return move
      end
    end

  { "move": move }
end

def next_move(move, head_coords)
  case move
  when 'up' then head_coords[:y] += 1
  when 'down' then head_coords[:y] -= 1
  when 'left' then head_coords[:x] -= 1
  when 'right' then head_coords[:x] += 1
  end

  head_coords
end


def hits_a_wall?(move, top_edge, right_edge, coords = {})
  y = coords[:y]
  x = coords[:x]

  move == 'up' && y == top_edge ||
    move == 'down' && y == 0 ||
    move == 'left' && x == 0 ||
    move == 'right' && x == right_edge
end

# {:game=>{:id=>"db68752e-a637-4d39-846f-5bc30011fede", :ruleset=>{:name=>"solo", :version=>"v1.0.17"}, :timeout=>500},
  # :turn=>18,
   # :board=>
      # {:height=>7,
       # :width=>7,
       # :snakes=>[{:id=>"gs_jScVVGh4KKqjf3Wrct8C4dkB", :name=>"fierce garter snake", :latency=>"90", :health=>90, :body=>[{:x=>4, :y=>2}, {:x=>4, :y=>3}, {:x=>4, :y=>4}, {:x=>3, :y=>4}], :head=>{:x=>4, :y=>2}, :length=>4, :shout=>""}],
       # :food=>[{:x=>6, :y=>2}],
       # :hazards=>[]},
  # :you=>{:id=>"gs_jScVVGh4KKqjf3Wrct8C4dkB", :name=>"fierce garter snake", :latency=>"90", :health=>90, :body=>[{:x=>4, :y=>2}, {:x=>4, :y=>3}, {:x=>4, :y=>4}, {:x=>3, :y=>4}], :head=>{:x=>4, :y=>2}, :length=>4, :shout=>""}
# }
