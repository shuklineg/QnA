shared_examples 'commentable model' do
  it { should have_many(:comments).dependent(:destroy) }
end
