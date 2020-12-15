#sample sets + real set (last element)
#sets = [[0,3,6], [1,3,2], [2,1,3], [1,2,3], [2,3,1], [3,2,1], [3,1,2], [19,20,14,0,9,1]]
sets = [[19,20,14,0,9,1]]


# so for a very large number of rounds, the naive approach from part 1 won't work.
# instead of keeping track of everything, we just store the most recent occurence
# of the number

sets.each do |s|
  round = 0
  seen = Array.new
  last = 0
  s.each do |e|
    round += 1
    seen[e] = round
    last = e
  end

  while round < 30000000
    round += 1
    # check last number and see if we've seen it before
    lastseen = seen[last]
    if lastseen
      age = (round -1) - lastseen
    else
      age = 0
    end
    seen[last] = round - 1
    last = age
  end
  puts "set #{s.inspect}: #{last}"
end


