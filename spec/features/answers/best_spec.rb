require 'rails_helper'

feature 'The author of the question can mark one answer as the best.', %q(
  In order to mark the correct answer
  As an authenticated user and question author
  I'd like to be able to mark one answer as the best
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
  given!(:reward) { create(:reward, question: question, name: 'reward name', image: image) }
  given!(:answers) { create_list(:answer, 3, :sequences, question: question) }
  given(:answer_last) { answers.last }
  given(:answer_first) { answers.first }

  describe 'As authenticated user', js: true do
    before { login(user) }

    scenario 'mark one answer as the best' do
      visit question_path(question)

      within "#answer-#{answer_last.id}" do
        click_on 'Best'
        sleep(0.5)
      end

      within first('.answer') do
        expect(page).to have_content answer_last.body
        expect(page).to_not have_link 'Best'
      end
    end

    scenario 'mark another answer as the best' do
      answer_last.best!

      visit question_path(question)

      within "#answer-#{answer_first.id}" do
        click_on 'Best'
        sleep(0.5)
      end

      within first('.answer') do
        expect(page).to have_content answer_first.body
      end
    end

    scenario 'user gets an reward' do
      visit question_path(question)

      within "#answer-#{answer_last.id}" do
        click_on 'Best'
      end

      visit user_rewards_path(answer_last.user)

      reward = question.reward

      expect(page).to have_content question.title
      expect(page).to have_content reward.name
      expect(page).to have_css "img[src*='#{reward.image.filename}']"
    end
  end

  scenario "can't mark the answer as the best in someone else's question" do
    visit question_path(question)

    within first('.answer') do
      expect(page).to_not have_link 'Best'
    end
  end
end
