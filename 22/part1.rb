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

counter = 0
while stack_p1.size > 0 and stack_p2.size > 0
  counter += 1
  puts "Round #{counter}"
  puts "----------------"
  puts "p1 deck: #{stack_p1.inspect}"
  puts "p2 deck: #{stack_p2.inspect}"
  p1 = stack_p1.shift
  p2 = stack_p2.shift
  puts "p1 draws: #{p1}"
  puts "p2 draws: #{p2}"
  if p1 > p2
    puts "p1 wins"
    # p1 wins
    stack_p1 << p1
    stack_p1 << p2
  elsif p2 > p1
    puts "p1 wins"
    # p1 wins
    # p2 wins
    stack_p2 << p2
    stack_p2 << p1
  else # draw, not defined!
    puts "NOT DEFINED"
  end
end


puts "winner found"
pp stack_p1
pp stack_p2

if stack_p1.size > 0
  winner_stack = stack_p1
else
  winner_stack = stack_p2
end

puts winner_stack.reverse.map.with_index{|e, i| e*(i+1)}.sum
