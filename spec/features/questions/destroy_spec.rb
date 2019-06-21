require 'rails_helper'

feature 'User can delete own question', %q(
  In order to delete the own question
  As an authenticated user and author
  I'd like to be able to delete the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    given(:someone_else_queston) { create(:question, user: create(:user)) }

    background { login(user) }

    scenario 'tries to delete own question' do
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question has been deleted.'
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
    end

    scenario "tries to delete someone else's question" do
      visit question_path(someone_else_queston)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
