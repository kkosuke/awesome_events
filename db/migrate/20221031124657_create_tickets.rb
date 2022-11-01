class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      # 退会ユーザーもいることを考慮し、nullを許可する
      t.references :user
      t.references :event, null: false, foreign_key: true, index: false
      t.string :comment
      t.timestamps
    end

    # userが重複してイベントに参加できないように
    add_index :tickets, %i[event_id user_id], unique: true
  end
end
