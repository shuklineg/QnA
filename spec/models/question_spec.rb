require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  it_behaves_like 'votable model'
  it_behaves_like 'commentable model'

  it { should have_many(:answers).dependent(:destroy).order(best: :desc, id: :asc) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
