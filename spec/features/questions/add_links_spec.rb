require 'rails_helper'

feature 'User can add links to question', %q(
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
) do
  describe 'Authenticated user asks question', js: true do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/shuklineg/781f42ffe9faad73c559b11cfb20e7aa' }
    given(:google_url) { 'https://www.google.com' }
    given(:gmail_url) { 'https://www.gmail.com' }

    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'question text'

      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: google_url
    end

    scenario 'with link' do
      click_on 'Ask'

      expect(page).to have_link 'My link', href: google_url
    end

    scenario 'with links' do
      click_on 'Add link'

      within all('.link-fields').last do
        fill_in 'Link name', with: 'Second link'
        fill_in 'Url', with: gmail_url
      end

      click_on 'Ask'

      expect(page).to have_link 'My link', href: google_url
      expect(page).to have_link 'Second link', href: gmail_url
    end

    scenario 'with invalid link' do
      fill_in 'Url', with: 'invalid_url'

      click_on 'Ask'

      within '.question-errors' do
        expect(page).to have_content 'Links url must be a valid URL'
      end

      expect(page).to_not have_link 'My link', href: 'invalid_url'
    end

    scenario 'with gist link' do
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      within '.question' do
        expect(page).to have_content 'Test text'
        expect(page).to have_content 'test.txt'
      end
    end
  end

  context 'Unauthenticated user', js: true do
    given!(:question) { create(:question) }
    given(:gmail_url) { 'https://gmail.com' }
    given!(:link) { create(:link, linkable: question, name: 'My link', url: gmail_url) }

    scenario 'can see links' do
      visit question_path(question)

      within '.question' do
        expect(page).to have_link 'My link', href: gmail_url
      end
    end
  end
end
