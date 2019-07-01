require 'rails_helper'

RSpec.describe Reward, type: :model do
  let(:question) { create(:question) }

  it { should validate_presence_of :name }
  it { should belong_to(:answer).optional }
  it { should belong_to(:question) }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'validate image presence' do
    expect(Reward.new(name: 'reward name', question: question)).to_not be_valid
    expect(Reward.new(name: 'reward name', question: question, image: fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain'))).to_not be_valid
    expect(Reward.new(name: 'reward name', question: question, image: fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png'))).to be_valid
  end
end
