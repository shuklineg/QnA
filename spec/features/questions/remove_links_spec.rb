require 'rails_helper'

feature 'User can delete links from the question', %q(
  In order to remove unnecessary or outdated links
  As the author of the question
  I would like to be able to delete links
) do
  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }
    given!(:another_user_question) { create(:question) }
    given!(:another_user_link) { create(:link, linkable: another_user_question) }

    background { login(user) }

    scenario 'Removes the link in owned question.' do
      visit question_path(question)

      within 'ul.links' do
        click_on 'Remove link'
      end

      expect(page).to_not have_link link.name, href: link.url
    end

    scenario 'Attempts to delete the link in another question' do
      visit question_path(another_user_question)

      within 'ul.links' do
        expect(page).to_not have_link 'Remove link'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }

    scenario 'Tries to remove link' do
      visit question_path(question)

      within 'ul.links' do
        expect(page).to_not have_link 'Remove link'
      end
    end
  end
end
