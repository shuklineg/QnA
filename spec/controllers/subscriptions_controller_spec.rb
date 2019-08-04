require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with authenticated user' do
      before { login(user) }

      it 'add subscription' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(user.subscriptions, :count).by(1)
      end

      it 'render subscription' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with unauthenticated user' do
      it "can't add subscription" do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(Subscription, :count)
      end

      it '401 status' do
        post :create, params: { question_id: question }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscripton) { create(:subscription, user: user, question: question) }

    context 'with authenticated user' do
      before { login(user) }

      it 'remove subscription' do
        expect { delete :destroy, params: { question_id: question, id: subscripton }, format: :js }.to change(user.subscriptions, :count).by(-1)
      end

      it 'render subscription' do
        delete :destroy, params: { question_id: question, id: subscripton }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'with unauthenticated user' do
      it "can't remove subscription" do
        expect { delete :destroy, params: { question_id: question, id: subscripton }, format: :js }.to_not change(Subscription, :count)
      end

      it '401 status' do
        delete :destroy, params: { question_id: question, id: subscripton }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
