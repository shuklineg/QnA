require 'rails_helper'

feature 'User can add links to answer', %q(
  In order to provide additional info to my anwer
  As an answer's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) {'https://gist.github.com/shuklineg/781f42ffe9faad73c559b11cfb20e7aa'}
  
  scenario 'User adds link when given answer', js: true do
    login(user)
    visit question_path(question)
    
    fill_in 'Body', with: 'question text'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
