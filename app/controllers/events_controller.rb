class EventsController < ApplicationController
  skip_before_action :authenticate, only: :show

  def show
    @event = Event.find(params[:id])
    @ticket  = current_user && current_user.tickets.find_by(event: @event)
    @tickets = @event.tickets.includes(:user).order(:created_at)
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "作成しました"
    end
    # @event.saveがバリデーションエラーになった時は、redirect_toが実行されない。
    # 何が実装されるかというと、デフォルトの挙動であるビューのレンダリングが行われます。
    # この時、失敗した時のエラーメッセージを、app/views/events/create.js.erbとしてJavaScriptで表現します。
    # 最終的にJavaScriptを返すので、他のビューテンプレートとは異なりERBを利用しています。
    # form_withなどによるAjaxリクエストのレスポンスとしてJavaScriptが返された場合、そのJavaScriptはブラウザ上で実行されます。これはrails ujsの機能です。

  end

  def edit
    # current_user.created_events.find(params[:id])という方法でイベントを取得することで、イベントを作成したユーザだけがイベント編集ページにアクセス可能なように実装
    # current_userの関連を使うとログインしているユーザの関連するモデルであることがより伝わりやすい
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "更新しました"
    end
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to root_path, notice: "削除しました"
  end

  private
    def event_params
      params.require(:event).permit(
        :name, :place, :content, :start_at, :end_at
      )
    end

end
