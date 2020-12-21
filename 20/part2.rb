require 'set'

class Hash
  def deepcopy
    Marshal.load(Marshal.dump(self))
  end
end

def ppt
  ppt = Array.new
  i = 0

  $bitmap.each_with_index do |r,m|
    beginrow = i
    r.each do |id|
      t = $alltiles[id]
      t.each_with_index do |line,n|
        if not ppt[beginrow + n]
          ppt[beginrow + n] = ''
        end
        ppt[beginrow + n] += line.join
        i = beginrow + n + 1
      end
    end
  end
  return ppt
end

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
  return get_unique_edges(tile, alltiles).count
end

def get_unique_edges(tile, alltiles)
  mytile_id = tile[0]
  alledges = Set.new
  result = Array.new
  alltiles.each do |t|
    next if mytile_id == t[0]
    alledges += get_edges(t)
  end
  get_edges(tile).each do |e|
    if not alledges.include? e
      result << e
    end
  end
  return result
end

def remove_borders(id)
  $alltiles[id] = $alltiles[id][0..-2] # south
  $alltiles[id] = $alltiles[id][1..-1] # north
  $alltiles[id] = $alltiles[id].transpose[0..-2].transpose # east
  $alltiles[id] = $alltiles[id].transpose[1..-1].transpose # west
end

def position_nw(id)
  t = $tiles[id]
  u_edges = get_unique_edges([id,t], $alltiles)
  # position tile t at the top left: unique edges are north and west
  found = false
  while not found
    n = t[0].join
    w = t.transpose[0].join
    if u_edges.include? n and u_edges.include? w
      found = true
      $bitmap[0][0] = id
      $alltiles[id] = t
      break
    end
    # rotate the tile and try again
    t = t.transpose.reverse
  end
  $tiles.delete(id)
end


def position_north
  # find east edge of what we have
  edge_west = $alltiles[$bitmap[0][-1]].transpose[-1].join # this is edge_east of our last northern tile, this is the west of what we're looking for
  mytile = nil
  myid = nil
  $edges.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_west
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_east is on the west side and the north is unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    w = mytile.transpose[0].join
    if u_edges.include? n and w == edge_west
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      w = mytile.transpose[0].join
      if u_edges.include? n and w == edge_west
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[0] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $edges.delete(myid)
end

def position_south
  # find east edge of what we have
  mycol = $bitmap[-1].size
  edge_west  = $alltiles[$bitmap[-1][-1]].transpose[-1].join # this is edge_east of our last tile, this is the west of what we're looking for
  edge_north = $alltiles[$bitmap[-2][mycol]][-1].join # this is edge_south of our northern neighbour tile, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $edges.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_west
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_east is on the west side and the north is unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    s = mytile[-1].join
    w = mytile.transpose[0].join
    if u_edges.include? s and w == edge_west and n ==edge_north
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      s = mytile[-1].join
      w = mytile.transpose[0].join
      if u_edges.include? s and w == edge_west and n ==edge_north
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[-1] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $edges.delete(myid)
end

def position_middle
  # find east edge of what we have
  mycol = $bitmap[-1].size
  edge_west  = $alltiles[$bitmap[-1][-1]].transpose[-1].join # this is edge_east of our last northern tile, this is the west of what we're looking for
  edge_north = $alltiles[$bitmap[-2][mycol]][-1].join # this is edge_south of our northern neighbour tile, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $centers.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_west and get_edges([id,t]).include? edge_north
      # should be try to detect that edge and north are "possible"?
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_west is on the west side and the north is on the north
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    w = mytile.transpose[0].join
    if w == edge_west and n == edge_north
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      w = mytile.transpose[0].join
      if w == edge_west and n == edge_north
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[-1] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $centers.delete(myid)
end

def position_ne
  # find east edge of what we have
  edge_west = $alltiles[$bitmap[0][-1]].transpose[-1].join # this is edge_east of our last northern tile, this is the west of what we're looking for
  mytile = nil
  myid = nil
  $corners.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_west
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_east is on the west side and the north and east is unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    w = mytile.transpose[0].join
    e = mytile.transpose[-1].join
    if u_edges.include? n and u_edges.include? e and w == edge_west
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      w = mytile.transpose[0].join
      e = mytile.transpose[-1].join
      if u_edges.include? n and u_edges.include? e and w == edge_west
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[0] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $corners.delete(myid)
end

