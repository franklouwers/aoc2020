ff = File.open("input")
numbers = ff.readlines.map(&:to_i)
numbers.each do |x|
  candidates = numbers.select {|n| n < 2020-x}
  candidates.each do |y|
    last = candidates.select {|z| z == (2020 - x - y) }
    z = last.first
    next if not z
    puts "FOUND: x: #{x} - y: #{y} - z: #{z}"
    puts " test: x + y + z = #{x + y + z} (should be 2020)"
    puts " answer: #{x * y * x}"
    exit 0
  end
end
