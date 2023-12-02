def run(file_name)
  file_name = File.basename(file_name, File.extname(file_name))
  puts "solving \"#{file_name}\""
  input = File.read(file_name + "_input.txt").strip
  result = solve(input)
  puts "result"
  puts result.inspect
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
