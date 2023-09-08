FactoryBot.define do
  factory :appointment, class: Appointment do
  	
  	doctor { create(:doctor) }
    start_date { Time.zone.parse('2023-01-01 10:00 -03:00') }
    end_date { Time.zone.parse('2023-01-01 10:30 -03:00') }
    patient_info { {"full_name":"John Doe", "contact_phone":"1111-1111"} }

  end
end