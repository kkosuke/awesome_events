class TicketsController < ApplicationController
  def new
    raise ActionController::RoutingError, "ログイン状態でTicketsControlloer#newにアクセス"
  end
end
