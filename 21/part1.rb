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

safelist = ingredients - aller_ingr.values.flatten.uniq
counter = 0
safelist.each do |i|
  counter += all_ingredients.flatten.flatten.count i
end

pp counter

