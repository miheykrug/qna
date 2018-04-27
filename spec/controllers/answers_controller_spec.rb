require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:create!) { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
    sign_in_user

    it 'assigns the request question to @question' do
      create!
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'save the new answer in database' do
        expect { create! }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question index view' do
        create!
        expect(response).to redirect_to question_path(question)
      end

      it 'new answer has association with question' do
        create!
        expect(assigns(:answer).question_id).to eq question.id
      end

      it 'new answer has association with user' do
        create!
        expect(assigns(:answer).user_id).to eq @user.id
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
    let(:destroy!) { delete :destroy, params: { id: some_answer } }
    let!(:some_answer) { create(:answer, question: question) }

    context 'current user is author of answer' do
      @user = sign_in_user
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: user_answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to question show view' do
        delete :destroy, params: { id: user_answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'current user is not author of answer' do
      sign_in_user
      it 'deletes answer' do
        expect { destroy! }.to_not change(Answer, :count)
      end

      it 'redirect to question show view' do
        destroy!
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'non-authenticated user delete question' do
      it 'deletes answer' do
        expect { destroy! }.to_not change(Answer, :count)
      end

      it 'redirect to new session view' do
        destroy!
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
