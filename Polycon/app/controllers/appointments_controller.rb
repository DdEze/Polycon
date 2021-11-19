class AppointmentsController < ApplicationController
    load_and_authorize_resource
    before_action :set_appointment, only: %i[ show edit update destroy ]
    before_action :set_professional, only: %i[ index show new edit update destroy destroy_all create]
      
    # GET /appointments or /appointments.json
    def index
        @appointments = Professional.find(params[:professional_id]).appointments.paginate({page: params[:page], per_page:1})
    end
      
    # GET /appointments/1 or /appointments/1.json
    def show
    end
      
    # GET /appointments/new
    def new
        @appointment = Appointment.new
    end
      
    # GET /appointments/1/edit
    def edit
    end
      
    # POST /appointments or /appointments.json
    def create
        @appointment = Appointment.new(appointment_params)
      
        respond_to do |format|
            if @appointment.save
                format.html { redirect_to professional_appointments_path(@professional.id), notice: "El turno se creó con éxito." }
                #format.html { redirect_to @appointment, notice: "Appointment was successfully created." }
                format.json { render :show, status: :created, location: @appointment }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @appointment.errors, status: :unprocessable_entity }
            end
        end
    end
      
    # PATCH/PUT /appointments/1 or /appointments/1.json
    def update
        respond_to do |format|
            if @appointment.update(appointment_params)
              format.html { redirect_to professional_appointments_path(@professional), notice: "El turno se actualizó correctamente."}
              format.json { render :show, status: :ok, location: @appointment }
            else
              format.html { render :edit, status: :unprocessable_entity }
              format.json { render json: @appointment.errors, status: :unprocessable_entity }
            end
        end
    end
      
    # DELETE /appointments/1 or /appointments/1.json
    def destroy
        @appointment.destroy
        respond_to do |format|
          format.html { redirect_to professional_appointments_path(@professional.id), notice: "El turno se borro con éxito." }
          format.json { head :no_content }
        end
    end

    def destroy_all
        Appointment.where(professional_id: @professional.id).destroy_all
        respond_to do |format|
          format.html { redirect_to professional_appointments_path(@professional.id), notice: "Los turnos han sido cancelado." }
          format.json { head :no_content }
        end
    end
      
    private
    # Use callbacks to share common setup or constraints between actions.
        def set_appointment
            @appointment = Appointment.find(params[:id])
        end

        def set_professional
            @professional = Professional.find(params[:professional_id])
        end
        # Only allow a list of trusted parameters through.
        def appointment_params
            params.require(:appointment).permit(:date, :name, :surname, :phone, :notes, :professional_id)
        end
end
