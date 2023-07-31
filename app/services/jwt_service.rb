class JwtService
  def self.encode(payload, expiry = 2.minutes)
    payload[:exp] = expiry.from_now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode(jwt_token)
    JWT.decode(jwt_token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256').first
  rescue JWT::DecodeError
    nil
  end
end
