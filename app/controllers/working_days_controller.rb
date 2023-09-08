class WorkingDaysController < ApplicationController
  before_action :set_working_day, only: %i[ show destroy ]
  before_action :parse_working_hours, only: %i[ create update ]

  WORKING_HOURS_FORMAT = /\A\d{2}:\d{2}\z/.freeze

  # GET /working_days
  def index
    render json: @WorkingDay.all
  end

  # GET /working_days/1
  def show
    render json: @model
  end

  # POST /working_days
  def create
    begin
      doctor = Doctor.find(working_days_params[:doctor_id])
    rescue  ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      return render json: 'Doctor not found', status: :unprocessable_entity
    end
    doctor.working_days.destroy_all

    wdays = []
    working_days_params.dig(:working_days).each do |working_day|
      wday = WorkingDay.new(working_day)
      wday.doctor = doctor
      wday.save!
      wdays.push wday
    end

    render json: wdays, status: :created
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # PATCH/PUT /working_days/1
  def update
    begin
      doctor = Doctor.find(working_days_params[:doctor_id])
    rescue  ActiveRecord::RecordNotFound => e
      Rails.logger.error "#{e.message} - #{e.backtrace}"
      return render json: 'Doctor not found', status: :unprocessable_entity
    end
    doctor.working_days.destroy_all

    wdays = []
    working_days_params.dig(:working_days).each do |working_day|
      wday = WorkingDay.new(working_day)
      wday.doctor = doctor
      wday.save!
      wdays.push wday
    end

    render json: wdays, status: :created
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'Doctor not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  # DELETE /working_days/1
  def destroy
    @model.destroy
    render json: {message: 'WorkingDay deleted'}
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'WorkingDay not found', status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: e.message, status: :unprocessable_entity
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_working_day
    @model = WorkingDay.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "#{e.message} - #{e.backtrace}"
    render json: 'WorkingDay not found', status: :unprocessable_entity
  end

  # Only allow a list of trusted parameters through.
  def working_days_params
    params.permit(:doctor_id, :working_days => [:id, :weekday, :start_working_hour, :end_working_hour])
  end

  def parse_working_hours
    (working_days_params.dig(:working_days) || []).each do |param| 
      raise StandardError.new("start_working_hour has a invalid format") unless time_format_valid?(param[:start_working_hour])
      raise StandardError.new("end_working_hour has a invalid format") unless time_format_valid?(param[:end_working_hour])
    end
  rescue StandardError => e
    raise StandardError.new(e.message)
  end

  def time_format_valid?(time)
    hours, minutes = time.split(':').map(&:to_i)
    (time.match? WORKING_HOURS_FORMAT) && (0..23).include?(hours) && (0..59).include?(minutes)
  end

end
