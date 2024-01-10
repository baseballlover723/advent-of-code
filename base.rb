require "benchmark"

def run(file_name)
  file_name = File.basename(file_name, File.extname(file_name))
  puts "solving \"#{file_name}\""
  input = File.read("../inputs/" + file_name[0..-2] + "_input.txt").strip
  result = nil
  time = Benchmark.realtime do
    result = solve(input)
  end
  puts "result"
  puts result.inspect
  puts "time taken: #{to_human_duration(time)}"
end

def to_human_duration(time)
  time *= 1_000
  ss, ms = time.divmod(1000)
  mm, ss = ss.divmod(60)
  hh, mm = mm.divmod(60)
  dd, hh = hh.divmod(24)
  str = ""
  str << "#{dd} days, " if dd > 0
  str << "#{hh} hours, " if hh > 0
  str << "#{mm} mins, " if mm > 0
  str << "#{ss} sec, " if ss > 0
  str << "#{ms.round(3)} ms, " if ms > 0
  str = str[0..-3]
  str.reverse.sub(" ,", " and ".reverse).reverse
end

def test_run(args)
  puts solve(args)
end

def solve(arg)
  raise "TO IMPLEMENT"
end
