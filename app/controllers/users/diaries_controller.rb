class Users::DiariesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_diary, only: %i[show edit update destroy]

  def index
    @diaries = current_user.diaries.order_by_newest.page(params[:page]).per(5)
  end

  def new
    @diary = current_user.diaries.build
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      redirect_to users_diaries_path, notice: '日記を作成しました'
    else
      flash.now[:alert] = '日記の作成に失敗しました'
      render :new
    end
  end

  def show
    @comments = @diary.comments.order_by_newest.page(params[:page]).per(5)
  end

  def edit
  end

  def update
    if @diary.update(diary_params)
      redirect_to users_diaries_path, notice: '日記を更新しました'
    else
      flash.now[:alert] = '日記の更新に失敗しました'
      render :edit
    end
  end

  def destroy
    @diary.destroy!
    redirect_to users_diaries_path, notice: '日記を削除しました'
  end

  private

  def set_diary
    @diary = current_user.diaries.find(params[:id])
  end

  def diary_params
    params.require(:diary).permit(:title, :content, :display)
  end
end
