class WorkingDay < ApplicationRecord
  acts_as_paranoid

  belongs_to :doctor

end
