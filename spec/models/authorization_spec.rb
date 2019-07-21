require 'rails_helper'

RSpec.describe Authorization, type: :model do
  it { should belong_to :user }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }

  describe '#confirmed?' do
    let(:user) { create(:user) }
    let(:authorization) { create(:authorization, user: user, uid: '123', provider: 'provider', confirmation_token: '1234') }

    it { expect(authorization).to_not be_confirmed }
    it 'when no token returns true' do
      expect { authorization.update(confirmation_token: nil) }.to change(authorization, :confirmed?).to(true)
    end
  end

  describe '#confirm!' do
    let(:user) { create(:user) }
    let(:authorization) { create(:authorization, user: user, uid: '123', provider: 'provider', confirmation_token: '1234') }

    it 'update confirmation_token to nil' do
      expect { authorization.confirm! }.to change(authorization, :confirmation_token).to be_nil
    end
  end
end
