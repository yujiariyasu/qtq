class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: 'qtq：ユーザー認証メール'
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'qtq：パスワードのリセット'
  end
end
