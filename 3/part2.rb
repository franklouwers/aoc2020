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

product = 1


instructions = [[1,1],[3,1],[5,1],[7,1],[1,2]]

instructions.each do |i|
  right = i[0] # number of moves right
  down = i[1] # number of moves down

  cur_row = 0
  cur_col = 0

  trees = 0
## pp cur_row
## pp cur_col

  while cur_row < rows
    what = map[cur_row][cur_col]
##    puts "now at position row: #{cur_row} col: #{cur_col} where I see: #{what}"
    if what == '#'
      trees += 1
    end
    # move: right +right, down +down
    cur_col += right
    cur_row += down
    if cur_col >= cols
      cur_col = cur_col - cols # repeats
    end
  end

  puts "trees: #{trees}"
  product *= trees
end

puts "product: #{product}"
