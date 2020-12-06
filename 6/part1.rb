require 'set'

#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

ingroup = false
currentfields = Set.new
totalcounter = 0
len = entries.length

entries.each_with_index do |l, index|
  if not ingroup # new entry
    ingroup = true
    currentfields = Set.new
  end

  # parse the line
  l.split('').each do |c|
    currentfields << c
  end

  # detect empty line or last line
  if (l == "" or index+1 == len) and ingroup
    # empty line or last line, so previous ends here
    # Count what we have
    thisgroup = currentfields.size
    puts "This group had #{thisgroup} answers"
    totalcounter += thisgroup

    ingroup = false
    currentfields = Set.new
  end

end

puts "total: #{totalcounter}"
