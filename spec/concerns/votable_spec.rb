require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:model_klass) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(model_klass) }
  let(:owned_votable) { create(model_klass, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    it do
      expect(votable.rating).to eq(0)
      Vote.vote_down(create(:user), votable).save
      expect(votable.rating).to eq(-1)
      Vote.vote_up(create(:user), votable).save
      expect(votable.rating).to eq(0)
      Vote.vote_up(create(:user), votable).save
      expect(votable.rating).to eq(1)
    end
  end
end
