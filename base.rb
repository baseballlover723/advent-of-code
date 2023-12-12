require "benchmark"

def run(file_name)
  file_name = File.basename(file_name, File.extname(file_name))
  puts "solving \"#{file_name}\""
  input = File.read(file_name[0..-2] + "_input.txt").strip
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

def parse_input_into_map(arg)
  arg.split("\n")
  # arg.split("\n").each do |input|
  #   input.strip!
  #   # puts "input: #{input}"
  #   if input.start_with?(">")
  #     # puts "nameline"
  #     new_name = input[1..-1]
  #     if name != ''
  #       dnas[name] = dna
  #     end
  #     name = new_name
  #     dna = ""
  #   else
  #     dna += input.strip
  #   end
  # end
  # dnas[name] = dna
  # # puts "dnas: #{dnas}"
  #
  # dnas
end

def parse_input_into_array(arg)
  arg.split("\n")
  # dnas = []
  # dna = ""
  # arg.split("\n").each do |input|
  #   input.strip!
  #   if input.start_with?(">")
  #     dnas << dna unless dna.empty?
  #     dna = ""
  #   else
  #     dna += input.strip
  #   end
  # end
  # dnas << dna
  # # puts "dnas: #{dnas}"
  # dnas
end

def test_run(args)
  puts solve(args)
end

def solve(args)
  raise "TO IMPLEMENT"
end
