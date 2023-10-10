class DoctorsController < ApplicationController

  before_action :set_doctor, only: %i[ show update destroy working_days appointments]

  WORKING_HOURS_FORMAT = /\A\d{2}:\d{2}\z/.freeze
  SLOT_INTERVAL = 30

  # GET /doctors
  def index
    render json: ::Repositories::DoctorsRepository.all
  end

  # GET /doctors/1/working_days
  def working_days
    render json: @model.working_days

  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  # GET /doctors/1/appointments
  def appointments
    render json: @model.appointments

  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  # GET /doctors/1/open_slots
  def open_slots
    doctor = ::Repositories::DoctorsRepository.find params[:id]
    date = Time.zone.parse(params[:date])

    if doctor.works_on?(date)
      slots = doctor.slots(date)
      appointments = doctor.appointments_for(date.beginning_of_day, date.end_of_day)

      return render json: {available_slots: slots - appointments}
    end
    return render json: {available_slots: []}

  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  # POST /doctors
  def create
    @model = ::Repositories::DoctorsRepository.build(doctor_params)

    if @model.save
      render json: @model, status: :created
    else
      render json: @model.errors, status: :unprocessable_entity
    end

  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  # PATCH/PUT /doctors/1
  def update
    if @model.update(doctor_params)
      render json: @model
    else
      render json: @model.errors, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  # DELETE /doctors/1
  def destroy
    @model.destroy
    render json: {message: 'Doctor deleted'}

  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  rescue StandardError => e
    return Errors::UnhandledError.render_error(e)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @model = ::Repositories::DoctorsRepository.find params[:id]
  rescue ActiveRecord::RecordNotFound
    return Errors::AppointmentNotFoundError.render_error
  end

  # Only allow a list of trusted parameters through.
  def doctor_params
    params.permit(:id, :full_name)
  end
end
