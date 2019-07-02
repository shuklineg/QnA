require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it do
    should validate_numericality_of(:value)
      .is_greater_than_or_equal_to(-1)
      .is_less_than_or_equal_to(1)
      .only_integer
  end
end
