require 'rails_helper'

feature 'User can see a question', %q(
  In order to read question
  As an any user
  I'd like to be able to see a question text
) do
  given!(:question) { create(:question) }

  scenario 'Any user visits questions/show' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
