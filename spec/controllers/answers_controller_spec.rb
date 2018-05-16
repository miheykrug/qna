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

    context 'current user is author of answer' do
      @user = sign_in_user
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'change answer attributes' do
        patch :update, params: { id: user_answer, answer: { body: 'new body'}, format: :js }
        user_answer.reload
        expect(user_answer.body).to eq 'new body'
      end

      it 'assigns the request answer to @answer' do
        patch :update, params: { id: user_answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq user_answer
      end

      it 'render update template' do
        patch :update, params: { id: user_answer, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :update
      end
    end

    context 'current user is not author of answer' do
      sign_in_user

      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    context 'non-authenticated user edit answer' do
      it 'change answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end
  end


  describe 'DELETE #destroy' do
    let(:destroy!) { delete :destroy, params: { id: some_answer }, format: :js }
    let!(:some_answer) { create(:answer, question: question) }

    context 'current user is author of answer' do
      @user = sign_in_user
      let!(:user_answer) { create(:answer, question: question, user: @user) }

      it 'deletes answer' do
        expect { delete :destroy, params: { id: user_answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'current user is not author of answer' do
      sign_in_user
      it 'deletes answer' do
        expect { destroy! }.to_not change(Answer, :count)
      end
    end

    context 'non-authenticated user delete question' do
      it 'deletes answer' do
        expect { destroy! }.to_not change(Answer, :count)
      end

      it 'redirect to new session view' do
        delete :destroy, params: { id: some_answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #best' do
    let(:answer) { create(:answer, question: question) }

    context 'current user is author of answer question' do
      @user = sign_in_user
      let(:user_question) { create(:question, user: @user) }
      let!(:old_best_answer) { create(:answer, question: user_question, best: true) }
      let(:new_best_answer) { create(:answer, question: user_question) }

      it 'assigns the request answer to @answer' do
        patch :best, params: { id: new_best_answer, format: :js }
        expect(assigns(:answer)).to eq new_best_answer
      end

      it 'assigns the request question to @question' do
        patch :best, params: { id: new_best_answer, format: :js }
        expect(assigns(:question)).to eq user_question
      end

      it 'set best answer of question' do
        patch :best, params: { id: new_best_answer, format: :js }
        new_best_answer.reload
        old_best_answer.reload
        expect(new_best_answer.best).to be true
        expect(old_best_answer.best).to be false
      end

      it 'render best template' do
        patch :best, params: { id: new_best_answer, format: :js }
        expect(response).to render_template :best
      end
    end

    context 'current user is not author of answer question' do
      sign_in_user

      it 'set best answer of question' do

        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be false
      end
    end

    context 'non-authenticated user' do
      it 'set best answer of question' do
        patch :best, params: { id: answer, format: :js }
        answer.reload
        expect(answer.best).to be false
      end
    end
  end

  it_behaves_like 'voted resource'
end
