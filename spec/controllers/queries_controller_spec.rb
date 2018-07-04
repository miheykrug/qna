require 'rails_helper'

RSpec.describe QueriesController, type: :controller do
  describe 'GET #index' do
    it 'renders index view' do
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    let!(:question) { create(:question) }

    it '@results contains the question' do
      # ThinkingSphinx::Test.run do
      #   post :create, params: { query: question.title, resource: "Question" }
      #   expect(assigns(:results)).to include(question)
      # end
    end

    it 'send search method' do
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape(question.title), :classes => [Question])
      post :create, params: { query: question.title, resource: "Question" }
    end
  end
end
