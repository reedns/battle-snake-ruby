def move(board)
  puts board

  possible_moves = %i(up down left right).shuffle
  top_edge = board[:board][:height] - 1
  right_edge = board[:board][:width] - 1
  head = board[:you][:head]
  body = board[:you][:body]
  snakes = board[:board][:snakes]
  food = board[:board][:food]

  possible_moves = possible_moves.prepend(food_directions(food, head)).uniq

  safe_move =
    possible_moves.detect do |move|
      new_position = next_move(move, head)
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
    other_head = snake[:body].first
    snake[:body].detect do |body|
      body == new_position
    end
  end
end

def food_directions(food, head)
  min = nil
  distance = 1000
  closest = food.each do |f|
     dist = (head[:x] - f[:x]).abs + (head[:y] - f[:y]).abs
     if dist < distance
       min = f
       distance = dist
     end
  end

  x_dist = head[:x] - min[:x]
  y_dist = head[:y] - min[:y]
  x = (x_dist).positive? ? :left : :right
  y = (y_dist).positive? ? :down : :up

  x_min = (x_dist).abs
  y_min = (y_dist).abs

  x_min < y_min ? [x, y] : [y, x]
end

# {:game=>
 # {:id=>"0849548c-b5da-4c04-b7f6-8e432c2349ef", :ruleset=>{:name=>"standard", :version=>"v1.0.17"}, :timeout=>500},
 # :turn=>8,
 # :board=>{:height=>11,
          # :width=>11,
          # :snakes=>[{:id=>"gs_kKHjJyvFCgHPkpjYMTdCpFpJ", :name=>"fierce garter snake", :latency=>"149", :health=>92, :body=>[{:x=>8, :y=>2}, {:x=>8, :y=>3}, {:x=>9, :y=>3}], :head=>{:x=>8, :y=>2}, :length=>3, :shout=>""}
                    # , {:id=>"gs_6gMVhcFggxVPvhtbYtQxvy9F", :name=>"fierce garter snake", :latency=>"151", :health=>94, :body=>[{:x=>7, :y=>1}, {:x=>8, :y=>1}, {:x=>8, :y=>0}, {:x=>7, :y=>0}], :head=>{:x=>7, :y=>1}, :length=>4, :shout=>""}],
         # :food=>[{:x=>8, :y=>4}, {:x=>5, :y=>5}], :hazards=>[]},
 # :you=>{:id=>"gs_kKHjJyvFCgHPkpjYMTdCpFpJ", :name=>"fierce garter snake", :latency=>"149", :health=>92, :body=>[{:x=>8, :y=>2}, {:x=>8, :y=>3}, {:x=>9, :y=>3}], :head=>{:x=>8, :y=>2}, :length=>3, :shout=>""}}
