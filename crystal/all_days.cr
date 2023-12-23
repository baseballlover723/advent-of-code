require "benchmark"
require "option_parser"
require "json"
require "./base"

TIMES_PATH     = "./times_crystal.json"
SLOW_THRESHOLD = 0.100 # seconds

scripts = [] of Base

{{ run("./all_days_macro.cr") }}

options = {times: 5, slow: false, prefix: /^day/}
OptionParser.new do |opts|
  opts.banner = "Usage: all_days.cr --times=5 --include-slow"

  opts.on("-tTIMES", "--times=TIMES", "Run N number of times per script") do |numb|
    options = options.merge({times: numb.to_i})
  end

  opts.on("-s", "--slow", "Run slow files") do |bool|
    options = options.merge({slow: true})
  end

  opts.on("-o", "--only=str", "Only run files that start with the str") do |str|
    options = options.merge({prefix: /^day#{str}#{str[-1].ascii_letter? ? "" : "\\D"}/})
  end
end.parse

def main(scripts, times_path, times, include_slow, prefix)
  File.write(times_path, "{}") unless File.exists?(times_path)
  #  times_json = JSON.parse(File.read(times_path))
  times_json = Hash(String, Hash(String, NamedTuple(total_time: Float64, times: Int32, result: Int128))).from_json(File.read(times_path))

  puts "times: #{times}"
  opt_level = {{ flag?(:release) ? "release" : "normal" }}
  scripts.each do |script|
    human_file_name = script.name
    next unless human_file_name.starts_with?(prefix)
    #    human_file_name = File.basename(file_name, File.extname(file_name))
    times_json[human_file_name] = {} of String => NamedTuple(total_time: Float64, times: Int32, result: Int128) unless times_json.has_key?(human_file_name)
    if !include_slow && times_json[human_file_name].has_key?(opt_level) &&
       (times_json[human_file_name][opt_level]["total_time"] / times_json[human_file_name][opt_level]["times"]) > SLOW_THRESHOLD
      print_time(times_json, times_path, human_file_name, nil, nil, nil, false)
      next
    end
    input = File.read("../" + human_file_name[0..-2] + "_input.txt").strip
    result = uninitialized Int128
    time = Benchmark.realtime do
      times.times do |_|
        result = script.solve(input).to_i128
      end
    end.total_seconds
    print_time(times_json, times_path, human_file_name, time, times, result, true)
  end
end

def print_time(times_json, times_path, file_name, total_time, times, result, actually_ran)
  opt_level = {{ flag?(:release) ? "release" : "normal" }}
  if actually_ran && !total_time.nil? && !times.nil? && !result.nil?
    times_json[file_name][opt_level] = {total_time: total_time, times: times, result: result}
    File.write(times_path, times_json.to_pretty_json)
  else
    total_time, times, result = [:total_time, :times, :result].map { |arg| times_json[file_name][opt_level][arg] }
  end
  puts if file_name.ends_with?('a')
  puts "#{file_name} (#{opt_level.rjust(7)}): #{Base.to_human_duration(total_time / times)} => #{result}#{actually_ran ? "" : " (cached)"}"
end

main(scripts, TIMES_PATH, options[:times], options[:slow], options[:prefix])
