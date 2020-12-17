def ppf(field)
  field.sort.each do |z, yx|
    puts "z = #{z}"
    yx.each do |y, x|
      puts x.values.join ''
    end
    puts
  end
end

def countactive(field)
  counter = 0
  field.values.each do |yx|
    yx.values.each do |x|
      counter += x.values.count{|a| a == '#'}
    end
  end
  return counter
end

def getnei(field,x,y,z)
  #puts "getnei for #{x} #{y} #{z}"
  nei = Array.new
  (x-1..x+1).each do |xx|
    (y-1..y+1).each do |yy|
      (z-1..z+1).each do |zz|
        next if xx == x and yy == y and zz == z # self
        a = field.dig(zz,yy,xx)
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
  return nei
end

def getrange_1(field)
  zr = field.keys.min-1..field.keys.max+1 # extend search range by 1 each side
  yr = field.values.first.keys.min-1..field.values.first.keys.max+1
  xr = field.values.first.values.first.keys.min-1..field.values.first.values.first.keys.max+1
  return [zr, yr, xr]
end

def transform(field)
  newfield = deepcopy(field)
  (zr, yr, xr) = getrange_1(field)
  zr.each do |z| # need to evaluate the neighbours outside of the current field as well
    zees = field.dig(z)
    if not zees
      newfield[z] = Hash.new
    end
    yr.each do |y| # to_i makes nil-1 a 0-1
      yees = newfield.dig(z,y)
      if not yees
        newfield[z][y] = Hash.new
      end
      xr.each do |x|
        neis = getnei(field,x,y,z).count{|a| a=='#'}
        a = field.dig(z,y,x)
        if a == '#'
          # If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
          if neis == 2 or neis == 3
            # cube remains active
          else
            newfield[z][y][x] = '.' # becomes inactive
          end
        else
          # If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive
          if neis == 3
            newfield[z][y][x] = '#' # becomes active
          else
            newfield[z][y][x] = '.' # could have been nil
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
field = Hash.new # we can have negative indexes

field[z] = Hash.new

ff.readlines.each_with_index do |line,y|
  line.chomp!
  field[z][y] = Hash.new
  elements = line.split('')
  elements.each_with_index do |a,x|
    field[z][y][x] = a
  end
end
ppf field


(1..6).each do |cycle|
  puts "Cycle #{cycle}"
  field = transform(field)
  pp countactive(field)
  puts
end
