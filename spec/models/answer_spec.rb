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
