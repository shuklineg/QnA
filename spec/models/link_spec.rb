require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validate url' do
    let(:question) { create(:question) }
    let!(:valid_url) { build(:link, url: 'http://google.com/', linkable: question) }
    let!(:invalid_url) { build(:link, url: 'some_invalid_url', linkable: question) }

    it { expect(valid_url).to be_valid }
    it { expect(invalid_url).to be_invalid }

    it do
      invalid_url.validate
      expect(invalid_url.errors[:url]).to include('must be a valid URL')
    end
  end
end
