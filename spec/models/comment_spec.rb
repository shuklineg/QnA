require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:commentable).touch(true) }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  it 'should have default scope by id ascending' do
    expect(Comment.all.to_sql).to eq Comment.all.order(id: :asc).to_sql
  end
end
