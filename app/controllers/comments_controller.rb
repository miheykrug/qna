class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :load_resource, only: %i[create]

  def create
    @comment = @resource.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      render json: { comment: @comment, user_email: @comment.user.email }
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def load_resource
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    @resource = klass.find(params["#{klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
