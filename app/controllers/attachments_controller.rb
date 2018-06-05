class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]
  before_action :load_attachment, only: %i[destroy]

  authorize_resource

  def destroy
    @attachment.destroy
  end

  private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end
end
