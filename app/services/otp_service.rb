class OtpService
  attr_reader :totp, :user

  def initialize(user)
    @user = user
    @totp = ROTP::TOTP.new(@user.otp_secret)
  end

  def generate
    totp.now
  end

  def verify(otp)
    last_otp_at = totp.verify(otp, after: user.last_otp_at)
    user.update!(last_otp_at: last_otp_at) if last_otp_at
    last_otp_at
  end

  def email
    otp = generate
    UserMailer.send_otp(user, otp).deliver_now
  end
end
