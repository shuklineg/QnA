require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).through(:answers) }
  it { should have_many(:votes) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User#author_of?' do
    let(:user) { create(:user) }
    let(:owned_question) { create(:question, user: user) }
    let(:someone_elses_answer) { create(:answer, question: owned_question, user: create(:user)) }

    it { expect(user).to be_author_of(owned_question) }
    it { expect(user).to_not be_author_of(someone_elses_answer) }
    it { expect(user).to_not be_author_of(nil) }
  end
end
