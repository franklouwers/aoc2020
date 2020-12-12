ff = File.open("input")
#ff = File.open("sample")

instructions = ff.readlines.map(&:chomp)

heading = 90 # degrees, so start east
pos_ns = 0
pos_ew = 0
w_pos_ns = 1 # relative to the ships position
w_pos_ew = 10 # relatieve to the ships position

instructions.each do |instr|
  instr = instr.match(/^(\D)(\d+)$/)
  command = instr[1]
  amount = instr[2].to_i
  puts "i: #{command} #{amount}"
  case command
  when 'N'
    w_pos_ns += amount
  when 'S'
    w_pos_ns -= amount
  when 'E'
    w_pos_ew += amount
  when 'W'
    w_pos_ew -= amount
  when 'R'
    # turn clockwise
    (amount / 90).times do
      new_w_pos_ns = -w_pos_ew
      new_w_pos_ew = w_pos_ns
      w_pos_ns = new_w_pos_ns
      w_pos_ew = new_w_pos_ew
    end
  when 'L'
    # turn counter-clockwise
    (amount / 90).times do
      new_w_pos_ns = w_pos_ew
      new_w_pos_ew = -w_pos_ns
      w_pos_ns = new_w_pos_ns
      w_pos_ew = new_w_pos_ew
    end
  when 'F'
    # move forward to the waypoint a number of times
    pos_ns += (w_pos_ns * amount)
    pos_ew += (w_pos_ew * amount)
  end
  puts "new ship pos (ns x ew): #{pos_ns} x #{pos_ew}"
  puts "new wayp pos (ns x ew): #{w_pos_ns} x #{w_pos_ew}"
end

dist = pos_ns.abs + pos_ew.abs
pp dist
