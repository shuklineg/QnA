shared_examples 'API Validatable' do
  context 'authorized' do
    context 'with valid params' do
      it 'returns successful status' do
        do_request(method, api_path, params: valid_params, headers: headers)
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      it 'returns 422 status' do
        do_request(method, api_path, params: invalid_params, headers: headers)
        expect(response.status).to eq 422
      end
    end
  end
end
