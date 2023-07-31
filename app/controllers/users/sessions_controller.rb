module Users
  class SessionsController < ApplicationController
    api :POST, 'users/login/', 'Login user'
    param :email, String, desc: 'Email', required: true
    param :password, String, desc: 'Password', required: true
    def create
      user = User.find_by(email: params[:email])

      if user&.authenticate(params[:password])
        token = JwtService.encode({ user_id: user.id })
        OtpService.new(user).email
        render json: { token: token }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end
end
