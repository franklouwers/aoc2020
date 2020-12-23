class Cup
  attr_accessor :label, :n, :p
  def initialize(label)
    @label = label
  end

  def inspect
    "Label #{@label}, next: #{n.label if n}"
  end

end

#input = '389125467' # sample
input = '962713854' # input
pos1 = nil

NCUPS = 1_000_000
all_cups = Array.new(NCUPS + 1) # silly, but makes it easier. Except for the first 10, label == index

NCUPS.times do |i|
  n = i+1
  all_cups[n] = Cup.new(n)
end

NCUPS.times do |i| # 2nd pass to connect the next links
  next if i == 0
  all_cups[i].n = all_cups[i+1]
end

# the first 10 are special
cups = input.split('').map(&:to_i)
cups.each_with_index do |val,i|
  next if i == cups.size - 1
  all_cups[val].n = all_cups[cups[i+1]] # eg: the next for 3 is (next-one after 3 in input array)
end

# now connect a few special ones...
all_cups[cups.last].n = all_cups[cups.size + 1] # the next one after the initial set, is the first one after the set

if NCUPS == cups.size # special
  all_cups[cups.last].n = all_cups[cups.first]
end

current = all_cups[cups.first] # the current one is the first one in the array
all_cups.last.n = current

10_000_000.times do |i|
  # print a line every million lines

  # grab 3 items
  p1 = current.n
  p2 = current.n.n
  p3 = current.n.n.n


  # connect current to p3.next
  current.n = p3.n

  currentlabel = current.label
  targetlabel = currentlabel - 1
  while p1.label == targetlabel or p2.label == targetlabel or p3.label == targetlabel or targetlabel == 0
    targetlabel -= 1
    targetlabel = NCUPS if targetlabel == 0
  end

  # we need to find the cup with label targetlabel
  destination = all_cups[targetlabel]


  p3.n = destination.n
  # add next for destination pointing to p1
  destination.n = p1
  current = current.n
end


#pp all_cups[1]
#pp all_cups[1].n
#pp all_cups[1].n.n


puts all_cups[1].n.label * all_cups[1].n.n.label
