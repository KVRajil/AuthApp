# README

A simple AuthApp using Rails 7(API only).

Features
1. User sign up and login
2. Generate & verify OTP
3. Update password & toggle 2FA


Rails version - 7.0.4   
Ruby  version - 3.0.2


Installation & Setup:

    Clone the project.
    Create master.key file in config folder (value - 88b37458d4861b547e93a24e4c173387)
    Run bundle install and rails db:setup.
    Start the Rails server using rails s.
    Run the RSpec tests with rspec spec/.

App Workflow:

    Register using email id & password (the password should be strong).
    Click on the confirmation email link to verify the account.
    Log in to create a temporary JWT and use that token for generating and verifying OTP.
    Generate & verify the OTP (requires the temporary JWT token).
    Once the OTP is verified, use the JWT token for authenticating other actions.
    Enabling or disabling 2FA  requires the current password + the newly generated OTP.
    Updating the password requires the current password + the newly generated OTP.

Code coverage
   file:///{path}/coverage/index.html


APIPIE documentation
   http://localhost:3000/apipie 

CURL Requests

1. Registration
   ```bash
   curl --location 'localhost:3000/users/signup' \
   --header 'Content-Type: application/json' \
   --data-raw '{ "email": "rajilkva2z@gmail.com", "password": "Test@1234", "password_confirmation": "Test@1234"}'


2. Confirm Email
   ```bash
   curl --location 'http://localhost:3000/users/confirmations/AccNSNPWb1tQcJcyenlIHA'

3. Resend Confirmation Email
   ```bash
   curl --location 'localhost:3000/users/confirmations' \
   --header 'Content-Type: application/json' \
   --data-raw '{"email": "rajilkva2z@gmail.com", "password": "Test@1234"}'

4. Login
   ```bash
   curl --location 'localhost:3000//users/login' \
   --header 'Content-Type: application/json' \
   --data-raw '{"email": "rajilkva2z@gmail.com", "password": "Test@1234"}'


5. Generate OTP
   ```bash
   curl --location --request POST 'localhost:3000/users/generate_otp' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2OTA4MDQ3Mjh9.jd_FQdE5jzdOu9YuTwP6wbVdk0FNdCvjBsPGsElkfvc' \
   --data ''

6. Verify OTP
   ```bash
   curl --location 'localhost:3000/users/verify_otp' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE2OTA4MDQ3Mjh9.jd_FQdE5jzdOu9YuTwP6wbVdk0FNdCvjBsPGsElkfvc' \
   --data '{"otp": "388409"}'

7. Toggle 2FA
   ```bash
   curl --location --request PATCH 'localhost:3000/users/toggle_2fa' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJvdHBfdmVyaWZpZWQiOnRydWUsImV4cCI6MTY5MDgwNTAwNH0.2kiAFIKN3e2BfLLTOl-S00KRbQ9qzoTyHo0dGOEX4J4' \
   --data-raw '{"password": "Test@1234", "otp": "544608", "enable_2fa": false}'

8. Update Password
   ```bash
   curl --location --request PATCH 'localhost:3000/users/passwords' \
   --header 'Content-Type: application/json' \
   --header 'Accept: application/json' \
   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJvdHBfdmVyaWZpZWQiOnRydWUsImV4cCI6MTY5MDgwODE1NH0.krhMI0b1YYei0eX1iSPZQAcifiEljMxILMGdozfd_Jw' \
   --data-raw '{"current_password": "Test@1234", "new_password": "TestNew@1234", "otp": "275073"}'
