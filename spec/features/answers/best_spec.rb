require 'rails_helper'

feature 'The author of the question can mark one answer as the best.', %q(
  In order to mark the correct answer
  As an authenticated user and question author
  I'd like to be able to mark one answer as the best
) do
  describe 'As authenticated user', js: true do
    given!(:user) { create(:user) }

    before { login(user) }

    context 'and author' do
      given!(:question) { create(:question, user: user) }
      given!(:answers) { create_list(:answer, 5, :sequences, question: question) }
      given!(:answer) { answers.last }

      context 'another answer is marked as best' do
        given!(:answer) { create(:answer, :sequences, question: question, best: true ) }

        scenario 'mark another answer as the best'
      end

      scenario 'mark one answer as the best' do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_on 'Best'
        end

        within first('.answer').first do
          expect(page).to have_content answer.body
          expect(page).to_not have_link 'Best'
        end
      end
    end

    scenario "can't mark the answer as the best in someone else's question"
  end

  scenario "Unauthenticated user can't mark the answer as the best"
end
