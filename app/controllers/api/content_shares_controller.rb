module Api
  class ContentSharesController < BaseController
    before_action :find_content_share, only: [:show]

    def show
      render json: @content_share.try(:content)
    end

    private

    def find_content_share
      @content_share = ContentShare.find_by_hash_id(params[:id])
    end

  end
end
