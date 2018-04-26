require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  # describe 'GET #new' do
  #   before { get :new, params: { question_id: question } }
  #
  #   it 'assigns the request question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end
  #
  #   it 'assign a new Answer to @answer' do
  #     expect(assigns(:answer)).to be_a_new(Answer)
  #   end
  #
  #   it 'render new view' do
  #     expect(response).to render_template :new
  #   end
  # end

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

end
