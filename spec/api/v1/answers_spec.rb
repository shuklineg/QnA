require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' } }
  let(:access_token) { create(:access_token) }

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

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comments_response) { answer_response['comments'].first }
        let(:comment) { comments.first }

        it 'returns list of comments' do
          expect(answer_response['comments'].size).to eq comments.count
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:links_response) { answer_response['links'].first }
        let(:link) { links.first }

        it 'returns list of links' do
          expect(answer_response['links'].size).to eq links.count
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(links_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file_response) { answer_response['files'].first }
        let(:first_file) { answer.files.first }
        let(:path) { rails_blob_path(first_file, disposition: 'attachment', only_path: true) }

        it 'returns list of files' do
          expect(answer_response['files'].count).to eq answer.files.count
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

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:api_path) { api_v1_answer_path(answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        delete api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        delete api_path, params: { access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't delete the answer" do
        expect { delete api_path, headers: headers }.to_not change(Answer, :count)
      end
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

  describe 'POST /api/v1/questions' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post api_path, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post api_path, params: { access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't create the answer" do
        expect { post api_path, headers: headers }.to_not change(Answer, :count)
      end
    end

    context 'authorized' do
      context 'with valid params' do
        let(:answer_params) { build(:answer) }
        let(:params) { { access_token: access_token.token, answer: answer_params }.to_json }

        it 'create the answer' do
          expect { post api_path, params: params, headers: headers }.to change(Answer, :count).by(1)
        end

        it 'returns 200 status' do
          post api_path, params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid params' do
        let(:answer_params) { { body: '' } }
        let(:params) { { access_token: access_token.token, answer: answer_params }.to_json }

        it "doesn't create the answer" do
          expect { post api_path, params: params, headers: headers }.to_not change(Answer, :count)
        end

        it 'returns 422 status' do
          post api_path, params: params, headers: headers
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PUT /api/v1/answers/:id' do
    let!(:answer) { create(:answer, user_id: access_token.resource_owner_id) }
    let(:answer_params) { { body: 'new body' } }
    let(:api_path) { api_v1_answer_path(answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        put api_path, params: { answer: answer_params }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        put api_path, params: { answer: answer_params, access_token: '1234' }.to_json, headers: headers
        expect(response.status).to eq 401
      end

      it "dosn't update the answer" do
        expect { put api_path, params: { answer: answer_params }.to_json, headers: headers }.to_not change { answer.reload.body }
      end
    end

    context 'authorized' do
      context 'with valid params' do
        let(:params) { { access_token: access_token.token, answer: answer_params }.to_json }

        it 'update the answer' do
          expect { put api_path, params: params, headers: headers }.to change { answer.reload.body }.to(answer_params[:body])
        end

        it 'returns 200 status' do
          put api_path, params: params, headers: headers
          expect(response).to be_successful
        end
      end

      context 'with invalid params' do
        let(:answer_params) { { body: '' } }
        let(:params) { { access_token: access_token.token, answer: answer_params }.to_json }

        it "doesn't update the answer" do
          expect { put api_path, params: params, headers: headers }.to_not change { answer.reload.body }
        end

        it 'returns 422 status' do
          put api_path, params: params, headers: headers
          expect(response.status).to eq 422
        end
      end
    end
  end
end
