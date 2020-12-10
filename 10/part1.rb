require 'set'

ff = File.open("input")
#ff = File.open("sample-a2")

entries = ff.readlines.map{|l| l.chomp.to_i}
adapters = SortedSet.new(entries)

input = 0
diff_1 = 0
diff_2 = 0
diff_3 = 0

while adapters.size > 0
  # we can take input +1, +2 and +3. Search the lowest one
  try = adapters.first
  adapters.delete try
  case try - input
  when 0
    puts "Duplicate?! shouldn't happen"
    exit
  when 1
    diff_1 += 1
  when 2
    diff_2 += 1
  when 3
    diff_3 += 1
  else
    puts 'too big of a difference, done playing'
    break
  end
  input = try
end


pp diff_1
pp diff_2
pp diff_3 + 1 # the jump to the device must be counted and is always 3

pp (diff_1 * (diff_3 + 1))


# input is 0, so can take 1, 2, 3
