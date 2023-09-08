require "rails_helper"

RSpec.describe Doctor, type: :model do

  describe 'Show' do
    let(:doctor) { create :doctor }

    it 'Success show by id' do
      expect(doctor.id).not_to be(nil)
    end
  end

  describe 'create' do
    let(:doctor) { create :doctor }

    it 'Success creation' do
      expect(doctor.full_name).to eq("Doctor Full Name")
    end
  end

  describe 'update' do
    let(:doctor) { create :doctor }
    
    it 'Success update fields' do
      doctor.full_name = "New Name"
      doctor.save

      expect(doctor.full_name).to eq("New Name")
    end
  end

  describe 'delete' do
    let(:doctor) { create :doctor }

    it 'Success deletion' do
      doctor.delete
      expect{ Doctor.find(doctor.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
