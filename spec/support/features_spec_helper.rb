module FeaturesSpecHelper
  def login(user, password = '123456')
    visit login_path
    within('#login-form') do
      fill_in 'general_user_mail', with: user.mail
      fill_in 'general_user_password', with: password
      click_button 'ログインする'
    end
  end
end
