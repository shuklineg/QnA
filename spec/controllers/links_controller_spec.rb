require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:question) { create(:question) }
  let!(:link) { create(:link, linkable: question) }

  describe 'DELETE #destroy' do
    it 'delete the link' do
      expect { delete :destroy, params: { id: link }, format: :js }.to change(Link, :count).by(-1)
    end
    it 'render destroy' do
      delete :destroy, params: { id: link }, format: :js
      expect(response).to render_template :destroy
    end
  end
end
