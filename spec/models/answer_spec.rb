require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe 'Answer#best!' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'set the best answer' do
      expect { answer.best! }.to change(answer, :best).to(true)
    end

    context 'can be only one in question' do
      let!(:best_answer) { create(:answer, question: question, best: true) }
      let!(:second_question) { create(:question) }
      let!(:second_question_answer) { create(:answer, question: second_question, best: true) }

      before { answer.best! }

      it { expect(best_answer.reload.best).to be_falsey }
      it { expect(second_question_answer.reload.best).to be_truthy }
    end
  end
end
