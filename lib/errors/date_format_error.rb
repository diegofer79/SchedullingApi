module Errors
  class DateFormatError

    def self.render_error(e)
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      { message: "Invalid date format", status: :unprocessable_entity }
    end
    
  end
end