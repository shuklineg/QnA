require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  context 'authenticated user' do
    before { login(user) }

    describe 'POST #create' do
      context 'with valid attributes' do
        context 'question' do
          it 'user can add comment' do
            expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
          end

          it 'render create' do
            post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js

            expect(response).to render_template :create
          end
        end

        context 'answer' do
          it 'user can add comment' do
            expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to change(answer.comments, :count).by(1)
          end

          it 'render create' do
            post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js

            expect(response).to render_template :create
          end
        end
      end

      context 'with invalid attributes' do
        context 'question' do
          it "user can't add comment" do
            expect { post :create, params: { comment: { body: '' }, question_id: question }, format: :js }.to_not change(question.comments, :count)
          end

          it 'render create' do
            post :create, params: { comment:  { body: '' }, question_id: question }, format: :js

            expect(response).to render_template :create
          end
        end

        context 'answer' do
          it "user can't add comment" do
            expect { post :create, params: { comment:  { body: '' }, answer_id: answer }, format: :js }.to_not change(answer.comments, :count)
          end

          it 'render create' do
            post :create, params: { comment:  { body: '' }, question_id: question }, format: :js

            expect(response).to render_template :create
          end
        end
      end
    end
  end

  context 'unauthenticated user' do
    context 'question' do
      it "user can't add comment" do
        expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to_not change(question.comments, :count)
      end

      it '401 status' do
        post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js

        expect(response).to have_http_status(401)
      end
    end

    context 'answer' do
      it "user can't add comment" do
        expect { post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js }.to_not change(answer.comments, :count)
      end

      it '401 status' do
        post :create, params: { comment: attributes_for(:comment), answer_id: answer }, format: :js

        expect(response).to have_http_status(401)
      end
    end
  end
end
