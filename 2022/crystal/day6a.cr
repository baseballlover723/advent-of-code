require "../../base"

class Year2022::Day6a < Base
  def solve(arg)
    find_marker(arg)
  end

  def find_marker(str)
    hash = {} of Char => UInt8
    str.each_char.with_index do |c, i|
      # puts "#{i}: #{c}, hash: #{hash}"
      if i >= 4
        last_c = str[i - 4]
        hash[last_c] -= 1_u8
        hash.delete(last_c) if hash[last_c] == 0_u8
      end
      if hash.has_key?(c)
        hash[c] += 1_u8
      else
        hash[c] = 1_u8
      end
      return i + 1 if hash.size == 4
    end
    -1
  end
end

stop_if_not_script(__FILE__)
# test_run("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
# test_run("bvwbjplbgvbhsrlpgdmjqwftvncz")
# test_run("nppdvjthqldpwncqszvftbrmjlhg")
# test_run("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
# test_run("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
run(__FILE__)
