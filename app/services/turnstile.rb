require "net/http"
require "json"

# Verifies Cloudflare Turnstile CAPTCHA tokens.
#
# Configure via the TURNSTILE_SITE_KEY / TURNSTILE_SECRET_KEY env vars.
# While either is unset, checks are skipped so the app keeps working
# before keys have been configured (and in development).
module Turnstile
  SITEVERIFY_URL = "https://challenges.cloudflare.com/turnstile/v0/siteverify"

  module_function

  def enabled?
    site_key.present? && secret_key.present?
  end

  def disabled?
    !enabled?
  end

  def site_key
    ENV["TURNSTILE_SITE_KEY"].to_s
  end

  def secret_key
    ENV["TURNSTILE_SECRET_KEY"].to_s
  end

  # Returns true when the token verifies successfully.
  def verify(token, remote_ip = nil)
    return false if token.blank?

    params = { "secret" => secret_key, "response" => token.to_s }
    params["remoteip"] = remote_ip.to_s if remote_ip.present?

    uri = URI(SITEVERIFY_URL)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(params)
      http.request(request)
    end

    JSON.parse(response.body)["success"] == true
  rescue => e
    Rails.logger.error("[Turnstile] verification error: #{e.class}: #{e.message}")
    false
  end
end
