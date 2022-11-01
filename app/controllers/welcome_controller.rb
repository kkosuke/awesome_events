class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    @events = Event.where("start_at >?", Time.zone.now).order(:start_at)
    # リダイレクト、アンカーリンクの挙動確認です。あとで破壊するかも
    if params[:redirect_test].present?
      redirect_to "/test#a"
    end
  end
end
