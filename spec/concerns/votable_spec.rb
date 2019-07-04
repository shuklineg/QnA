require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:model_klass) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(model_klass) }
  let(:owned_votable) { create(model_klass, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#vote_up!' do
    it do
      expect { votable.vote_up!(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq 1
    end
    it { expect { owned_votable.vote_up!(user) }.to_not change(owned_votable.votes, :count) }
  end

  describe '#vote_down!' do
    it do
      expect { votable.vote_down!(user) }.to change(votable.votes, :count).by(1)
      expect(votable.votes.last.value).to eq(-1)
    end
    it { expect { owned_votable.vote_down!(user) }.to_not change(owned_votable.votes, :count) }
  end

  describe '#rating' do
    it do
      expect(votable.rating).to eq(0)
      votable.vote_down!(user)
      expect(votable.rating).to eq(-1)
      votable.vote_up!(user)
      expect(votable.rating).to eq(0)
      votable.vote_up!(user)
      expect(votable.rating).to eq(1)
    end
  end
end
