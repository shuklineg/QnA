require 'rails_helper'

RSpec.shared_examples 'voted controller' do
  describe 'POST #vote_up' do
    let(:klass_sym) { described_class.controller_name.singularize.to_sym }
    let(:voted) { create(klass_sym) }

    it 'add new vote to voted' do
      expect { post :vote_up, params: { id: voted }, format: :json }.to change(voted.votes, :count).by(1)
    end

    it 'render json' do
      post :vote_up, params: { id: voted }, format: :json
      json_response = JSON.parse(response.body)

      expect(json_response['model']).to eq voted.class.name.underscore
      expect(json_response['object_id']).to eq voted.id
      expect(json_response['value']).to eq 1
    end
  end
end
