require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).through(:answers) }
  it { should have_many(:votes) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:owned_question) { create(:question, user: user) }
    let(:someone_elses_answer) { create(:answer, question: owned_question, user: create(:user)) }

    it { expect(user).to be_author_of(owned_question) }
    it { expect(user).to_not be_author_of(someone_elses_answer) }
    it { expect(user).to_not be_author_of(nil) }
  end

  describe '.create_authorization' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    it 'returns the authorization' do
      expect(user.create_authorization(auth)).to be_a(Authorization)
    end

    it 'create the authorization' do
      expect { user.create_authorization(auth) }.to change(user.authorizations, :count).by(1)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Service::FindForOauth') }

    it 'calls Service::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
