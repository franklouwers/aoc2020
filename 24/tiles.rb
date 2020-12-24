# based on https://github.com/ideasasylum/hexgrid which is based on http://www.redblobgames.com/grids/hexagons/
class Point
  include Comparable

  attr_reader :q, :r, :s

  def initialize q, r, s = -q-r
    @q = q
    @r = r
    @s = s
    raise InvalidPointError unless valid?
  end

  def valid?
    @q + @r + @s == 0
  end

  def == other
    @q == other.q && @r == other.r && @s == other.s
  end
  alias :eql? :==

  def hash
    [@q, @r, @s].hash
  end

  def <=> other
    hash <=> other.hash
  end

  def + point
    Point.new(@q + point.q, @r + point.r, @s + point.s)
  end

  def - point
    Point.new(@q - point.q, @r - point.r, @s - point.s)
  end

  def * n
    Point.new(@q * n, @r * n, @s * n)
  end

  def length
    (@q.abs + @r.abs + @s.abs).to_f / 2.0
  end

  def distance point
    (self - point).length
  end

  EAST = Point.new(-1, 1, 0)
  WEST = Point.new(1, -1, 0)
  SOUTH_WEST = Point.new(0, -1, 1)
  SOUTH_EAST = Point.new(-1, 0, 1)
  NORTH_EAST = Point.new(0, 1, -1)
  NORTH_WEST = Point.new(1, 0, -1)

  VALID_DIRECTIONS = [
    Point::EAST,
    Point::SOUTH_EAST,
    Point::SOUTH_WEST,
    Point::WEST,
    Point::NORTH_WEST,
    Point::NORTH_EAST
  ]

  def neighbor direction
    raise InvalidDirectionError unless Point::VALID_DIRECTIONS.include? direction
    self + direction
  end
  alias :neighbour :neighbor

  def neighbors
    Point::VALID_DIRECTIONS.map { |direction| neighbor direction }
  end
  alias :neighbours :neighbors
end

class Tile
  attr_accessor :point, :grid
  attr_reader :color, :touched

  def initialize *args
    @color = 1 # white 1, black: -1
    if args.length == 1
      @point = args[0]
    elsif args.length > 1
      @point = Point.new *args
    end
  end

  def inspect
    "Tile at (" + @point.q.to_s + "," + @point.r.to_s + "," + @point.s.to_s + "). Color: " + @color.to_s + " - touched? #{'y' if touched}\n"
  end

  def flip
    @color *= -1
    @touched = true
  end
end

class Grid
  include Enumerable

  def initialize
    @tiles = {}
  end

  def add_tile tile
    @tiles[tile.point] = tile
    tile.grid = self
  end

  def << tile
    if tile.respond_to? :each
      tile.each { |t| add_tile t }
    else
      add_tile tile
    end
  end

  def [] point
    @tiles[point]
  end

  def each
    if block_given?
      @tiles.values.each { |tile| yield tile }
    end
  end

  def clone
    Marshal.load(Marshal.dump(self))
  end

end
