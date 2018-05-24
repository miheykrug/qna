class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :load_resource, only: %i[create]

  def create
    @resource.comments.create!(user: current_user)
  end

  private

  def load_resource
    klass = [Question, Answer].find { |k| params["#{k.name.underscore}_id"] }
    @resource = klass.find(params["#{klass.name.underscore}_id"])
  end

end
