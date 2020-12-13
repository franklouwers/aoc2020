ff = File.open("input")

junk = ff.gets
schedules = ff.gets.chomp.split(',')
pp schedules

t = 0
skip = 1 # should we bother with the max? probably not, will mess up time offsets. Also note: will fail if we start with x

schedules.each_with_index do |bus, min|
  next if bus == 'x'
  bus = bus.to_i
  while (t + min) % bus != 0
    t += skip
  end
  skip *= bus
end
puts "solution found at #{t}"
