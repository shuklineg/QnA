require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.count
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at best].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
    let(:second_file) { fixture_file_upload("#{Rails.root}/spec/spec_helper.rb", 'text/plain') }
    let!(:question) { create(:question, files: [file, second_file]) }
    let!(:comments) { create_list(:comment, 5, commentable: question) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:links) { create_list(:link, 4, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'with resources' do
        let(:resource_response) { question_response }
        let(:files) { question.files }

        it_behaves_like 'API Commentable'
        it_behaves_like 'API Linkable'
        it_behaves_like 'API Attachable'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token } }

      it 'deletes the question' do
        expect { delete api_path, params: params.to_json, headers: headers }.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: params.to_json, headers: headers
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }
    let(:valid_params) { { question: build(:question), access_token: access_token.token } }
    let(:invalid_params) { { question: { title: '', body: '' }, access_token: access_token.token } }
    let(:method) { :post }

    it_behaves_like 'API Validatable'
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'with valid params create the question' do
        expect { post api_path, params: valid_params.to_json, headers: headers }.to change(Question, :count).by(1)
      end

      it "with invalid params doesn't create the question" do
        expect { post api_path, params: invalid_params.to_json, headers: headers }.to_not change(Question, :count)
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:valid_params) { { question: { title: 'new title', body: 'new body' }, access_token: access_token.token } }
    let(:invalid_params) { { question: { title: '', body: '' }, access_token: access_token.token } }
    let(:api_path) { api_v1_question_path(question) }
    let(:method) { :put }

    it_behaves_like 'API Validatable'
    it_behaves_like 'API Authorizable'

    context 'authorized' do
      it 'with valid params update the question' do
        put api_path, params: valid_params.to_json, headers: headers

        question.reload

        %i[title body].each do |attr|
          expect(question.send(attr)).to eq valid_params[:question][attr]
        end
      end

      it "with invalid params doesn't update the question" do
        put api_path, params: invalid_params.to_json, headers: headers

        question.reload

        %i[title body].each do |attr|
          expect(question.send(attr)).to_not eq invalid_params[:question][attr]
        end
      end
    end
  end
end
