require "./base"

class Day15b < Base
  def solve(arg)
    strs = parse_input(arg)
    # puts "strs: #{strs}"

    arr = Array.new(256) { { {} of String => Int32, [] of String } }
    strs.each do |label, focal_length|
      box = arr[hash(label)]
      if focal_length.nil?
        box[0].delete(label)
        box[1].delete(label)
      else
        box[1] << label if !box[0].has_key?(label)
        box[0][label] = focal_length
      end
      # puts "arr: #{arr[0..3]}"
    end

    sum = 0
    arr.each_with_index do |(labels, orderings), i|
      orderings.each_with_index do |label, j|
        sum += (i + 1) * (j + 1) * labels[label]
      end
    end

    sum
  end

  def hash(str)
    hash = 0
    str.each_char do |c|
      hash += c.ord
      hash *= 17
      hash %= 256
    end

    hash
  end

  def parse_input(input)
    input.split(',').map do |str|
      next {str[0..-2], nil} if str.ends_with?('-')
      split = str.split('=')
      {split[0], split[1].to_i}
    end
  end
end

stop_if_not_script(__FILE__)
# test_run("HASH")
# test_run("rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7")
run(__FILE__)
