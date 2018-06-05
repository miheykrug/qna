require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'PATCH #update_email' do
    describe 'with temp email' do
      @user = sign_in_user_with_temp_email
      context 'with valid attribute' do
        it "should change user's temp email" do
          patch :update_email, params: { user: { email: 'new@email.com' } }
          @user.reload
          expect(@user.email).to eq 'new@email.com'
        end
      end
      context 'with invalid attribute' do
        it "should change user's temp email" do
          patch :update_email, params: { user: { email: nil } }
          @user.reload
          expect(@user.email).to_not eq 'new@email.com'
        end
      end
    end
  end

end
