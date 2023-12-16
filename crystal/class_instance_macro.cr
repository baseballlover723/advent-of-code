class_name = File.basename(ARGV[0], File.extname(ARGV[0])).capitalize
puts "#{class_name}.new"
