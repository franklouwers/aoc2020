require 'set'

def how_many(adapters, input)
  count = 0
  case adapters.size
  when 0
    return 0
  when 1
    return 1
  else
    while adapters.size > 0
      # we can take input +1, +2 and +3. Search the lowest one
      try = adapters.first
      adapters.delete try
      toofar = false
      # we also need to check if the next object would have been able to connect directly
      newadapters = adapters.dup
      while not toofar and newadapters.size > 0
        if newadapters.first - input < 4
          count += how_many(newadapters, input)
          newadapters.delete newadapters.first
        else
          toofar = true
        end
      end
      input = try
    end
    count += 1
  end
  return count
end

ff = File.open("input")
#ff = File.open("sample-a2")

entries = ff.readlines.map{|l| l.chomp.to_i}
adapters = SortedSet.new(entries)

totalcount = how_many(adapters,0)
print "total combinations: #{totalcount}"
