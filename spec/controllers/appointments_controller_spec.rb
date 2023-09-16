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
        it 'Invalid start_date' do
          params = { doctor_id: doctor.id, start_date: '99:00', end_date: '10:00' }
          expect { post :create, params: params, session: session }.to raise_error(StandardError, 'start_date has a invalid format')
        end

        it 'Invalid end_date' do
          params = { doctor_id: doctor.id, start_date: '09:00', end_date: '99:00' }
          expect { post :create, params: params, session: session }.to raise_error(StandardError, 'end_date has a invalid format')
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
