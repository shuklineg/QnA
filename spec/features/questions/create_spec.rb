require 'rails_helper'

feature 'User can create question', %q(
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
) do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'question text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'Author subscribed by default' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'

      click_on 'Ask'

      expect(page).to_not have_content('Subscribe')
      expect(page).to have_content('Unsubscribe')
    end
  end

  context 'multiple sessioins', js: true do
    given(:another_user) { create(:user) }
    given(:google_url) { 'https://www.google.com' }
    given(:question) { Question.last }

    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('another_user') do
        login(another_user)
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'

        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'question text'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: google_url

        click_on 'Ask'

        expect(page).to have_content 'Test question'
        expect(page).to have_content 'question text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'question text'
        expect(page).to have_link 'My link', href: google_url
        expect(page).to_not have_link 'Vote up', href: vote_up_question_path(question)
        expect(page).to_not have_link 'Vote down', href: vote_down_question_path(question)
      end

      Capybara.using_session('another_user') do
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'question text'

        expect(page).to have_link 'My link', href: google_url
        expect(page).to have_link 'Vote up', href: vote_up_question_path(question)
        expect(page).to have_link 'Vote down', href: vote_down_question_path(question)
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
