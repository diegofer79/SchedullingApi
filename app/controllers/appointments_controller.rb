class AppointmentsController < ApplicationController

  before_action :set_appointment, only: %i[ show update destroy ]
  # before_action :parse_date, only: %i[ create update ]

  # GET /appointments/1
  def show
    render json: @model
  end

  # POST /appointments
  def create
    parse_dates
    doctor = ::Repositories::DoctorsRepository.find(appointment_params[:doctor_id])
 
    if doctor.has_appointment_on?(appointment_params[:start_date], appointment_params[:end_date])     
      error = ::Errors::AppointmentDuplicatedError.render_error
      return render json: error, status: error[:status]
    end

    @model = ::Repositories::AppointmentsRepository.build(doctor, {
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
    error = ::Errors::DoctorNotFoundError.render_error(e) 
    return render json: error, status: error[:status]
  rescue Exception => e
    error = ::Errors::DateFormatError.render_error(e) 
    return render json: error, status: error[:status]
  rescue StandardError => e
    error = ::Errors::UnhandledError.render_error(e)
    return render json: error, status: error[:status]
  end

  # PATCH/PUT /appointments/1
  def update
    parse_dates
    doctor = ::Repositories::DoctorsRepository.find(appointment_params[:doctor_id])

    if doctor.has_appointment_on?(appointment_params[:start_date], appointment_params[:end_date])     
      error = ::Errors::AppointmentDuplicatedError.render_error
      return render json: error, status: error[:status]
    end

    if @model.update(appointment_params)
      render json: @model
    else
      render json: @model.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    error = ::Errors::DoctorNotFoundError.render_error(e) 
    return render json: error, status: error[:status]
  rescue ::Errors::DateFormatError => e
    error = ::Errors::DateFormatError.render_error(e) 
    return render json: error, status: error[:status]
  rescue StandardError => e
    error = ::Errors::UnhandledError.render_error(e)
    return render json: error, status: error[:status]
  end

  # DELETE /appointments/1
  def destroy
    @model.destroy
    render json: { message: 'Appointment deleted' }
  rescue ActiveRecord::RecordNotFound => e
    error = ::Errors::DoctorNotFoundError.render_error(e) 
    return render json: error, status: error[:status]
  rescue StandardError => e
    error = ::Errors::UnhandledError.render_error(e)
    return render json: error, status: error[:status]
  end


  private

  def set_appointment
    @model = ::Repositories::AppointmentsRepository.find params[:id]
  rescue ActiveRecord::RecordNotFound => e
    error = ::Errors::DoctorNotFoundError.render_error(e) 
    return render json: error, status: error[:status]
  end

  def appointment_params
    params.permit(:id, :start_date, :end_date, :doctor_id, :patient_info)
  end

  def parse_dates
    raise Exception.new("start_date has a invalid format") unless time_format_valid?(params[:start_date])
    raise Exception.new("end_date has a invalid format") unless time_format_valid?(params[:end_date])
  end

  def time_format_valid?(time)
    Time.zone.parse(time)
  rescue
    nil
  end

end
