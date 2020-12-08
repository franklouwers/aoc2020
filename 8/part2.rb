require 'set'

def run(code)
  stop = false
  loopje = false
  len = code.size
  acc = 0
  pos = 0
  visited = Set.new

  while not stop
    # have we visited this line before?
    if visited.include? pos
      stop = true
      loopje = true
      puts "loop detected: already visited position #{pos}"
      break
    end

    # add pos to visited set
    visited << pos
    instruction, arg = code[pos].split
    arg = arg.to_i
    case instruction
    when 'nop'
      pos += 1
    when 'acc'
      pos += 1
      acc += arg
    when 'jmp'
      pos += arg
    end
    if pos == len
      # new pos is just after bootloader: bingo
      stop = true
    end
  end
  return [loopje, acc]
end


#ff = File.open("sample-a")
ff = File.open('input')
entries = ff.readlines.map(&:chomp)
code = entries

code.each_with_index do |l, idx|
  instruction, arg = l.split

  case instruction
  when 'acc'
    next
  when 'jmp'
    mycode = code.dup
    mycode[idx] = "nop 0"
  when 'nop'
    mycode = code.dup
    mycode[idx] = "jmp #{arg}"
  end
  loopje, acc = run(mycode)
  if loopje == false
    puts "found a solution! Line changed was line #{idx+1} (#{l}). Acc: #{acc}"
    break
  end
end
