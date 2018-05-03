require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:create!) { post :create, params: { question_id: question,
                                            answer: attributes_for(:answer), format: :js } }
    sign_in_user

    it 'assigns the request question to @question' do
      create!
      expect(assigns(:question)).to eq question
    end

    context 'with valid attributes' do
      it 'save the new answer in database' do
        expect { create! }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        create!
        expect(response).to render_template :create
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
                                         answer: attributes_for(:invalid_answer),
                                         format: :js } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_answer), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer) }

    it 'assigns the request answer to @answer' do
      patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
      expect(assigns(:answer)).to eq answer
    end

    it 'change answer attributes' do
      patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
      expect(response).to render_template :update
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
