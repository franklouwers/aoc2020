def parse(parts)
  stack = []
  currentstack = Array.new
  pp stack
  while $pos < parts.size
    part = parts[$pos]
    puts "my pos is #{$pos}. I will evaluate #{part}"
    $pos += 1
    pp part
    if part.match /^\d+/
      stack << part.to_i
    elsif part.match /[+*]/
      stack << part
    elsif part == '('
      puts "new section found"
      stack << parse(parts)
    elsif part == ')'
      # end of a section, return what we have
      puts "end section, calculating my stack (#{stack.inspect})"
      while stack.count('+') > 0
        # find first +
        i = stack.find_index('+')
        # perform i-1 + i+1
        pp stack
        stack[i] = stack[i-1] + stack[i+1]
        stack[i-1] = nil
        stack[i+1] = nil
        stack.compact!
        pp stack
      end
      res = 1
      opr = "*"
      stack.each do |e|
        if e.class == Integer
          case opr
          when '*'
            res = res * e
          end
        else
          opr = e
        end
      end
      puts "returning my sum of #{res}"
      return res
    end
  end
  return stack.first
end


ff = File.open("input")

sum = 0
while line = ff.gets
  $pos = 0
  line = "(" + line.chomp + ")"
  line = line.gsub(/\)/,' ) ').gsub(/\(/,' ( ')
  pp line
  result = parse(line.split)
  puts "result: #{result}"
  sum += result
end

puts "Endresult: #{sum}"




