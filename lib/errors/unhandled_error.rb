module Errors
  class UnhandledError

    def self.render_error(e)
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      { message: "Unhandled error", status: :internal_server_error }
    end
    
  end
end