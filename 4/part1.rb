require 'set'

#ff = File.open("input-sample")
ff = File.open("input")
entries = ff.readlines.map(&:chomp)

required_fields = Set['byr','iyr','eyr','eyr','hgt','hcl','ecl','pid'] # ignore cid

inpass = false
currentpass_fields = Set.new
validcounter = 0
totalcounter = 0

len = entries.length

entries.each_with_index do |l, index|
  if not inpass # new entry
    inpass = true
    currentpass = Set.new
  end

  # parse the line
  l.split.each do |le|
    values = le.split(":")
    currentpass_fields << values[0]
  end

  # detect empty line or last line
  if (l == "" or index+1 == len) and inpass
    # empty line or last line, so previous ends here
    # Validate what we have
    if currentpass_fields.superset? required_fields
      # all fields found, valid
      validcounter += 1
    end

    inpass = false
    currentpass_fields = Set.new
    totalcounter += 1
    next
  end

end

puts "total: #{totalcounter}"
puts "valid: #{validcounter}"
