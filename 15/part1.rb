#sample sets + real set (last element)
sets = [[0,3,6], [1,3,2], [2,1,3], [1,2,3], [2,3,1], [3,2,1], [3,1,2], [19,20,14,0,9,1]]

sets.each do |s|
  spoken = s.reverse
  (spoken.size+1..2020).each do |count|
    if i_last = spoken[1..-1].index(spoken.first)
      age = i_last + 1 # +1 because our search above is off by 1
    else
      age = 0
    end
    spoken.prepend(age)
  end
  puts "set #{s.inspect}: #{spoken.first}"
end


