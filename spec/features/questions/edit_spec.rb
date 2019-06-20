require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:someone_elses_question) { create(:question, :sequences) }

  scenario 'Unauthenticated can not edit question'

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit questions_path
    end

    scenario 'edit his question'

    scenario 'edit his question with errors'

    scenario "tries to edit other user's question"
  end
end
