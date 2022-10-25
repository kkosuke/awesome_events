Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.development? || Rails.env.test?
    provider :github,
    # 直書きでもいいけど production と同じ書き方ができるかお試し。
    Rails.application.credentials.github[:client_id], Rails.application.credentials.github[:client_secret]
  else
    provider :github,
    Rails.application.credentials.github[:client_id]
    Rails.application.credentials.github[:client_secret]
  end
end