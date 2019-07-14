require 'rails_helper'

feature 'User can create answer', %q(
  In order to help with the question
  As an authenticated user
  I'd like to be able to answer the question
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'Answer the question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer the question'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer body'
      end
    end

    scenario 'Answer the question with error' do
      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'Answer the question with attached file' do
      fill_in 'Body', with: 'question text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer the question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessioins', js: true do
    given(:another_user) { create(:user) }
    given(:google_url) { 'https://www.google.com' }
    given!(:question) { create(:question) }
    given(:answer) { Answer.last }

    scenario "question appears on another user's page" do
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
        within '.new-answer' do
          fill_in 'Body', with: 'Answer text'

          fill_in 'Link name', with: 'My link'
          fill_in 'Url', with: google_url

          click_on 'Answer the question'
        end

        expect(page).to have_content 'Answer text', count: 1
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer text'
          expect(page).to have_link 'My link', href: google_url
          expect(page).to_not have_link 'Vote up', href: vote_up_answer_path(answer)
          expect(page).to_not have_link 'Vote down', href: vote_down_answer_path(answer)
        end
      end

      Capybara.using_session('another_user') do
        within '.answers' do
          expect(page).to have_content 'Answer text'
          expect(page).to have_link 'My link', href: google_url
          expect(page).to have_link 'Vote up', href: vote_up_answer_path(answer)
          expect(page).to have_link 'Vote down', href: vote_down_answer_path(answer)
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)

    expect(page).to_not have_button 'Answer the question'
    expect(page).to_not have_field 'Body'
  end
end
