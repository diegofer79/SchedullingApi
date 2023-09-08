FactoryBot.define do
  factory :working_day, class: WorkingDay do
    
    weekday { 0 }
    start_working_hour { '09:00' }
    end_working_hour { '18:00' }

  end
end