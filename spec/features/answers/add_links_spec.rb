require 'rails_helper'

feature 'User can add links to answer', %q(
  In order to provide additional info to my anwer
  As an answer's author
  I'd like to be able to add links
) do
  context 'Authenticated user give answer', js: true do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given(:gmail_url) { 'https://gmail.com' }
    given(:google_url) { 'https://www.google.com' }
    given(:gist_url) { 'https://gist.github.com/shuklineg/781f42ffe9faad73c559b11cfb20e7aa' }

    background do
      login(user)
      visit question_path(question)

      within '.new-answer' do
        fill_in 'Body', with: 'answer text'

        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: gmail_url
      end
    end

    scenario 'with link' do
      click_on 'Answer the question'

      within '.answers' do
        expect(page).to have_link 'My link', href: gmail_url
      end
    end

    scenario 'with links' do
      within '.new-answer' do
        click_on 'Add link'

        within all('.link-fields').last do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end
      end

      click_on 'Answer the question'

      within '.answers' do
        expect(page).to have_link 'My link', href: gmail_url
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'with invalid link' do
      within '.new-answer' do
        fill_in 'Url', with: 'invalid_url'
      end

      click_on 'Answer the question'

      within '.answer-errors' do
        expect(page).to have_content 'Links url must be a valid URL'
      end

      expect(page).to_not have_link 'My link', href: 'invalid_url'
    end

    scenario 'with gist link' do
      fill_in 'Url', with: gist_url

      click_on 'Answer the question'

      within '.answers' do
        expect(page).to have_content 'Test text'
        expect(page).to have_content 'test.txt'
      end
    end
  end

  context 'Unauthenticated user', js: true do
    given(:answer) { create(:answer) }
    given(:gmail_url) { 'https://gmail.com' }
    given!(:link) { create(:link, linkable: answer, name: 'My link', url: gmail_url) }

    scenario 'can see links' do
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to have_link 'My link', href: gmail_url
      end
    end
  end
end
