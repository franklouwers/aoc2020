require 'set'

#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)

highest = 0

entries.each do |pass|
  binpass = pass.gsub('F','0').gsub('B','1').gsub('R','1').gsub('L','0')
  row = binpass[0..6].to_i(2)
  col = binpass[7..9].to_i(2)
  seatid = row * 8 + col
  puts "code: #{pass}: row: #{row}, col: #{col}, seatid: #{seatid}"
  if seatid > highest
    highest = seatid
  end
end

puts "highest: #{highest}"

