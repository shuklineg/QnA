require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'User#author_of?' do
    let(:user) { create(:user) }

    context 'resource authored by the user' do
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, user: user, question: question) }

      it 'question' do
        expect(user.author_of?(question)).to eq true
      end
      it 'answer' do
        expect(user.author_of?(answer)).to eq true
      end
    end

    context 'resource authored by another user' do
      let(:question) { create(:question, user: create(:user)) }
      let(:answer) { create(:answer, user: create(:user), question: question) }

      it 'question' do
        expect(user.author_of?(question)).to eq false
      end
      it 'answer' do
        expect(user.author_of?(answer)).to eq false
      end
    end
  end
end
