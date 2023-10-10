module Repositories
  class AppointmentsRepository

    def self.find(id)
      Appointment.find(id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      raise e
    end

    def self.build(doctor, data)
      Appointment.new( {
                        doctor: doctor, 
                        start_date: data[:start_date], 
                        end_date: data[:end_date], 
                        patient_info: data[:patient_info]
                      } )
    end

  end
end