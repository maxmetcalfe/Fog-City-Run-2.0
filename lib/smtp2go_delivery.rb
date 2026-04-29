require 'httparty'

class Smtp2goDelivery
  include HTTParty
  base_uri 'https://api.smtp2go.com/v3'

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

    response = self.class.post('/email/send', body: payload.to_json, headers: { 'Content-Type' => 'application/json' })

    unless response.success? && response['data'] && response['data']['succeeded'] == mail.to.size
      raise "SMTP2GO delivery failed: #{response.body}"
    end
  end
end
