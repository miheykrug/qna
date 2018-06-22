class QueriesController < ApplicationController
  def index
  end

  def create
    query = params[:query]
    resource = params[:resource].constantize unless params[:resource].empty?

    @results = ThinkingSphinx.search ThinkingSphinx::Query.escape(query), :classes => [resource]
    render json: @results
  end
end
