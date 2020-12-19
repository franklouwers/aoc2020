ff = File.open("input")

rules = Array.new
while ff.gets
  line = $_.chomp
  break if line.size == 0
  (rulenr, ruleline) = line.split(/: /)
  rules[rulenr.to_i] = ruleline.gsub(/\"/,'')
end

# manually overriding rules. Not pretty, but they hint at it in the puzzle page
# "8: 42 | 42 8" means 1 or more times 42, so 42+
rules[8] = "42+" # "8: 42 | 42 8" means 1 or more times 42, so 42+

# "11: 42 31 | 42 11 31" so 42 31 or 42 42 31 31 or 42 42 42 31 31 31
# As per Ruby Regexp guide (and thank you rubular!):
# https://ruby-doc.org/core-2.7.2/Regexp.html#class-Regexp-label-Subexpression+Calls
rules[11] = '(?<eleven>42 \g<eleven>* 31)'


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
