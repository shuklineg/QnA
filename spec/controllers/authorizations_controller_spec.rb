require 'rails_helper'

RSpec.describe AuthorizationsController, type: :controller do
  let(:auth_hash) { { provider: 'some provider', uid: '123' } }
  let(:authorization_params) { { user: { email: 'valid@email.com' } } }

  describe 'GET new' do
    before { get :new }

    it 'redirect to root path without auth data' do
      expect(response).to redirect_to root_path
    end

    context 'with auth data' do
      before do
        session[:omniauth] = auth_hash
        get :new
      end

      it 'assigns @user' do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe 'POST create' do
    it 'redirect to root path without auth data' do
      post :create
      expect(response).to redirect_to root_path
    end

    context 'with auth data' do
      before do
        session[:omniauth] = auth_hash
      end

      context 'with valid email' do
        it 'create user' do
          expect { post :create, params: authorization_params }.to change(User, :count).by(1)
        end

        it 'redirect to root' do
          post :create, params: authorization_params

          expect(response).to redirect_to root_path
        end

        it 'set flash' do
          post :create, params: authorization_params

          is_expected.to set_flash[:notice].to(/link has been sent to your email/)
        end

        it 'clear session' do
          expect { post :create, params: authorization_params }.to change { session[:omniauth] }.to be_nil
        end
      end

      context 'with invalid email' do
        let(:invalid_params) { { user: { email: 'invalid email' } } }

        it 'does not create user' do
          expect { post :create, params: invalid_params }.to_not change(User, :count)
        end

        it 'render new_auth' do
          post :create, params: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end
end
