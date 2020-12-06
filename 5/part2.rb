require 'set'

#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)
seats = SortedSet.new

entries.each do |pass|
  binpass = pass.gsub('F','0').gsub('B','1').gsub('R','1').gsub('L','0')
  row = binpass[0..6].to_i(2)
  col = binpass[7..9].to_i(2)
  seatid = row * 8 + col
  seats << seatid
end

# Loop over seats to try to find the empty ones?

seats.each do |s|
  if s < 2
    next # not the first seat
  end
  # check if s-2 exists but s-1 doesnt
  if seats.member? s-2 and not seats.member? s-1
    puts "seat #{s-2} exists, seat #{s} exists, but seat #{s-1} doesn't"
    puts "My seat: #{s-1}"
    break
  end
end