def position_sw
  # find south edge of what we have
  edge_north = $alltiles[$bitmap[-1][0]][-1].join # this is south_east of our line above, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $corners.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_north
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_north is on the north side and both the west and the south are unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    s = mytile[-1].join
    w = mytile.transpose[0].join
    if u_edges.include? w and u_edges.include? s and n == edge_north
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      s = mytile[-1].join
      w = mytile.transpose[0].join
      if u_edges.include? w and u_edges.include? s and n == edge_north
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[$bitmap.size] = [ myid ]
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $corners.delete(myid)
end

def position_se
  # we know which one we want, just need to make sure it fits, so do the entire logic without optimizing
  # find south edge of what we have
  edge_north = $alltiles[$bitmap[-2][-1]][-1].join # this is south_east of our line above, this is the north of what we're looking for
  edge_west  = $alltiles[$bitmap[-1][-1]].transpose[-1].join # this is south_east of our line above, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $corners.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_north
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_north is on the north side and both the east and the south are unique and the west side matches
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    s = mytile[-1].join
    w = mytile.transpose[0].join
    e = mytile.transpose[-1].join
    if u_edges.include? e and u_edges.include? s and n == edge_north and w == edge_west
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      s = mytile[-1].join
      w = mytile.transpose[0].join
      e = mytile.transpose[-1].join
      if u_edges.include? e and u_edges.include? s and n == edge_north and w == edge_west
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[-1] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $corners.delete(myid)
end

def position_west
  # find south edge of what we have
  edge_north = $alltiles[$bitmap[-1][0]][-1].join # this is south_east of our line above, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $edges.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_north
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_north is on the north side and the west is unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    w = mytile.transpose[0].join
    if u_edges.include? w and n == edge_north
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      w = mytile.transpose[0].join
      if u_edges.include? w and n == edge_north
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end

  $bitmap[$bitmap.size] = [ myid ]
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $edges.delete(myid)
end

def position_east
  # find south edge of what we have
  edge_north = $alltiles[$bitmap[-2][-1]][-1].join # this is south_east of our line above, this is the north of what we're looking for
  mytile = nil
  myid = nil
  $edges.each do |id|
    t = $tiles[id]
    if get_edges([id,t]).include? edge_north
      mytile = t
      myid = id
      break
    end
  end
  # now we need to position it so that edge_north is on the north side and the east is unique
  u_edges = get_unique_edges([myid,mytile], $alltiles)
  found = false
  4.times do
    n = mytile[0].join
    e = mytile.transpose[-1].join
    if u_edges.include? e and n == edge_north
      found = true
      break
    end
    # rotate the tile and try again
    mytile = mytile.transpose.reverse
  end

  if not found
    # if not found, we need to start flipping
    mytile = mytile.reverse
    4.times do
      n = mytile[0].join
      e = mytile.transpose[-1].join
      if u_edges.include? e and n == edge_north
        found = true
        break
      end
      # rotate the tile and try again
      mytile = mytile.transpose.reverse
    end
  end


  $bitmap[-1] << myid
  $alltiles[myid] = mytile

  $tiles.delete(myid)
  $edges.delete(myid)
end
#ff = File.open("sample")
ff = File.open("input")

$tiles = Hash.new

currenttile = Array.new
currenttilenr = nil
while line = ff.gets
  line.chomp!
  if line.size == 0
    # close previous one
    $tiles[currenttilenr] = currenttile
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
$tiles[currenttilenr] = currenttile

$corners = Array.new
$edges = Array.new
$centers = Array.new

rows = Math.sqrt($tiles.size).to_i
puts "we have a #{rows} x #{rows} squre"


$alltiles = $tiles.deepcopy

