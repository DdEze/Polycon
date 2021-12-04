class UsersController < ApplicationController
    before_action :set_user, only: %i[ admin consultation attendance ]
    def index
        @users = User.paginate({page: params[:page], per_page:5}).joins(:rol).where.not(rol: {name: "Administración"})
    end
    
    def admin
        @user.rol_id = 1
        self.update
    end

    def consultation
        @user.rol_id = 2
        self.update
    end

    def attendance
        @user.rol_id = 3
        self.update
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def update
        @user.save
        respond_to do |format|
            format.html { redirect_to users_path, notice: "Usuario se actualizó con éxito." }
            format.json { render :show, status: :ok, location: @user }
        end
    end

end