require 'set'

ff = File.open("input")
#ff = File.open("input-sample2")
entries = ff.readlines.map(&:chomp)

valid_ecl = Set['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']
required_fields = Set['byr','iyr','eyr','hgt','hcl','ecl','pid'] # ignore cid

inpass = false
currentpass_fields = Set.new

validcounter = 0
totalcounter = 0

len = entries.length

entries.each_with_index do |l, index|
  if not inpass # new entry
    inpass = true
  end

  # parse the line
  l.split.each do |le|
    valid = false
    key, value = le.split(":")
    case key
    when 'byr'
      if value.to_i >= 1920 and value.to_i <= 2002
        valid = true
      end
    when 'iyr'
      if value.to_i >= 2010 and value.to_i <= 2020
        valid = true
      end
    when 'eyr'
      if value.to_i >= 2020 and value.to_i <= 2030
        valid = true
      end
    when 'hgt'
      if m = value.match(/^(\d+)cm$/)
        if m[1].to_i >= 150 and m[1].to_i <= 193
          valid = true
        end
      elsif m = value.match(/^(\d+)in$/)
        if m[1].to_i >= 59 and m[1].to_i <= 76
          valid = true
        end
      end
    when 'hcl'
      if value.match(/^#([0-9a-f]){6}$/)
        valid = true
      end
    when 'ecl'
      if valid_ecl.include? value
        valid = true
      end
    when 'pid'
      if value.match(/^\d{9}$/)
        valid = true
      end
    end

    if valid
      currentpass_fields << key
    end
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
