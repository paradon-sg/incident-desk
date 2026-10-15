module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    # Allow the selected actions to run without a signed-in session.
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    # Return the current session, restoring it from the signed cookie when needed.
    def authenticated?
      resume_session
    end

    # Require a session before allowing a protected controller action.
    def require_authentication
      resume_session || request_authentication
    end

    # Cache the session identified by the signed cookie for this request.
    def resume_session
      Current.session ||= find_session_by_cookie
    end

    # Find an existing session only when a valid signed session cookie is present.
    def find_session_by_cookie
      Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
    end

    # Remember the requested URL and redirect the visitor to sign in.
    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to new_session_path
    end

    # Consume the saved return URL, defaulting to the ticket dashboard.
    def after_authentication_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    # Record a new session and persist its ID in an HTTP-only signed cookie.
    def start_new_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
        Current.session = session
        cookies.signed.permanent[:session_id] = { value: session.id, httponly: true, same_site: :lax }
      end
    end

    # Destroy the current session and remove its cookie from the browser.
    def terminate_session
      Current.session.destroy
      cookies.delete(:session_id)
    end
end
