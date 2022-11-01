class TicketsController < ApplicationController
  def new
    raise ActionController::RoutingError, "ログイン状態でTicketsControlloer#newにアクセス"
  end

  def create
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event
      t.comment = params[:ticket][:comment]
    end
    if @ticket.save
      redirect_to event, notice: "このイベントに参加表明しました。"
    end
  end

  def destroy
    # Ticketモデルの取得をfind_byではなくfind_by!にしているのは、存在しないevent_idが渡されてきた時にActiveRecord::NotFoundErrorを発生させ、ユーザには404画面を表示させたいからです。
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    redirect_to event_path(params[:event_id]), notice: "このイベントの参加をキャンセルしました。"
  end
end
