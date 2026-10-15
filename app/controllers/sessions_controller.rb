class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  # Show the sign-in form, or send an authenticated user to the dashboard.
  def new
    redirect_to root_path if authenticated?
  end

  # Start a session for valid credentials; otherwise render a generic sign-in error.
  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  # End the signed-in session and redirect the browser to sign in.
  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
