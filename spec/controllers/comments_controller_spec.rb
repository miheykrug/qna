require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:resource) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'Authenticate user' do
      sign_in_user
      it 'assigns the requested resource to @resource' do
        post :create, params: { user_id: user, question_id: resource, comment: attributes_for(:comment) }, format: :js
        expect(assigns(:resource)).to eq resource
      end
      it 'create new comment' do
        expect { post :create, params: { user_id: user, question_id: resource, comment: attributes_for(:comment) }, format: :js  }.to change(resource.comments, :count).by(1)
      end
    end
    context 'Non authenticate user' do
      it 'try to save new vote' do
        expect { post :create, params: { user_id: user, question_id: resource, comment: attributes_for(:comment) }, format: :js  }.to_not change(Comment, :count)
      end
    end
  end

end
