require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable).touch(true) }

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

  describe 'Link#gist?' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/shuklineg/781f42ffe9faad73c559b11cfb20e7aa') }
    let!(:google_link) { build(:link, url: 'http://google.com/') }

    it { expect(gist_link).to be_gist }
    it { expect(google_link).to_not be_gist }
  end

  describe 'Link#gist' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/shuklineg/781f42ffe9faad73c559b11cfb20e7aa') }

    it { expect(gist_link.gist).to be_a_kind_of Array }
    it { expect(gist_link.gist.first).to include(content: 'Test text', name: 'test.txt') }
  end
end
