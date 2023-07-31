module Users
  class ConfirmationsController < ApplicationController
    api :GET, 'users/confirmations/:token', 'Confirm email'
    def show
      user = User.find_by(confirmation_token: params[:token])
      if user
        user.update!(email_confirmed_at: Time.zone.now, confirmation_token: nil)
        render json: { message: 'Email successfully confirmed' }, status: :ok
      else
        render json: { error: 'Invalid confirmation link' }, status: :unprocessable_entity
      end
    end

    api :POST, 'users/confirmations/', 'Resend email confirmation'
    param :email, String, desc: 'User email', required: true
    param :password, String, desc: 'User password', required: true
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        if user.email_confirmed_at.nil?
          user.update_confirmation_token
          UserMailer.confirmation_email(user).deliver_now
        end
        render json: { message: 'Confirmation email sent.' }, status: :ok
      else
        render json: { error: 'Invalid email id or password' }, status: :not_found
      end
    end
  end
end
