require "rails_helper"

RSpec.describe Appointment, type: :model do

  describe 'show' do
    let(:appointment) { create :appointment }

    it 'Success show by id' do
      expect(appointment.id).not_to be(nil)
    end
  end

  describe 'create' do
    let(:appointment) { create :appointment }

    it 'Success creation' do
      expect(appointment.start_date).not_to be(nil)
      expect(appointment.end_date).not_to be(nil)
    end
  end

  describe 'update' do
    let(:appointment) { create :appointment }
    
    it 'Success update fields' do
      appointment.start_date = Time.zone.parse('2023-01-01 11:00 -03:00')
      appointment.end_date = Time.zone.parse('2023-01-01 11:30 -03:00')
      appointment.save

      expect(appointment.start_date).to eq(Time.zone.parse('2023-01-01 11:00 -03:00'))
      expect(appointment.end_date).to eq(Time.zone.parse('2023-01-01 11:30 -03:00'))
    end
  end

  describe 'delete' do
    let(:appointment) { create :appointment }

    it 'Success deletion' do
      appointment.delete
      expect{ Appointment.find(appointment.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
