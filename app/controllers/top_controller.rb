class TopController < ApplicationController
  def index
    @diaries = Diary.displayed.order_by_newest.page(params[:page]).per(5)
  end
end
