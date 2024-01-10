require "benchmark"
require 'optparse'
require "json"

TIMES_PATH = "./times_ruby_#{RUBY_VERSION.gsub('.', '_')}.json"
SLOW_THRESHOLD = 0.100 # seconds

options = {times: 5, slow: false, prefix: /^day/, year: nil}
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

  opts.on("-y", "--year=str", "Only run files for a specific year") do |str|
    options[:year] = str
  end
end.parse!

def main(times_path, times, include_slow, prefix, year)
  puts "ruby: #{RUBY_VERSION}, times: #{times}"
  if prefix != /^day/ && year.nil?
    year = Dir.glob("*").select { |f| f.size == 4 && f.start_with?("20") && File.directory?(f) }.min
    puts "saw \"--only\" but no year, so defaulting to the earliest year: #{year}"
  end
  if year
    run_year(times_path, times, include_slow, prefix, year)
  else
    years = Dir.glob('*').select { |f| f.size == 4 && f.start_with?("20") && File.directory?(f) }
    years.each do |year|
      run_year(times_path, times, include_slow, prefix, year)
    end
  end
end

def run_year(times_path, times, include_slow, prefix, year)
  puts "\nyear #{year}"
  files = Dir["./#{year}/ruby/day*.rb"].sort_by do |file_name|
    [File.basename(file_name)[/\d+/].to_i, File.basename(file_name)]
  end

  File.write(times_path, "{}") unless File.exist?(times_path)
  times_json = JSON.parse(File.read(times_path))
  if !times_json[year]
    times_json[year] = {}
    File.write(times_path, JSON.pretty_generate(times_json))
  end
  total_time = 0
  total_files = 0
  files.each do |file_name|
    human_file_name = File.basename(file_name, File.extname(file_name))
    next unless human_file_name.start_with?(prefix)
    if !include_slow && times_json[year][human_file_name] && (times_json[year][human_file_name]["total_time"] / times_json[year][human_file_name]["times"]) > SLOW_THRESHOLD
      print_time(year, times_json, times_path, human_file_name, nil, nil, nil, false)
      total_files += 1
      total_time += times_json[year][human_file_name]["total_time"] / times_json[year][human_file_name]["times"]
      next
    end
    require file_name
    human_file_name = File.basename(file_name, File.extname(file_name))
    input = File.read(year + "/inputs/" + human_file_name[0..-2] + "_input.txt").strip
    result = nil
    GC.start
    GC.compact
    time = Benchmark.realtime do
      times.times do |_|
        result = solve(input)
      end
    end
    times_json = print_time(year, times_json, times_path, human_file_name, time, times, result, true)
    total_files += 1
    total_time += time / times
  end

  puts "Took an average of #{to_human_duration(total_time / total_files)} to run #{total_files} files (total_time: #{total_time})"
end

def print_time(year, times_json, times_path, file_name, total_time, times, result, actually_ran)
  if actually_ran
    times_json = JSON.parse(File.read(times_path))
    times_json[year][file_name] = {total_time: total_time, times: times, result: result}
    File.write(times_path, JSON.pretty_generate(times_json))
  else
    total_time, times, result = times_json[year][file_name].values_at("total_time", "times", "result")
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

main(TIMES_PATH, options[:times], options[:slow], options[:prefix], options[:year])
