require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:resources) { create_list(:question, 2) }
      let(:question) { resources.first }
      let!(:answer) { create(:answer, question: question) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      it_behaves_like "returns array", 2

      it_behaves_like "check resources list attributes", %w[id title body created_at updated_at]

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it_behaves_like "returns array", 1, "0/answers"

        let(:resource) { answer }
        it_behaves_like "check resource attributes", %w[id body created_at updated_at], "0/answers/0/"
      end
    end

    def do_request(options = {})
      get '/api/v1/questions', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, commentable: question, user: user) }
      let!(:attachment) { create(:attachment, attachable: question)}

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      let(:resource) { question }
      it_behaves_like "check resource attributes", %w[id title body created_at updated_at], ""

      context 'comments' do
        it_behaves_like "returns array", 1, "comments"

        let(:resource) { comment }
        it_behaves_like "check resource attributes", %w[id body created_at updated_at], "comments/0/"
      end

      context 'attachments' do
        it_behaves_like "returns array", 1, "attachments"

        let(:resource) { attachment }
        it_behaves_like "check resource attributes", %w[id created_at updated_at], "attachments/0/"


        it 'contains url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'save the new question in database' do
          expect { do_request(question: attributes_for(:question), access_token: access_token.token) }.to change(Question, :count).by(1)
        end

        it 'new question has association with user' do
          expect { do_request(question: attributes_for(:question), access_token: access_token.token) }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question in database' do
          expect { do_request(question: attributes_for(:invalid_question), access_token: access_token.token) }.to_not change(Question, :count)
        end
      end
    end
    def do_request(options = {})
      post "/api/v1/questions", params: { format: :json }.merge(options)
    end
  end
end
