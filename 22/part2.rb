require 'set'

def play_game(stack_p1, stack_p2)
  gamewinner = nil
  if $won_p1.include? [stack_p1, stack_p2]
    return 'p1'
  elsif
    $won_p2.include? [stack_p1, stack_p2]
    return 'p2'
  end

  ostack_p1 = stack_p1.dup
  ostack_p2 = stack_p2.dup

  rounds = Set.new
  roundcounter = 0
  loop do
    if stack_p1.empty?
      $won_p2 << [ostack_p1, ostack_p2]
      return 'p2'
    end
    if stack_p2.empty?
      $won_p1 << [ostack_p1, ostack_p2]
      return 'p1'
    end

    if rounds.include?([stack_p1, stack_p2])
      $won_p1 << [ostack_p1, ostack_p2]
      return 'p1'
    end

    rounds << [stack_p1.dup, stack_p2.dup]

    p1 = stack_p1.shift
    p2 = stack_p2.shift

    if stack_p1.size >= p1 and stack_p2.size >= p2
      dup_p1 = stack_p1[0..(p1-1)]
      dup_p2 = stack_p2[0..(p2-1)]
      winner = play_game(dup_p1, dup_p2)
    else
      if p1 > p2
        winner = 'p1'
      else
        winner = 'p2'
      end
    end

    if winner == 'p1'
      stack_p1 << p1
      stack_p1 << p2
    else
      stack_p2 << p2
      stack_p2 << p1
    end
  end
end

ff = File.open("input")

stack_p1 = nil
stack_p2 = nil

while ff.gets
  line = $_.chomp
  if line.match /Player 1:/
    stack_p1 = Array.new
    next
  elsif line.match /Player 2:/
    stack_p2 = Array.new
    next
  elsif line.size == 0
    next
  end
  if stack_p2
    stack_p2 << line.to_i
  else
    stack_p1 << line.to_i
  end
end
puts "p1 deck: #{stack_p1.inspect}"
puts "p2 deck: #{stack_p2.inspect}"

$won_p1 = Set.new
$won_p2 = Set.new

puts play_game(stack_p1, stack_p2)

if stack_p1.size > 0
  winner_stack = stack_p1
else
  winner_stack = stack_p2
end

puts winner_stack.reverse.map.with_index{|e, i| e*(i+1)}.sum
