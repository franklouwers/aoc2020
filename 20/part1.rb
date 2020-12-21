require 'set'

def get_edges(t)
  tile = t[1]
  edges = Set.new
  # we're also allowed to flip, so take the reverses into account as well
  edges << tile[0].join
  edges << tile[0].join.reverse # north
  edges << tile[-1].join
  edges << tile[-1].join.reverse # south
  # transpose them for east/west.
  tile_t = tile.transpose
  edges << tile_t[0].join
  edges << tile_t[0].join.reverse # west
  edges << tile_t[-1].join
  edges << tile_t[-1].join.reverse # east
  return edges
end

def count_unique_edges(tile, alltiles)
  mytile_id = tile[0]
  alledges = Set.new
  alltiles.each do |t|
    next if mytile_id == t[0]
    alledges += get_edges(t)
  end
  return get_edges(tile).map{|e| alledges.include? e}.count false
end




ff = File.open("input")

tiles = Hash.new

currenttile = Array.new
currenttilenr = nil
while line = ff.gets
  line.chomp!
  if line.size == 0
    # close previous one
    tiles[currenttilenr] = currenttile
    next
  end
  if m = line.match(/Tile (\d+):/)
    currenttilenr = m[1]
    currenttile = Array.new
    next
  end
  currenttile << line.split('')
end


# save the last one
tiles[currenttilenr] = currenttile

result = 1
tiles.each do |t|
  uniq = count_unique_edges(t, tiles)
  # the 4 corners have 4 (2 but flipped, so 4) unique edges.
  if uniq == 4
    puts "found a corner: #{t[0]}"
    result *= t[0].to_i
  end
end
pp result
