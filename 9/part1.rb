ff = File.open("input")
#ff = File.open("sample-a")
PRELEN = 25

#ff = File.open('input')
entries = ff.readlines.map(&:chomp)
code = entries

last_n = Array.new

code.each_with_index do |l, idx|
  l = l.to_i
  if idx < PRELEN
    last_n << l
    next
  end

  valid = false
  # take last_n array, calculate permutations, loop over them
  last_n.permutation(2).each do |pair|
    if l == pair[0] + pair[1]
      # l equals one of the pairs, so we found a match,
      valid = true
      break
    end
  end

  if not valid
    puts "number #{l} is not valid!"
    break
  end
  # number is valid: delete first element of last_n array, add this one at the end
  last_n.shift
  last_n << l
end
