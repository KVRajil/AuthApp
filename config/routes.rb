Rails.application.routes.draw do
  apipie

  namespace :users do
    post  'signup',                   to: 'registrations#create'
    get   'confirmations/:token',     to: 'confirmations#show', as: :confirmation
    post  'confirmations',            to: 'confirmations#create'
    post  'login',                    to: 'sessions#create'
    patch 'passwords',                to: 'passwords#update'
    post  'generate_otp',             to: 'two_factor_authentication#generate_otp'
    post  'verify_otp',               to: 'two_factor_authentication#verify_otp'
    patch 'toggle_2fa',               to: 'two_factor_authentication#toggle_2fa'
  end
end
