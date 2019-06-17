require 'rails_helper'

feature 'User can sign up', %q(
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign up
) do
  given(:user) { build(:user) }

  background do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
  end

  scenario 'Unregistered user tries to sign up' do
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Registered user tries to sign up' do
    user.save!
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
