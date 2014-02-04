module Api
  class BaseController < ::ApplicationController

    private

    def current_user
      @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def content_share_params(type, id)
      {
        content_type: type,
        content_id: id,
        recipients: params[:recipients],
        message: params[:message],
        sent: false
      }
    end

  end
end
