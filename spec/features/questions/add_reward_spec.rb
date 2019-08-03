require 'rails_helper'

feature 'User can add reward to question', %q(
  In order to mark the best answer
  As an question's author
  I'd like to be able to add reward
) do
  describe 'Authenticated user asks question', js: true do
    given(:user) { create(:user) }

    background do
      login(user)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'
    end

    scenario 'add reward' do
      within '.reward' do
        fill_in 'Name', with: 'Reward name test'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.png"
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
    end

    scenario 'add invalid reward image' do
      within '.reward' do
        fill_in 'Name', with: 'Reward name test'
      end

      click_on 'Ask'

      expect(page).to have_content 'You must add an image file.'
    end

    scenario 'add invalid reward name' do
      within '.reward' do
        attach_file 'Image', "#{Rails.root}/spec/fixtures/images/reward.png"
      end

      click_on 'Ask'

      expect(page).to have_content "Reward name can't be blank"
    end
  end
end
