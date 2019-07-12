require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
) do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  given!(:someone_elses_answer) { create(:answer, :sequences, question: question, files: [file]) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'edit his answer' do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save'
      end

      within '.answers' do
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'edited answer'
      end
    end

    context 'with files' do
      background do
        within "#answer-#{answer.id}" do
          click_on 'Edit'

          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save'
        end
      end

      scenario 'add' do
        within "#answer-#{answer.id}" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end

      scenario 'delete' do
        within "#answer-#{answer.id}" do

          first('.attachments .file').click_on 'Delete attachment'

          expect(page).to_not have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end

    scenario 'edit his answer with errors' do
      within "#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      within "#answer-#{someone_elses_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario "tries to delete other user's answer file" do
      within "#answer-#{someone_elses_answer.id}" do
        expect(page).to_not have_link 'Delete attachmentr'
      end
    end
  end
end
