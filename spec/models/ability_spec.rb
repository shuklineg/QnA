require 'rails_helper'
require "cancan/matchers"

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:answer) { create(:answer, files: [file], user: user) }
    let(:question) { create(:question, files: [file], user: user) }
    let(:other_user_answer) { create(:answer, files: [file], user: other) }
    let(:other_user_question) { create(:question, files: [file], user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_user_question }

    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_user_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_user_question }

    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_user_answer }

    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_user_question.files.first }

    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, other_user_answer.files.first }

    it { should be_able_to :best, create(:answer, question: question) }
    it { should_not be_able_to :best, create(:answer, question: other_user_question) }

    it { should be_able_to :index, Reward }

    it { should be_able_to :vote_up, other_user_answer }
    it { should be_able_to :vote_down, other_user_question }
    it { should_not be_able_to :vote_up, answer }
    it { should_not be_able_to :vote_down, question }
  end
end
