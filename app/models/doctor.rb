class Doctor < ApplicationRecord  
  acts_as_paranoid

  has_many :appointments
  has_many :working_days

end
