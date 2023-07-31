module Users
  class RegistrationsController < ApplicationController
    api :POST, 'users/signup/', 'Create user'
    param :email, String, desc: 'Email', required: true
    param :password, String, desc: 'Password', required: true
    param :password_confirmation, String, desc: 'Confirm password', required: true
    def create
      user = User.new(user_params)
      if user.save
        send_email_confirmation(user)
        render json: { message: 'User successfully created' }, status: :created
      else
        render json: { error: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    private

    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def send_email_confirmation(user)
      UserMailer.confirmation_email(user).deliver_now
    end
  end
end
