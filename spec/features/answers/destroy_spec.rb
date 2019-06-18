require 'rails_helper'

feature 'User can delete own answers', %q(
  In order to delete own answer
  As an authenticated user and author
  I'd like to be able to delete the answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user tries to delete own answer' do
    login(user)
    visit question_path(question)
    click_link 'Delete answer'

    expect(page).to have_content 'Your answer has been deleted.'
  end

  scenario "Authenticated user tries to delete someone else's answer" do
    login(another_user)
    visit question_path(question)

    expect(page).not_to have_selector(:link_or_button, 'Delete answer')
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).not_to have_selector(:link_or_button, 'Delete answer')
  end
end
