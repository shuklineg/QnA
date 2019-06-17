require 'rails_helper'

feature 'User can see questions', %q(
  In order to find the question
  As an any user
  I'd like to be able to see questions list
) do
  given!(:questions) { 5.times.collect { create(:question, :sequences) } }

  scenario 'Any user visits questions/index' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
