require 'rails_helper'

feature 'User can subscribe to the question', %q(
  In order to receive mail about adding answers
  As an authenticated user
  I'd like to be able to subscribe to the question
) do
  given(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user tries subscribe' do
    visit question_path(question)

    expect(page).to_not have_content('Subscribe')
  end

  describe 'Authenticated user', js: true do
    given(:subscribed_question) { create(:question, subscribed_users: [user]) }

    background { login(user) }

    scenario 'Authenticated user tries to subscribe' do
      visit question_path(question)

      expect(page).to have_content('Subscribe')
      expect(page).to_not have_content('Unsubscribe')

      click_on('Subscribe')

      expect(page).to have_content('Unsubscribe')
      expect(page).to_not have_content('Subscribe')
    end

    scenario 'Authenticated user tries to unsubscribe' do
      visit question_path(subscribed_question)

      expect(page).to_not have_content('Subscribe')
      expect(page).to have_content('Unsubscribe')

      click_on('Unsubscribe')

      expect(page).to_not have_content('Unsubscribe')
      expect(page).to have_content('Subscribe')
    end
  end
end