$tiles.each do |t|
  uniq = count_unique_edges(t, $tiles)
  # the 4 corners have 4 (2 but flipped, so 4) unique edges.
  # the edges have 2 ( 1 but flipped) unique
  # the rest has 0
  case uniq
  when 4
    $corners << t[0]
  when 2
    $edges << t[0]
  when 0
    $centers << t[0]
  else
    die "should not happen! #{t[0]} has #{uniq} unique edges"
  end
end

puts "Corners: #{$corners.count} - should be 4"
puts "Edges:   #{$edges.count} - should be #{(rows - 2)*4}"
puts "Middle:  #{$centers.count} - should be #{(rows-2) * (rows-2)}"

$bitmap = Array.new
$bitmap[0] = Array.new
# Take one of the corners as top left, and remove it from the set of corners
tl = $corners.pop
tl_tile = position_nw(tl)

# now that we have top left, fill the rest of the top row: from all "edges", find ROWS-2 number of edge blocks that DONE
(rows-2).times do |i|
# allign with the east col of tl DONE
  puts '>> positioning north'
  position_north
end


# then, find top right corner DONE
position_ne

(rows-2).times do
# find west block, find middle, find east. each time taking into account north as well
  # find the western boundery
  position_west
  (rows-2).times do
    position_middle
  end
  position_east
end

# then, find south west corner DONE
position_sw

# then south row, south-east corner
(rows-2).times do
# allign with the east col of tl DONE
  puts '>> positioning south'
  position_south
end

# there should be only one left. But verify nonetheless..
position_se

# Now, perform the stitching
#
# Remove ALL borders, not just the border-pairs!

$bitmap.each do |row|
  row.each do |t|
    remove_borders t
  end
end

field = ppt

# count current #'s
totalhashes = field.map{|r| r.count "#"}.sum

monster = [
  '..................#.',
  '#....##....##....###',
  '.#..#..#..#..#..#...'
] # this way, we can use them as regexps

monsterhashes = monster.map{|r| r.count "#"}.sum

numlines = field.size
monsters = 0

pos = 0
flipped = false

4.times do
  i = 0
  while i < numlines-2
    offset = 0
    monsterinline = false
    while startpos = field[i].index(/#{monster[0]}/,offset) # why while? because we could have multiple on 1 line
      r1 = /^.{#{startpos}}#{monster[1]}/
      r2 = /^.{#{startpos}}#{monster[2]}/
      if field[i+1].match r1 and field[i+2].match r2
        puts "BINGO - pos: #{pos} - flipped? {#flipped}"
        monsters += 1
        monsterinline = true
      end
      offset = startpos+1
    end
    if monsterinline
      i += 3
    else
      i += 1
    end
  end

  # rotate and try again
  field_new = Array.new
  field.each do |r|
    field_new << r.split('')
  end
  field_new = field_new.transpose.reverse
  field_new = field_new.map{|r| r.join}
  field = field_new

  pos = pos + 90
end

pos = 0
flipped = true

if not monsters > 0 # still not found, flip and same thing
  field = field.reverse
  4.times do
    i = 0
    while i < numlines-2
      offset = 0
      monsterinline = false
      while startpos = field[i].index(/#{monster[0]}/,offset) # why while? because we could have multiple on 1 line
        r1 = /^.{#{startpos}}#{monster[1]}/
        r2 = /^.{#{startpos}}#{monster[2]}/
        if field[i+1].match r1 and field[i+2].match r2
          puts "BINGO - pos: #{pos} - flipped? #{flipped} at line #{i}, startpos #{startpos}"
          monsters += 1
          monsterinline = true
        end
        offset = startpos+1
      end
      if monsterinline
        i += 1 # was +1
      else
        i += 1
      end
    end

    # rotate and try again
    field_new = Array.new
    field.each do |r|
      field_new << r.split('')
    end
    field_new = field_new.transpose.reverse
    field_new = field_new.map{|r| r.join}
    field = field_new
    pos = pos + 90
  end
end

result = totalhashes - monsters*monsterhashes
puts "total hashes:   #{totalhashes}"
puts "monsters found: #{monsters}"
puts "result:         #{result}"
