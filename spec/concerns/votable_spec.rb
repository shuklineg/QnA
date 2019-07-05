require 'rails_helper'

RSpec.shared_examples 'votable model' do
  let(:model_klass) { described_class.name.underscore.to_sym }
  let(:user) { create(:user) }
  let(:votable) { create(model_klass) }
  let(:owned_votable) { create(model_klass, user: user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#rating' do
    let!(:votes_up) { create_list(:vote, 10, user: create(:user), votable: votable, value: 1) }
    let!(:votes_down) { create_list(:vote, 3, user: create(:user), votable: votable, value: -1) }

    it { expect(votable.rating).to eq 7 }
  end
end
