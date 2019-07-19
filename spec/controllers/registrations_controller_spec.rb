require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET new_auth' do
    it 'redirect to root path without auth data' do
      get :new_auth
      expect(response).to redirect_to root_path
    end

    context 'with auth data' do
      before do
        session[:omniauth] = { provider: 'some provider', uid: '123' }
      end

      it 'assigns @user' do
        get :new_auth
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe 'POST create_auth' do
    it 'redirect to root path without auth data' do
      post :create_auth
      expect(response).to redirect_to root_path
    end

    context 'with auth data' do
      before do
        session[:omniauth] = { provider: 'some provider', uid: '123' }
      end

      context 'with valid email' do
        it 'create user' do
          expect { post :create_auth, params: { user: { email: 'valid@email.com' } } }.to change(User, :count).by(1)
        end

        it 'redirect to root' do
          post :create_auth, params: { user: { email: 'valid@email.com' } }

          expect(response).to redirect_to root_path
        end

        it 'set flash' do
          post :create_auth, params: { user: { email: 'valid@email.com' } }

          is_expected.to set_flash[:notice].to(/link has been sent to your email/)
        end

        it 'clear session' do
          expect do
            post :create_auth, params: { user: { email: 'valid@email.com' } }
          end.to change { session[:omniauth] }.to be_nil
        end
      end

      context 'with invalid email' do
        it 'does not create user' do
          expect { post :create_auth, params: { user: { email: 'invalid.email' } } }.to_not change(User, :count) 
        end

        it 'render new_auth' do
          post :create_auth, params: { user: { email: 'invalid.email' } }

          expect(response).to render_template :new_auth
        end
      end
    end
  end
end
