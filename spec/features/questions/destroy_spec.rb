require 'rails_helper'

feature 'User can delete own question', %q(
  In order to delete the own question
  As an authenticated user and author
  I'd like to be able to delete the question
) do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author tries to delete own question' do
    login(author)
    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Your question has been deleted.'
  end

  scenario "User tries to delete someone else's question"
  scenario 'Unauthenticated user tries to delete question'
end
