class AppointmentsController < ApplicationController

  before_action :set_appointment, only: %i[ show update destroy ]
  before_action :parse_date, only: %i[ create update ]

  # GET /appointments/1
  def show
    render json: @model
  end

  # POST /appointments
  def create
    begin
      doctor = Doctor.find(appointment_params[:doctor_id])
    rescue  ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      return render json: 'Doctor not found', status: :unprocessable_entity
    end
 
    if doctor.appointments
             .where('start_date >= ?', appointment_params[:start_date])
             .where('end_date <= ?', appointment_params[:end_date])
             .count > 0
      
      return render json: {error: "An appointment for that date and hour already exists"}, status: :unprocessable_entity
    end

    @model = Appointment.new({
                    doctor: doctor, 
                    start_date: appointment_params[:start_date], 
                    end_date: appointment_params[:end_date], 
                    patient_info: appointment_params[:patient_info]
                  })

    if @model.save
      render json: @model, status: :created
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # PATCH/PUT /appointments/1
  def update
    begin
      doctor = Doctor.find(appointment_params[:doctor_id])
    rescue  ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      return render json: 'Doctor not found', status: :unprocessable_entity
    end

    if doctor.appointments
      .where('start_date >= ?', appointment_params[:start_date])
      .where('end_date <= ?', appointment_params[:end_date])
      .count > 0

      return render json: {error: "An appointment for that date and hour already exists"}, status: :unprocessable_entity
    end

    if @model.update(appointment_params)
      render json: @model
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # DELETE /appointments/1
  def destroy
    @model.destroy
    render json: {message: 'Appointment deleted'}
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Appointment not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end


  private

  # Use callbacks to share common setup or constraints between actions.
  def set_appointment
    @model = Appointment.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Appointment not found', status: :unprocessable_entity
  end

  # Only allow a list of trusted parameters through.
  def appointment_params
    params.permit(:id, :start_date, :end_date, :doctor_id, :patient_info)
  end

  def parse_date
    raise StandardError.new("start_date has a invalid format") unless time_format_valid?(params[:start_date])
    raise StandardError.new("end_date has a invalid format") unless time_format_valid?(params[:end_date])
  end

  def time_format_valid?(time)
    Time.zone.parse(time)
  rescue
    nil
  end

end
