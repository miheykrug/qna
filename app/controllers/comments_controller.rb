class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :load_resource, only: %i[create]
  after_action :publish_comment, only: %i[create]

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
    @klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    @resource = @klass.find(params["#{@klass.name.underscore}_id"])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = (@klass == Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast(
      "comments_question_#{question_id}",
      { partial: ApplicationController.render(partial: 'comments/comment',
                                              locals: { comment: @comment }),
        klass: @klass.to_s, id: @resource.id, comment_user_id: @comment.user_id}
    )
  end
end
