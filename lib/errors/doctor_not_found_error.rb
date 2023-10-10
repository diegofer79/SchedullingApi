module Errors
  class DoctorNotFoundError

    def self.render_error(e)
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      { message: "Doctor not found", status: :unprocessable_entity }
    end
    
  end
end