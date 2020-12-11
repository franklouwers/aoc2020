def around(row,col)
  # calculate the 8 seats around pos col,row in the mapping
  # All decisions are based on the number of occupied seats adjacent to a given seat
  # (one of the eight positions immediately up, down, left, right, or diagonal from the seat)

  up = $seats.dig(row-1, col)
  down = $seats.dig(row+1,col)
  left = $seats.dig(row,col-1)
  right = $seats.dig(row,col+1)
  d_ul = $seats.dig(row-1,col-1)
  d_ur = $seats.dig(row-1,col+1)
  d_dl = $seats.dig(row+1,col-1)
  d_dr = $seats.dig(row+1,col+1)

  if row == 0
    up = d_ul = d_ur = nil
  end
  if col == 0
    left = d_ul = d_dl = nil
  end
  return [up, down, left, right, d_ul, d_ur, d_dl, d_dr].compact
end

def pp_seats(seats)
  puts seats.map{|r| r.join}.join("\n")
  puts
  puts
end

def count_seats(seats)
   seats.collect{|r| r.count{|s| s == '#'}}.sum
end

class Array
  def dupdup
    map { |it| it.dup }
  end
end


ff = File.open("input")
#ff = File.open("sample")

$seats = ff.readlines.map{|l| l.chomp.split('')}
pp_seats $seats

changed = true
counter = 0


while changed
  changed = false
  newseats = $seats.dupdup
  $seats.each_with_index do |row, r_idx|
    row.each_with_index do |seat, s_idx|
      case seat
      when 'L'
        # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied
        if around(r_idx,s_idx).select{ |x| x == '#' }.size == 0
          changed = true
          newseats[r_idx][s_idx] = '#'
        end
      when '#'
        # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
        if around(r_idx,s_idx).select{ |x| x == '#' }.size >= 4
          changed = true
          newseats[r_idx][s_idx] = 'L'
        end
      end
    end
  end
  counter += 1
  puts "After round #{counter}:"
  pp_seats newseats
  puts
  $seats = newseats
end

puts ">> Done after round #{counter}!!"
puts count_seats($seats)

