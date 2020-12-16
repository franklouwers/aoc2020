ff = File.open("input")

in_section = 'rules'
invalid_sum = 0

rules = Hash.new
myticket = Array.new

while line = ff.gets
  line = line.chomp
  case in_section
  when 'rules'
    if line.size == 0
      # end of rules
      in_section = 'myticket'
      next
    end
    valid_for_field = Array.new
    parts = line.split /:/
    field = parts[0]
    parts = parts[1].split(/^\s(\d+-\d+)/)
    parts.each do |p|
      if p.size > 0
        m = p.match(/(\d+-\d+)/)
        min_max = m[1].split(/-/).map(&:to_i)
        valid_for_field << min_max
      end
    end
    rules[field] = valid_for_field

  when 'myticket'
    next if line.match /your ticket:/
    if line.size == 0
      # end of my ticket
      in_section = 'nearby'
      next
    end
    my_ticket = line.split ','

  when 'nearby'
    next if line.match /nearby tickets:/

    valid_fields = Array.new
    line.split(/,/).each do |field|
      valid = false
      val = field.to_i
      rules.values.each do |rr|
        rr.each do |r|
          if val >= r[0] and val <= r[1]
            valid = true
          end
        end
      end
      valid_fields << valid
      if not valid
        invalid_sum += val
      end
    end
    puts "#{line}: #{not valid_fields.include? false}"
  end
end

puts invalid_sum
