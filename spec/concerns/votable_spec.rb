require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:votable) { create(described_class.name.underscore.to_sym) }
  let(:user) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up!' do
    it { expect { votable.vote_up!(user) }.to change(votable.votes, :count).by(1) }
  end
end
