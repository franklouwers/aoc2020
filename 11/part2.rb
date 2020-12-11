def search_around(row,col,r_factor,c_factor)
  i = 0
  loop do
    i += 1
    # out of bounds negative. OOB positive is handled by dig
    if (row + (i*r_factor)) < 0 or (col + (i*c_factor)) < 0
      return nil
    end

    if ['L','#',nil].include? $seats.dig(row + (i*r_factor), col + (i*c_factor))
      return $seats.dig(row + (i*r_factor), col + (i*c_factor))
    end

  end
end



def around(row,col)
  # calculate the 8 seats around pos col,row in the mapping
  # All decisions are based on the number of occupied seats adjacent to a given seat
  # (one of the eight positions immediately up, down, left, right, or diagonal from the seat)

  up = search_around(row,col,-1,0)
  down = search_around(row,col,1,0)
  left = search_around(row,col,0,-1)
  right = search_around(row,col,0,1)
  d_ul = search_around(row,col,-1,-1)
  d_ur = search_around(row,col,-1,1)
  d_dl = search_around(row,col,1,-1)
  d_dr = search_around(row,col,1,1)

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
        # If a seat is occupied (#) and five or more seats adjacent to it are also occupied, the seat becomes empty.
        if around(r_idx,s_idx).select{ |x| x == '#' }.size >= 5
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

