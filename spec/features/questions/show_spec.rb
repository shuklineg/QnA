require 'rails_helper'

feature 'User can see the question', %q(
  In order to read the question
  As an any user
  I'd like to be able to see the question text
) do
  given!(:question) { create(:question) }

  scenario 'Any user visits questions/show' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
