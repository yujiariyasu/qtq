module FeaturesSpecHelper
  def login(user, password = 'password')
    visit login_path
    within('#login-form') do
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: password
      click_button 'ログイン'
    end
  end
end
