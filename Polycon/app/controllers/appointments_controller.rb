class AppointmentsController < ApplicationController
    load_and_authorize_resource
    before_action :set_appointment, only: %i[ show edit update destroy ]
    before_action :set_professional, only: %i[ index show new edit update destroy destroy_all create]
    before_action :monday_week, only: %i[ download_week ]
    # GET /appointments or /appointments.json
    def index
        @appointments = Professional.find(params[:professional_id]).appointments.paginate({page: params[:page], per_page:5}).reorder('date')
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

    def download_day
        date = DateTime.parse("#{(params["date(1i)".to_sym])}-#{(params["date(2i)".to_sym])}-#{(params["date(3i)".to_sym])}_08:00")
        date_fin = DateTime.parse(date.strftime("%F__21:00"))
        erb = ERB.new(File.read("./app/views/appointments/index_g_d.html.erb"))
        if (params[:profes_id]) == ""
            appointments = Appointment.where('date BETWEEN ? AND ?', (date), (date_fin)).reorder('date')
            title= "turnos_del_#{date.strftime("%F")}"
            output = erb.result_with_hash(appointments: appointments, date: date, professional:nil)
        else
            @professional = Professional.find(params[:profes_id])
            appointments = @professional.appointments.where('date BETWEEN ? AND ?', (date), (date_fin)).reorder('date')
            output = erb.result_with_hash(appointments: appointments, date:date, professional:@professional)
            title="#{@professional.surname_and_name.gsub(" ","_")}_turnos_del_#{date.strftime("%F")}"
        end
        send_data(output, :filename =>"#{title}.html")
    end

    def download_week
        erb = ERB.new(File.read("./app/views/appointments/index_g_w.html.erb"))
        if (params[:profes_id]) == ""
            app = (Appointment.where('date BETWEEN ? AND ?', (@date), (@date_fin))).collect {|a| a.professional_id}
            professionals = Professional.where(:id => app ).reorder('surname, name')
            title= "turnos_semana_del_#{@date.strftime("%F")}"
            output = erb.result_with_hash(professionals:professionals, date: @date, date_fin:@date_fin, professional:nil)
        else
            @professional = Professional.find(params[:profes_id])
            professionals = [@professional]
            output = erb.result_with_hash(professionals:professionals, date:@date, date_fin:@date_fin, professional:@professional)
            title="#{@professional.surname_and_name.gsub(" ","_")}_turnos_semana_del_#{@date.strftime("%F")}"
        end
        send_data(output, :filename =>"#{title}.html")
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

        def monday_week
            @date = DateTime.parse("#{(params["date(1i)".to_sym])}-#{(params["date(2i)".to_sym])}-#{(params["date(3i)".to_sym])}_08:00")
            case @date.strftime("%A")
             when "Monday"
                @date
             when "Tuesday"
                @date = @date - 1
             when "Wednesday"
                @date = @date - 2
             when "Thursday"
                @date = @date - 3
             when "Friday"
                @date = @date - 4
             when "Saturday"
                @date = @date - 5
             when "Sunday"
                @date = @date - 6
            end
            @date_fin = DateTime.parse((@date + 6).strftime("%F__21:00"))
        end
end
