require 'rails_helper'

RSpec.shared_examples 'voted resource' do
  let(:model) { described_class.controller_name.classify.constantize }
  let(:votable) { create(model.to_s.underscore.to_sym) }

  describe 'POST #rating_up' do

    context 'current user is not author of resource' do
      sign_in_user
      it 'assigns the requested resource to @votable' do
        post :rating_up, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end
      it 'create new vote' do
        expect { post :rating_up, params: { id: votable } }.to change(votable.votes, :count).by(1)
      end

      it 'create two votes from one resource' do
        post :rating_down, params: { id: votable }
        expect { post :rating_down, params: { id: votable } }.to_not change(Vote, :count)
      end
    end

    context 'current user is author of resource' do
      @user = sign_in_user
      let!(:user_votable) { create(model.to_s.underscore.to_sym, user: @user) }
      it 'try to save new vote' do
        expect { post :rating_up, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    context 'Non-authenticated user' do
      it 'try to save new vote' do
        expect { post :rating_up, params: { id: votable } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #rating_down' do
    context 'current user is not author of resource' do
      sign_in_user
      it 'assigns the requested resource to @votable' do
        post :rating_down, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end
      it 'create new vote' do
        expect { post :rating_down, params: { id: votable } }.to change(votable.votes, :count).by(1)
      end

      it 'create two votes from one resource' do
        post :rating_down, params: { id: votable }
        expect { post :rating_down, params: { id: votable } }.to_not change(Vote, :count)
      end
    end

    context 'current user is author of resource' do
      @user = sign_in_user
      let!(:user_votable) { create(model.to_s.underscore.to_sym, user: @user) }
      it 'try to save new vote' do
        expect { post :rating_down, params: { id: user_votable } }.to_not change(Vote, :count)
      end
    end

    context 'Non-authenticated user' do
      it 'try to save new vote' do
        expect { post :rating_down, params: { id: votable } }.to_not change(Vote, :count)
      end
    end
  end

  describe 'DELETE #rating_cancel' do

    context 'current user cancel his vote' do
      @user = sign_in_user
      let!(:vote) { create(:vote, votable: votable, user: @user) }

      it 'assigns the requested resource to @votable' do
        delete :rating_cancel, params: { id: votable }
        expect(assigns(:votable)).to eq votable
      end
      it 'delete vote' do
        expect { delete :rating_cancel, params: { id: votable } }.to change(votable.votes, :count).by(-1)
      end
    end

    context 'current user' do
      let(:other_user) { create(:user) }
      let!(:other_vote) { create(:vote, votable: votable, user: other_user) }

      it 'try to cancel vote of other user' do
        expect { delete :rating_cancel, params: { id: votable } }.to_not change(Vote, :count)
      end
    end

    context 'Non-authenticated user' do
      it 'try to cancel vote' do
        expect { delete :rating_cancel, params: { id: votable } }.to_not change(Vote, :count)
      end
    end
  end
end