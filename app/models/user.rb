class User < ApplicationRecord
  before_destroy :check_all_event_finished
  has_many :created_events, class_name: "Event", foreign_key: "owner_id", dependent: :nullify
  has_many :tickets, dependent: :nullify
  has_many :participating_events, through: :tickets, source: :event

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = nickname
      user.image_url = image_url
    end
  end

  private

    def check_all_event_finished
      now = Time.zone.now
      if created_events.where(":now < end_at" , now: now).exists?
        errors[:base] << "公開中の未終了イベントがあります。"
      end

      if participating_events.where(":now < end_at", now: now).exists?
        errors[:base] << "未終了の参加イベントがあります。"
      end

      #最後にエラーの有無を調べ、エラーが存在していた場合はthrow(:abort)として削除処理を中断
      throw(:abort) unless errors.empty?
    end
end
