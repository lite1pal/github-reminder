require "net/http"
require "json"
require "date"
require "time"

class GithubChecker
  def pushed_today?
    latest_push.to_date == Date.today
  end

  def latest_push
    Time.parse(latest_repo["pushed_at"])
  end

  def latest_repo
    uri = URI("https://api.github.com/user/repos?per_page=1&sort=pushed&direction=desc")

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{ENV.fetch("GITHUB_TOKEN")}"
    request["Accept"] = "application/vnd.github+json"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "GitHub API error: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body).first
  end
end