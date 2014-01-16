module Api
  class CategoriesController < BaseController
    doorkeeper_for :create, :update, :destroy

    before_action :find_category, only: [:show, :update, :destroy,
                                         :featured_items]

    def index
      @categories = load_paginated(Category)

      render json: @categories, each_serializer: CategorySerializer
    end

    def create
      @category = Category.new(category_params)
      status = @category.save

      render json: @category, meta: gen_meta(status)
    end

    def show
      render json: @category
    end

    def update
      @category.assign_attributes(category_params)
      status = @category.save

      render json: @category, meta: gen_meta(status)
    end

    def destroy
      status = @category.destroy

      render json: @category, meta: gen_meta(status)
    end

    def featured_items
      @items = @category.featured_items

      render json: @items, each_serializer: ItemSerializer
    end

    private

    def category_params
      params.require(:category).permit(:name, :description)
    end

    def find_category
      @category = Category.find(params[:id])
    end

  end
end
