require 'net/http'
require 'json'

class Smtp2goDelivery
  API_ENDPOINT = 'https://api.smtp2go.com/v3/email/send'.freeze

  def initialize(options = {})
    @api_key = ENV['SMTP2GO_API_KEY']
  end

  def deliver!(mail)
    payload = {
      api_key: @api_key,
      to: mail.to,
      sender: mail.from.first,
      subject: mail.subject,
      text_body: mail.text_part&.body&.to_s,
      html_body: mail.html_part&.body&.to_s
    }.compact

    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = payload.to_json

    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      raise "SMTP2GO delivery failed: #{response.code} #{response.message}"
    end

    result = JSON.parse(response.body)
    unless result['data'] && result['data']['succeeded'].to_i >= mail.to.size
      raise "SMTP2GO delivery failed: #{response.body}"
    end
  end
end
