require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    let(:answers) { create_list(:answer, 2, question: question) }

    before { get :show, params: { id: question } }

    it 'assigns the request question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assign a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assign a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    @user = sign_in_user
    let(:create!) { post :create, params: { question: attributes_for(:question) } }

    context 'with valid attributes' do
      it 'save the new question in database' do
        expect { create! }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        create!
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'new question has association with user' do
        create!
        expect(assigns(:question).user_id).to eq @user.id
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question in database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
      end

      it 're-render new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:destroy!) { delete :destroy, params: { id: question } }
    before { question }

    context 'current user is author of question' do
      @user = sign_in_user
      let!(:user_question) { create(:question, user: @user) }

      it 'deletes question' do
        expect { delete :destroy, params: { id: user_question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: user_question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'current user is not author of question' do
      sign_in_user

      it 'deletes question' do
        expect { destroy! }.to_not change(Question, :count)
      end

      it 'redirect to show view' do
        destroy!
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'Non-authenticated user delete question' do
      it 'deletes question' do
        expect { destroy! }.to_not change(Question, :count)
      end

      it 'redirect to new session view' do
        destroy!
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
