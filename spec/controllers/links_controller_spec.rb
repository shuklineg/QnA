require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }
  let(:someone_elses_question) { create(:question) }
  let!(:another_link) { create(:link, linkable: someone_elses_question) }

  describe 'DELETE #destroy' do
    context 'authenticated user' do
      before { login(user) }

      context 'is author of the linkable' do
        it 'delete the link' do
          expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: link }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'is not author of the linkable' do
        it "can't delete the link" do
          expect { delete :destroy, params: { id: another_link }, format: :js }.to_not change(Link, :count)
        end

        it 'render destroy' do
          delete :destroy, params: { id: link }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'unauthenticated user' do
      it "can't delete the link" do
        expect { delete :destroy, params: { id: link }, format: :js }.to_not change(Link, :count)
      end

      it '401 status' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
