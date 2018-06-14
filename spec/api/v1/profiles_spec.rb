require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      let(:resource) { me }
      it_behaves_like "check resource attributes", %w[id email created_at updated_at admin], ""

      %w[password encrypted_password].each do |attr|
        it "does not contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:others) { create_list(:user, 3) }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response status"

      it 'does not contains me' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'contains others' do
        expect(response.body).to be_json_eql(others.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end
