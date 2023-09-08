class Appointment < ApplicationRecord
  acts_as_paranoid

  belongs_to :doctor

end
