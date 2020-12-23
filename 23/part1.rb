class CircularArrayFixedSize < Array
  def [](index)
    return nil if empty?
    super(index % size)
  end

  def c_slice!(i, c)
    self.rotate!(i % size)
    ret = slice!(0, c)
    ret
  end

  def c_insert(pos, items)
    # items is going to be an array. Don't bother making this too generic
    #
    self.rotate!(pos)
    items.each_with_index do |item, idx|
      self.insert(idx, item)
    end
  end
end

input = '389125467' # sample
#input = '962713854' # input

$positions = CircularArrayFixedSize[input.split('').map(&:to_i)].flatten
counter = 10

$current_pos = 0

100.times do |i|
  currentlabel = $positions[$current_pos]
  targetlabel = currentlabel - 1 # target label = current cup's label - 1
  # grab next 3 items
  pickups = $positions.c_slice!($current_pos+1, 3) #

  while pickups.include? targetlabel or targetlabel < 1
    targetlabel -= 1
    targetlabel = 9 if targetlabel < 1
  end

  # place labels after destination, keeping order
  $positions.c_insert($positions.index(targetlabel) + 1, pickups)


  # new current cup: the cup which is immediately clockwise of the current cup.
  # This is NOT: $current_pos += 1, as we might have shifted already
  currentlabelpos = $positions.index(currentlabel)
  $current_pos = currentlabelpos + 1
end

pp $positions.first

