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
    let(:api_path) { api_v1_question_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 5, commentable: question) }
      let!(:links) { create_list(:link, 4, linkable: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { question_response['comments'].first }
        let(:comment) { comments.first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq comments.count
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:links_response) { question_response['links'].first }
        let(:link) { links.first }

        it 'returns list of links' do
          expect(question_response['links'].size).to eq links.count
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(links_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { question_response['files'].first }
        let(:first_file) { question.files.first }
        let(:path) { rails_blob_path(first_file, disposition: 'attachment', only_path: true) }

        it 'returns list of files' do
          expect(question_response['files'].count).to eq question.files.count
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
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_question_path(question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete api_path, params: { access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't delete the question" do
        expect { delete api_path, headers: headers }.to_not change(Question, :count)
      end
    end

    context 'authorized' do
      let(:params) { { access_token: access_token.token }.to_json }

      it 'deletes the question' do
        expect { delete api_path, params: params, headers: headers }.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: params, headers: headers
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post api_path, params: { access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't create the question" do
        expect { post api_path, headers: headers }.to_not change(Question, :count)
      end
    end

    context 'authorized' do
      context 'with valid params' do
        let(:question_params) { build(:question) }
        let(:params) { { access_token: access_token.token, question: question_params }.to_json }

        it 'create the question' do
          expect { post api_path, params: params, headers: headers }.to change(Question, :count).by(1)
        end

        it 'returns 200 status' do
          post api_path, params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid params' do
        let(:question_params) { { title: '', body: '' } }
        let(:params) { { access_token: access_token.token, question: question_params }.to_json }

        it "doesn't create the question" do
          expect { post api_path, params: params, headers: headers }.to_not change(Question, :count)
        end

        it 'returns 422 status' do
          post api_path, params: params, headers: headers
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let!(:question) { create(:question, user_id: access_token.resource_owner_id) }
    let(:question_params) { { title: 'new title', body: 'new body' } }
    let(:api_path) { api_v1_question_path(question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        put api_path, params: { question: question_params }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        put api_path, params: { question: question_params, access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't update the question" do
        put api_path, params: { question: question_params }.to_json, headers: headers

        question.reload

        expect(question.title).to_not eq question_params[:title]
        expect(question.body).to_not eq question_params[:body]
      end
    end

    context 'authorized' do
      context 'with valid params' do
        let(:params) { { access_token: access_token.token, question: question_params }.to_json }

        it 'update the question' do
          put api_path, params: params, headers: headers

          question.reload

          expect(question.title).to eq question_params[:title]
          expect(question.body).to eq question_params[:body]
        end

        it 'returns 200 status' do
          put api_path, params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid params' do
        let(:question_params) { { title: '', body: '' } }
        let(:params) { { access_token: access_token.token, question: question_params }.to_json }

        it "doesn't update the question" do
          put api_path, params: params, headers: headers

          question.reload

          expect(question.title).to_not eq question_params[:title]
          expect(question.body).to_not eq question_params[:body]
        end

        it 'returns 422 status' do
          put api_path, params: params, headers: headers
          expect(response.status).to eq 422
        end
      end
    end
  end
end
