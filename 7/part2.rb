require 'set'

def search(target)
  total = 1 # don't forget to count the bag itself
  $rules[target].each do |type, amount|
    total += amount.to_i * search(type)
  end
  return total
end

#ff = File.open("sample-b")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

$rules = Hash.new

entries.each do |rule|
  words = rule.split
  type = "#{words[0]} #{words[1]}"
  children = Hash.new
  evalset = words[4..]
  while evalset.size > 0
    if evalset.join(" ") == "no other bags."
      evalset = Array.new
    else
      children["#{evalset[1]} #{evalset[2]}"] = evalset[0]
      evalset = evalset[4..]
    end
  end
  $rules[type] = children
end

# now find al the shiny things
target = "shiny gold"

pp search(target) - 1 # we count one too many: we don't need to count the shiny gold bag itself.
