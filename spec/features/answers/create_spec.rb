require 'rails_helper'

feature 'User can create answer', %q(
  In order to help with the question
  As an authenticated user
  I'd like to be able to answer the question
) do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'Answer the question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer the question'

      expect(page).to have_content 'Answer successfully created.'
    end

    scenario 'Answer the question with error' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
