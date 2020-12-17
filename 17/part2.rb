def countactive(field)
  counter = 0
  field.values.each do |zyx|
    zyx.values.each do |yx|
      yx.values.each do |x|
        counter += x.values.count{|a| a == '#'}
      end
    end
  end
  return counter
end

def getnei(field,x,y,z,w)
  #puts "getnei for #{x} #{y} #{z}"
  nei = Array.new
  (x-1..x+1).each do |xx|
    (y-1..y+1).each do |yy|
      (z-1..z+1).each do |zz|
        (w-1..w+1).each do |ww|
          next if xx == x and yy == y and zz == z and ww == w # self
          a = field.dig(ww,zz,yy,xx)
          # puts "digging for #{xx} #{yy} #{zz} returned #{a}"
          if a
            nei << a
          else
            # not found, so inactive
            nei << '.'
          end
        end
      end
    end
  end
  return nei
end

def getrange_1(field)
  wr = field.keys.min-1..field.keys.max+1 # extend search range by 1 each side
  zr = field.values.first.keys.min-1..field.values.first.keys.max+1
  yr = field.values.first.values.first.keys.min-1..field.values.first.values.first.keys.max+1
  xr = field.values.first.values.first.keys.min-1..field.values.first.values.first.keys.max+1
  return [wr, zr, yr, xr]
end

def transform(field)
  newfield = deepcopy(field)
  (wr, zr, yr, xr) = getrange_1(field)
  wr.each do |w|
    wees = field.dig(w)
    if not wees
      newfield[w] = Hash.new
    end
    zr.each do |z|
      zees = field.dig(w,z)
      if not zees
        newfield[w][z] = Hash.new
      end
      yr.each do |y|
        yees = newfield.dig(w,z,y)
        if not yees
          newfield[w][z][y] = Hash.new
        end
        xr.each do |x|
          neis = getnei(field,x,y,z,w).count{|a| a=='#'}
          a = field.dig(w,z,y,x)
          if a == '#'
            # If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
            if neis == 2 or neis == 3
              # cube remains active
            else
              newfield[w][z][y][x] = '.' # becomes inactive
            end
          else
            # If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive
            if neis == 3
              newfield[w][z][y][x] = '#' # becomes active
            else
              newfield[w][z][y][x] = '.' # could have been nil
            end
          end
        end
      end
    end
  end
  return newfield
end

def deepcopy(obj)
  Marshal.load(Marshal.dump(obj))
end


ff = File.open('input')

z = 0
w = 0
field = Hash.new # we can have negative indexes

field[w] = Hash.new
field[w][z] = Hash.new

ff.readlines.each_with_index do |line,y|
  line.chomp!
  field[w][z][y] = Hash.new
  elements = line.split('')
  elements.each_with_index do |a,x|
    field[w][z][y][x] = a
  end
end


(1..6).each do |cycle|
  puts "Cycle #{cycle}"
  field = transform(field)
  pp countactive(field)
  puts
end
