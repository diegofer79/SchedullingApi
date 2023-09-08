require 'rails_helper'

RSpec.describe WorkingDaysController, type: :controller do
  
  context 'Show WorkingDay' do

    describe '#create' do
      let!(:doctor) { create(:doctor) }
      let!(:params) { 
                      { 
                        doctor_id: doctor.id,
                        working_days: [
                          { weekday: 0, start_working_hour: '09:00', end_working_hour: '18:00' },
                          { weekday: 1, start_working_hour: '09:00', end_working_hour: '18:00' }
                        ]
                      } 
                    } 

      context 'Succesfully create model' do
        before { post :create, params: params }

        it do
          result = JSON.parse(response.body)
          expect(result.size).to eq(2)

          expect(result[0]["id"]).not_to eq(nil)
          expect(result[0]["weekday"]).to eq(0)
          expect(result[0]["start_working_hour"]).to eq('09:00')
          expect(result[0]["end_working_hour"]).to eq('18:00')
        end
      end
    end

    describe '#update' do
      let!(:doctor) { create(:doctor) }
      let!(:working_day_1) { create(:working_day, doctor: doctor, weekday: 0) }
      let!(:working_day_2) { create(:working_day, doctor: doctor, weekday: 1) }

      let!(:params) { 
                      { 
                        doctor_id: doctor.id,
                        working_days: [
                          { weekday: 0, start_working_hour: '11:00', end_working_hour: '19:00' },
                          { weekday: 1, start_working_hour: '11:00', end_working_hour: '19:00' }
                        ]
                      } 
                    } 

      context 'Succesfully update model' do

        before { patch :update, params: params }

        it do
          result = JSON.parse(response.body)
          expect(result.size).to eq(2)

          expect(result[0]["id"]).not_to eq(nil)
          expect(result[0]["weekday"]).to eq(0)
          expect(result[0]["start_working_hour"]).to eq('11:00')
          expect(result[0]["end_working_hour"]).to eq('19:00')
        end
      end
    end

    describe '#delete' do
      let!(:doctor) { create(:doctor) }
      let!(:working_day) { create(:working_day, doctor: doctor, weekday: 0) }
      before { delete :destroy, params: { id: working_day.id } }

      it 'Success delete' do
        expect(WorkingDay.with_deleted.where(id: working_day.id).first.deleted_at).not_to eq(nil)
      end
    end

  end
end
