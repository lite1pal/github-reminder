require "net/http"
require "dotenv/load"
require_relative "github_checker"

checker = GithubChecker.new

if checker.pushed_today?
  puts "Already pushed today."
  puts "Latest push: #{checker.latest_push}"
  exit
end

puts "No push today. Sending reminder..."

uri = URI(ENV.fetch("NTFY_URL"))

request = Net::HTTP::Post.new(uri, initheader = {'X-Email' => "dev@denistarasenko.com"})
request["Title"] = "GitHub reminder"
request.body = "You haven't pushed anything to GitHub today."

response = Net::HTTP.start(
  uri.hostname,
  uri.port,
  use_ssl: uri.scheme == "https"
) do |http|
  http.request(request)
end

raise "ntfy error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

puts "Reminder sent."