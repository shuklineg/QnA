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

        it 'sends email' do
          delivery = double
          expect(delivery).to receive(:deliver_later)

          expect(AuthorizationsMailer).to receive(:email_confirmation).and_return(delivery)

          post :create, params: authorization_params
        end

        it 'create authorization' do
          expect { post :create, params: authorization_params }.to change(Authorization, :count).by(1)
          expect(Authorization.last.confirmation_token).to_not be_nil
        end
      end

      context 'with invalid email' do
        let(:invalid_params) { { user: { email: 'invalid email' } } }

        it 'does not create user' do
          expect { post :create, params: invalid_params }.to_not change(User, :count)
        end

        it 'render new' do
          post :create, params: invalid_params

          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET email_confirmation' do
    let(:user) { create(:user) }
    let!(:authorization) { create(:authorization, user: user, uid: '12345', provider: 'some_provider', confirmation_token: '12345678') }

    it 'redirect to root' do
      get :email_confirmation, params: { confirmation_token: authorization.confirmation_token }

      expect(response).to redirect_to root_path
    end

    context 'with valid token' do
      it 'confirm authorization' do
        get :email_confirmation, params: { confirmation_token: authorization.confirmation_token }
        expect(authorization.reload).to be_confirmed
      end

      it 'add notice message' do
        get :email_confirmation, params: { confirmation_token: authorization.confirmation_token }

        is_expected.to set_flash[:notice].to(/successfully confirmed/)
      end

      it 'sign in user' do
        expect do
          get :email_confirmation, params: { confirmation_token: authorization.confirmation_token }
        end.to change(controller, :current_user).from(nil).to(user)
      end
    end

    it 'not confirm authorization with invalid token' do
      get :email_confirmation, params: { confirmation_token: 'invalid' }

      expect(authorization.reload).to_not be_confirmed
    end

    it 'no notice messages' do
      get :email_confirmation, params: { confirmation_token: 'invalid' }

      expect(flash[:notice]).to be_nil
    end
  end
end
