require_relative "../../base"

def solve(arg)
  directories = Hash.new(0)
  lines = arg.split("\n")

  i = 1
  path = "/"
  while i < lines.size
    line = lines[i]
    # puts "line: #{line}, path: #{path}, directories: #{directories}"
    current_command = line[2..3]
    if current_command == "cd"
      new_dir = line.split(' ').last
      if new_dir == ".."
        # puts "cd #{new_dir}: \"#{path}\" -> \"#{File.dirname(path)}\""
        path = File.dirname(path)
      else
        # puts "cd #{new_dir}: \"#{path}\" -> \"#{File.join(path, new_dir)}\""
        path = File.join(path, new_dir)
      end
      i += 1
      next
    end
    # ls
    i += 1
    while i < lines.size && lines[i][0] != '$'
      result_line = lines[i]
      i += 1
      next if result_line.start_with?("dir")
      new_size = result_line.split(' ').first.to_i
      add_file!(directories, path, new_size)
    end
  end
  # puts "directories: #{directories}"

  full = 0
  directories.values.each do |count|
    full += count if count < 100_000
  end
  full
end

def add_file!(directories, path, new_size)
  # puts "adding #{new_size} to #{path}"
  while path != "/"
    directories[path] += new_size
    path = File.dirname(path)
  end
  directories[path] += new_size
end

return if __FILE__ != $0
# test_run("$ cd /
# $ ls
# dir a
# 14848514 b.txt
# 8504156 c.dat
# dir d
# $ cd a
# $ ls
# dir e
# 29116 f
# 2557 g
# 62596 h.lst
# $ cd e
# $ ls
# 584 i
# $ cd ..
# $ cd ..
# $ cd d
# $ ls
# 4060174 j
# 8033020 d.log
# 5626152 d.ext
# 7214296 k")
run(__FILE__)
