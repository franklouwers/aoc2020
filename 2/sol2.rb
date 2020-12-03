ff = File.open("input")
entries = ff.readlines.map(&:chomp)
counter = 0
entries.each do |l|
  le = l.split
  a = le[0].split '-'
  p1 = a[0].to_i - 1
  p2 = a[1].to_i - 1 # base0
  char = le[1][0]
  pass = le[2]
  if (pass[p1] == char and pass[p2] != char) or
    (pass[p1] != char and pass[p2] == char)
    counter = counter + 1
  end

end

puts counter
