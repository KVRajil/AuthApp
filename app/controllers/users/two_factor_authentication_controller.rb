module Users
  class TwoFactorAuthenticationController < ApplicationController
    before_action :authenticate_with_password, only: %i[generate_otp verify_otp]
    before_action :authenticate, only: %i[toggle_2fa]

    api :POST, 'users/generate_otp/', 'Generate OTP'
    def generate_otp
      # otp = OtpService.new(current_user).generate
      if OtpService.new(current_user).email
        render json: { message: 'OTP sent to the email address' }, status: :created
      else
        render json: { error: 'OTP creation failed' }, status: :unprocessable_entity
      end
    end

    api :POST, 'users/verify_otp/', 'Verify OTP'
    param :otp, String, desc: 'OTP', required: true
    def verify_otp
      if OtpService.new(current_user).verify(params[:otp])
        payload = { user_id: current_user.id, otp_verified: true }
        token   = JwtService.encode(payload, 50.minutes)
        render json: { token: token }, status: :created
      else
        render json: { error: 'Invalid OTP' }, status: :unauthorized
      end
    end

    api :PATCH, 'users/toggle_2fa/', 'Toggle 2FA'
    param :password, String, desc: 'Password', required: true
    param :otp, String, desc: 'OTP', required: true
    def toggle_2fa
      error =  'Invalid password' unless current_user.authenticate(params[:password])
      error =  'Invalid OTP' unless OtpService.new(current_user).verify(params[:otp])

      if error.nil?
        current_user.update!(is_two_factor_enabled: params[:enable_2fa])
        render json: { message: '2FA settings updated' }, status: :ok
      else
        render json: { error: error }, status: :unprocessable_entity
      end
    end
  end
end
