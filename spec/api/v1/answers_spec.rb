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
        %w[id body created_at updated_at].each do |attr|
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

      before { get api_path, params: { access_token: access_token.token, id: answer }, headers: headers }

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
end
