year = File.basename(File.dirname(File.dirname(ARGV[0]))).capitalize
class_name = File.basename(ARGV[0], File.extname(ARGV[0])).capitalize
puts "Year#{year}::#{class_name}.new"
