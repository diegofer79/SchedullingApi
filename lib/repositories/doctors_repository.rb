module Repositories
  class DoctorsRepository

    def self.find(id)
      Doctor.find(id)
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      raise e
    end

    def self.all
      Doctor.all
    end

    def self.build(data)
      Doctor.new( {full_name: data[:full_name]} )
    end

  end
end