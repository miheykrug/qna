require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    @user = sign_in_user
    let!(:question) { create(:question) }
    let(:create!) { post :create, params: { question_id: question, format: :js } }
    it 'save the new subscription in database' do
      expect { create! }.to change(@user.tracked_questions, :count).by(1)
    end

    it 'not save the second subscription in database' do
      create!
      expect { create! }.to_not change(Subscription, :count)
    end
  end

  describe 'DELETE #destroy' do
    @user = sign_in_user
    let!(:question) { create(:question, user: @user) }

    it 'delete subscription' do
      expect { delete :destroy, params: { question_id: question, format: :js } }.to change(Subscription, :count).by(-1)
    end
  end

end
