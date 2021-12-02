class UsersController < ApplicationController
    def index
        @users = User.paginate({page: params[:page], per_page:5}).all
    end
end