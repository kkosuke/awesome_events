class Ticket < ApplicationRecord
  # 関連先がなくてもエラーにならないように。
  belongs_to :user, optional: true
  belongs_to :event

  # 30文字以内、空白を許可
  validates :comment, length: {maximum: 30}, allow_blank: true
  validates :user, uniqueness: true
end
