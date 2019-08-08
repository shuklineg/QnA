require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #find' do
    context 'with query' do
      let(:search_params) { { query: 'keyword', indices: ['question'] } }
      it 'render find' do
        get :find, params: { search: search_params }, format: :js

        expect(response).to render_template :find
      end

      it 'call Search.find' do
        expect(Search).to_not receive(:new)
        expect(Search).to receive(:find).with(ActionController::Parameters.new(search_params).permit(:query, indices: []))

        get :find, params: { search: search_params }, format: :js
      end

      it 'assigns @search' do
        get :find, params: { search: search_params }, format: :js

        expect(assigns(:search)).to be_a Search
      end
    end

    context 'without query' do
      it 'render find' do
        get :find, format: :js

        expect(response).to render_template :find
      end

      it 'call Search.new' do
        expect(Search).to_not receive(:find)
        expect(Search).to receive(:new)

        get :find, format: :js
      end

      it 'assigns @search' do
        get :find, format: :js

        expect(assigns(:search)).to be_a Search
      end
    end
  end
end
