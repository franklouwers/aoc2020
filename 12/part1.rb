ff = File.open("input")
#ff = File.open("sample")

instructions = ff.readlines.map(&:chomp)

heading = 90 # degrees, so start east
pos_ns = 0
pos_ew = 0

instructions.each do |instr|
  instr = instr.match(/^(\D)(\d+)$/)
  command = instr[1]
  amount = instr[2].to_i
  case command
  when 'N'
    pos_ns += amount
  when 'S'
    pos_ns -= amount
  when 'E'
    pos_ew += amount
  when 'W'
    pos_ew -= amount
  when 'R'
    heading += amount
  when 'L'
    heading -= amount
  when 'F'
    # first, clean up multiples of 360 and negatives
    heading = heading % 360
    # this is the difficult part :)
    # naive approach: assume this will always be a multiple of 90
    case heading
    when 0
      pos_ns += amount
    when 180
      pos_ns -= amount
    when 90
      pos_ew += amount
    when 270
      pos_ew -= amount
    end
  end
end

dist = pos_ns.abs + pos_ew.abs
pp dist
