module Errors
  class AppointmentDuplicatedError

    def self.render_error(e)
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      { message: "An appointment for that date and hour already exists", status: :unprocessable_entity }
    end

  end
end