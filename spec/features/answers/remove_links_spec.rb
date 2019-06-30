require 'rails_helper'

feature 'User can delete links from the answer', %q(
  In order to remove unnecessary or outdated links
  As the author of the answer
  I would like to be able to delete links
) do
  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:answer) { create(:answer, user: user) }
    given!(:link) { create(:link, linkable: answer) }
    given!(:another_user_answer) { create(:answer) }
    given!(:another_user_link) { create(:link, linkable: another_user_answer) }

    background { login(user) }

    scenario 'Removes the link in owned answer.' do
      visit question_path(answer.question)

      within '.answers ul.links' do
        click_on 'Remove link'
      end

      expect(page).to_not have_link link.name, href: link.url
    end

    scenario 'Attempts to delete the link in another question' do
      visit question_path(another_user_answer.question)

      within '.answers ul.links' do
        expect(page).to_not have_link 'Remove link'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:answer) { create(:answer, user: user) }
    given!(:link) { create(:link, linkable: answer) }

    scenario 'Tries to remove link' do
      visit question_path(answer.question)

      within '.answers ul.links' do
        expect(page).to_not have_link 'Remove link'
      end
    end
  end
end
