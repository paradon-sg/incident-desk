module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    # Accept a cable connection only when its signed cookie identifies a session.
    def connect
      set_current_user || reject_unauthorized_connection
    end

    private
      # Assign the user from the signed session cookie, returning nil when absent.
      def set_current_user
        if session = Session.find_by(id: cookies.signed[:session_id])
          self.current_user = session.user
        end
      end
  end
end
