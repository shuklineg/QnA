require 'rails_helper'

feature 'User can add comments to question', %q(
  In order discuss the question
  As an user
  I'd like to be able to add comments
), js: true do
  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given(:comment_text) { 'Comment text' }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'add valid comment' do
      within '.question' do
        expect(page).to_not have_content comment_text

        click_on 'Add comment'

        expect(page).to_not have_link 'Add comment'

        within '.comment-form' do
          fill_in 'Body', with: comment_text
          click_on 'Comment'
        end

        expect(page).to have_content comment_text
        expect(page).to_not have_link 'Comment'
      end
    end

    scenario 'add invalid comment' do
      within '.question' do
        click_on 'Add comment'
        within '.comment-form' do
          fill_in 'Body', with: ''
          click_on 'Comment'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries add comment' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Add comment'
    end
  end

  context 'multiple sessioins', js: true do
    given(:another_user) { create(:user) }
    given(:question) { create(:question) }
    given(:comment) { Comment.last }

    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        login(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          click_on 'Add comment'

          within '.comment-form' do
            fill_in 'Body', with: comment_text
            click_on 'Comment'
          end

          expect(page).to have_content comment_text, count: 1
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content comment_text
        end
      end

      Capybara.using_session('another_user') do
        within '.question' do
          expect(page).to have_content comment_text
        end
      end
    end
  end
end
