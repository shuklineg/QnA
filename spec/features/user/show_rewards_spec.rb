require 'rails_helper'

feature 'User can see their rewards', %q(
  In order to see rewards
  As an authenticated user
  I'd like to be see my rewards
) do
  given(:user) { create(:user) }
  given(:reward) { create(:reward, name: 'first reward', image: fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png')) }
  given(:second_reward) { create(:reward, name: 'second reward', image: fixture_file_upload("#{Rails.root}/spec/fixtures/images/second_reward.png", 'image/png'))}
  given(:question) { create(:question, reward: reward) }
  given(:second_question) { create(:question, reward: second_reward) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: second_question, user: user) }

  context 'With best answers' do
    background do
      login(user)
      answer.best!
      second_answer.best!
      visit user_rewards_path(user)
    end

    scenario 'user is viewing their rewards' do
      expect(page).to have_content 'first reward'
      expect(page).to have_content 'second reward'
      expect(page).to have_css "img[src*='reward.png']"
      expect(page).to have_css "img[src*='second_reward.png']"
    end
  end

  context 'Without best answers' do
    background do
      login(user)
      visit user_rewards_path(user)
    end

    scenario 'user has no rewards' do
      expect(page).to_not have_content 'first reward'
      expect(page).to_not have_content 'second reward'
      expect(page).to_not have_css "img[src*='reward.png']"
      expect(page).to_not have_css "img[src*='second_reward.png']"
    end
  end
end
