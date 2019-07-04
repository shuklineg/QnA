require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it do
    should validate_numericality_of(:value)
      .is_greater_than_or_equal_to(-1)
      .is_less_than_or_equal_to(1)
      .with_message("You can't vote twice")
      .only_integer
  end

  describe '#vote_up' do
    let(:user) { create(:user) }

    context 'someone elses votable' do
      let(:votable) { create(:answer) }

      it do
        expect { described_class.vote_up(user, votable).save }.to change(votable, :rating).by(1)
      end

      it do
        expect { described_class.vote_down(user, votable).save }.to change(votable, :rating).by(-1)
      end
    end

    context 'owned votable' do
      let(:votable) { create(:answer, user: user) }

      it { expect { described_class.vote_up(user, votable).save }.to_not change(votable, :rating) }
    end
  end
end
