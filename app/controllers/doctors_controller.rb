class DoctorsController < ApplicationController

  before_action :set_doctor, only: %i[ show update destroy working_days appointments]

  WORKING_HOURS_FORMAT = /\A\d{2}:\d{2}\z/.freeze
  SLOT_INTERVAL = 30

  # GET /doctors
  def index
    render json: Doctor.all
  end

  # GET /doctors/1/working_days
  def working_days
    render json: @model.working_days

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # GET /doctors/1/appointments
  def appointments
    render json: @model.appointments

  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # GET /doctors/1/open_slots
  def open_slots
    date = Time.zone.parse(params[:date])

    doctor = Doctor.find(params[:id])
    working_day = doctor.working_days.find{ |day| day.weekday == date.wday }
    
    if working_day
      slots = build_slots(working_day)

      appointments = doctor.appointments
                     .where('start_date >= ?', date.beginning_of_day)
                     .where('end_date <= ?', date.end_of_day)
                     .map { |appointment| appointment.start_date.strftime("%H:%M") }

      return render json: {available_slots: slots - appointments}
    end

    return render json: {available_slots: []}
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # POST /doctors
  def create
    @model = Doctor.new(doctor_params)

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

  # PATCH/PUT /doctors/1
  def update
    if @model.update(doctor_params)
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

  # DELETE /doctors/1
  def destroy
    @model.destroy
    render json: {message: 'Doctor deleted'}
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @model = Doctor.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.permit(:id, :full_name)
  end

  def build_slots(working_day)
    hour, minutes = working_day.start_working_hour.split(":")
    hour = hour.to_i
    minutes = minutes.to_i

    start_hour = hour * 60 + minutes

    hour, minutes = working_day.end_working_hour.split(":")
    hour = hour.to_i
    minutes = minutes.to_i

    end_hour = hour * 60 + minutes
    
    slots = []

    hour = start_hour
    while hour <= end_hour
      slots << "%02d:%02d" % [hour / 60, hour % 60]
      hour += 30
    end

    slots
  end
end
