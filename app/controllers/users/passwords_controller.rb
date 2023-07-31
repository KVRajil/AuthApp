module Users
  class PasswordsController < ApplicationController
    before_action :authenticate, only: :update

    api :PATCH, 'users/passwords/', 'Update password'
    param :current_password, String, desc: 'Current  password', required: true
    param :new_password, String, desc: 'New  password', required: true
    param :otp, String, desc: 'OTP', required: true
    def update
      if valid_update?
        if current_user.update(password: params[:new_password], password_confirmation: params[:new_password])
          render json: { message: 'Password successfully updated' }, status: :ok
        else
          render json: { error: current_user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      else
        render json: { error: error_message }, status: :unprocessable_entity
      end
    end

    private

    def valid_update?
      valid_otp? && valid_current_password?
    end

    def valid_otp?
      OtpService.new(current_user).verify(params[:otp])
    end

    def valid_current_password?
      current_user.authenticate(params[:current_password])
    end

    def error_message
      return 'Invalid OTP' unless valid_otp?
      return 'Current password is invalid' unless valid_current_password?
    end
  end
end
