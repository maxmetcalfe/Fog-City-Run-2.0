require 'net/http'
require 'json'

class Smtp2goDelivery
  API_ENDPOINT = 'https://api.smtp2go.com/v3/email/send'.freeze

  def initialize(options = {})
    @api_key = ENV['SMTP2GO_API_KEY']
  end

  def deliver!(mail)
    payload = build_payload(mail)
    Rails.logger.info "[SMTP2GO] Sending email with payload: #{payload.to_json}"
    
    uri = URI(API_ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = payload.to_json

    response = http.request(request)

    Rails.logger.info "[SMTP2GO] Response: #{response.code} #{response.message} - #{response.body}"

    unless response.is_a?(Net::HTTPSuccess)
      raise "SMTP2GO delivery failed: #{response.code} #{response.message} - #{response.body}"
    end

    result = JSON.parse(response.body)
    unless result['data'] && result['data']['succeeded'].to_i > 0
      raise "SMTP2GO delivery failed: #{response.body}"
    end
  end

  private

  def build_payload(mail)
    {
      api_key: @api_key,
      to: mail.to.map(&:to_s),
      from: mail.from.first.to_s,
      subject: mail.subject.to_s,
      text_body: extract_text_body(mail),
      html_body: extract_html_body(mail)
    }.compact
  end

  def extract_text_body(mail)
    if mail.multipart?
      text_part = mail.parts.find { |p| p.content_type.match?(/text\/plain/) }
      text_part ? text_part.body.to_s : nil
    else
      mail.content_type.match?(/text\/plain/) ? mail.body.to_s : nil
    end
  end

  def extract_html_body(mail)
    if mail.multipart?
      html_part = mail.parts.find { |p| p.content_type.match?(/text\/html/) }
      html_part ? html_part.body.to_s : nil
    else
      mail.content_type.match?(/text\/html/) ? mail.body.to_s : nil
    end
  end
end
