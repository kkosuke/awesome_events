class EventsController < ApplicationController
  skip_before_action :authenticate, only: :show

  def show
    @event = Event.find(params[:id])
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

  private
    def event_params
      params.require(:event).permit(
        :name, :place, :content, :start_at, :end_at
      )
    end

end
