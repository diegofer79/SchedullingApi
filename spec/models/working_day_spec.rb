require "rails_helper"

RSpec.describe WorkingDay, type: :model do

  describe 'Show' do
    let!(:doctor) { create(:doctor) }
    let!(:working_day) { create(:working_day, doctor: doctor) }

    it 'Success show by id' do
      expect(working_day.id).not_to be(nil)
    end
  end

  describe 'create' do
    let!(:doctor) { create(:doctor) }
    let!(:working_day) { create(:working_day, doctor: doctor, weekday: 1) }

    it 'Success creation' do
      expect(working_day.weekday).to eq(1)
    end
  end

  describe 'update' do
    let!(:doctor) { create(:doctor) }
    let!(:working_day) { create(:working_day, doctor: doctor, weekday: 0, start_working_hour: '09:00', end_working_hour: '10:00') }
    
    it 'Success update fields' do
      working_day.weekday = 5
      working_day.start_working_hour = "10:00"
      working_day.end_working_hour = "11:00"
      working_day.save

      expect(working_day.weekday).to eq(5)
      expect(working_day.start_working_hour).to eq("10:00")
      expect(working_day.end_working_hour).to eq("11:00")
    end
  end

  describe 'delete' do
    let!(:doctor) { create(:doctor) }
    let!(:working_day) { create(:working_day, doctor: doctor) }

    it 'Success deletion' do
      working_day.delete
      expect{ WorkingDay.find(working_day.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
