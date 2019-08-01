require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }
  let(:valid_params) { { answer: attributes_for(:answer), access_token: access_token.token } }
  let(:invalid_params) { { answer: attributes_for(:answer, :invalid), access_token: access_token.token } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.count
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at best].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /api/v1/questions/:question_id/answers/:id' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:second_file) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:answer) { create(:answer, files: [file, second_file]) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 5, commentable: answer) }
      let!(:links) { create_list(:link, 4, linkable: answer) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      context 'with resources' do
        let(:resource_response) { answer_response }
        let(:files) { answer.files }

        it_behaves_like 'API Commentable'
        it_behaves_like 'API Linkable'
        it_behaves_like 'API Attachable'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token }.to_json }

      it 'deletes the answer' do
        expect { delete api_path, params: params, headers: headers }.to change(Answer, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }
    let(:method) { :post }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API Validatable'

      it 'with valid params create the answer' do
        expect { post api_path, params: valid_params.to_json, headers: headers }.to change(Answer, :count).by(1)
      end

      it "with invalid params doesn't create the answer" do
        expect { post api_path, params: invalid_params.to_json, headers: headers }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_answer_path(answer) }
    let(:method) { :put }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it_behaves_like 'API Validatable'

      it 'with valid params update the answer' do
        put api_path, params: valid_params.to_json, headers: headers

        answer.reload

        expect(answer.body).to eq valid_params[:answer][:body]
      end

      it "with invalid params doesn't update the answer" do
        put api_path, params: invalid_params.to_json, headers: headers

        answer.reload

        expect(answer.body).to_not eq invalid_params[:answer][:body]
      end
    end
  end
end
