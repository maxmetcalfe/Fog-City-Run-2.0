class Rack::Attack

  ### Client IP resolution (behind Cloudflare and/or the Fly.io proxy) ###
  # Prefer headers set by our proxies, since Rails' req.ip can otherwise
  # resolve to a shared proxy address and throttle innocent users together.

  def self.client_ip(req)
    req.env["HTTP_CF_CONNECTING_IP"] || req.env["HTTP_FLY_CLIENT_IP"] || req.ip
  end

  ### Global per-IP throttle: 600 requests / 5 minutes ###
  throttle("req/ip", limit: 600, period: 5.minutes) do |req|
    client_ip(req)
  end

  ### Signups: max 10 POST /users per hour per IP ###
  throttle("signups/ip", limit: 10, period: 1.hour) do |req|
    if req.post? && req.path == "/users"
      client_ip(req)
    end
  end

  ### Password resets: max 10 POST /password_resets per hour per IP ###
  throttle("password_resets/ip", limit: 10, period: 1.hour) do |req|
    if req.post? && req.path == "/password_resets"
      client_ip(req)
    end
  end

  ### Account emails (signup + password reset): max 3 per hour per email ###
  throttle("account_emails/email", limit: 3, period: 1.hour) do |req|
    if req.post? && ["/users", "/password_resets"].include?(req.path)
      email = (req.params["user"] && req.params["user"]["email"]) ||
              (req.params["password_reset"] && req.params["password_reset"]["email"])
      email.to_s.strip.downcase.presence
    end
  end

  ### Friendly throttled response ###

  self.throttled_responder = lambda do |request|
    match_data = request.env["rack.attack.match_data"]
    now = match_data[:epoch_time]
    retry_after = match_data[:period] - (now % match_data[:period])
    [
      429,
      { "Content-Type" => "text/plain", "Retry-After" => retry_after.to_s },
      ["Rate limit exceeded. Please try again later.\n"]
    ]
  end

end
