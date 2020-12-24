require 'strscan'
require './tiles.rb'

$DEBUG=false

def walkExpand(grid)
  # this could be optimized: no need to walk the center
  grid.each do |tile|
    tile.point.neighbours.each do |nei|
      if not grid[nei]
        newtile = Tile.new(nei)
        puts "adding #{newtile.inspect}" if $DEBUG
        grid.add_tile newtile
      end
    end
  end
end

def processGrid(grid)
  newgrid = grid.clone
  grid.each do |tile|
    white, black = colorNei(grid,tile.point,newgrid)
    if tile.color == -1 # any black tile...
      # zero or more than 2 black tiles immediately adjecent is flipped to white
      if black == 0 or black > 2
        puts "flipping from black to white #{tile.inspect}" if $DEBUG
        newgrid[tile.point].flip
      end
    else
      # white tile
      # exactly 2 black tiles immediately adjacent to it is flipped to black.
      if black == 2
        puts "flipping from white to black #{tile.inspect}" if $DEBUG
        newgrid[tile.point].flip
      end
    end
  end
  return newgrid
end

def colorNei(grid, pos, newgrid)
  black = 0
  white = 0
  pos.neighbours.each do |nei|
    if grid[nei]
      black += 1 if grid[nei].color == -1
      white += 1 if grid[nei].color == 1
    end
  end
  return [white, black]
end


grid = Grid.new

# start at the center
refTile = Tile.new(0,0)
grid << refTile

flippers = File.open("input").readlines.map(&:chomp)

flippers.each do |instruction|
  current = refTile
  s = StringScanner.new(instruction)
  while not s.eos?
    c = s.peek(1)
    if c == 'w' or c == 'e'
      instr = s.getch
    else
      instr = s.getch
      instr += s.getch
    end
    # move in the correct direction
    case instr
    when 'e'
      dir = Point::EAST
    when 'se'
      dir = Point::SOUTH_EAST
    when 'sw'
      dir = Point::SOUTH_WEST
    when 'w'
      dir = Point::WEST
    when 'nw'
      dir = Point::NORTH_WEST
    when 'ne'
      dir = Point::NORTH_EAST
    end

    newtile = grid[current.point.neighbour(dir)]
    if not newtile
      newtile = Tile.new(current.point.neighbour(dir))
      grid.add_tile newtile
    end
    current = newtile
  end
  # at end of an instruction, so we flip
  current.flip
  puts "Flipped tile: #{current.inspect}"
end

grid.each do |tile|
  pp tile if $DEBUG
end

100.times do |i|
  day = i + 1
  print "Day #{day}: " if day % 10 == 0
  walkExpand(grid)
  grid = processGrid(grid)
  puts grid.count{|tile| tile.color == -1 } if day % 10 == 0
end
