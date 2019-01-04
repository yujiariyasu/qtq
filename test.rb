require 'webpush'
payload = {
  endpoint: @endpoint, # ブラウザでregistration.pushManager.getSubscription()で取得したsubscriptionのendpoint
  p256dh: @p256dh, # 同じくsubscriptionのp256dh
  auth: @auth, # 同じくsubscriptionのauth
  ttl: @ttl, # 任意の値
  vapid: {
    subject: 'qtq.work@gmail.com', # APPサーバのコンタクト用URIとか('mailto:' もしくは 'https://')
    public_key: ENV['WEB_PUSH_VAPID_PUBLIC_KEY'],
    private_key: ENV['WEB_PUSH_VAPID_PRIVATE_KEY']
  },
  message: {
    # icon: 'https://example.com/images/demos/icon-512x512.png',
    title: 'test',
    body: 'body',
    target_url: 'target_url' # 任意のキー、値
  }.to_json
}
# NOTE: payload_sendの例外
#         RuntimeError の場合             Webpush::Error
#         Error の場合                    Webpush::ConfigurationError
#         Net::HTTPGone 410 の場合        Webpush::InvalidSubscription
#         Net::HTTPSuccess 2XX 以外の場合 Webpush::ResponseError
Webpush.payload_send(payload)
