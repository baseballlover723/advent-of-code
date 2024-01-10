require_relative "../../base"

def solve(arg)
  find_marker(arg)
end

def find_marker(str)
  hash = {}
  str.each_char.with_index do |c, i|
    # puts "#{i}: #{c}, hash: #{hash}"
    if i >= 4
      last_c = str[i - 4]
      hash[last_c] -= 1
      hash.delete(last_c) if hash[last_c] == 0
    end
    if hash[c]
      hash[c] += 1
    else
      hash[c] = 1
    end
    return i + 1 if hash.size == 4
  end
end

return if __FILE__ != $0
# test_run("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
# test_run("bvwbjplbgvbhsrlpgdmjqwftvncz")
# test_run("nppdvjthqldpwncqszvftbrmjlhg")
# test_run("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
# test_run("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
run(__FILE__)
