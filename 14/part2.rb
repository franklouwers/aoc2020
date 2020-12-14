class Array
  def dupdup
    map { |it| it.dup }
  end
end

def get_addrs(addrs,orig, mask,pos)
  case mask[pos]
  when 'X'
    addrs.each do |a|
      a[pos] = '0'
    end
    # next, duplicate and set to 1
    newaddrs = addrs.dupdup
    newaddrs.each do |a|
      a[pos] = '1'
    end
    addrs = addrs + newaddrs
  when '1'
    addrs.each do |a|
      a[pos] = mask[pos]
    end
  when '0'
    addrs.each do |a|
      a[pos] = orig[pos]
    end
  end
  return addrs
end

ff = File.open("input")

mem = Hash.new

mask = Array.new(36,0)

while line = ff.gets
  line = line.chomp
  if m = line.match(/^mask = ([10X]{36})$/)
    mask = m[1].split('').reverse # we store LSB first, makes it a tad easier later on
    next
  end

  if m = line.match(/^mem\[(\d+)\] = (\d+)$/)
    addr = m[1].to_i.to_s(2).split('').reverse
    val = m[2].to_i
    (addr.size..35).each do |i|
      addr[i] = "0"
    end
    # apply the mask
    mask.each_with_index do |bit, idx|
      case bit
      when '1'
        addr[idx] = '1'
      when '0'
        # nothing
      when 'X'
        addr[idx] = 'X'
      end
    end
    # now, find the actual addresses to change
    addrs = Array.new
    addrs << [0]

    addr.each_with_index do |bit, idx|
      addrs = get_addrs(addrs,addr,mask,idx)
    end
    addrs.each do |a|
      puts "storing #{val} at #{a.reverse.join.to_i(2)}"
      mem[a.reverse.join.to_i(2)] = val
    end


  end
end

pp mem.values.sum


