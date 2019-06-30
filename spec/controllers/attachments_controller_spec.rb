require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let!(:user) { create(:user) }

    context 'authenticated user' do
      before { login(user) }

      context 'is author of the resource' do
        let!(:resource) { create(:question, files: [file], user: user) }

        it 'author can remove attached file' do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to change(resource.files, :count).by(-1)
        end

        it 'render destroy' do
          delete :destroy, params: { id: resource.files.first }, format: :js

          expect(response).to render_template :destroy
        end
      end

      context 'is not author of the resource' do
        let!(:resource) { create(:question, files: [file]) }

        it "can't remove attached file" do
          expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
        end

        it 'render destroy' do
          delete :destroy, params: { id: resource.files.first }, format: :js

          expect(response).to render_template :destroy
        end
      end
    end

    context 'unauthenticated user' do
      let!(:resource) { create(:question, files: [file]) }

      it "can't remove attached file" do
        expect { delete :destroy, params: { id: resource.files.first }, format: :js }.to_not change(resource.files, :count)
      end

      it '401 status' do
        delete :destroy, params: { id: resource.files.first }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
