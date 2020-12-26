public_card = 6270530
public_door = 14540258

start_subject_card = 7
start_subject_door = 7

divider = 20201227

loop_card = 0
loop_door = 0
k = 1

while k != public_card
  loop_card += 1
  k *= start_subject_card
  k = k % divider
end
puts "loops card: #{loop_card}"

k = 1
while k != public_door
  loop_door += 1
  k *= start_subject_door
  k = k % divider
end

puts "loops door: #{loop_door}"

k = 1
loop_card.times do
  k *= public_door
  k = k % divider
end

puts "Encryption key: #{k}"

puts "Check, doing it the other way around:"
k = 1
loop_door.times do
  k *= public_card
  k = k % divider
end
puts "Encryption key: #{k}"



