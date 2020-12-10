ff = File.open("input")
#ff = File.open("sample-a")

adapters = Array.new([0]) + ff.readlines.map{|l| l.chomp.to_i}.sort
count_a = Array.new([1])

adapters.each_with_index do |a, idx|
  if idx < 4
    start = 0
  else
    start = idx - 4
  end
  (start..idx-1).each do |j|
    if a - adapters[j] < 4
      count_a[idx] = count_a[idx].to_i + count_a[j]
    end
  end
end

pp count_a.last
