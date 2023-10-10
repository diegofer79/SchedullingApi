require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  let!(:session) do
    { validation_key: Rails.configuration.api_key }
  end

  context 'Show Appointments' do

    describe '#show' do
      let!(:doctor) { create :doctor }
      let!(:appointment) { create(:appointment, doctor: doctor) }

      before { get :show, params: { id: appointment.id }, session: session }

      it 'Show expected info for appointment' do
        expect(JSON.parse(response.body).keys).to include(*%w[id start_date end_date patient_info])
      end
    end

    describe '#create' do    
      let(:doctor) { create :doctor }
      let!(:params) { { doctor_id: doctor.id, start_date: '2023-01-01T09:00:00.000Z', end_date: '2023-01-01T09:30:00.000Z'} }
      
      context 'Succesfully create model' do
        before { post :create, params: params, session: session }
        it do
          result = JSON.parse(response.body)

          expect(result["id"]).not_to eq(nil)
          expect(result["start_date"]).to eq('2023-01-01T09:00:00.000Z')
          expect(result["end_date"]).to eq('2023-01-01T09:30:00.000Z')
        end
      end

      context 'Fail to create model' do
        it 'Invalid doctor' do
          params = { doctor_id: 100000, start_date: '09:00', end_date: '18:00' }
          post :create, params: params, session: session
          result = JSON.parse(response.body)
          expect(result.dig("message")).to eq('Doctor not found')
        end

        it 'Invalid start_date' do
          params = { doctor_id: doctor.id, start_date: '99:00', end_date: '10:00' }
          post :create, params: params, session: session
          result = JSON.parse(response.body)
          expect(result.dig("message")).to eq('Invalid date format')
        end

        it 'Invalid end_date' do
          params = { doctor_id: doctor.id, start_date: '09:00', end_date: '99:00' }
          post :create, params: params, session: session
          result = JSON.parse(response.body)
          expect(result.dig("message")).to eq('Invalid date format')
        end
      end
    end

    describe '#delete' do
      let!(:doctor) { create :doctor }
      let!(:appointment) { create(:appointment, doctor: doctor) }
      before { delete :destroy, params: { id: appointment.id }, session: session }

      it 'Success delete' do
        expect(Appointment.with_deleted.where(id: appointment.id).first.deleted_at).not_to eq(nil)
      end
    end

  end
end
