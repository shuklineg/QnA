require 'rails_helper'

feature 'User can edit link from the answer', %q(
  In order to correct mistakes
  As the author of the answer
  I would like to be able to edit link
) do
  describe 'Authenticated user', js: true do
    given!(:user) { create(:user) }
    given!(:answer) { create(:answer, user: user) }
    given!(:link) { create(:link, linkable: answer) }

    background { login(user) }

    scenario 'Edit the link in owned answer' do
      visit question_path(answer.question)
      within first('.answer') do
        click_on 'Edit'

        fill_in 'Link name',	with: 'Edited link'
        fill_in 'Url',	with: 'http://new.url'

        click_on 'Save'
      end

      expect(page).to_not have_link 'Edited link', href: 'http://new.url'
    end
  end
end
