module Api
  class UsersController < BaseController
    doorkeeper_for :index, :create, :update, :destroy, :me
    #doorkeeper_for :me
    #doorkeeper_for :create#, scopes: [:public]
    #doorkeeper_for :index, :show#, scopes: [:admin]
    #doorkeeper_for :update, :destroy#, scopes: [:admin]

    before_action :find_user, only: [:show, :update, :destroy, :wysh]

    def index
      @users = load_paginated(User)

      render json: @users, each_serializer: UserSerializer
    end

    def create
      @user = User.new(user_params)
      status = @user.save

      render json: @user, meta: gen_meta(status)
    end

    def show
      render json: @user
    end

    def update
      @user.assign_attributes(user_params)
      status = @user.save

      render json: @user, meta: gen_meta(status)
    end

    def destroy
      status = @user.destroy

      render json: @user, meta: gen_meta(status)
    end

    def me
      render json: current_user
    end

    # Returns list of public Wysh Lists
    def wysh
      @pub_lists = @user.lists.public

      render json: @pub_lists
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name,
                                   :password, :password_confirmation)
    end

    def find_user
      @user = User.find(params[:id])
    end

  end
end
