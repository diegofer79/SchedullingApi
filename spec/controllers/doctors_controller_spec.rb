require 'rails_helper'

RSpec.describe DoctorsController, type: :controller do
  let!(:session) do
    { validation_key: Rails.configuration.api_key }
  end

  context 'Show Doctor' do

    describe '#index' do
      let!(:doctor) { create(:doctor) }
      before { get :index, session: session }

      it 'Show expected info for array' do
        expect(JSON.parse(response.body).first.keys).to include(*%w[id full_name])
      end
    end

    describe '#working_days' do
      let!(:doctor) { create(:doctor) }
      let!(:working_day_1) { create(:working_day, doctor: doctor) }
      let!(:working_day_2) { create(:working_day, doctor: doctor, weekday: 1) }

      before { get :working_days, params: { id: doctor.id }, session: session }

      context 'Show expected keys for models' do
        it do
          expect(JSON.parse(response.body).first.keys).to  include(*%w[weekday start_working_hour end_working_hour])
          expect(JSON.parse(response.body).second.keys).to  include(*%w[weekday start_working_hour end_working_hour])
        end
      end
    end

    describe '#open_slots' do
      let!(:doctor) { create(:doctor) }
      let!(:working_day) { create(:working_day, doctor: doctor, weekday: 0) }
      let!(:appointment) { create(:appointment, doctor: doctor) }

      before { get :open_slots, params: { id: doctor.id, date: '2023-01-01' }, session: session }

      context 'Show expected keys for models' do
        it do
          expect(JSON.parse(response.body).keys).to include(*%w[available_slots])
          expect(JSON.parse(response.body)).not_to include(*%w[10:30])
        end
      end
    end

    describe '#create' do
      context 'Succesfully create model' do
        before { post :create, params: {full_name: 'Dr. Full Name'}, session: session }

        it do
          result = JSON.parse(response.body)

          expect(result["id"]).not_to eq(nil)
          expect(result["full_name"]).to eq('Dr. Full Name')
        end
      end
    end

    describe '#delete' do
      let!(:doctor) { create(:doctor) }
      
      before { delete :destroy, params: { id: doctor.id }, session: session }

      it 'Success delete' do
        expect(Doctor.with_deleted.where(id: doctor.id).first.deleted_at).not_to eq(nil)
      end
    end

  end
end
