ff = File.open("input")
#ff = File.open("sample-a")
PRELEN = 25

#ff = File.open('input')
entries = ff.readlines.map{|l| l.chomp.to_i}
code = entries

last_n = Array.new

target = 0

code.each_with_index do |l, idx|
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
    target = l
    break
  end
  # number is valid: delete first element of last_n array, add this one at the end
  last_n.shift
  last_n << l
end

# now that we've found the target, loop over the code again, adding up the numbers till we hit target

code.each_with_index do |l, idx|
  candidate = Array(l)
  i = idx
  while candidate.inject(0, :+) < target
    i += 1
    candidate << code[i]
  end
  if candidate.inject(0, :+) == target
    puts "bingo! Set found: "
    pp candidate
    puts "Smallest: #{candidate.min} - Largetst: #{candidate.max} - sum: #{candidate.min + candidate.max}"
    exit
  end
end
