require 'rails_helper'

feature 'User can delete own answers', %q(
  In order to delete own answer
  As an authenticated user and author
  I'd like to be able to delete the answer
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete own answer' do
    login(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Your answer has been deleted.'
  end
  scenario "Authenticated user tries to delete someone else's answer"
  scenario 'Unauthenticated user tries to delete answer'
end
