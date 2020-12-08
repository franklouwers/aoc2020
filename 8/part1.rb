require 'set'

#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

acc = 0
pos = 0
visited = Set.new
stop = false

while not stop
  # have we visited this line before?

  if visited.include? pos
    stop = true
    puts "loop detected: already visited position #{pos}"
    break
  end
  # add pos to visited set
  visited << pos
  instruction, arg = entries[pos].split
  puts "i: #{instruction} - a: #{arg}"
  arg = arg.to_i
  case instruction
  when 'nop'
    pos += 1
  when 'acc'
    pos += 1
    acc += arg
  when 'jmp'
    pos += arg
  end
end

puts "acc: #{acc}"




