require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of :name }

  it 'have one attached image' do
    expect(Reward.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end

  it 'validate image presence' do
    expect(Reward.new(name: 'reward name')).to_not be_valid
  end
end
