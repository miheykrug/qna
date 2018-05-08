require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe "DELETE #destroy" do
    let(:question) { create(:question) }
    let!(:other_file) { create(:attachment, attachable: question) }

    context 'current user is author of resource attachment' do
      @user = sign_in_user
      let!(:user_question) { create(:question, user: @user) }
      let!(:file) { create(:attachment, attachable: user_question)}
      it 'deletes attachment' do
        expect { delete :destroy, params: { id: file }, format: :js }.to change(Attachment, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author of resource attachment' do
      sign_in_user
      it 'deletes attachment' do
        expect { delete :destroy, params: { id: other_file }, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'non-authenticated user delete attachment' do
      it 'deletes attachment' do
        expect { delete :destroy, params: { id: other_file }, format: :js }.to_not change(Attachment, :count)
      end

      it 'redirect to new session view' do
        delete :destroy, params: { id: other_file }

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end
