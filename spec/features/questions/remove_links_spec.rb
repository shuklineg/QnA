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

    background { login(user) }

    scenario 'Removes the link in owned question.' do
      visit question_path(question)
      within '.question' do
        click_on 'Edit'

        within first('.link-fields') do
          click_on 'Remove link'
        end

        click_on 'Save'
      end

      expect(page).to_not have_link link.name, href: link.url
    end
  end
end
