ff = File.open("input")

mem = Array.new

mask = Array.new(36,0)

while line = ff.gets
  line = line.chomp
  if m = line.match(/^mask = ([10X]{36})$/)
    mask = m[1].split('').reverse # we store LSB first, makes it a tad easier later on
    next
  end

  if m = line.match(/^mem\[(\d+)\] = (\d+)$/)
    addr = m[1].to_i
    val = m[2].to_i.to_s(2).split('').reverse
    (val.size..35).each do |i|
      val[i] = 0
    end
    # apply the mask
    mask.each_with_index do |bit, idx|
      case bit
      when 'X'
        # nothing
      when '1'
        val[idx] = '1'
      when '0'
        val[idx] = '0'
      end
    end
    val = val.reverse.join.to_i(2)
    mem[addr] = val
  end
end

pp mem
pp mem.compact.sum

