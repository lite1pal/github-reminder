require "sinatra"
require "net/http"
require "json"
require "pp"
require "dotenv/load"
require "date"

get "/status" do
  content_type :json
  
  uri = URI("https://api.github.com/user/repos?per_page=1&sort=pushed&direction=desc")
  request = Net::HTTP::Get.new(uri)
  request["Authorization"] = "Bearer #{ENV["GITHUB_TOKEN"]}"

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end
  
  repos = JSON.parse(response.body)
  
  latest_pushed_repo = repos.first
  
  last_push = DateTime.parse(latest_pushed_repo["pushed_at"])
  {
      pushed_today: last_push.to_date == Date.today,
      latest_repo_pushed: latest_pushed_repo["name"],
      pushed_at: last_push
    }.to_json
end