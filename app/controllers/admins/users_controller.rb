class Admins::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.order_by_oldest
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_users_path, notice: t('common.controller.update.success', model: User.model_name.human)
    else
      flash.now[:alert] = t('common.controller.update.failed', model: User.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_path, notice: t('common.controller.destroy.success', model: User.model_name.human)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :display_name, :name, :phone_number, :postal_code, :address)
  end
end
