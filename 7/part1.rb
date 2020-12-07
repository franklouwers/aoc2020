require 'set'

#ff = File.open("sample")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

rules = Hash.new

entries.each do |rule|
  words = rule.split
  type = "#{words[0]} #{words[1]}"
  children = Array.new
  evalset = words[4..]
  while evalset.size > 0
    if evalset.join(" ") == "no other bags."
      evalset = Array.new
    else
      children << "#{evalset[1]} #{evalset[2]}"
      evalset = evalset[4..]
    end
  end
  rules[type] = children
end
pp rules

# now find al the shiny things
answer = Set.new
searchset = Set.new
searchset << "shiny gold"

while searchset.size > 0
  target = searchset.first
  searchset.delete target
  pp target
  rules.filter {|k,v| v.include? target }.keys.each do |k|
    searchset << k
    answer << k
  end
end
pp answer.size
