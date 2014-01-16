module Api
  class ItemsController < BaseController
    doorkeeper_for :create, :update, :destroy, :like, :wysh

    before_action :find_item, only: [:show, :update, :destroy, :like, :wysh]

    def index
      @items = load_paginated(Item)

      render json: @items, each_serializer: ItemSerializer
    end

    def create
      @item = Item.new(item_params)
      set_item_associations
      status = @item.save

      render json: @item, meta: gen_meta(status)
    end

    def show
      render json: @item
    end

    def update
      @item.assign_attributes(item_params)
      set_item_associations
      status = @item.save

      render json: @item, meta: gen_meta(status)
    end

    def destroy
      status = @item.destroy

      render json: @item, meta: gen_meta(status)
    end

    # PUT /api/items/ITEM_ID/like
    def like
      ItemLike.find_or_create_by(user_id: current_user.id,
                                 item_id: @item.id)

      @item.update_attribute(:likes, @item.item_likes.count)

      render json: @item
    end

    # PUT /api/items/ITEM_ID/wysh
    def wysh
      ItemWysh.find_or_create_by(user_id: current_user.id,
                                 item_id: @item.id)

      @item.update_attribute(:wyshes, @item.item_wyshes.count)

      render json: @item
    end

    def featured
      @items = Item.featured

      render json: @items, each_serializer: ItemSerializer
    end

    private

    def item_params
      params.require(:item).permit(:name, :description,
                                   :price, :image, :url, :retailer)
    end

    def find_item
      @item = Item.find(params[:id])
    end

    def set_item_associations
      set_associations(@item, Category, params[:item][:category_ids])
    end

  end
end
