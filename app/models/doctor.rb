class Doctor < ApplicationRecord  
  acts_as_paranoid

  has_many :appointments
  has_many :working_days

  def has_appointment_on?(start_date, end_date)
    appointments_for(start_date, end_date).count > 0
  end  

  def appointments_for(start_date, end_date, to_map = false)
    _appointments = appointments
            .where('start_date >= ?', start_date)
            .where('end_date <= ?', end_date)

    return _appointments unless to_map
    
    _appointments.map { |appointment| appointment.start_date.strftime("%H:%M") }
  end

  def works_on?(date)
    working_day(date)
  end

  def working_day(date)
    working_days.find { |day| day.weekday == date.wday }
  end

  def slots(date)
    _day = working_day(date)
    hour, minutes = _day.start_working_hour.split(":")
    hour = hour.to_i
    minutes = minutes.to_i

    start_hour = hour * 60 + minutes

    hour, minutes = _day.end_working_hour.split(":")
    hour = hour.to_i
    minutes = minutes.to_i

    end_hour = hour * 60 + minutes
    
    slots = []

    hour = start_hour
    while hour <= end_hour
      slots << "%02d:%02d" % [hour / 60, hour % 60]
      hour += 30
    end

    slots
  end
end
