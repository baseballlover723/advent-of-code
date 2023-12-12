require "benchmark"
TIMES = 5

def main
  files = Dir["./day*.rb"].sort_by do |file_name|
    file_name[/\d+/].to_i
  end

  puts "TIMES: #{TIMES}"
  files.each do |file_name|
    require file_name
    file_name = File.basename(file_name, File.extname(file_name))
    input = File.read(file_name[0..-2] + "_input.txt").strip
    result = nil
    time = Benchmark.realtime do
      TIMES.times do |_|
        result = solve(input)
      end
    end
    puts "#{file_name}: #{to_human_duration(time / TIMES)} => #{result}"
    puts if file_name.end_with?("b")
  end
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

main
