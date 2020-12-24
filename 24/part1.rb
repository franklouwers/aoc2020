require 'strscan'
require './tiles.rb'

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

#grid.each do |k, v|
#  pp v
#end

pp grid.count{|pos,tile| tile.color == -1 } # need to figure out why i need t[1] here...
