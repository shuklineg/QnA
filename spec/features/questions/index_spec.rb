require 'rails_helper'

feature 'User can see questions', %q(
  In order to find the question
  As an any user
  I'd like to be able to see questions list
) do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5, :sequences, user: user) }

  scenario 'Any user visits questions/index' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
