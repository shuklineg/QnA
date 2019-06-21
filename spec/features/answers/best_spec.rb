require 'rails_helper'

feature 'The author of the question can mark one answer as the best.', %q(
  In order to mark the correct answer
  As an authenticated user and question author
  I'd like to be able to mark one answer as the best
) do
  describe 'As authenticated user' do
    context 'and author' do
      context 'another answer is marked as best' do
        scenario 'mark another answer as the best'
      end
      scenario 'mark one answer as the best'
    end
    scenario "can't mark the answer as the best in someone else's answer"
  end
  scenario "Unauthenticated user can't mark the answer as the best"
end
