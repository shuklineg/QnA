shared_examples 'API Attachable' do
  let(:file_response) { resource_response['files'].first }
  let(:first_file) { files.first }
  let(:path) { rails_blob_path(first_file, disposition: 'attachment', only_path: true) }

  it 'returns list of files' do
    expect(resource_response['files'].count).to eq files.count
  end

  it 'returns id' do
    expect(file_response['id']).to eq first_file.id
  end

  it 'returns filename' do
    expect(file_response['file_name']).to eq first_file.filename.to_s
  end

  it 'returns path' do
    expect(file_response['path']).to eq path
  end
end
