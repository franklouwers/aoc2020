ff = File.open("input")
#ff = File.open("sample")

cur_time = ff.gets.chomp.to_i
schedules = ff.gets.chomp.split(',').delete_if{|x| x == 'x'}
when_next = Float::INFINITY
id_next = 0
schedules.each do |s|
  if s.to_i - (cur_time % s.to_i) < when_next
    when_next = s.to_i - (cur_time % s.to_i)
    id_next = s.to_i
  end
end
puts "next id: #{id_next} in #{when_next} minutes"
puts "answer: #{id_next * when_next}"

