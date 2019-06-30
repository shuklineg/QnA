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

    scenario 'Removes the link in owned question.' do
      login(user)
      visit question_path(question)

      within '.question' do
        click_on 'Remove link'
      end

      expect(page).to_not have_link link.name, href: link.url
    end

    scenario 'Attempts to delete the link in another question'
  end
  describe 'Unauthenticated user', js: true do
    scenario 'Tries to remove link'
  end
end
