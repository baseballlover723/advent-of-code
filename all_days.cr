require "benchmark"
require "option_parser"
require "json"
require "./base"

TIMES_PATH     = {{"./times_crystal_#{Crystal::VERSION.gsub(/\./, "_").id}.json"}}
SLOW_THRESHOLD = 0.100 # seconds

scripts = Hash(String, Array(Base)).new { |hsh, k| hsh[k] = [] of Base }

{{ run("./all_days_macro.cr") }}

options = {times: 5, slow: false, prefix: /^day/, year: nil}
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

  opts.on("-y", "--year=str", "Only run files for a specific year") do |str|
    options = options.merge({year: str})
  end
end.parse

def main(scripts, times_path, times, include_slow, prefix, year)
  puts "crystal: #{Crystal::VERSION}, times: #{times}"
  if prefix != /^day/ && year.nil?
    year = Dir.glob("*").select { |f| f.size == 4 && f.starts_with?("20") && File.directory?(f) }.min
    puts "saw \"--only\" but no year, so defaulting to the earliest year: #{year}"
  end
  if year
    run_year(scripts[year], times_path, times, include_slow, prefix, year)
  else
    years = Dir.glob("*").select { |f| f.size == 4 && f.starts_with?("20") && File.directory?(f) }
    years.each do |year|
      run_year(scripts[year], times_path, times, include_slow, prefix, year)
    end
  end
end

def run_year(scripts, times_path, times, include_slow, prefix, year)
  puts "\nyear #{year}"
  File.write(times_path, "{}") unless File.exists?(times_path)
  times_json = Hash(String, Hash(String, Hash(String, NamedTuple(total_time: Float64, times: Int32, result: Int128 | String)))).from_json(File.read(times_path))
  if !times_json.has_key?(year)
    times_json[year] = {} of String => Hash(String, NamedTuple(total_time: Float64, times: Int32, result: Int128 | String))
    File.write(times_path, times_json.to_pretty_json)
  end
  total_time = 0
  total_files = 0
  opt_level = {{ flag?(:release) ? "release" : "normal" }}
  scripts.each do |script|
    human_file_name = script.name
    next unless human_file_name.starts_with?(prefix)
    times_json[year][human_file_name] = {} of String => NamedTuple(total_time: Float64, times: Int32, result: Int128 | String) unless times_json[year].has_key?(human_file_name)
    if !include_slow && times_json[year][human_file_name].has_key?(opt_level) &&
       (times_json[year][human_file_name][opt_level]["total_time"] / times_json[year][human_file_name][opt_level]["times"]) > SLOW_THRESHOLD
      print_time(year, times_json, times_path, human_file_name, nil, nil, nil, false)
      total_files += 1
      total_time += times_json[year][human_file_name][opt_level]["total_time"] / times_json[year][human_file_name][opt_level]["times"]
      next
    end
    input = File.read(year + "/inputs/" + human_file_name[0..-2] + "_input.txt").strip
    result = uninitialized Int128 | String
    GC.collect
    time = Benchmark.realtime do
      times.times do |_|
        result = convert_result(script.solve(input))
      end
    end.total_seconds
    times_json = print_time(year, times_json, times_path, human_file_name, time, times, result, true)
    total_files += 1
    total_time += time / times
  end

  puts "Took an average of #{Base.to_human_duration(total_time / total_files)} to run #{total_files} files (total_time: #{total_time})"
end

def convert_result(result : String) : Int128 | String
  result
end

def convert_result(result) : Int128 | String
  result.to_i128
end

def print_time(year, times_json, times_path, file_name, total_time, times, result, actually_ran)
  opt_level = {{ flag?(:release) ? "release" : "normal" }}
  if actually_ran && !total_time.nil? && !times.nil? && !result.nil?
    times_json = Hash(String, Hash(String, Hash(String, NamedTuple(total_time: Float64, times: Int32, result: Int128 | String)))).from_json(File.read(times_path))
    times_json[year][file_name] = {} of String => NamedTuple(total_time: Float64, times: Int32, result: Int128 | String) unless times_json[year].has_key?(file_name)
    times_json[year][file_name][opt_level] = {total_time: total_time, times: times, result: result}
    File.write(times_path, times_json.to_pretty_json)
  else
    {% for arg in {:total_time, :times, :result} %}
      {{arg.id}} = times_json[year][file_name][opt_level][{{arg}}]
    {% end %}
  end
  puts if file_name.ends_with?('a')
  puts "#{file_name} (#{opt_level.rjust(7)}): #{Base.to_human_duration(total_time / times)} => #{result}#{actually_ran ? "" : " (cached)"}"
  times_json
end

main(scripts, TIMES_PATH, options[:times], options[:slow], options[:prefix], options[:year])
