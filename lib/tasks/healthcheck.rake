require "net/http"
require "uri"

# healthcheck
task :healthcheck do
  uri = URI.parse("https://www.fogcityrun.com")

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(uri.request_uri)
  res = http.request(request)

  if res.code.to_i == 200
    puts "Healthcheck okay."
    Net::HTTP.get(URI.parse("https://hc-ping.com/594f737b-5446-49c4-a36a-fa030298abe8"))
  else
    puts "Healthceck failed."
    Net::HTTP.get(URI.parse("https://hc-ping.com/594f737b-5446-49c4-a36a-fa030298abe8/fail"))
  end
end
