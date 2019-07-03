require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:model_klass) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(model_klass) }
  let(:owned_votable) { create(model_klass, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up!' do
    it { expect { votable.vote_up!(user) }.to change(votable.votes, :count).by(1) }
    it { expect { owned_votable.vote_up!(user) }.to_not change(owned_votable.votes, :count) }
  end
end
