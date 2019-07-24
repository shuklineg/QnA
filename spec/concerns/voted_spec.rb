require 'rails_helper'

RSpec.shared_examples 'voted controller' do
  let(:model_klass) { described_class.controller_name.singularize.to_sym }
  let!(:voteable) { create(model_klass) }
  let(:user) { create(:user) }
  let!(:owned_voteable) { create(model_klass, user: user) }

  describe 'POST #vote_up' do

    context 'Authenticated user' do
      before { login(user) }

      context 'with someone elses votable' do
        it 'can vote' do
          expect { post :vote_up, params: { id: voteable }, format: :json }.to change(voteable.votes, :count).by(1)
          expect(voteable.votes.last.value).to eq(1)
        end

        it 'render json' do
          post :vote_up, params: { id: voteable }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['model']).to eq voteable.class.name.underscore
          expect(json_response['object_id']).to eq voteable.id
          expect(json_response['value']).to eq 1
        end

        it "can't vote twice" do
          2.times { post :vote_up, params: { id: voteable }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'with own votable' do
        it "can't vote" do
          expect { post :vote_up, params: { id: owned_voteable }, format: :json }.to_not change(owned_voteable.votes, :count)
        end

        it '401 status' do
          post :vote_up, params: { id: owned_voteable }, format: :json

          expect(response).to have_http_status(401)
        end
      end
    end

    context 'Unauthenticated user' do
      before { logout(user) }

      it "can't vote" do
        expect { post :vote_up, params: { id: voteable }, format: :json }.to_not change(voteable.votes, :count)
      end

      it '401 status' do
        post :vote_up, params: { id: voteable }, format: :json

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'POST #vote_down' do
    context 'Authenticated user' do
      before { login(user) }

      context 'with someone elses votable' do
        it 'can vote' do
          expect { post :vote_down, params: { id: voteable }, format: :json }.to change(voteable.votes, :count).by(1)
          expect(voteable.votes.last.value).to eq(-1)
        end

        it 'render json' do
          post :vote_down, params: { id: voteable }, format: :json
          json_response = JSON.parse(response.body)

          expect(json_response['model']).to eq voteable.class.name.underscore
          expect(json_response['object_id']).to eq voteable.id
          expect(json_response['value']).to eq(-1)
        end

        it "can't vote twice" do
          2.times { post :vote_up, params: { id: voteable }, format: :json }
          json_response = JSON.parse(response.body)

          expect(response.status).to eq 422
          expect(json_response['value']).to eq ["You can't vote twice"]
        end
      end

      context 'with own votable' do
        it "can't vote" do
          expect { post :vote_down, params: { id: owned_voteable }, format: :json }.to_not change(owned_voteable.votes, :count)
        end

        it '401 status' do
          post :vote_up, params: { id: owned_voteable }, format: :json

          expect(response).to have_http_status(401)
        end
      end
    end

    context 'Unauthenticated user' do
      before { logout(user) }

      it "can't vote" do
        expect { post :vote_up, params: { id: voteable }, format: :json }.to_not change(voteable.votes, :count)
      end

      it '401 status' do
        post :vote_up, params: { id: voteable }, format: :json

        expect(response).to have_http_status(401)
      end
    end
  end
end
