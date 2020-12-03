ff = File.open("input")
entries = ff.readlines.map(&:chomp)

map = Array.new
cols = 0

# assume fix rows!
entries.each do |l|
  row = l.split ''
  map << row
  cols = row.size
end

rows = map.size

pp map
print map[3][6] # opgelet, x en y omgewisseld
pp rows
pp cols

cur_row = 0
cur_col = 0

trees = 0
pp cur_row
pp cur_col

while cur_row < rows
  what = map[cur_row][cur_col]
  puts "now at position row: #{cur_row} col: #{cur_col} where I see: #{what}"
  if what == '#'
    trees += 1
  end
  # move: right +3, down +1
  cur_col += 3
  cur_row += 1
  if cur_col >= cols
    cur_col = cur_col - cols # repeats
  end
end

puts "trees: #{trees}"
