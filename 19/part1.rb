ff = File.open("input")

rules = Array.new
while ff.gets
  line = $_.chomp
  break if line.size == 0
  (rulenr, ruleline) = line.split(/: /)
  rules[rulenr.to_i] = ruleline.gsub(/\"/,'')
end
r0 = rules[0]
re = "^#{r0}$"

while true
  elements = re.scan /\d+/
  break if elements.size == 0 # if we don't have any numbers left, we've expanded enough
  elements.each do |e|
    re.gsub! /\b#{e}\b/, "(#{rules[e.to_i]})" # looks up e and replace by rule e, adding ('s to allow |s to do the right thing
  end
end

pp re.gsub!(" ",'') # remove spaces

# Now loop over all candidates
counter = 0
while ff.gets
  counter +=1 if $_.chomp.match /#{re}/
end
pp counter
