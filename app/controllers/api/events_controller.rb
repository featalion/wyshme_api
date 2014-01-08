module Api
  class EventsController < BaseController
    doorkeeper_for :all

    before_action :find_event, only: [:show, :update, :destroy]

    def index
      @events = load_paginated(Event, true)

      render json: @events, each_serializer: EventSerializer
    end

    def create
      @event = current_user.events.new(event_params)
      set_associations(@event, Item, params[:event][:item_ids])
      status = @event.save

      render json: @event, meta: gen_meta(status)
    end

    def show
      render json: @event
    end

    def update
      @event.assign_attributes(event_params)
      set_associations(@event, Item, params[:event][:item_ids])
      status = @event.save

      render json: @event, meta: gen_meta(status)
    end

    def destroy
      status = @event.destroy

      render json: @event, meta: gen_meta(status)
    end

    private

    def event_params
      params.require(:event).permit(:name, :description, :date)
    end

    def find_event
      # TODO: load event only if current user is its owner
      @event = current_user.event.where(id: params[:id]).first
    end

  end
end
