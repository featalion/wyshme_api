require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @controller = Api::EventsController.new
    setup_token
  end

  test "should return items" do
    get(:items, {id: events(:event_1).id, access_token: @token})
    assert_response(:success, 'response is not successful')
    assert_not_nil(assigns(:items), '@items is not assigned')
    assert_equal(7, assigns(:items).size, '@items size is not 7')
  end

end
