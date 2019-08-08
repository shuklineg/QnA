require 'rails_helper'

RSpec.describe Search, type: :model do
  let(:params) { { query: 'keyword', indices: ['question'] } }

  it { should validate_length_of(:query).is_at_least(4) }

  describe 'Search.find' do
    it 'initialize search' do
      expect(Search).to receive(:new).with(params).and_call_original

      Search.find(params)
    end

    it 'validate search' do
      search = Search.new(params)
      allow(Search).to receive(:new).with(params).and_return(search)
      expect(search).to receive(:validate)

      Search.find(params)
    end

    it 'return search' do
      expect(Search.find(params)).to be_a Search
    end
  end

  describe 'Search#results' do
    it 'call ThinkingSphinx.search' do
      search = Search.find(params)
      escaped_query = ThinkingSphinx::Query.escape(params[:query])
      expect(ThinkingSphinx).to receive(:search).with(escaped_query, indices: search.indices)

      search.results
    end

    it 'return empty if query invalid' do
      search = Search.find({})

      expect(search.results).to be_empty
    end
  end

  describe 'Search#initialize' do
    it 'initialize attributes' do
      search = Search.new(params)

      expect(search.query).to eq params[:query]
      expect(search.indices).to eq params[:indices]
    end
  end
end
