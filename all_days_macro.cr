Dir["./*/crystal/day*.cr"].sort_by { |file_name| {File.basename(file_name)[/\d+/].to_i, File.basename(file_name)} }.each do |file_name|
  puts "require \"#{file_name}\""
  year = File.basename(File.dirname(File.dirname(file_name))).capitalize
  class_name = File.basename(file_name, File.extname(file_name)).capitalize
  puts "scripts[\"#{year}\"] << Year#{year}::#{class_name}.new"
end
