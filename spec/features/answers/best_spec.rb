require 'rails_helper'

feature 'The author of the question can mark one answer as the best.', %q(
  In order to mark the correct answer
  As an authenticated user and question author
  I'd like to be able to mark one answer as the best
) do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, :sequences, question: question) }

  describe 'As authenticated user', js: true do
    given!(:user) { create(:user) }

    context 'and author' do
      given!(:author) { create(:user) }
      given!(:answer) { create(:answer, :sequences, question: question, user: author ) }

      context 'another answer is marked as best' do
        given!(:answer) { create(:answer, :sequences, question: question, user: author, best: true ) }

        scenario 'mark another answer as the best'
      end

      scenario 'mark one answer as the best' do
        login(author)

        visit question_path(question)

        within "#answer-#{answer.id}" do
          click_on 'Best'
        end

        within first('.answer') do
          expect(page).to have_content answer.body
          expect(page).to_not have_link 'Best'
        end
      end
    end

    scenario "can't mark the answer as the best in someone else's question"
  end

  scenario "Unauthenticated user can't mark the answer as the best"
end
