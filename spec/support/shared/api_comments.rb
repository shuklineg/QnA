shared_examples 'API Commentable' do
  let(:comment) { comments.first }
  let(:comments_response) { resource_response['comments'].first }

  it 'returns list of comments' do
    expect(resource_response['comments'].size).to eq comments.count
  end

  it 'returns all public fields' do
    %w[id body user_id created_at updated_at].each do |attr|
      expect(comments_response[attr]).to eq comment.send(attr).as_json
    end
  end
end
