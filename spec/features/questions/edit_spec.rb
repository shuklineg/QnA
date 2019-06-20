require 'rails_helper'

feature 'User can edit his question', %q(
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:someone_elses_question) { create(:question, :sequences) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit questions_path
    end

    scenario 'edit his question' do
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'

        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
      end
    end

    scenario 'edit his question with errors' do
      within "#question-#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do
      within "#question-#{someone_elses_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
