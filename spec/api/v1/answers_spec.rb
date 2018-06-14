require 'rails_helper'

describe 'Answer API' do
  let(:question) { create(:question) }

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:resources) { create_list(:answer, 2, question: question) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      it_behaves_like "returns array", 2

      it_behaves_like "check resources list attributes", %w[id body created_at updated_at]
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comment) { create(:comment, commentable: answer, user: user) }
      let!(:attachment) { create(:attachment, attachable: answer)}

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      let(:resource) { answer }
      it_behaves_like "check resource attributes", %w[id body created_at updated_at best], ""

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
      get "/api/v1/answers/#{answer.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'save the new answer in database' do
          expect { do_request(answer: attributes_for(:answer), access_token: access_token.token) }.to change(question.answers, :count).by(1)
        end

        it 'new answer has association with user' do
          expect { do_request(answer: attributes_for(:answer), access_token: access_token.token) }.to change(user.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer in database' do
          expect { do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token) }.to_not change(Answer, :count)
        end
      end
    end

    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", params: { format: :json }.merge(options)
    end
  end
end
