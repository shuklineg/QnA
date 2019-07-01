require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'Answer#best!' do
    let(:question) { create(:question) }
    let(:user) { create(:user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:image) { fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png') }
    let!(:reward) { create(:reward, question: question, image: image) }

    it 'set the best answer' do
      expect { answer.best! }.to change(answer, :best).to(true)
    end

    it 'add reward to user' do
      expect { answer.best! }.to change(user.rewards, :count).by(1)
    end

    context 'can be only one in question' do
      let!(:best_answer) { create(:answer, question: question, best: true) }
      let!(:second_question_answer) { create(:answer, best: true) }

      before { answer.best! }

      it { expect(best_answer.reload).to_not be_best }
      it { expect(second_question_answer.reload).to be_best }
    end
  end

  describe 'Answer#best?' do
    let(:answer) { create(:answer) }
    let(:best_answer) { create(:answer, best: true) }

    it { expect(answer).to_not be_best }
    it { expect(best_answer).to be_best }
  end
end
