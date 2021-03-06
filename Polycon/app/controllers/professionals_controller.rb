class ProfessionalsController < ApplicationController
  load_and_authorize_resource
  before_action :set_professional, only: %i[ show edit update destroy ]
  #before_action :authorize
  # GET /professionals or /professionals.json
  def index
    @professionals = Professional.paginate({page: params[:page], per_page:5}).all.reorder('surname, name')
  end

  # GET /professionals/1 or /professionals/1.json
  def show
  end

  # GET /professionals/new
  def new
    @professional = Professional.new
  end

  # GET /professionals/1/edit
  def edit
  end

  # POST /professionals or /professionals.json
  def create
    @professional = Professional.new(professional_params)

    respond_to do |format|
      if @professional.save
        format.html { redirect_to @professional, notice: "Profesional fue creado con éxito." }
        format.json { render :show, status: :created, location: @professional }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /professionals/1 or /professionals/1.json
  def update
    respond_to do |format|
      if @professional.update(professional_params)
        format.html { redirect_to @professional, notice: "Profesional se actualizó con éxito." }
        format.json { render :show, status: :ok, location: @professional }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @professional.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /professionals/1 or /professionals/1.json
  def destroy
    begin
     @professional.destroy
     respond_to do |format|
       format.html { redirect_to professionals_url, notice: "Profesional fue borrado con éxito." }
       format.json { head :no_content }
     end
    rescue
      respond_to do |format|
        format.html { redirect_to professionals_url, notice: "Cancela todos los turnos antes de borrar a #{@professional.surname_and_name}" }
        format.json { head :no_content }
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_professional
      @professional = Professional.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def professional_params
      params.require(:professional).permit(:name, :surname)
    end

end
