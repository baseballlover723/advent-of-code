require 'httparty'
require 'optparse'

def main(year, session)
  raise "Invalid year \"#{year}\"" if year[/\d\d\d\d/] != year
  raise "Missing session (get from chrome)" if session.nil?

  create_if_not_exists("./" + year)
  create_if_not_exists("./" + year + "/crystal")
  create_if_not_exists("./" + year + "/inputs")
  File.write("./" + year + "/inputs/.gitkeep", "") unless File.exist?("./" + year + "/inputs/.gitkeep")
  create_if_not_exists("./" + year + "/ruby")

  download_year_inputs(session, year, "./" + year + "/inputs/")
end

def create_if_not_exists(path)
  Dir.mkdir(path) unless Dir.exist?(path)
end

def download_year_inputs(session, year, dir)
  puts "Downloading inputs for Year #{year} -> #{dir}"
  (1..25).each do |day|
    download_day_input(session, year, day, dir)
  end
end

def download_day_input(session, year, day, dir)
  path = dir + "day" + day.to_s + "_input.txt"
  puts "Downloading input for Year #{year}, Day #{day} -> #{path}"
  resp = HTTParty.get("https://adventofcode.com/#{year}/day/#{day}/input", {cookies: {"session" => session}})
  File.write(path, resp.body)
end

main(ARGV[0], ARGV[1])
