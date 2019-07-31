shared_examples 'API Linkable' do
  let(:link) { links.first }
  let(:links_response) { resource_response['links'].first }

  it 'returns list of links' do
    expect(resource_response['links'].size).to eq links.count
  end

  it 'returns all public fields' do
    %w[id name url created_at updated_at].each do |attr|
      expect(links_response[attr]).to eq link.send(attr).as_json
    end
  end
end
