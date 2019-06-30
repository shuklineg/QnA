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

    background { login(user) }

    scenario 'Removes the link in owned answer.' do
      visit question_path(answer.question)
      within first('.answer') do
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
