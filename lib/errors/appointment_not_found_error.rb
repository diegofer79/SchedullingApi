module Errors
  class AppointmentNotFoundError

    def self.render_error(e)
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      { message: "Appointment not found", status: :unprocessable_entity }
    end
    
  end
end