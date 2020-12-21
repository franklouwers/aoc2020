require 'set'
filename = "input"
ff = File.open(filename).map(&:chomp)

aller_ingr = Hash.new
ingredients = Set.new
allergens = Set.new
all_ingredients = Array.new

ff.each do |line|
  parts = line.split(' (contains')
  ingr = parts[0].split
  all_ingredients += ingr
  aller = parts[1].split
  aller.each do |a|
    a = a.chomp(',')
    a = a.chomp(')')
    allergens << a
    if not aller_ingr[a]
      aller_ingr[a] = ingr
    else
      aller_ingr[a] &= ingr # intersection
    end
  end
end
ingredients = all_ingredients.to_set
pp allergens
pp ingredients
pp aller_ingr

while aller_ingr.values.any? {|i| i.size > 1 }
  matched = aller_ingr.values.select { _1.count == 1 }.flatten.to_set
  # we are sure of those.
  # for all others, remove those matched ingredients
  aller_ingr.values.select {|i| i.size > 1 }.each do |foods|
    foods.reject! {|x| matched.include? x}
  end
end
pp aller_ingr
aller_ingr = aller_ingr.sort_by { |key| key }.to_h
pp aller_ingr.values.join ','


