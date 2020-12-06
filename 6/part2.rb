require 'set'

#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

ingroup = false
currentfields = Set.new
totalcounter = 0
len = entries.length

entries.each_with_index do |l, index|
  thisfields = Set.new
  # parse the line
  if l.size != 0
    l.split('').each do |c|
      thisfields << c
    end

    # Now take the common entries between this and the previous set, unless this is the first of the group
    if ingroup
      # not the first
      currentfields = currentfields & thisfields
    else
      # first entry of the group
      ingroup = true
      currentfields = thisfields
    end
  end

  # detect empty line or last line
  if (l.size == 0 or index+1 == len) and ingroup
    # empty line or last line, so previous ends here
    # Count what we have
    thisgroup = currentfields.size
    puts "This group had #{thisgroup} common answers"
    puts ""
    totalcounter += thisgroup

    ingroup = false
    currentfields = Set.new
  end

end

puts "total: #{totalcounter}"
