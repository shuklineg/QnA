require 'rails_helper'

feature 'User can vote for the answer', %q(
  In order to raise the answer rate
  As an authenticated user
  I'd like to be able to vote for the answer
) do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:owned_answer) { create(:answer, question: question, user: user) }

    background do
      login(user)
      visit question_path(question)
    end

    scenario 'can vote for the answer' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario 'tries vote for the owned answer' do
      within "#answer-#{owned_answer.id}" do
        expect(page).to_not have_link 'Vote up'
        expect(page).to_not have_link 'Vote down'
      end
    end

    scenario 'can vote down for the answer' do
      within "#answer-#{answer.id}" do
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '-1'
      end
    end

    scenario 'change vote' do
      within "#answer-#{answer.id}" do
        click_on 'Vote down'
        expect(page.find('.votes-count')).to have_content '-1'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '0'
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '1'
      end
    end

    scenario "can't vote twice" do
      within "#answer-#{answer.id}" do
        click_on 'Vote down'
        click_on 'Vote down'
      end
      expect(page).to have_content "You can't vote twice"
    end

    scenario 'can see rate' do
      create_list(:vote, 3, user: create(:user), value: -1, votable: answer)

      within "#answer-#{answer.id}" do
        click_on 'Vote up'
        expect(page.find('.votes-count')).to have_content '-2'
      end
    end
  end

  scenario "Unauthenticated user can't vote for the answer" do
    visit question_path(question)
    expect(page).to_not have_link 'Vote up'
    expect(page).to_not have_link 'Vote down'
  end
end
