require "benchmark"
require 'optparse'
require "json"

TIMES_PATH = "./times_ruby_#{RUBY_VERSION.gsub('.', '_')}.json"
SLOW_THRESHOLD = 0.100 # seconds

options = {times: 5, slow: false, prefix: /^day/}
OptionParser.new do |opts|
  opts.banner = "Usage: all_days.rb --times=5 --include-slow"

  opts.on("-tTIMES", "--times=TIMES", "Run N number of times per script") do |numb|
    options[:times] = numb.to_i
  end

  opts.on("-s", "--[no-]slow", "Run slow files") do |bool|
    options[:slow] = bool
  end

  opts.on("-o", "--only=str", "Only run files that start with the str") do |str|
    options[:prefix] = /^day#{str}#{str[-1].match(/\D/) ? "" : "\\D"}/
  end
end.parse!

def main(times_path, times, include_slow, prefix)
  files = Dir["./day*.rb"].sort_by do |file_name|
    [file_name[/\d+/].to_i, file_name]
  end

  File.write(times_path, "{}") unless File.exist?(times_path)
  times_json = JSON.parse(File.read(times_path))

  puts "ruby: #{RUBY_VERSION}, times: #{times}"
  total_time = 0
  total_files = 0
  files.each do |file_name|
    human_file_name = File.basename(file_name, File.extname(file_name))
    next unless human_file_name.start_with?(prefix)
    if !include_slow && times_json[human_file_name] && (times_json[human_file_name]["total_time"] / times_json[human_file_name]["times"]) > SLOW_THRESHOLD
      print_time(times_json, times_path, human_file_name, nil, nil, nil, false)
      total_files += 1
      total_time += times_json[human_file_name]["total_time"] / times_json[human_file_name]["times"]
      next
    end
    require file_name
    human_file_name = File.basename(file_name, File.extname(file_name))
    input = File.read(human_file_name[0..-2] + "_input.txt").strip
    result = nil
    GC.start
    GC.compact
    time = Benchmark.realtime do
      times.times do |_|
        result = solve(input)
      end
    end
    times_json = print_time(times_json, times_path, human_file_name, time, times, result, true)
    total_files += 1
    total_time += time / times
  end

  puts "Took an average of #{to_human_duration(total_time / total_files)} to run #{total_files} files (total_time: #{total_time})"
end

def print_time(times_json, times_path, file_name, total_time, times, result, actually_ran)
  if actually_ran
    times_json = JSON.parse(File.read(times_path))
    times_json[file_name] = {total_time: total_time, times: times, result: result}
    File.write(times_path, JSON.pretty_generate(times_json))
  else
    total_time, times, result = times_json[file_name].values_at("total_time", "times", "result")
  end
  puts if file_name.end_with?("a")
  puts "#{file_name} (ruby)   : #{to_human_duration(total_time / times)} => #{result}#{actually_ran ? "" : " (cached)"}"
  times_json
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

main(TIMES_PATH, options[:times], options[:slow], options[:prefix])
