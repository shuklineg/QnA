require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  before { login(user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'saves current user as author' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }

        expect(response).to redirect_to controller.question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(controller.question).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'render updated question' do
        patch :update, params: { id: question, question: attributes_for(:question), format: :js }

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }
      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'Question title'
        expect(question.body).to eq 'Question body'
      end

      it 'render updated question' do
        expect(response).to render_template :update
      end
    end

    context 'user is not author' do
      let!(:question) { create(:question) }

      it "user can't edit someone else's question" do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
        question.reload

        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is author' do
      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not author' do
      let!(:question) { create(:question) }

      it "user cannot delete someone else's question" do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'POST #delete_file' do
    let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }

    context 'user is author of the question' do
      let!(:question) { create(:question, files: [file], user: user) }

      it 'author can remove attached file' do
        expect { post :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'render delete_file' do
        post :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

        expect(response).to render_template :delete_file
      end
    end

    context 'user is not author of the question' do
      let!(:question) { create(:question, files: [file]) }

      it "can't remove attached file" do
        expect { post :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js }.to_not change(question.files, :count)
      end

      it 'render delete_file' do
        post :delete_file, params: { id: question, file_id: question.files.first.id }, format: :js

        expect(response).to render_template :delete_file
      end
    end
  end
end
