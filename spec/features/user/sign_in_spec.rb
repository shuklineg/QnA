require 'rails_helper'

feature 'User can sign in', %q(
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
) do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'Registred user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'unregistered_user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario 'User tries to sign up with oauth vkontakte' do
    expect(page).to have_content 'Sign in with Vkontakte'

    mock_auth :vkontakte
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'new@user.com'

    Sidekiq::Testing.inline! do
      click_on 'Sign up'
      expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
      sleep(1)
      open_email 'new@user.com'
    end
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'User tries to sign up with oauth vkontakte twice' do
    expect(page).to have_content 'Sign in with Vkontakte'

    mock_auth :vkontakte
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'new@user.com'
    click_on 'Sign up'

    visit new_user_session_path
    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'anower@user.com'
    Sidekiq::Testing.inline! do
      click_on 'Sign up'
      sleep(1)
      open_email 'anower@user.com'
    end
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'User tries to sign up with oauth github' do
    expect(page).to have_content 'Sign in with GitHub'

    mock_auth :github, 'new@user.com'
    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from Github account.'
  end
end
