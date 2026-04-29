require 'net/http'
require 'json'

class Smtp2goDelivery
  API_ENDPOINT = 'https://api.smtp2go.com/v3/email/send'.freeze
  DEFAULT_FROM = 'nitemovessb@gmail.com'.freeze

  def initialize(options = {})
    @api_key = ENV['SMTP2GO_API_KEY']
  end

  def deliver!(mail)
    payload = build_payload(mail)
    Rails.logger.info "[SMTP2GO] Sending email with payload: #{payload.compact.to_json}"
    
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
    from_address = extract_from(mail)
    
    {
      api_key: @api_key,
      to: mail.to.map(&:to_s),
      sender: from_address,
      subject: mail.subject.to_s,
      text_body: extract_text_body(mail),
      html_body: extract_html_body(mail)
    }.compact
  end

  def extract_from(mail)
    # Try multiple ways to get the from address
    if mail.from && mail.from.first && !mail.from.first.empty?
      return mail.from.first.to_s
    end
    
    # Try the From header directly
    if mail['From'] && mail['From'].value
      return mail['From'].value.to_s
    end
    
    # Try from_addrs
    if mail.respond_to?(:from_addrs) && mail.from_addrs && mail.from_addrs.first
      return mail.from_addrs.first.to_s
    end
    
    # Fall back to default
    DEFAULT_FROM
  end

  def extract_text_body(mail)
    if mail.multipart?
      text_part = mail.parts.find { |p| p.content_type.to_s.match?(/text\/plain/) }
      text_part ? text_part.body.to_s : nil
    else
      mail.content_type.to_s.match?(/text\/plain/) ? mail.body.to_s : nil
    end
  end

  def extract_html_body(mail)
    if mail.multipart?
      html_part = mail.parts.find { |p| p.content_type.to_s.match?(/text\/html/) }
      html_part ? html_part.body.to_s : nil
    else
      mail.content_type.to_s.match?(/text\/html/) ? mail.body.to_s : nil
    end
  end
end
