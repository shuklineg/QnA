require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  before { login(user) }

  include_examples 'voted controller'

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'saves current user as author' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirects to create view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(question.answers, :count)
      end

      it 're-renders create view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }

        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is author' do
      let!(:answer) { create(:answer, user: user, question: question) }

      it 'delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      let!(:answer) { create(:answer, user: create(:user), question: question) }

      it "user cannot delete someone else's answer" do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PUTCH #update' do
    let!(:answer) { create(:answer, question: question, user: user) }
    let!(:someone_elses_answer) { create(:answer, question: question) }

    context 'with valid attributes' do
      it 'update the answer in the database' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload

        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not update the answer' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 're-renders to update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js

        expect(response).to render_template :update
      end
    end

    context 'user is not author' do
      let!(:answer) { create(:answer) }

      it "user can't edit someone else's answer" do
        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js
        answer.reload

        expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'POST #best' do
    context 'user is author of the question' do
      let(:question) { create(:question, user: user) }
      let!(:reward) { create(:reward, question: question, name: 'first reward', image: fixture_file_upload("#{Rails.root}/spec/fixtures/images/reward.png", 'image/png')) }
      let(:answer_author) { create(:user) }
      let!(:answer) { create(:answer, question: question, user: answer_author) }

      it 'can set the answer as the best' do
        post :best, params: { id: answer }, format: :js
        expect(answer.reload).to be_best
      end

      it 'user should receive a reward' do
        expect { post :best, params: { id: answer }, format: :js }.to change(answer_author.rewards, :count).by(1)
      end

      it 'render best' do
        post :best, params: { id: answer }, format: :js

        expect(response).to render_template :best
      end
    end

    context 'user is not author of the question' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      it "can't set the answer as the best" do
        post :best, params: { id: answer }, format: :js
        expect(answer.reload).to_not be_best
      end

      it 'render best' do
        post :best, params: { id: answer }, format: :js

        expect(response).to render_template :best
      end
    end
  end
end
