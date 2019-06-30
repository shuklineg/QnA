require 'rails_helper'

feature 'User can edit link from the question', %q(
  In order to correct mistakes
  As the author of the question
  I would like to be able to edit link
) do
  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }
    given!(:link) { create(:link, linkable: question) }

    background { login(user) }

    scenario 'Edit the link in owned question' do
      visit question_path(question)
      within first('.question') do
        click_on 'Edit'

        fill_in 'Link name',	with: 'Edited link'
        fill_in 'Url',	with: 'http://new.url'

        click_on 'Save'
      end

      expect(page).to_not have_link 'Edited link', href: 'http://new.url'
    end
  end
end
