require "benchmark"

abstract class Base
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
    puts "time taken: #{Base.to_human_duration(time)}"
  end

  def name
    self.class.to_s[(self.class.to_s.index(':').not_nil! + 2)..-1].downcase
  end

  def self.to_human_duration(time : Time::Span)
    Base.to_human_duration(time.total_seconds)
  end

  def self.to_human_duration(time)
    time *= 1_000
    ss, ms = time.divmod(1000)
    mm, ss = ss.divmod(60)
    hh, mm = mm.divmod(60)
    dd, hh = hh.divmod(24)
    str = ""
    str += "#{dd} days, " if dd > 0
    str += "#{hh} hours, " if hh > 0
    str += "#{mm} mins, " if mm > 0
    str += "#{ss} sec, " if ss > 0
    str += "#{ms.round(3)} ms, " if ms > 0
    str = str[0..-3]
    str.reverse.sub(" ,", " and ".reverse).reverse
  end

  def test_run(args)
    puts solve(args)
  end

  abstract def solve(arg)
end

macro stop_if_not_script(file_name)
  {% skip_file unless parse_type("OptionParser").resolve?.nil? %}

  INSTANCE = {{ run("./class_instance_macro.cr", file_name) }}
  def test_run(arg)
    INSTANCE.test_run(arg)
  end

  def run(arg)
    INSTANCE.run(arg)
  end
end
