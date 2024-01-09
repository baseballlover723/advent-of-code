Dir["./day*.cr"].sort_by { |file_name| {file_name[/\d+/].to_i, file_name} }.each do |file_name|
  puts "require \"#{file_name}\""
  class_name = File.basename(file_name, File.extname(file_name)).capitalize
  puts "scripts << #{class_name}.new"
end
