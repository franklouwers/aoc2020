require 'set'
ff = File.open("input")

in_section = 'rules'
invalid_sum = 0

rules = Hash.new
my_ticket = Array.new
tickets = Array.new

field_candidates = Array.new
num_rules = 0

while line = ff.gets
  line = line.chomp
  case in_section
  when 'rules'
    if line.size == 0
      num_rules = rules.size
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
    line_elements = line.split(/,/)
    line_elements.each_with_index do |field|
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
    end
    if not valid_fields.include?(false)
      tickets << line_elements # valid ticket, keep it
    end
  end
end

tickets.each do |t|
  t.each_with_index do |field,field_idx|
    val = field.to_i
    field_valid = false
    rules.values.each_with_index do |rr,rule_idx|
      valid = false
      rr.each do |r|
        if not field_candidates[field_idx]
          field_candidates[field_idx] = (0..num_rules-1).to_set
        end
        if val >= r[0] and val <= r[1]
          valid = true
          field_valid = true
        else
        end
      end
      field_candidates[field_idx].delete rule_idx if not valid
    end
  end
end

# now id the candidates with only 1 possible field and remove those from others
not_done = true
while not_done
  field_candidates.each_with_index do |e,idx|
    if e.count == 1
      (0..idx-1).each do |field|
        field_candidates[field].delete e.first
      end
      (idx+1..field_candidates.size-1).each do |field|
        field_candidates[field].delete e.first
      end
    end
  end
  # are we done?
  not_done = field_candidates.map{|f| f.count == 1}.include? false
end

result = 1
field_candidates.each_with_index do |f, idx|
  next if not rules.keys[f.first].match /^departure /
  puts rules.keys[f.first] + ": " + my_ticket[idx]
  result *= my_ticket[idx].to_i
end

pp result
