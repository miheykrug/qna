require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:resource) { create(:question) }

  describe 'POST #create' do
    context 'Authenticate user' do
      sign_in_user
      it 'assigns the requested resource to @resource' do
        post :create, params: { question_id: resource }
        expect(assigns(:resource)).to eq resource
      end
      it 'create new comment' do
        expect { post :create, params: { question_id: resource } }.to change(resource.comments, :count).by(1)
      end
    end
    context 'Non authenticate user' do
      it 'try to save new vote' do
        expect { post :create, params: { question_id: resource } }.to_not change(Comment, :count)
      end
    end
  end

end
