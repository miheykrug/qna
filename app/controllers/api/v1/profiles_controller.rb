class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    respond_with current_resource_owner
  end

  def index
    respond_with all_without_current_resource_owner
  end

  protected

  def all_without_current_resource_owner
    @users ||= User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end