require 'rails_helper'

feature 'User can vote for the question', %q(
  In order to raise the question rate
  As an authenticated user
  I'd like to be able to vote for the question
) do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:owned_question) { create(:question, user: user) }

    background do
      login(user)
      visit question_path(question)
    end

    scenario 'can vote for the question' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
      end

      expect(page.find("#question-#{question.id} .votes-count")).to have_content '1'
    end

    scenario 'tries vote for the owned question' do
      visit question_path(owned_question)
      within "#question-#{owned_question.id}" do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'can vote down for the answer' do
      within "#question-#{question.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote down'
      end
      expect(page.find("#question-#{question.id} .votes-count")).to have_content '-1'
    end
  end

  scenario "Unauthenticated user can't vote for the question" do
    visit question_path(question)
    expect(page).to_not have_link 'Vote up'
    expect(page).to_not have_link 'Vote down'
  end
end
