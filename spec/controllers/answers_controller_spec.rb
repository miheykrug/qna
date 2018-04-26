require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: author) }

  describe 'POST #create' do
    sign_in_user

    it 'assigns the request question to @question' do
      post :create, params: { question_id: question, answer: attributes_for(:answer) }
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'save the new answer in database' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question index view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer in database' do
        expect { post :create, params: { question_id: question,
                                         answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_answer) }
        expect(response).to render_template "questions/show"
      end
    end
  end

  describe 'DELETE #destroy' do
    before { answer }

    context 'current user is author of answer' do
      before do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in author
      end


      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'current user is not author of answer' do
      sign_in_user

      it 'deletes answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(question.answers, :count)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
