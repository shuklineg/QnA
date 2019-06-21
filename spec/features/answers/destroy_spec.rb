require 'rails_helper'

feature 'User can delete own answers', %q(
  In order to delete own answer
  As an authenticated user and author
  I'd like to be able to delete the answer
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:someone_elses_answer) { create(:answer, :sequences, question: question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'tries to delete own answer' do
      click_link 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete someone else's answer" do
      within "#answer-#{someone_elses_answer.id}" do
        expect(page).to_not have_link('Delete answer')
      end
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link('Delete answer')
  end
end
