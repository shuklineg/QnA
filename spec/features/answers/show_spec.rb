require 'rails_helper'

feature 'User can see the answers to the question.', %q(
  In order to read the answers to the question
  As an any user
  I'd like to be able to see the answers to the question
) do
  given!(:question) { create(:question, user: create(:user)) }
  given!(:answers) { create_list(:answer, 5, :sequences, question: question, user: create(:user)) }

  scenario 'Any user visits questions/show' do
    visit question_path(question)

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
